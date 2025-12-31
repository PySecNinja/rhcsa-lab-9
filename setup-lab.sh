#!/bin/bash
# RHCSA EX200 Practice Lab Setup Script

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMAGE_NAME="rhcsa-lab"
NETWORK_NAME="rhcsa-net"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_banner() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║          RHCSA EX200 Practice Lab Environment              ║"
    echo "║                   Rocky Linux 9 Based                      ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Detect container runtime
detect_runtime() {
    if command -v podman &> /dev/null; then
        RUNTIME="podman"
    elif command -v docker &> /dev/null; then
        RUNTIME="docker"
    else
        print_error "Neither podman nor docker found. Please install one."
        exit 1
    fi
    print_status "Using container runtime: $RUNTIME"
}

build_image() {
    echo ""
    echo -e "${BLUE}Building RHCSA lab image...${NC}"
    echo "This may take a few minutes on first run."
    echo ""

    $RUNTIME build -t $IMAGE_NAME -f "$SCRIPT_DIR/Containerfile" "$SCRIPT_DIR"
    print_status "Image built successfully"
}

create_network() {
    if ! $RUNTIME network inspect $NETWORK_NAME &> /dev/null; then
        $RUNTIME network create $NETWORK_NAME --subnet 192.168.100.0/24
        print_status "Network $NETWORK_NAME created"
    else
        print_status "Network $NETWORK_NAME already exists"
    fi
}

start_containers() {
    echo ""
    echo -e "${BLUE}Starting exam containers...${NC}"

    # Stop existing containers if running
    $RUNTIME rm -f server1 server2 2>/dev/null || true

    # Start server1
    $RUNTIME run -d \
        --name server1 \
        --hostname server1.example.com \
        --network $NETWORK_NAME \
        --ip 192.168.100.10 \
        --privileged \
        --tmpfs /run \
        --tmpfs /run/lock \
        -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
        $IMAGE_NAME

    print_status "server1 started (192.168.100.10)"

    # Start server2
    $RUNTIME run -d \
        --name server2 \
        --hostname server2.example.com \
        --network $NETWORK_NAME \
        --ip 192.168.100.11 \
        --privileged \
        --tmpfs /run \
        --tmpfs /run/lock \
        -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
        $IMAGE_NAME

    print_status "server2 started (192.168.100.11)"

    # Wait for systemd to initialize
    echo ""
    echo "Waiting for systems to initialize..."
    sleep 5

    # Setup loop device for LVM practice in server1
    $RUNTIME exec server1 bash -c "losetup -f /var/exam-disk.img 2>/dev/null || true"
}

show_instructions() {
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                Lab Environment Ready!                      ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Access the lab:${NC}"
    echo "  Connect to server1:  $RUNTIME exec -it server1 bash"
    echo "  Connect to server2:  $RUNTIME exec -it server2 bash"
    echo ""
    echo -e "${YELLOW}Credentials:${NC}"
    echo "  Root password: redhat"
    echo ""
    echo -e "${YELLOW}Network:${NC}"
    echo "  server1: 192.168.100.10"
    echo "  server2: 192.168.100.11"
    echo "  Subnet:  192.168.100.0/24"
    echo ""
    echo -e "${YELLOW}Quick commands:${NC}"
    echo "  Start exam timer:     ./exam-timer.sh"
    echo "  Validate your work:   ./validate-tasks.sh"
    echo "  Stop lab:             ./setup-lab.sh stop"
    echo "  Reset lab:            ./setup-lab.sh reset"
    echo ""
    echo -e "${YELLOW}Limitations in container environment:${NC}"
    echo "  - Boot targets: Can view/set but won't persist real boot"
    echo "  - LVM: Use /dev/loop0 (500MB disk image provided)"
    echo "  - SELinux: May be limited depending on host"
    echo "  - Kernel modules: Cannot load new modules"
    echo ""
    echo -e "${BLUE}Good luck with your practice!${NC}"
}

stop_containers() {
    echo "Stopping lab containers..."
    $RUNTIME stop server1 server2 2>/dev/null || true
    $RUNTIME rm server1 server2 2>/dev/null || true
    print_status "Lab containers stopped and removed"
}

reset_lab() {
    echo "Resetting lab environment..."
    stop_containers
    start_containers
    print_status "Lab environment reset"
}

status_lab() {
    echo ""
    echo -e "${BLUE}Lab Status:${NC}"
    echo ""

    for server in server1 server2; do
        if $RUNTIME ps --format "{{.Names}}" | grep -q "^${server}$"; then
            IP=$($RUNTIME inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $server 2>/dev/null || echo "N/A")
            echo -e "  ${GREEN}●${NC} $server: Running (IP: $IP)"
        else
            echo -e "  ${RED}●${NC} $server: Not running"
        fi
    done
    echo ""
}

# Main
print_banner
detect_runtime

case "${1:-start}" in
    start)
        build_image
        create_network
        start_containers
        show_instructions
        ;;
    stop)
        stop_containers
        ;;
    reset)
        reset_lab
        show_instructions
        ;;
    status)
        status_lab
        ;;
    build)
        build_image
        ;;
    *)
        echo "Usage: $0 {start|stop|reset|status|build}"
        exit 1
        ;;
esac

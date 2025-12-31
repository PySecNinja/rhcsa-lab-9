#!/bin/bash
# RHCSA EX200 Practice Lab Setup Script

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NETWORK_NAME="rhcsa-net"

# Default settings
RHEL_VERSION="10"
DISTRO="rocky"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

parse_args() {
    ACTION=""
    for arg in "$@"; do
        case $arg in
            --rhel9)  RHEL_VERSION="9" ;;
            --rhel10) RHEL_VERSION="10" ;;
            --alma)   DISTRO="alma" ;;
            --rocky)  DISTRO="rocky" ;;
            start|stop|reset|status|build) ACTION="$arg" ;;
        esac
    done

    # Set base image based on selections (using fully qualified names for podman)
    if [[ "$DISTRO" == "alma" ]]; then
        if [[ "$RHEL_VERSION" == "9" ]]; then
            BASE_IMAGE="docker.io/library/almalinux:9"
        else
            BASE_IMAGE="docker.io/library/almalinux:10"
        fi
        DISTRO_NAME="AlmaLinux"
    else
        if [[ "$RHEL_VERSION" == "9" ]]; then
            BASE_IMAGE="docker.io/library/rockylinux:9"
        else
            BASE_IMAGE="docker.io/rockylinux/rockylinux:10"
        fi
        DISTRO_NAME="Rocky Linux"
    fi

    IMAGE_NAME="rhcsa-lab-rhel${RHEL_VERSION}"
    CONTAINERFILE="$SCRIPT_DIR/containerfiles/Containerfile.rhel${RHEL_VERSION}"
}

print_banner() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║          RHCSA EX200 Practice Lab Environment              ║"
    echo "║             ${DISTRO_NAME} ${RHEL_VERSION} Based                          ║"
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
    echo -e "${BLUE}Building RHCSA lab image (RHEL ${RHEL_VERSION} - ${DISTRO_NAME})...${NC}"
    echo "This may take a few minutes on first run."
    echo ""

    if [[ ! -f "$CONTAINERFILE" ]]; then
        print_error "Containerfile not found: $CONTAINERFILE"
        exit 1
    fi

    $RUNTIME build --build-arg BASE_IMAGE="$BASE_IMAGE" -t $IMAGE_NAME -f "$CONTAINERFILE" "$SCRIPT_DIR"
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
        -e RHEL_VERSION="$RHEL_VERSION" \
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
        -e RHEL_VERSION="$RHEL_VERSION" \
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
    echo -e "${YELLOW}Lab Configuration:${NC}"
    echo "  RHEL Version: ${RHEL_VERSION}"
    echo "  Distribution: ${DISTRO_NAME}"
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
    echo "  Start exam menu:      ./exam-menu.sh"
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
    if [[ "$RHEL_VERSION" == "10" ]]; then
        echo "  - Flatpak: Available for practice (Flathub configured)"
    fi
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
            VERSION=$($RUNTIME exec $server printenv RHEL_VERSION 2>/dev/null || echo "unknown")
            echo -e "  ${GREEN}●${NC} $server: Running (IP: $IP, RHEL: $VERSION)"
        else
            echo -e "  ${RED}●${NC} $server: Not running"
        fi
    done
    echo ""
}

show_usage() {
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "Commands:"
    echo "  start   Start the lab environment (default)"
    echo "  stop    Stop and remove lab containers"
    echo "  reset   Reset lab to fresh state"
    echo "  status  Show lab status"
    echo "  build   Build the container image only"
    echo ""
    echo "Options:"
    echo "  --rhel9   Use RHEL 9 compatible image"
    echo "  --rhel10  Use RHEL 10 compatible image (default)"
    echo "  --alma    Use AlmaLinux as base"
    echo "  --rocky   Use Rocky Linux as base (default)"
    echo ""
    echo "Examples:"
    echo "  $0 start                    # RHEL 10 + Rocky Linux (default)"
    echo "  $0 start --rhel9            # RHEL 9 + Rocky Linux"
    echo "  $0 start --alma             # RHEL 10 + AlmaLinux"
    echo "  $0 start --rhel9 --alma     # RHEL 9 + AlmaLinux"
}

# Main
parse_args "$@"

# Default to start if no action specified
if [[ -z "$ACTION" ]]; then
    ACTION="start"
fi

print_banner
detect_runtime

case "$ACTION" in
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
        show_usage
        exit 1
        ;;
esac

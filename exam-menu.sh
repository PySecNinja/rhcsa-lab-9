#!/bin/bash
# RHCSA Interactive Exam Menu

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Detect container runtime
if command -v podman &> /dev/null; then
    RUNTIME="podman"
elif command -v docker &> /dev/null; then
    RUNTIME="docker"
else
    echo "Error: Neither podman nor docker found."
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_main_menu() {
    clear
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║          RHCSA EX200 Practice Exam Environment             ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    echo -e "${CYAN}Main Menu:${NC}"
    echo ""
    echo "  1) View Exam Tasks"
    echo "  2) Connect to server1"
    echo "  3) Connect to server2"
    echo "  4) Start Exam Timer (2.5 hours)"
    echo "  5) Validate All Tasks"
    echo "  6) Validate Specific Section"
    echo "  7) Reset Lab Environment"
    echo "  8) View Hints"
    echo "  9) Lab Status"
    echo "  0) Exit"
    echo ""
    echo -n "Select option: "
}

view_exam_tasks() {
    clear
    if command -v less &> /dev/null; then
        less "$SCRIPT_DIR/../rhel10-ex200-sample-exam.md" 2>/dev/null || \
        cat "$SCRIPT_DIR/../rhel10-ex200-sample-exam.md" 2>/dev/null || \
        echo "Exam file not found. Check rhel10-ex200-sample-exam.md"
    else
        cat "$SCRIPT_DIR/../rhel10-ex200-sample-exam.md" 2>/dev/null || \
        echo "Exam file not found."
    fi
    echo ""
    echo -e "${YELLOW}Press Enter to return to menu...${NC}"
    read
}

connect_server() {
    local server=$1
    if $RUNTIME ps --format "{{.Names}}" | grep -q "^${server}$"; then
        echo -e "${GREEN}Connecting to $server...${NC}"
        echo -e "${YELLOW}Type 'exit' to return to this menu${NC}"
        echo ""
        $RUNTIME exec -it $server bash
    else
        echo -e "${RED}$server is not running. Start the lab first.${NC}"
        echo ""
        echo -e "${YELLOW}Press Enter to continue...${NC}"
        read
    fi
}

validate_section_menu() {
    clear
    echo -e "${CYAN}Select Section to Validate:${NC}"
    echo ""
    echo "  1) Section 1: Essential Tools"
    echo "  2) Section 2: Shell Scripts"
    echo "  3) Section 3: Operate Running Systems"
    echo "  4) Section 4: Local Storage"
    echo "  5) Section 5: File Systems"
    echo "  6) Section 6: Deploy, Configure, Maintain"
    echo "  7) Section 7: Networking"
    echo "  8) Section 8: Users and Groups"
    echo "  9) Section 9: Security"
    echo "  0) Back to Main Menu"
    echo ""
    echo -n "Select section: "
    read section

    case $section in
        1) "$SCRIPT_DIR/validate-tasks.sh" 1 ;;
        2) "$SCRIPT_DIR/validate-tasks.sh" 2 ;;
        3) "$SCRIPT_DIR/validate-tasks.sh" 3 ;;
        4) "$SCRIPT_DIR/validate-tasks.sh" 4 ;;
        5) "$SCRIPT_DIR/validate-tasks.sh" 5 ;;
        6) "$SCRIPT_DIR/validate-tasks.sh" 6 ;;
        7) "$SCRIPT_DIR/validate-tasks.sh" 7 ;;
        8) "$SCRIPT_DIR/validate-tasks.sh" 8 ;;
        9) "$SCRIPT_DIR/validate-tasks.sh" 9 ;;
        0) return ;;
        *) echo "Invalid option" ;;
    esac
    echo ""
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read
}

show_hints() {
    clear
    echo -e "${CYAN}RHCSA Exam Hints & Quick Reference${NC}"
    echo ""
    echo -e "${YELLOW}Essential Commands:${NC}"
    echo "  man -k <keyword>         # Search man pages"
    echo "  apropos <keyword>        # Same as man -k"
    echo "  /usr/share/doc/          # Package documentation"
    echo ""
    echo -e "${YELLOW}User Management:${NC}"
    echo "  useradd -u UID -G group username"
    echo "  usermod -aG group username"
    echo "  passwd username"
    echo "  chage -l username        # View password aging"
    echo "  chage -M 90 username     # Set max password age"
    echo ""
    echo -e "${YELLOW}Storage:${NC}"
    echo "  lsblk                    # List block devices"
    echo "  fdisk /dev/sdX           # Partition disk"
    echo "  pvcreate, vgcreate, lvcreate  # LVM"
    echo "  lvextend -L +500M /dev/vg/lv"
    echo "  xfs_growfs /mount/point"
    echo "  resize2fs /dev/vg/lv"
    echo ""
    echo -e "${YELLOW}Services:${NC}"
    echo "  systemctl enable --now service"
    echo "  systemctl list-unit-files"
    echo "  journalctl -u service -f"
    echo ""
    echo -e "${YELLOW}SELinux:${NC}"
    echo "  getenforce / setenforce"
    echo "  semanage port -a -t http_port_t -p tcp 8888"
    echo "  semanage fcontext -a -t httpd_sys_content_t '/path(/.*)?'"
    echo "  restorecon -Rv /path"
    echo ""
    echo -e "${YELLOW}Firewall:${NC}"
    echo "  firewall-cmd --permanent --add-service=http"
    echo "  firewall-cmd --permanent --add-port=8080/tcp"
    echo "  firewall-cmd --reload"
    echo ""
    echo -e "${YELLOW}Network:${NC}"
    echo "  nmcli con add type ethernet con-name NAME ifname eth0"
    echo "  nmcli con mod NAME ipv4.addresses IP/PREFIX"
    echo "  nmcli con mod NAME ipv4.gateway GW"
    echo "  nmcli con mod NAME ipv4.method manual"
    echo "  nmcli con up NAME"
    echo ""
    echo -e "${YELLOW}ACLs:${NC}"
    echo "  setfacl -m u:user:rwx /path"
    echo "  setfacl -m d:u:user:rwx /path  # Default ACL"
    echo "  getfacl /path"
    echo ""
    echo -e "${YELLOW}Press Enter to return to menu...${NC}"
    read
}

lab_status() {
    clear
    echo -e "${CYAN}Lab Environment Status${NC}"
    echo ""
    "$SCRIPT_DIR/setup-lab.sh" status
    echo ""
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read
}

reset_lab() {
    echo ""
    echo -e "${YELLOW}Are you sure you want to reset the lab? (y/n)${NC}"
    read confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        "$SCRIPT_DIR/setup-lab.sh" reset
    fi
    echo ""
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read
}

# Main loop
while true; do
    show_main_menu
    read choice

    case $choice in
        1) view_exam_tasks ;;
        2) connect_server "server1" ;;
        3) connect_server "server2" ;;
        4)
            clear
            "$SCRIPT_DIR/exam-timer.sh"
            echo -e "${YELLOW}Press Enter to continue...${NC}"
            read
            ;;
        5)
            clear
            "$SCRIPT_DIR/validate-tasks.sh" all
            echo ""
            echo -e "${YELLOW}Press Enter to continue...${NC}"
            read
            ;;
        6) validate_section_menu ;;
        7) reset_lab ;;
        8) show_hints ;;
        9) lab_status ;;
        0)
            echo ""
            echo -e "${GREEN}Good luck with your RHCSA preparation!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option${NC}"
            sleep 1
            ;;
    esac
done

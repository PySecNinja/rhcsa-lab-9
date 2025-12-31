#!/bin/bash
# RHCSA EX200 Task Validation Script
# Routes to version-specific validation based on container RHEL version

# Don't exit on error - we want to continue validation even if checks fail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
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

# Detect RHEL version from running container
detect_version() {
    RHEL_VERSION=$($RUNTIME exec server1 printenv RHEL_VERSION 2>/dev/null || echo "")
    if [[ -z "$RHEL_VERSION" ]]; then
        # Fallback: try to detect from /etc/os-release
        RHEL_VERSION=$($RUNTIME exec server1 bash -c "grep -oP '(?<=VERSION_ID=\")[0-9]+' /etc/os-release" 2>/dev/null || echo "10")
    fi
    echo "$RHEL_VERSION"
}

TOTAL_POINTS=0
EARNED_POINTS=0
TASK_NUM=0

print_header() {
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}         RHCSA EX200 Practice Exam - Validation             ${NC}"
    echo -e "${BLUE}                    RHEL ${RHEL_VERSION} Edition                        ${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
    echo ""
}

print_section() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

check_task() {
    local server=$1
    local description=$2
    local points=$3
    local check_cmd=$4

    TASK_NUM=$((TASK_NUM + 1))
    TOTAL_POINTS=$((TOTAL_POINTS + points))

    if $RUNTIME exec $server bash -c "$check_cmd" &>/dev/null; then
        echo -e "${GREEN}[PASS]${NC} Task $TASK_NUM: $description (${points} pts)"
        EARNED_POINTS=$((EARNED_POINTS + points))
        return 0
    else
        echo -e "${RED}[FAIL]${NC} Task $TASK_NUM: $description (0/${points} pts)"
        return 1
    fi
}

check_task_with_output() {
    local server=$1
    local description=$2
    local points=$3
    local check_cmd=$4
    local expected=$5

    TASK_NUM=$((TASK_NUM + 1))
    TOTAL_POINTS=$((TOTAL_POINTS + points))

    result=$($RUNTIME exec $server bash -c "$check_cmd" 2>/dev/null || echo "")
    if [[ "$result" == *"$expected"* ]]; then
        echo -e "${GREEN}[PASS]${NC} Task $TASK_NUM: $description (${points} pts)"
        EARNED_POINTS=$((EARNED_POINTS + points))
        return 0
    else
        echo -e "${RED}[FAIL]${NC} Task $TASK_NUM: $description (0/${points} pts)"
        return 1
    fi
}

print_summary() {
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}                      EXAM RESULTS                          ${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
    echo ""

    PERCENTAGE=$((EARNED_POINTS * 100 / TOTAL_POINTS))
    PASS_THRESHOLD=70

    echo -e "  Total Points:    ${EARNED_POINTS} / ${TOTAL_POINTS}"
    echo -e "  Percentage:      ${PERCENTAGE}%"
    echo -e "  Pass Threshold:  ${PASS_THRESHOLD}%"
    echo ""

    if [ $PERCENTAGE -ge $PASS_THRESHOLD ]; then
        echo -e "${GREEN}  ╔════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}  ║              PASSED!                   ║${NC}"
        echo -e "${GREEN}  ╚════════════════════════════════════════╝${NC}"
    else
        echo -e "${RED}  ╔════════════════════════════════════════╗${NC}"
        echo -e "${RED}  ║           NOT YET PASSING              ║${NC}"
        echo -e "${RED}  ║     Keep practicing! You need ${PASS_THRESHOLD}%      ║${NC}"
        echo -e "${RED}  ╚════════════════════════════════════════╝${NC}"
    fi
    echo ""
}

# Check containers are running
check_containers() {
    if ! $RUNTIME ps --format "{{.Names}}" | grep -q "^server1$"; then
        echo -e "${RED}Error: server1 container is not running.${NC}"
        echo "Run './setup-lab.sh start' first."
        exit 1
    fi
    if ! $RUNTIME ps --format "{{.Names}}" | grep -q "^server2$"; then
        echo -e "${YELLOW}Warning: server2 container is not running.${NC}"
        echo "Some tasks requiring server2 will be skipped."
    fi
}

show_usage() {
    echo "Usage: $0 [section_number|section_name|all]"
    echo ""
    echo "RHEL 9 Sections:"
    echo "  1-essential, 2-scripts, 3-running, 4-storage,"
    echo "  5-filesystems, 6-deploy, 7-network, 8-users, 9-security"
    echo ""
    echo "RHEL 10 Sections (additional):"
    echo "  2-software (includes Flatpak)"
    echo "  4-running (includes systemd timers)"
    echo "  10-security (extended)"
}

# Main
check_containers
RHEL_VERSION=$(detect_version)

# Source the appropriate validation file
VALIDATION_FILE="$SCRIPT_DIR/validation/validate-rhel${RHEL_VERSION}.sh"
if [[ ! -f "$VALIDATION_FILE" ]]; then
    echo -e "${RED}Error: Validation file not found: $VALIDATION_FILE${NC}"
    echo "Falling back to RHEL 10 validation..."
    VALIDATION_FILE="$SCRIPT_DIR/validation/validate-rhel10.sh"
fi

source "$VALIDATION_FILE"

print_header

# Run validations based on argument or all
case "${1:-all}" in
    1|essential)
        validate_section1
        ;;
    2|scripts|software)
        validate_section2
        ;;
    3|running|scripting)
        validate_section3
        ;;
    4|storage|systems)
        validate_section4
        ;;
    5|filesystems)
        validate_section5
        ;;
    6|deploy|filesystem)
        validate_section6
        ;;
    7|network|deploy)
        validate_section7
        ;;
    8|users|network)
        validate_section8
        ;;
    9|security|users)
        validate_section9
        ;;
    10|security2)
        if [[ "$RHEL_VERSION" == "10" ]]; then
            validate_section10
        else
            echo "Section 10 is only available in RHEL 10 mode"
        fi
        ;;
    all)
        run_all_validations
        ;;
    *)
        show_usage
        exit 1
        ;;
esac

print_summary

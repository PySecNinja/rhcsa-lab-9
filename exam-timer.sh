#!/bin/bash
# RHCSA Exam Timer - 2.5 hours (150 minutes)

EXAM_DURATION=$((150 * 60))  # 150 minutes in seconds
START_TIME=$(date +%s)
END_TIME=$((START_TIME + EXAM_DURATION))

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

clear
echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║              RHCSA EX200 Practice Exam Timer               ║"
echo "║                    Duration: 2.5 hours                     ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""
echo "Exam started at: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Exam ends at:    $(date -d @$END_TIME '+%Y-%m-%d %H:%M:%S')"
echo ""
echo "Press Ctrl+C to stop the timer"
echo ""
echo -e "${YELLOW}Tip: Open another terminal to work on the exam${NC}"
echo ""

while true; do
    CURRENT_TIME=$(date +%s)
    REMAINING=$((END_TIME - CURRENT_TIME))

    if [ $REMAINING -le 0 ]; then
        echo -e "\n${RED}════════════════════════════════════════════════════════════${NC}"
        echo -e "${RED}                    TIME'S UP!                              ${NC}"
        echo -e "${RED}════════════════════════════════════════════════════════════${NC}"
        echo ""
        echo "Run './validate-tasks.sh' to see your score."
        exit 0
    fi

    HOURS=$((REMAINING / 3600))
    MINUTES=$(((REMAINING % 3600) / 60))
    SECONDS=$((REMAINING % 60))

    # Color based on time remaining
    if [ $REMAINING -le 300 ]; then
        COLOR=$RED
    elif [ $REMAINING -le 900 ]; then
        COLOR=$YELLOW
    else
        COLOR=$GREEN
    fi

    printf "\r${COLOR}Time Remaining: %02d:%02d:%02d${NC}   " $HOURS $MINUTES $SECONDS
    sleep 1
done

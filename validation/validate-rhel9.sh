# RHCSA EX200 Validation Functions - RHEL 9
# This file is sourced by validate-tasks.sh

validate_section1() {
    print_section "Section 1: Essential Tools"

    # Task 1.1 - Basic File Operations
    check_task "server1" "Directory /exam/archives exists" 2 \
        "test -d /exam/archives"

    check_task "server1" "Files starting with 'pass' copied from /etc" 3 \
        "ls /exam/archives/pass* 2>/dev/null | grep -q pass"

    check_task "server1" "Tar archive /root/etc-backup.tar.gz created" 5 \
        "test -f /root/etc-backup.tar.gz && tar -tzf /root/etc-backup.tar.gz >/dev/null 2>&1"

    # Task 1.2 - File Permissions
    check_task "server1" "File /exam/testfile.txt exists with content" 3 \
        "grep -q 'RHCSA Exam' /exam/testfile.txt 2>/dev/null"

    check_task "server1" "Correct permissions (640) on testfile.txt" 4 \
        "stat -c '%a' /exam/testfile.txt 2>/dev/null | grep -q '640'"

    check_task "server1" "Correct ownership (root:wheel) on testfile.txt" 3 \
        "stat -c '%U:%G' /exam/testfile.txt 2>/dev/null | grep -q 'root:wheel'"

    # Task 1.3 - Text Processing
    check_task "server1" "nologin-users.txt contains nologin entries" 5 \
        "test -f /exam/nologin-users.txt && grep -q nologin /exam/nologin-users.txt"

    check_task "server1" "line-count.txt exists with line count" 5 \
        "test -f /exam/line-count.txt && grep -qE '^[0-9]+$' /exam/line-count.txt"

    # Task 1.4 - Script creation
    check_task "server1" "sysinfo.sh script exists and is executable" 5 \
        "test -x /exam/scripts/sysinfo.sh"

    check_task "server1" "sysinfo.sh outputs date, hostname, user" 5 \
        "/exam/scripts/sysinfo.sh 2>/dev/null | grep -q -E '(date|hostname|$(whoami))' || bash /exam/scripts/sysinfo.sh 2>/dev/null"

    # Task 1.5 - Man pages
    check_task "server1" "man-answer.txt contains section 5" 10 \
        "grep -q '5' /exam/man-answer.txt 2>/dev/null"
}

validate_section2() {
    print_section "Section 2: Shell Scripts"

    # Task 2.1 - Conditional Script
    check_task "server1" "check-service.sh exists and is executable" 5 \
        "test -x /exam/scripts/check-service.sh"

    check_task "server1" "check-service.sh works correctly" 5 \
        "/exam/scripts/check-service.sh sshd 2>/dev/null | grep -qi 'running'"

    # Task 2.2 - Loop Script
    check_task "server1" "create-users.sh exists and is executable" 5 \
        "test -x /exam/scripts/create-users.sh"

    check_task "server1" "Script created users from userlist.txt" 5 \
        "id testuser1 &>/dev/null || id testuser2 &>/dev/null || id testuser3 &>/dev/null"
}

validate_section3() {
    print_section "Section 3: Operate Running Systems"

    # Task 3.1 - Boot Targets
    check_task_with_output "server1" "Default target is multi-user.target" 10 \
        "systemctl get-default" "multi-user.target"

    # Task 3.2 - Process Management (checking if they know how to use ps/top)
    check_task "server1" "Can identify sshd process" 5 \
        "pgrep sshd >/dev/null"

    # Task 3.3 - System Logs
    check_task "server1" "Persistent journal configured" 10 \
        "test -d /var/log/journal && ls /var/log/journal/ | grep -q ."
}

validate_section4() {
    print_section "Section 4: Local Storage"

    # Check for loop device setup
    check_task "server1" "Loop device configured for LVM practice" 5 \
        "losetup -a | grep -q exam-disk"

    # Task 4.2 - LVM
    check_task "server1" "Volume group 'examvg' exists" 5 \
        "vgs examvg &>/dev/null"

    check_task "server1" "Logical volume 'examlv' exists" 5 \
        "lvs examvg/examlv &>/dev/null"

    check_task "server1" "/mnt/examdata is mounted" 5 \
        "mountpoint -q /mnt/examdata 2>/dev/null"

    check_task "server1" "/mnt/examdata in fstab for persistence" 5 \
        "grep -q '/mnt/examdata' /etc/fstab"

    # Task 4.4 - Swap
    check_task "server1" "Swap space configured" 5 \
        "swapon --show | grep -q -E '(file|partition)'"
}

validate_section5() {
    print_section "Section 5: File Systems"

    # Task 5.1 - Directory permissions
    check_task "server1" "Directory /shared/projects exists" 3 \
        "test -d /shared/projects"

    check_task "server1" "SGID set on /shared/projects" 4 \
        "stat -c '%a' /shared/projects | grep -qE '^2'"

    check_task "server1" "Group 'developers' exists" 3 \
        "getent group developers >/dev/null"

    # Task 5.2 - ACLs
    check_task "server1" "User 'alice' exists" 2 \
        "id alice &>/dev/null"

    check_task "server1" "User 'bob' exists" 2 \
        "id bob &>/dev/null"

    check_task "server1" "ACLs configured on /shared/projects" 6 \
        "getfacl /shared/projects 2>/dev/null | grep -q 'user:'"
}

validate_section6() {
    print_section "Section 6: Deploy, Configure, Maintain"

    # Task 6.1 - Software Management
    check_task "server1" "DNF repo 'examrepo' configured" 5 \
        "test -f /etc/yum.repos.d/examrepo.repo || dnf repolist | grep -qi exam"

    check_task "server1" "httpd package installed" 5 \
        "rpm -q httpd &>/dev/null"

    # Task 6.2 - Service Management
    check_task "server1" "httpd service enabled" 5 \
        "systemctl is-enabled httpd &>/dev/null"

    check_task "server1" "httpd service running" 5 \
        "systemctl is-active httpd &>/dev/null"

    # Task 6.3 - Scheduled Tasks
    check_task "server1" "Cron job for sysinfo.sh exists" 5 \
        "crontab -l 2>/dev/null | grep -q sysinfo"

    # Task 6.4 - Time
    check_task_with_output "server1" "Timezone set to America/New_York" 5 \
        "timedatectl | grep 'Time zone'" "New_York"
}

validate_section7() {
    print_section "Section 7: Networking"

    # Task 7.2 - Hostname
    check_task_with_output "server2" "Hostname set correctly" 5 \
        "hostnamectl --static" "examhost"

    # Task 7.3 - Firewall
    check_task "server1" "Firewall is running" 3 \
        "systemctl is-active firewalld &>/dev/null"

    check_task "server1" "HTTP allowed in firewall" 4 \
        "firewall-cmd --list-services | grep -q http"

    check_task "server1" "HTTPS allowed in firewall" 3 \
        "firewall-cmd --list-services | grep -q https"
}

validate_section8() {
    print_section "Section 8: Users and Groups"

    # Task 8.1 - User Management
    check_task "server1" "User 'admin1' exists with UID 2001" 4 \
        "id admin1 2>/dev/null | grep -q '2001'"

    check_task "server1" "admin1 is member of wheel group" 3 \
        "id admin1 2>/dev/null | grep -q wheel"

    check_task "server1" "User 'developer1' exists" 3 \
        "id developer1 &>/dev/null"

    # Task 8.2 - Group Management
    check_task "server1" "Group 'developers' has GID 3000" 3 \
        "getent group developers | grep -q ':3000:'"

    check_task "server1" "developer1 in developers group" 2 \
        "id developer1 2>/dev/null | grep -q developers"

    # Task 8.3 - Password Policies
    check_task "server1" "Password aging configured for developer1" 5 \
        "chage -l developer1 2>/dev/null | grep -q 'Maximum'"

    check_task "server1" "User 'contractor1' account locked" 5 \
        "passwd -S contractor1 2>/dev/null | grep -qE '(LK|L)'"
}

validate_section9() {
    print_section "Section 9: Security"

    # Task 9.1 - SELinux
    check_task_with_output "server1" "SELinux is enforcing" 5 \
        "getenforce" "Enforcing"

    # Task 9.2 - SSH
    check_task "server1" "SSH root login disabled" 5 \
        "grep -E '^PermitRootLogin\s+no' /etc/ssh/sshd_config"

    # Task 9.3 - Sudo
    check_task "server1" "Sudo configured for developers group" 5 \
        "grep -r developers /etc/sudoers /etc/sudoers.d/ 2>/dev/null | grep -q httpd"
}

run_all_validations() {
    validate_section1
    validate_section2
    validate_section3
    validate_section4
    validate_section5
    validate_section6
    validate_section7
    validate_section8
    validate_section9
}

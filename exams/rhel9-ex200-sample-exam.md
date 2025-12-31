# RHCSA EX200 Practice Exam - RHEL 9

## Exam Information
- **Time Limit:** 2.5 hours (150 minutes)
- **Passing Score:** 70% (210/300 points)
- **Total Points:** 300

---

## Section 1: Essential Tools (50 points)

### Task 1.1: Basic File Operations (10 points)
On server1:
1. Create the directory `/exam/archives` if it doesn't exist
2. Copy all files starting with "pass" from `/etc` to `/exam/archives`
3. Create a compressed tar archive of `/etc` at `/root/etc-backup.tar.gz`

### Task 1.2: File Permissions (10 points)
On server1:
1. Create a file `/exam/testfile.txt` containing the text "RHCSA Exam"
2. Set permissions to 640 (rw-r-----)
3. Change ownership to root:wheel

### Task 1.3: Text Processing (10 points)
On server1:
1. Create `/exam/nologin-users.txt` containing all users with `/sbin/nologin` shell
2. Create `/exam/line-count.txt` containing only the line count of `/etc/passwd`

### Task 1.4: Script Creation (10 points)
On server1:
1. Create an executable script `/exam/scripts/sysinfo.sh`
2. The script should display the current date, hostname, and logged-in user

### Task 1.5: Documentation (10 points)
On server1:
1. Find which section of the manual contains the passwd configuration file
2. Save the section number to `/exam/man-answer.txt`

---

## Section 2: Shell Scripts (20 points)

### Task 2.1: Conditional Script (10 points)
On server1:
1. Create an executable script `/exam/scripts/check-service.sh`
2. The script should accept a service name as argument
3. Output "running" or "stopped" based on service status

### Task 2.2: Loop Script (10 points)
On server1:
1. Create an executable script `/exam/scripts/create-users.sh`
2. Read usernames from `/exam/userlist.txt`
3. Create each user if they don't exist

---

## Section 3: Operate Running Systems (25 points)

### Task 3.1: Boot Targets (10 points)
On server1:
1. Set the default boot target to multi-user.target

### Task 3.2: Process Management (5 points)
On server1:
1. Identify the PID of the sshd process
2. Verify you can use ps and top commands

### Task 3.3: System Logs (10 points)
On server1:
1. Configure persistent journald storage
2. Ensure logs survive reboot

---

## Section 4: Local Storage (30 points)

### Task 4.1: Loop Device (5 points)
On server1:
1. Verify the loop device is configured for LVM practice

### Task 4.2: LVM Configuration (20 points)
On server1:
1. Create a volume group named `examvg` using available storage
2. Create a logical volume named `examlv` (200MB)
3. Format with xfs filesystem
4. Mount persistently at `/mnt/examdata`

### Task 4.3: Swap Space (5 points)
On server1:
1. Create and enable additional swap space

---

## Section 5: File Systems (20 points)

### Task 5.1: Directory Permissions (10 points)
On server1:
1. Create directory `/shared/projects`
2. Create group `developers`
3. Set SGID on the directory
4. Set group ownership to `developers`

### Task 5.2: Access Control Lists (10 points)
On server1:
1. Create users `alice` and `bob`
2. Configure ACLs on `/shared/projects`:
   - alice: read/write/execute
   - bob: read only

---

## Section 6: Deploy, Configure, Maintain (30 points)

### Task 6.1: Software Management (10 points)
On server1:
1. Configure a DNF repository named `examrepo`
2. Ensure httpd package is installed

### Task 6.2: Service Management (10 points)
On server1:
1. Enable httpd service to start at boot
2. Start the httpd service

### Task 6.3: Scheduled Tasks (5 points)
On server1:
1. Create a cron job to run `/exam/scripts/sysinfo.sh` daily at midnight

### Task 6.4: Time Configuration (5 points)
On server1:
1. Set the timezone to America/New_York

---

## Section 7: Networking (15 points)

### Task 7.1: Hostname (5 points)
On server2:
1. Set the static hostname to `examhost`

### Task 7.2: Firewall (10 points)
On server1:
1. Ensure firewalld is running
2. Allow HTTP and HTTPS services permanently

---

## Section 8: Users and Groups (25 points)

### Task 8.1: User Management (10 points)
On server1:
1. Create user `admin1` with UID 2001
2. Add `admin1` to the wheel group
3. Create user `developer1`

### Task 8.2: Group Management (5 points)
On server1:
1. Create group `developers` with GID 3000
2. Add `developer1` to the developers group

### Task 8.3: Password Policies (10 points)
On server1:
1. Configure password aging for `developer1` (max 90 days)
2. Create user `contractor1` and lock the account

---

## Section 9: Security (15 points)

### Task 9.1: SELinux (5 points)
On server1:
1. Ensure SELinux is in enforcing mode

### Task 9.2: SSH Security (5 points)
On server1:
1. Disable root login via SSH

### Task 9.3: Sudo Configuration (5 points)
On server1:
1. Allow members of `developers` group to manage httpd service without password

---

## Exam Tips

- Read each task carefully before starting
- Use tab completion and man pages
- Verify your work using the validation script
- Time management is crucial - don't spend too long on one task
- Make sure persistent configurations survive reboot

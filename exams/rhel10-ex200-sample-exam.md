# RHCSA EX200 Practice Exam - RHEL 10

## Exam Information
- **Time Limit:** 3 hours (180 minutes)
- **Passing Score:** 70% (217/310 points)
- **Total Points:** 310

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

## Section 2: Software Management (25 points)

### Task 2.1: DNF Repository (5 points)
On server1:
1. Configure a DNF repository named `examrepo`
2. Verify the repository is enabled

### Task 2.2: RPM Package Management (5 points)
On server1:
1. Ensure the httpd package is installed
2. Query package information using rpm

### Task 2.3: Flatpak Repository (NEW - 5 points)
On server1:
1. Verify the Flathub remote is configured
2. List available Flatpak remotes

### Task 2.4: Flatpak Package Management (NEW - 10 points)
On server1:
1. Search for a calculator application in Flatpak
2. Install the GNOME Calculator Flatpak (org.gnome.Calculator)
3. List installed Flatpak applications
4. Remove the Calculator Flatpak after verification

---

## Section 3: Shell Scripting (20 points)

### Task 3.1: Conditional Script (10 points)
On server1:
1. Create an executable script `/exam/scripts/check-service.sh`
2. The script should accept a service name as argument
3. Output "running" or "stopped" based on service status

### Task 3.2: Loop Script (10 points)
On server1:
1. Create an executable script `/exam/scripts/create-users.sh`
2. Read usernames from `/exam/userlist.txt`
3. Create each user if they don't exist

---

## Section 4: Operate Running Systems (35 points)

### Task 4.1: Boot Targets (10 points)
On server1:
1. Set the default boot target to multi-user.target

### Task 4.2: Process Management (5 points)
On server1:
1. Identify the PID of the sshd process
2. Verify you can use ps and top commands

### Task 4.3: System Logs (10 points)
On server1:
1. Configure persistent journald storage
2. Ensure logs survive reboot

### Task 4.4: Systemd Timers (NEW - 10 points)
On server1:
1. Create a systemd service unit `/etc/systemd/system/exam-backup.service`:
   - Type=oneshot
   - ExecStart=/exam/scripts/backup.sh
2. Create a systemd timer `/etc/systemd/system/exam-backup.timer`:
   - Run daily at 2:00 AM (OnCalendar=*-*-* 02:00:00)
   - Also run 15 minutes after boot (OnBootSec=15min)
3. Enable and start the timer
4. Verify with `systemctl list-timers`

---

## Section 5: Local Storage (35 points)

### Task 5.1: Loop Device (5 points)
On server1:
1. Verify the loop device is configured for LVM practice

### Task 5.2: LVM Configuration (25 points)
On server1:
1. Create a physical volume on the loop device
2. Create a volume group named `examvg`
3. Create a logical volume named `examlv` (200MB)
4. Format with xfs filesystem
5. Mount persistently at `/mnt/examdata`

### Task 5.3: Swap Space (5 points)
On server1:
1. Create and enable additional swap space using a file or LV

---

## Section 6: File Systems (30 points)

### Task 6.1: Directory Permissions (10 points)
On server1:
1. Create directory `/shared/projects`
2. Create group `developers`
3. Set SGID on the directory
4. Set group ownership to `developers`

### Task 6.2: Access Control Lists (10 points)
On server1:
1. Create users `alice` and `bob`
2. Configure ACLs on `/shared/projects`:
   - alice: read/write/execute
   - bob: read only

### Task 6.3: NFS Client (10 points)
On server1:
1. Configure autofs to mount NFS shares on demand
2. Create the master map entry for `/mnt/nfsdata`

---

## Section 7: Deploy, Configure, Maintain (30 points)

### Task 7.1: Service Management (10 points)
On server1:
1. Enable httpd service to start at boot
2. Start the httpd service

### Task 7.2: Scheduled Tasks (10 points)
On server1:
1. Create a cron job to run `/exam/scripts/sysinfo.sh` daily at midnight
2. Create an at job to run a command in 5 minutes

### Task 7.3: Time Configuration (5 points)
On server1:
1. Set the timezone to America/New_York
2. Verify chrony is configured for time synchronization

### Task 7.4: Tuned Profiles (5 points)
On server1:
1. List available tuned profiles
2. Set the active profile to `throughput-performance`

---

## Section 8: Networking (30 points)

### Task 8.1: Network Configuration (10 points)
On server1:
1. Verify network connectivity to server2
2. Display all network connections using nmcli

### Task 8.2: Hostname (5 points)
On server2:
1. Set the static hostname to `examhost`

### Task 8.3: Hostname Resolution (5 points)
On server1:
1. Add an entry to /etc/hosts for server2

### Task 8.4: Firewall (10 points)
On server1:
1. Ensure firewalld is running
2. Allow HTTP and HTTPS services permanently
3. Reload firewall rules

---

## Section 9: Users and Groups (25 points)

### Task 9.1: User Management (10 points)
On server1:
1. Create user `admin1` with UID 2001
2. Add `admin1` to the wheel group
3. Create user `developer1`

### Task 9.2: Group Management (5 points)
On server1:
1. Create group `developers` with GID 3000
2. Add `developer1` to the developers group

### Task 9.3: Password Policies (10 points)
On server1:
1. Configure password aging for `developer1` (max 90 days)
2. Create user `contractor1` and lock the account

---

## Section 10: Security (30 points)

### Task 10.1: SELinux (10 points)
On server1:
1. Ensure SELinux is in enforcing mode
2. List SELinux contexts for web content directory
3. Restore default contexts for `/var/www/html`

### Task 10.2: SSH Security (10 points)
On server1:
1. Disable root login via SSH
2. Configure key-based authentication for admin1

### Task 10.3: Sudo Configuration (5 points)
On server1:
1. Allow members of `developers` group to manage httpd service without password

### Task 10.4: Firewall Security (5 points)
On server1:
1. Block a specific IP address using firewalld rich rules
2. List all active firewall rules

---

## Exam Tips

- Read each task carefully before starting
- Use tab completion and man pages
- Verify your work using the validation script
- Time management is crucial - don't spend too long on one task
- Make sure persistent configurations survive reboot
- For Flatpak tasks: Use `flatpak remote-list`, `flatpak search`, `flatpak install`, `flatpak list`
- For systemd timers: Remember both .service and .timer units are needed

## Quick Reference - New RHEL 10 Commands

### Flatpak
```bash
flatpak remote-list                    # List remotes
flatpak remote-add NAME URL            # Add remote
flatpak search NAME                    # Search packages
flatpak install REMOTE PACKAGE         # Install package
flatpak list                           # List installed
flatpak remove PACKAGE                 # Remove package
```

### Systemd Timers
```bash
systemctl list-timers                  # List active timers
systemctl enable --now NAME.timer      # Enable and start timer
systemctl status NAME.timer            # Check timer status
systemd-analyze calendar "SPEC"        # Test calendar spec
```

# RHCSA EX200 Practice Lab

A containerized practice environment for the Red Hat Certified System Administrator (RHCSA) exam. Supports both **RHEL 9** and **RHEL 10** exam objectives with AlmaLinux or Rocky Linux.

## Prerequisites

- **Podman** (recommended) or Docker
- Linux host (tested on Fedora, RHEL, Rocky Linux, AlmaLinux)
- ~2GB disk space for the container image

## Quick Start

```bash
# 1. Make scripts executable
chmod +x *.sh

# 2. Start the lab environment
./setup-lab.sh start              # RHEL 10 + Rocky Linux (default)
./setup-lab.sh start --alma       # RHEL 10 + AlmaLinux
./setup-lab.sh start --rhel9      # RHEL 9 + Rocky Linux

# 3. Launch the interactive menu
./exam-menu.sh
```

## Version Selection

| Command | RHEL Version | Distribution |
|---------|--------------|--------------|
| `./setup-lab.sh start` | 10 (default) | Rocky Linux |
| `./setup-lab.sh start --alma` | 10 | AlmaLinux |
| `./setup-lab.sh start --rhel9` | 9 | Rocky Linux |
| `./setup-lab.sh start --rhel9 --alma` | 9 | AlmaLinux |

## Lab Components

| File | Description |
|------|-------------|
| `setup-lab.sh` | Build image and manage containers |
| `exam-menu.sh` | Interactive menu for exam practice |
| `validate-tasks.sh` | Automated task validation |
| `exam-timer.sh` | Countdown timer (3h for RHEL 10, 2.5h for RHEL 9) |
| `containerfiles/` | Version-specific container definitions |
| `exams/` | Version-specific exam task documents |
| `validation/` | Version-specific validation scripts |

## Usage

### Starting the Lab

```bash
./setup-lab.sh start    # Build and start containers
./setup-lab.sh stop     # Stop and remove containers
./setup-lab.sh reset    # Reset to fresh state
./setup-lab.sh status   # Check container status
./setup-lab.sh build    # Build image only
```

### Connecting to Servers

```bash
# Using podman/docker directly
podman exec -it server1 bash
podman exec -it server2 bash

# Or use the interactive menu
./exam-menu.sh
```

### Validating Your Work

```bash
# Validate all sections
./validate-tasks.sh

# Validate specific section
./validate-tasks.sh 1          # Essential Tools
./validate-tasks.sh 2          # Software/Scripts
./validate-tasks.sh storage    # Local Storage
./validate-tasks.sh security   # Security
```

## Lab Environment

| Server | Hostname | IP Address |
|--------|----------|------------|
| server1 | server1.example.com | 192.168.100.10 |
| server2 | server2.example.com | 192.168.100.11 |

**Root Password:** `redhat`

## RHEL 10 EX200 Exam Sections (New)

| Section | Domain | Points | New in RHEL 10 |
|---------|--------|--------|----------------|
| 1 | Essential Tools | 50 | - |
| 2 | Software Management | 25 | **Flatpak added** |
| 3 | Shell Scripting | 20 | - |
| 4 | Running Systems | 35 | **systemd timers** |
| 5 | Local Storage | 35 | - |
| 6 | File Systems | 30 | - |
| 7 | Deploy/Configure | 30 | - |
| 8 | Networking | 30 | - |
| 9 | Users/Groups | 25 | - |
| 10 | Security | 30 | - |

**Total: 310 points | Passing: 217 (70%)**

> **Note:** Podman/container tasks have been removed from RHEL 10 exam objectives.

### RHEL 10 Exam Tasks

---

#### Section 1: Essential Tools (50 points)

##### Task 1.1: Basic File Operations (10 points)
On server1:
1. Create the directory `/exam/archives` if it doesn't exist
2. Copy all files starting with "pass" from `/etc` to `/exam/archives`
3. Create a compressed tar archive of `/etc` at `/root/etc-backup.tar.gz`

##### Task 1.2: File Permissions (10 points)
On server1:
1. Create a file `/exam/testfile.txt` containing the text "RHCSA Exam"
2. Set permissions to 640 (rw-r-----)
3. Change ownership to root:wheel

##### Task 1.3: Text Processing (10 points)
On server1:
1. Create `/exam/nologin-users.txt` containing all users with `/sbin/nologin` shell
2. Create `/exam/line-count.txt` containing only the line count of `/etc/passwd`

##### Task 1.4: Script Creation (10 points)
On server1:
1. Create an executable script `/exam/scripts/sysinfo.sh`
2. The script should display the current date, hostname, and logged-in user

##### Task 1.5: Documentation (10 points)
On server1:
1. Find which section of the manual contains the passwd configuration file
2. Save the section number to `/exam/man-answer.txt`

---

#### Section 2: Software Management (25 points)

##### Task 2.1: DNF Repository (5 points)
On server1:
1. Configure a DNF repository named `examrepo`
2. Verify the repository is enabled

##### Task 2.2: RPM Package Management (5 points)
On server1:
1. Ensure the httpd package is installed
2. Query package information using rpm

##### Task 2.3: Flatpak Repository (NEW - 5 points)
On server1:
1. Verify the Flathub remote is configured
2. List available Flatpak remotes

##### Task 2.4: Flatpak Package Management (NEW - 10 points)
On server1:
1. Search for a calculator application in Flatpak
2. Install the GNOME Calculator Flatpak (org.gnome.Calculator)
3. List installed Flatpak applications
4. Remove the Calculator Flatpak after verification

---

#### Section 3: Shell Scripting (20 points)

##### Task 3.1: Conditional Script (10 points)
On server1:
1. Create an executable script `/exam/scripts/check-service.sh`
2. The script should accept a service name as argument
3. Output "running" or "stopped" based on service status

##### Task 3.2: Loop Script (10 points)
On server1:
1. Create an executable script `/exam/scripts/create-users.sh`
2. Read usernames from `/exam/userlist.txt`
3. Create each user if they don't exist

---

#### Section 4: Operate Running Systems (35 points)

##### Task 4.1: Boot Targets (10 points)
On server1:
1. Set the default boot target to multi-user.target

##### Task 4.2: Process Management (5 points)
On server1:
1. Identify the PID of the sshd process
2. Verify you can use ps and top commands

##### Task 4.3: System Logs (10 points)
On server1:
1. Configure persistent journald storage
2. Ensure logs survive reboot

##### Task 4.4: Systemd Timers (NEW - 10 points)
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

#### Section 5: Local Storage (35 points)

##### Task 5.1: Loop Device (5 points)
On server1:
1. Verify the loop device is configured for LVM practice

##### Task 5.2: LVM Configuration (25 points)
On server1:
1. Create a physical volume on the loop device
2. Create a volume group named `examvg`
3. Create a logical volume named `examlv` (200MB)
4. Format with xfs filesystem
5. Mount persistently at `/mnt/examdata`

##### Task 5.3: Swap Space (5 points)
On server1:
1. Create and enable additional swap space using a file or LV

---

#### Section 6: File Systems (30 points)

##### Task 6.1: Directory Permissions (10 points)
On server1:
1. Create directory `/shared/projects`
2. Create group `developers`
3. Set SGID on the directory
4. Set group ownership to `developers`

##### Task 6.2: Access Control Lists (10 points)
On server1:
1. Create users `alice` and `bob`
2. Configure ACLs on `/shared/projects`:
   - alice: read/write/execute
   - bob: read only

##### Task 6.3: NFS Client (10 points)
On server1:
1. Configure autofs to mount NFS shares on demand
2. Create the master map entry for `/mnt/nfsdata`

---

#### Section 7: Deploy, Configure, Maintain (30 points)

##### Task 7.1: Service Management (10 points)
On server1:
1. Enable httpd service to start at boot
2. Start the httpd service

##### Task 7.2: Scheduled Tasks (10 points)
On server1:
1. Create a cron job to run `/exam/scripts/sysinfo.sh` daily at midnight
2. Create an at job to run a command in 5 minutes

##### Task 7.3: Time Configuration (5 points)
On server1:
1. Set the timezone to America/New_York
2. Verify chrony is configured for time synchronization

##### Task 7.4: Tuned Profiles (5 points)
On server1:
1. List available tuned profiles
2. Set the active profile to `throughput-performance`

---

#### Section 8: Networking (30 points)

##### Task 8.1: Network Configuration (10 points)
On server1:
1. Verify network connectivity to server2
2. Display all network connections using nmcli

##### Task 8.2: Hostname (5 points)
On server2:
1. Set the static hostname to `examhost`

##### Task 8.3: Hostname Resolution (5 points)
On server1:
1. Add an entry to /etc/hosts for server2

##### Task 8.4: Firewall (10 points)
On server1:
1. Ensure firewalld is running
2. Allow HTTP and HTTPS services permanently
3. Reload firewall rules

---

#### Section 9: Users and Groups (25 points)

##### Task 9.1: User Management (10 points)
On server1:
1. Create user `admin1` with UID 2001
2. Add `admin1` to the wheel group
3. Create user `developer1`

##### Task 9.2: Group Management (5 points)
On server1:
1. Create group `developers` with GID 3000
2. Add `developer1` to the developers group

##### Task 9.3: Password Policies (10 points)
On server1:
1. Configure password aging for `developer1` (max 90 days)
2. Create user `contractor1` and lock the account

---

#### Section 10: Security (30 points)

##### Task 10.1: SELinux (10 points)
On server1:
1. Ensure SELinux is in enforcing mode
2. List SELinux contexts for web content directory
3. Restore default contexts for `/var/www/html`

##### Task 10.2: SSH Security (10 points)
On server1:
1. Disable root login via SSH
2. Configure key-based authentication for admin1

##### Task 10.3: Sudo Configuration (5 points)
On server1:
1. Allow members of `developers` group to manage httpd service without password

##### Task 10.4: Firewall Security (5 points)
On server1:
1. Block a specific IP address using firewalld rich rules
2. List all active firewall rules

## RHEL 9 EX200 Exam Sections (Legacy)

| Section | Domain | Points |
|---------|--------|--------|
| 1 | Essential Tools | 50 |
| 2 | Shell Scripts | 20 |
| 3 | Operating Systems | 25 |
| 4 | Local Storage | 30 |
| 5 | File Systems | 20 |
| 6 | Deploy/Configure | 30 |
| 7 | Networking | 15 |
| 8 | Users & Groups | 25 |
| 9 | Security | 15 |

**Total: 300 points | Passing: 210 (70%)**

### RHEL 9 Exam Tasks

---

#### Section 1: Essential Tools (50 points)

##### Task 1.1: Basic File Operations (10 points)
On server1:
1. Create the directory `/exam/archives` if it doesn't exist
2. Copy all files starting with "pass" from `/etc` to `/exam/archives`
3. Create a compressed tar archive of `/etc` at `/root/etc-backup.tar.gz`

##### Task 1.2: File Permissions (10 points)
On server1:
1. Create a file `/exam/testfile.txt` containing the text "RHCSA Exam"
2. Set permissions to 640 (rw-r-----)
3. Change ownership to root:wheel

##### Task 1.3: Text Processing (10 points)
On server1:
1. Create `/exam/nologin-users.txt` containing all users with `/sbin/nologin` shell
2. Create `/exam/line-count.txt` containing only the line count of `/etc/passwd`

##### Task 1.4: Script Creation (10 points)
On server1:
1. Create an executable script `/exam/scripts/sysinfo.sh`
2. The script should display the current date, hostname, and logged-in user

##### Task 1.5: Documentation (10 points)
On server1:
1. Find which section of the manual contains the passwd configuration file
2. Save the section number to `/exam/man-answer.txt`

---

#### Section 2: Shell Scripts (20 points)

##### Task 2.1: Conditional Script (10 points)
On server1:
1. Create an executable script `/exam/scripts/check-service.sh`
2. The script should accept a service name as argument
3. Output "running" or "stopped" based on service status

##### Task 2.2: Loop Script (10 points)
On server1:
1. Create an executable script `/exam/scripts/create-users.sh`
2. Read usernames from `/exam/userlist.txt`
3. Create each user if they don't exist

---

#### Section 3: Operate Running Systems (25 points)

##### Task 3.1: Boot Targets (10 points)
On server1:
1. Set the default boot target to multi-user.target

##### Task 3.2: Process Management (5 points)
On server1:
1. Identify the PID of the sshd process
2. Verify you can use ps and top commands

##### Task 3.3: System Logs (10 points)
On server1:
1. Configure persistent journald storage
2. Ensure logs survive reboot

---

#### Section 4: Local Storage (30 points)

##### Task 4.1: Loop Device (5 points)
On server1:
1. Verify the loop device is configured for LVM practice

##### Task 4.2: LVM Configuration (20 points)
On server1:
1. Create a volume group named `examvg` using available storage
2. Create a logical volume named `examlv` (200MB)
3. Format with xfs filesystem
4. Mount persistently at `/mnt/examdata`

##### Task 4.3: Swap Space (5 points)
On server1:
1. Create and enable additional swap space

---

#### Section 5: File Systems (20 points)

##### Task 5.1: Directory Permissions (10 points)
On server1:
1. Create directory `/shared/projects`
2. Create group `developers`
3. Set SGID on the directory
4. Set group ownership to `developers`

##### Task 5.2: Access Control Lists (10 points)
On server1:
1. Create users `alice` and `bob`
2. Configure ACLs on `/shared/projects`:
   - alice: read/write/execute
   - bob: read only

---

#### Section 6: Deploy, Configure, Maintain (30 points)

##### Task 6.1: Software Management (10 points)
On server1:
1. Configure a DNF repository named `examrepo`
2. Ensure httpd package is installed

##### Task 6.2: Service Management (10 points)
On server1:
1. Enable httpd service to start at boot
2. Start the httpd service

##### Task 6.3: Scheduled Tasks (5 points)
On server1:
1. Create a cron job to run `/exam/scripts/sysinfo.sh` daily at midnight

##### Task 6.4: Time Configuration (5 points)
On server1:
1. Set the timezone to America/New_York

---

#### Section 7: Networking (15 points)

##### Task 7.1: Hostname (5 points)
On server2:
1. Set the static hostname to `examhost`

##### Task 7.2: Firewall (10 points)
On server1:
1. Ensure firewalld is running
2. Allow HTTP and HTTPS services permanently

---

#### Section 8: Users and Groups (25 points)

##### Task 8.1: User Management (10 points)
On server1:
1. Create user `admin1` with UID 2001
2. Add `admin1` to the wheel group
3. Create user `developer1`

##### Task 8.2: Group Management (5 points)
On server1:
1. Create group `developers` with GID 3000
2. Add `developer1` to the developers group

##### Task 8.3: Password Policies (10 points)
On server1:
1. Configure password aging for `developer1` (max 90 days)
2. Create user `contractor1` and lock the account

---

#### Section 9: Security (15 points)

##### Task 9.1: SELinux (5 points)
On server1:
1. Ensure SELinux is in enforcing mode

##### Task 9.2: SSH Security (5 points)
On server1:
1. Disable root login via SSH

##### Task 9.3: Sudo Configuration (5 points)
On server1:
1. Allow members of `developers` group to manage httpd service without password

## New RHEL 10 Features

### Flatpak Package Management

```bash
flatpak remote-list                     # List configured remotes
flatpak remote-add NAME URL             # Add a remote
flatpak search PACKAGE                  # Search for packages
flatpak install REMOTE PACKAGE          # Install a package
flatpak list                            # List installed packages
flatpak remove PACKAGE                  # Remove a package
```

### Systemd Timers

```bash
# Create a service unit (/etc/systemd/system/myservice.service)
# Create a timer unit (/etc/systemd/system/myservice.timer)
systemctl enable --now myservice.timer  # Enable and start timer
systemctl list-timers                   # List active timers
systemctl status myservice.timer        # Check timer status
```

## Container Limitations

| Feature | Status | Notes |
|---------|--------|-------|
| User/Group Management | Full | Works normally |
| File Permissions/ACLs | Full | Works normally |
| Services (systemd) | Full | With --privileged |
| Firewall | Full | firewalld works |
| Flatpak | Full | RHEL 10 only |
| SELinux | Partial | Depends on host |
| LVM | Partial | Use /dev/loop0 (500MB image) |
| Boot Targets | View Only | Can set but no real boot |
| Kernel Modules | No | Cannot load modules |
| Real Partitioning | No | Use loop devices |

### LVM Practice

A 500MB disk image is pre-configured:

```bash
# Inside server1
losetup -a                    # Verify loop device
# Use /dev/loop0 for LVM practice
pvcreate /dev/loop0
vgcreate examvg /dev/loop0
lvcreate -L 200M -n examlv examvg
```

## Tips for Success

1. Read each task completely before starting
2. Use `man` pages - they're allowed on the real exam
3. Test persistence: Check if configs survive container restart
4. Use `systemctl` for all service management
5. Always verify your work with the validation script
6. Practice with the timer to simulate real exam pressure
7. For RHEL 10: Practice Flatpak commands and systemd timers

## Troubleshooting

**Containers won't start:**
```bash
# Check if containers exist
podman ps -a

# Remove and restart
./setup-lab.sh reset
```

**Permission denied errors:**
```bash
# Ensure scripts are executable
chmod +x *.sh
```

**SELinux issues:**
```bash
# Check host SELinux status
getenforce

# Container SELinux may be limited if host is permissive
```

**Wrong RHEL version running:**
```bash
# Stop current lab
./setup-lab.sh stop

# Start with desired version
./setup-lab.sh start --rhel9      # For RHEL 9
./setup-lab.sh start              # For RHEL 10 (default)
```

## Full VM Alternative

For complete exam simulation (boot targets, real LVM, full SELinux), consider:

1. **Vagrant + libvirt/VirtualBox** with Rocky/AlmaLinux 10 boxes
2. **RHEL Developer Subscription** (free) for real RHEL VMs
3. **Cloud instances** (AWS, GCP, Azure) with RHEL/Rocky/AlmaLinux

## Sources

- [Red Hat EX200 Exam Objectives](https://www.redhat.com/en/services/training/ex200-red-hat-certified-system-administrator-rhcsa-exam)
- [AlmaLinux Docker Hub](https://hub.docker.com/_/almalinux)
- [Rocky Linux Docker Hub](https://hub.docker.com/r/rockylinux/rockylinux)

## License

This practice material is for educational purposes. Not affiliated with Red Hat.

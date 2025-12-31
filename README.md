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

<details>
<summary>Section 1: Essential Tools (50 pts)</summary>

- **1.1 Basic File Operations** (10 pts): Create `/exam/archives`, copy files from `/etc`, create tar archive
- **1.2 File Permissions** (10 pts): Create file with specific permissions and ownership
- **1.3 Text Processing** (10 pts): Extract users with nologin shell, count lines in passwd
- **1.4 Script Creation** (10 pts): Create sysinfo.sh script showing date, hostname, user
- **1.5 Documentation** (10 pts): Find manual section for passwd config file
</details>

<details>
<summary>Section 2: Software Management (25 pts)</summary>

- **2.1 DNF Repository** (5 pts): Configure and verify examrepo
- **2.2 RPM Package Management** (5 pts): Install and query httpd package
- **2.3 Flatpak Repository** (5 pts) ⭐NEW: Verify Flathub remote configuration
- **2.4 Flatpak Package Management** (10 pts) ⭐NEW: Search, install, list, remove Flatpak apps
</details>

<details>
<summary>Section 3: Shell Scripting (20 pts)</summary>

- **3.1 Conditional Script** (10 pts): Create check-service.sh with argument handling
- **3.2 Loop Script** (10 pts): Create create-users.sh reading from file
</details>

<details>
<summary>Section 4: Operate Running Systems (35 pts)</summary>

- **4.1 Boot Targets** (10 pts): Set default to multi-user.target
- **4.2 Process Management** (5 pts): Identify sshd PID, use ps/top
- **4.3 System Logs** (10 pts): Configure persistent journald storage
- **4.4 Systemd Timers** (10 pts) ⭐NEW: Create service/timer units, enable daily backup
</details>

<details>
<summary>Section 5: Local Storage (35 pts)</summary>

- **5.1 Loop Device** (5 pts): Verify loop device for LVM
- **5.2 LVM Configuration** (25 pts): Create PV, VG (examvg), LV (examlv), format xfs, mount
- **5.3 Swap Space** (5 pts): Create and enable additional swap
</details>

<details>
<summary>Section 6: File Systems (30 pts)</summary>

- **6.1 Directory Permissions** (10 pts): Create /shared/projects with SGID
- **6.2 Access Control Lists** (10 pts): Configure ACLs for alice and bob
- **6.3 NFS Client** (10 pts): Configure autofs for NFS mounts
</details>

<details>
<summary>Section 7: Deploy, Configure, Maintain (30 pts)</summary>

- **7.1 Service Management** (10 pts): Enable and start httpd
- **7.2 Scheduled Tasks** (10 pts): Create cron job and at job
- **7.3 Time Configuration** (5 pts): Set timezone, verify chrony
- **7.4 Tuned Profiles** (5 pts): List and set tuned profile
</details>

<details>
<summary>Section 8: Networking (30 pts)</summary>

- **8.1 Network Configuration** (10 pts): Verify connectivity, display connections
- **8.2 Hostname** (5 pts): Set static hostname on server2
- **8.3 Hostname Resolution** (5 pts): Add /etc/hosts entry
- **8.4 Firewall** (10 pts): Allow HTTP/HTTPS, reload rules
</details>

<details>
<summary>Section 9: Users and Groups (25 pts)</summary>

- **9.1 User Management** (10 pts): Create admin1 (UID 2001), add to wheel, create developer1
- **9.2 Group Management** (5 pts): Create developers group (GID 3000)
- **9.3 Password Policies** (10 pts): Configure password aging, lock contractor1
</details>

<details>
<summary>Section 10: Security (30 pts)</summary>

- **10.1 SELinux** (10 pts): Enforce mode, list/restore contexts
- **10.2 SSH Security** (10 pts): Disable root login, configure key-based auth
- **10.3 Sudo Configuration** (5 pts): Allow developers to manage httpd
- **10.4 Firewall Security** (5 pts): Block IP with rich rules
</details>

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

<details>
<summary>Section 1: Essential Tools (50 pts)</summary>

- **1.1 Basic File Operations** (10 pts): Create `/exam/archives`, copy files from `/etc`, create tar archive
- **1.2 File Permissions** (10 pts): Create file with specific permissions and ownership
- **1.3 Text Processing** (10 pts): Extract users with nologin shell, count lines in passwd
- **1.4 Script Creation** (10 pts): Create sysinfo.sh script showing date, hostname, user
- **1.5 Documentation** (10 pts): Find manual section for passwd config file
</details>

<details>
<summary>Section 2: Shell Scripts (20 pts)</summary>

- **2.1 Conditional Script** (10 pts): Create check-service.sh with argument handling
- **2.2 Loop Script** (10 pts): Create create-users.sh reading from file
</details>

<details>
<summary>Section 3: Operate Running Systems (25 pts)</summary>

- **3.1 Boot Targets** (10 pts): Set default to multi-user.target
- **3.2 Process Management** (5 pts): Identify sshd PID, use ps/top
- **3.3 System Logs** (10 pts): Configure persistent journald storage
</details>

<details>
<summary>Section 4: Local Storage (30 pts)</summary>

- **4.1 Loop Device** (5 pts): Verify loop device for LVM
- **4.2 LVM Configuration** (20 pts): Create VG (examvg), LV (examlv), format xfs, mount
- **4.3 Swap Space** (5 pts): Create and enable additional swap
</details>

<details>
<summary>Section 5: File Systems (20 pts)</summary>

- **5.1 Directory Permissions** (10 pts): Create /shared/projects with SGID
- **5.2 Access Control Lists** (10 pts): Configure ACLs for alice and bob
</details>

<details>
<summary>Section 6: Deploy, Configure, Maintain (30 pts)</summary>

- **6.1 Software Management** (10 pts): Configure DNF repo, install httpd
- **6.2 Service Management** (10 pts): Enable and start httpd
- **6.3 Scheduled Tasks** (5 pts): Create cron job for sysinfo.sh
- **6.4 Time Configuration** (5 pts): Set timezone to America/New_York
</details>

<details>
<summary>Section 7: Networking (15 pts)</summary>

- **7.1 Hostname** (5 pts): Set static hostname on server2
- **7.2 Firewall** (10 pts): Allow HTTP/HTTPS services permanently
</details>

<details>
<summary>Section 8: Users and Groups (25 pts)</summary>

- **8.1 User Management** (10 pts): Create admin1 (UID 2001), add to wheel, create developer1
- **8.2 Group Management** (5 pts): Create developers group (GID 3000)
- **8.3 Password Policies** (10 pts): Configure password aging, lock contractor1
</details>

<details>
<summary>Section 9: Security (15 pts)</summary>

- **9.1 SELinux** (5 pts): Ensure enforcing mode
- **9.2 SSH Security** (5 pts): Disable root login via SSH
- **9.3 Sudo Configuration** (5 pts): Allow developers to manage httpd
</details>

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

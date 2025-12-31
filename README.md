# RHCSA EX200 Practice Lab

A containerized practice environment for the Red Hat Certified System Administrator (RHCSA) exam.

## Prerequisites

- **Podman** (recommended) or Docker
- Linux host (tested on Fedora, RHEL, Rocky Linux)
- ~2GB disk space for the container image

## Quick Start

```bash
# 1. Make scripts executable
chmod +x *.sh

# 2. Start the lab environment
./setup-lab.sh start

# 3. Launch the interactive menu
./exam-menu.sh
```

## Lab Components

| File | Description |
|------|-------------|
| `setup-lab.sh` | Build image and manage containers |
| `exam-menu.sh` | Interactive menu for exam practice |
| `validate-tasks.sh` | Automated task validation |
| `exam-timer.sh` | 2.5-hour countdown timer |
| `Containerfile` | Rocky Linux 9 exam image |

## Usage

### Starting the Lab

```bash
./setup-lab.sh start    # Build and start containers
./setup-lab.sh stop     # Stop and remove containers
./setup-lab.sh reset    # Reset to fresh state
./setup-lab.sh status   # Check container status
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
./validate-tasks.sh 2          # Shell Scripts
./validate-tasks.sh storage    # Local Storage
./validate-tasks.sh security   # Security
```

## Lab Environment

| Server | Hostname | IP Address |
|--------|----------|------------|
| server1 | server1.example.com | 192.168.100.10 |
| server2 | server2.example.com | 192.168.100.11 |

**Root Password:** `redhat`

## Container Limitations

This containerized environment has some limitations compared to real VMs:

| Feature | Status | Notes |
|---------|--------|-------|
| User/Group Management | Full | Works normally |
| File Permissions/ACLs | Full | Works normally |
| Services (systemd) | Full | With --privileged |
| Firewall | Full | firewalld works |
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

## Exam Sections

1. **Essential Tools** (50 pts) - File operations, permissions, text processing
2. **Shell Scripts** (20 pts) - Conditionals, loops, arguments
3. **Operating Systems** (40 pts) - Boot targets, processes, logs
4. **Local Storage** (40 pts) - Partitions, LVM, swap
5. **File Systems** (30 pts) - Permissions, ACLs, NFS
6. **Deploy/Configure** (40 pts) - DNF, services, cron, time
7. **Networking** (30 pts) - nmcli, hostname, firewall
8. **Users & Groups** (25 pts) - User management, policies
9. **Security** (25 pts) - SELinux, SSH, sudo

**Total: 300 points | Passing: 210 (70%)**

## Tips for Success

1. Read each task completely before starting
2. Use `man` pages - they're allowed on the real exam
3. Test persistence: Check if configs survive container restart
4. Use `systemctl` for all service management
5. Always verify your work with the validation script
6. Practice with the timer to simulate real exam pressure

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

## Full VM Alternative

For complete exam simulation (boot targets, real LVM, full SELinux), consider:

1. **Vagrant + libvirt/VirtualBox** with Rocky Linux 9 boxes
2. **RHEL Developer Subscription** (free) for real RHEL VMs
3. **Cloud instances** (AWS, GCP, Azure) with RHEL/Rocky

## License

This practice material is for educational purposes. Not affiliated with Red Hat.

# GCP Infrastructure Automation with Ansible

This project automates the creation and management of GCP infrastructure (Jenkins, SonarQube, Nexus) using Ansible and Just command runner.

## Prerequisites

1. **Just** - Command runner (like Make but better)
   ```bash
   brew install just
   ```

2. **Google Cloud SDK**
   ```bash
   brew install --cask google-cloud-sdk
   ```

3. **Ansible**
   ```bash
   brew install ansible
   ```

## Setup

### 1. Place your Google Service Account JSON file

1. Create the credential directory (if not exists):
   ```bash
   mkdir -p credential
   ```

2. Place your service account JSON file at:
   ```
   credential/google-service-account.json
   ```

3. To get the service account file:
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Navigate to: **IAM & Admin → Service Accounts**
   - Create a new service account with these permissions:
     - Compute Admin
     - Service Account User
     - Compute Network Admin
   - Create and download a JSON key
   - Save it as `credential/google-service-account.json`

### 2. Update Project ID (if needed)

Edit the `Justfile` and update the `PROJECT_ID` variable:
```just
PROJECT_ID := "your-project-id"
```

### 3. Run initial setup

```bash
just setup
```

This will:
- Check all prerequisites
- Authenticate with GCP
- Install required Ansible collections and dependencies

## Usage

### Quick Start

```bash
# First time setup
just setup

# Deploy everything (create infrastructure + install services)
just deploy
```

### Common Commands

```bash
# Show all available commands
just --list

# Show help with common workflows
just help

# Create GCP infrastructure only
just create

# Install services (Jenkins, SonarQube, Nexus)
just install-services

# Destroy all infrastructure
just destroy

# List all GCP instances
just list-instances

# SSH into an instance
just ssh master02

# Show GCP configuration
just show-config

# Clean up local files
just clean
```

### Workflow Examples

**Full deployment:**
```bash
just deploy
```

**Create infrastructure, then install services separately:**
```bash
just create
# Wait for instances to be ready
just install-services
```

**Check what will be created (dry-run):**
```bash
just dry-run
```

**Destroy everything:**
```bash
just destroy
```

## Project Structure

```
.
├── Justfile                    # Main automation file
├── ansible.cfg                 # Ansible configuration
├── credential/
│   └── google-service-account.json  # GCP service account (you provide this)
├── inventory/
│   └── hosts.ini              # Ansible inventory
├── playbooks/
│   ├── create-infra.yml       # Create GCP infrastructure
│   ├── destroy-infra.yml      # Destroy infrastructure
│   └── install-services.yml   # Install Jenkins, SonarQube, Nexus
├── roles/
│   └── gcp/                   # GCP-related Ansible tasks
└── vars/
    └── machines.yaml          # Machine specifications
```

## Configuration

### Machine Specifications

Edit `vars/machines.yaml` to configure:
- Machine types (e2-medium, e2-standard-2, etc.)
- Zones (asia-southeast1-a, asia-east2-a, etc.)
- Disk sizes and types
- Ubuntu versions
- Machine names

### Service Account Path

The service account file should be at:
```
credential/google-service-account.json
```

If you need to change this, update the `SERVICE_ACCOUNT_FILE` variable in the `Justfile`.

## Troubleshooting

### Authentication Issues

```bash
# Re-authenticate
just auth

# Check current authentication
gcloud auth list
```

### Missing Dependencies

```bash
# Install all dependencies
just install-deps
```

### Check Prerequisites

```bash
just check-prereqs
```

## Security Notes

⚠️ **Important:**
- Never commit `credential/google-service-account.json` to git
- Add it to `.gitignore`
- Keep your service account credentials secure
- Use least-privilege permissions for the service account

## What Gets Created

Based on your configuration, this will create:
- **master02** - e2-standard-2 instance in asia-southeast1-a
- **master03** - e2-standard-2 instance in asia-southeast1-a  
- **worker01** - e2-medium instance in asia-east2-a
- **worker02** - e2-medium instance in asia-east2-a

All instances run Ubuntu 22.04 LTS with:
- 20GB disk (pd-standard)
- HTTP/HTTPS server tags
- SSH access configured

## Next Steps

After infrastructure is created:
1. Check instances: `just list-instances`
2. SSH into an instance: `just ssh master02`
3. Install services: `just install-services`

## License

MIT

# GCP Infrastructure Automation with Ansible

This repository contains a set of Ansible playbooks and helper scripts
(`Justfile`) to **automate the creation and configuration of a small GCP
stack** hosting Jenkins, SonarQube and Nexus. The machines are provisioned on
Google Cloud Platform and each service is installed inside a Docker container
on its respective VM.

> 💡 The goal of the project is to serve as an opinionated demo for managing
> infrastructure with Ansible while keeping roles modular and variable
> scoping clear.

---

## 🚀 Getting Started

Anyone who clones this project can follow the steps below. A `requirements.txt`
file is provided so Python‑based tooling (Ansible, Just) can be installed
quickly with `pip` if desired.

### 📦 Prerequisites

- **Python 3.8+** (used by Ansible and Just)
- **pip** (to install Python packages from `requirements.txt`)
- **git** (for cloning the repository)
- **Google Cloud SDK** (`gcloud` command)
- **Just** (command runner)

You can satisfy the Python dependencies with:

```bash
pip install -r requirements.txt
```

> Note: on macOS you can install `just` and `google-cloud-sdk` via Homebrew
> (see original README snippet below). On Linux use your package manager or
> download from upstream.

### 🔐 Google Service Account

1. Create a directory for credentials:
   ```bash
   mkdir -p credential
   ```
2. Download a JSON key for a service account with the following roles:
   - `Compute Admin`
   - `Service Account User`
   - `Compute Network Admin`
3. Save the file as `credential/google-service-account.json`.

### 🛠 Configuration

Edit the `Justfile` and set your `PROJECT_ID`:

```just
PROJECT_ID := "your-gcp-project-id"
```

The only other configuration you’ll typically change is machine size or zones
in `vars/machines.yaml` and any service domains in
`roles/*/vars/main.yml`.

### 🧪 Initial Setup

```bash
just create-infra
```

This will verify prerequisites, authenticate `gcloud`, and install required
Ansible collections.

---

## 🧼 Project Structure

```
.
├── Justfile                    # automation commands
├── ansible.cfg                 # Ansible configuration
├── credential/                 # store your GCP service account here
│   └── google-service-account.json
├── inventory/                  # Ansible inventories
├── playbooks/                  # top‑level playbooks (create, destroy, install)
├── roles/                      # modular Ansible roles
│   ├── docker/
│   ├── gcp/
│   ├── jenkins/
│   │   ├── tasks/
│   │   ├── templates/
│   │   ├── vars/main.yml       # service variables
│   │   └── defaults/main.yml   # legacy; kept empty
│   ├── nexus/                  # similar layout
│   └── sonarqube/
└── vars/
    └── machines.yaml          # GCP VM specs and list
```

Roles are intentionally self‑contained. All configuration that was previously
in `group_vars` has been moved into `roles/*/vars/main.yml` so cloning the
repo gives you a ready‑to‑run set of playbooks with reasonable defaults.

---

## 🛠 Common Commands

```bash
just --list                # show available targets
just create                # provision GCP VMs only
just install-services      # install Jenkins/SonarQube/Nexus
just deploy                # create + install
just destroy               # tear down everything
just list-instances        # gcloud list of created machines
just ssh <instance-name>   # SSH into a machine
```

You can combine `--extra-vars` to override any variable, e.g.:

```bash
just install-services EXTRA_VARS='jenkins_domain=ci.example.com'
```

---

## 🧠 Variables and Configuration

- Service domains, ports and other settings are located in
  `roles/<role>/vars/main.yml`.
- Machine definitions are in `vars/machines.yaml`.
- You may override any variable at inventory/host level or via CLI; Ansible’s
  standard precedence applies (role vars > defaults > inventory).

No `group_vars` directory exists; variables are scoped per role for clarity.

---

## 🧩 Customization

To add another component:

1. Create a new role under `roles/` with its own `tasks`, `templates`, etc.
2. Define default settings in `roles/<new>/vars/main.yml`.
3. Update `playbooks/install-services.yml` to include the new role and target
   host group(s).

---

## 🧯 Troubleshooting

- **Authentication errors**: run `just auth` or `gcloud auth login`.
- **Missing dependencies**: rerun `pip install -r requirements.txt` or
  `just install-deps`.
- **Playbook failures**: use `ansible-playbook -vvv` for verbose output.

---

## 📄 License

ISTAD Student



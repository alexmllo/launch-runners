# GitHub Actions Runner Launcher

A containerized solution for managing GitHub Actions self-hosted runners. This project provides a Docker-based setup for running GitHub Actions runners in containers, with support for Docker-in-Docker capabilities and additional development tools.

## Features

- Containerized GitHub Actions runner setup
- Docker-in-Docker support
- Pre-installed development tools:
  - AWS CLI
  - Terraform
  - Packer
  - Python with pip
  - Git
  - SSH client
- Automatic runner cleanup on container termination
- Configurable runner naming based on hostname

## Prerequisites

- Docker
- Docker Compose
- GitHub Personal Access Token with appropriate permissions
- GitHub organization or repository where you want to register the runner

## Setup

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd launch-runners
   ```

2. Configure the environment variables in `compose.yml`:
   ```yaml
   services:
     runner:
       environment:
         - OWNER=your-github-org-or-username
         - ACCESS_TOKEN=your-github-token
   ```

3. Build and start the runner:
   ```bash
   docker compose up -d
   ```

## Configuration

### Environment Variables

- `OWNER`: Your GitHub organization name or username
- `ACCESS_TOKEN`: GitHub Personal Access Token with `admin:org` or `repo` scope
- `RUNNER_NAME`: (Optional) Custom name for the runner (defaults to `bbrunner-${HOSTNAME}`)

### Docker Socket Mount

The runner container mounts the Docker socket to enable Docker-in-Docker capabilities:
```yaml
volumes:
  - /var/run/docker.sock:/var/run/docker.sock
```

## Runner Management

### Starting Runners

The `start.sh` script handles:
- Runner registration
- Automatic cleanup on container termination
- Signal handling for graceful shutdown

### Cleaning Up Offline Runners

Use the `delete-runners.sh` script to remove offline runners:
1. Configure the script with your repository and token:
   ```bash
   REPO="your-org/repo"
   TOKEN="your-github-token"
   ```
2. Run the script:
   ```bash
   ./delete-runners.sh
   ```

## Security Considerations

- The GitHub token should have minimal required permissions
- The runner runs as a non-root user inside the container
- Docker socket mounting should be used with caution in production environments

## Included Tools

The container comes with several pre-installed tools:
- AWS CLI v2
- Terraform v1.8.5
- Packer v1.8.5
- Python 3 with pip
- Git
- Docker
- SSH client
- Additional development dependencies

## License

[Add your license information here]

## Contributing

[Add contribution guidelines here]

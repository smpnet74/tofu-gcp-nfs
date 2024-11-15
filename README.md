# ZenML NFS Infrastructure with OpenTofu

This repository contains OpenTofu (formerly known as OpenTerraform) infrastructure code for deploying a NFS server on Google Cloud Platform for ZenML storage.

## Prerequisites

- OpenTofu installed (`sudo snap install opentofu --classic`)
- Google Cloud SDK installed and configured
- Access to Google Cloud Platform
- A GCP project with necessary APIs enabled:
  - Compute Engine API
  - Cloud Resource Manager API

## Configuration

1. Copy the example variables file:
```bash
cp terraform.tfvars.example terraform.tfvars
```

2. Edit `terraform.tfvars` with your specific values:
```hcl
project_id = "your-project-id"        # Your GCP project ID
region     = "us-central1"            # Desired GCP region
zone       = "us-central1-a"          # Desired GCP zone

nfs_disk_size     = 30                # Size of NFS disk in GB
nfs_instance_type = "e2-medium"       # GCP instance type
```

## Usage

1. Initialize OpenTofu:
```bash
tofu init
```

2. Review the planned changes:
```bash
tofu plan
```

3. Apply the infrastructure:
```bash
tofu apply
```

4. To destroy the infrastructure:
```bash
tofu destroy
```

## Infrastructure Components

- GCP Persistent Disk for NFS (30GB by default)
- GCP Compute Instance (e2-medium) running as NFS server
- GCP Firewall rules for NFS access
- NFS share at `/mnt/nfs/zenml`

## Outputs

After applying the infrastructure, you'll get:
- NFS server public IP
- NFS mount command for connecting to the NFS share

Example usage of the NFS share:
```bash
# On client machine
sudo apt-get install -y nfs-common
sudo mkdir -p /mount/point
sudo mount -t nfs <nfs_server_public_ip>:/mnt/nfs/zenml /mount/point
```

## Security Considerations

- The NFS server is exposed to the public internet. In production, you should restrict the firewall rules to your specific IP ranges.
- Consider using VPC networks and private IPs for better security.
- The example configuration uses basic settings. Adjust according to your security requirements.

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

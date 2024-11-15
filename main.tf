# Create a persistent disk for NFS
resource "google_compute_disk" "nfs_disk" {
  name = "nfs-disk"
  size = var.nfs_disk_size
  type = "pd-standard"
  zone = var.zone
}

# NFS server startup script
locals {
  startup_script = <<-EOF
    #!/bin/bash
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y nfs-kernel-server

    # Format the disk if not already formatted
    if ! blkid /dev/sdb; then
        mkfs.ext4 /dev/sdb
    fi

    # Create mount directory and mount the disk
    mkdir -p /mnt/nfs
    mount /dev/sdb /mnt/nfs

    # Add to fstab for persistence
    echo '/dev/sdb /mnt/nfs ext4 defaults 0 0' >> /etc/fstab

    # Create the NFS export directory
    mkdir -p /mnt/nfs/data
    chown nobody:nogroup /mnt/nfs/data
    chmod 777 /mnt/nfs/data

    # Configure NFS exports
    echo '/mnt/nfs/data *(rw,sync,no_root_squash,no_subtree_check)' > /etc/exports

    # Enable and start services
    systemctl enable rpcbind
    systemctl start rpcbind
    systemctl enable nfs-server
    systemctl restart nfs-server

    # Export the NFS shares
    exportfs -ra
  EOF
}

# Create NFS server instance
resource "google_compute_instance" "nfs_server" {
  name         = "nfs-server"
  machine_type = var.nfs_instance_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  attached_disk {
    source = google_compute_disk.nfs_disk.self_link
  }

  network_interface {
    network = "default"
    access_config {
      # Ephemeral public IP
    }
  }

  metadata_startup_script = local.startup_script

  tags = ["nfs-server"]
}

# Create firewall rules for NFS and RPC
resource "google_compute_firewall" "nfs_firewall" {
  name    = "nfs-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["2049", "111", "4045"]
  }

  allow {
    protocol = "udp"
    ports    = ["2049", "111", "4045"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["nfs-server"]
}

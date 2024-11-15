output "nfs_server_public_ip" {
  description = "The public IP address of the NFS server"
  value       = google_compute_instance.nfs_server.network_interface[0].access_config[0].nat_ip
}

output "nfs_mount_command" {
  description = "Command to mount the NFS share"
  value       = "mount -t nfs ${google_compute_instance.nfs_server.network_interface[0].access_config[0].nat_ip}:/mnt/nfs/data /mount/point"
}

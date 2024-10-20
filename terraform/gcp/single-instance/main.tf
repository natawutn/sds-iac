provider "google" {
  project     = "software-defined-system"
  region      = "asia-southeast1"
  zone        = "asia-southeast1-c"
}
resource "google_compute_network" "vpc_network" {
  name                    = "my-custom-mode-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "default" {
  name          = "my-custom-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "asia-southeast1"
  network       = google_compute_network.vpc_network.id
}

# Create a single Compute Engine instance
resource "google_compute_instance" "default" {
  name         = "nginx-vm"
  machine_type = "f1-micro"
  zone         = "asia-southeast1-c"
  tags         = ["ssh"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  # Install nginx
  metadata_startup_script = "sudo apt-get update; sudo apt-get install nginx"

  network_interface {
    subnetwork = google_compute_subnetwork.default.id

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}
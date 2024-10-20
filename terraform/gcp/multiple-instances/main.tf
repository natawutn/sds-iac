provider "google" {
  project     = "software-defined-system"
  region      = "asia-southeast1"
  zone        = "asia-southeast1-c"
}
resource "google_compute_network" "vpc_network" {
  name                    = "sds-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "default" {
  name          = "sds-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "asia-southeast1"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "ssh" {
  name = "allow-ssh"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc_network.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

resource "google_compute_firewall" "http" {
  name = "allow-http"
  allow {
    ports    = ["80"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc_network.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http"]
}

variable "instance_set" {
  type = list(string)
  default = ["pacific", "arctic", "atlantic"]
}

# Create a single Compute Engine instance
resource "google_compute_instance" "default" {
  for_each = toset(var.instance_set)
  name         = each.value
  machine_type = "f1-micro"
  zone         = "asia-southeast1-c"
  tags         = ["ssh", "http"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  metadata = {
    ssh-keys = "natawut:${file("~/.ssh/id_rsa.pub")}"
  }
  
  # Install python3 and set locale
  metadata_startup_script = "sudo apt-get update; sudo apt-get install python3 -y; sudo apt-get install locales -y; sudo locale-gen en_US.UTF-8"

  network_interface {
    subnetwork = google_compute_subnetwork.default.id

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}

output "nat_ip" {
  value = {
    for instance in google_compute_instance.default : instance.name => instance.network_interface.0.access_config.0.nat_ip
  }
}
# Define the provider
provider "google" {
  project = "interview-testing-area"
  region  = "us-central1"
  credentials = "${file("/home/michael_zarate_ce/google-creds/interview-testing-area-terraform-cred.json")}"
}

# Define the GKE cluster
resource "google_container_cluster" "regional-cluster" {
  # gives you a regional 3 node cluster 
  name               = "regional-lab-cluster-01"
  location           = "us-central1"
  initial_node_count = 1

  # Define the node pool
  node_config {
    preemptible  = false
    machine_type = "e2-medium"

    # Define the disk size for each node
    disk_size_gb = 100

    # Define the labels for the nodes
    labels = {
      environment = "dev"
    }
  }

  # Define the network policy for the cluster
  network_policy {
    enabled = false
  }
}

# Define the Cloud SQL instance
resource "google_sql_database_instance" "sql_instance" {
  name             = "my-sql-instance"
  database_version = "MYSQL_8_0"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"
  }

  deletion_protection = false

  depends_on = [google_container_cluster.regional-cluster]
}
# Compute instance group for masters
resource "yandex_compute_instance_group" "k8s-masters" {
  name               = "k8s-masters"
  service_account_id = yandex_iam_service_account.denk-sa.id
  depends_on = [
    yandex_iam_service_account.denk-sa,
    yandex_resourcemanager_folder_iam_binding.editor,
    yandex_vpc_network.k8s-network,
    yandex_vpc_subnet.k8s-subnet-1,
    yandex_vpc_subnet.k8s-subnet-2,
    yandex_vpc_subnet.k8s-subnet-3,
  ]

  instance_template {

    name = "master-{instance.index}"
    resources {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }

    boot_disk {
      initialize_params {
        image_id = "fd8vmcue7aajpmeo39kk" # Ubuntu 20.04 LTS
        size     = 10
        type     = "network-ssd"
      }
    }

    network_interface {
      network_id = yandex_vpc_network.k8s-network.id
      subnet_ids = [
        yandex_vpc_subnet.k8s-subnet-1.id,
        yandex_vpc_subnet.k8s-subnet-2.id,
        yandex_vpc_subnet.k8s-subnet-3.id,
      ]
      nat = true
    }

    metadata = {
      user-data = "${file("./meta.txt")}"
    }
    network_settings {
      type = "STANDARD"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [
      "ru-central1-a",
      "ru-central1-b",
      "ru-central1-d",
    ]
  }

  deploy_policy {
    max_unavailable = 3
    max_creating    = 3
    max_expansion   = 3
    max_deleting    = 3
  }
}

# Compute instance group for frontend
resource "yandex_compute_instance_group" "k8s-frontend" {
  name               = "k8s-frontend"
  service_account_id = yandex_iam_service_account.denk-sa.id
  depends_on = [
    yandex_iam_service_account.denk-sa,
    yandex_resourcemanager_folder_iam_binding.editor,
    yandex_vpc_network.k8s-network,
    yandex_vpc_subnet.k8s-subnet-1,
  ]

  instance_template {
    name = "frontend-{instance.index}"

    resources {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }

    boot_disk {
      initialize_params {
        image_id = "fd8vmcue7aajpmeo39kk" # Ubuntu 20.04 LTS
        size     = 10
        type     = "network-hdd"
      }
    }

    network_interface {
      network_id = yandex_vpc_network.k8s-network.id
      subnet_ids = [
        yandex_vpc_subnet.k8s-subnet-1.id,
        yandex_vpc_subnet.k8s-subnet-2.id,
        yandex_vpc_subnet.k8s-subnet-3.id,
      ]
      nat = true
    }

    metadata = {
      user-data = "${file("./meta.txt")}"
    }

    network_settings {
      type = "STANDARD"
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    zones = [
      "ru-central1-a",
      "ru-central1-b",
      "ru-central1-d",
    ]
  }

  deploy_policy {
    max_unavailable = 1
    max_creating    = 1
    max_expansion   = 1
    max_deleting    = 1
  }
}

# Compute instance group for workers
resource "yandex_compute_instance_group" "k8s-workers" {
  name               = "k8s-workers"
  service_account_id = yandex_iam_service_account.denk-sa.id
  depends_on = [
    yandex_iam_service_account.denk-sa,
    yandex_resourcemanager_folder_iam_binding.editor,
    yandex_vpc_network.k8s-network,
    yandex_vpc_subnet.k8s-subnet-1,
    yandex_vpc_subnet.k8s-subnet-2,
    yandex_vpc_subnet.k8s-subnet-3,
  ]

  instance_template {

    name = "worker-{instance.index}"

    resources {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }

    boot_disk {
      initialize_params {
        image_id = "fd8vmcue7aajpmeo39kk" # Ubuntu 20.04 LTS
        size     = 10
        type     = "network-hdd"
      }
    }

    network_interface {
      network_id = yandex_vpc_network.k8s-network.id
      subnet_ids = [
        yandex_vpc_subnet.k8s-subnet-1.id,
        yandex_vpc_subnet.k8s-subnet-2.id,
        yandex_vpc_subnet.k8s-subnet-3.id,
      ]
      nat = true
    }

    metadata = {
      user-data = "${file("./meta.txt")}"
    }
    network_settings {
      type = "STANDARD"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [
      "ru-central1-a",
      "ru-central1-b",
      "ru-central1-d",
    ]
  }

  deploy_policy {
    max_unavailable = 3
    max_creating    = 3
    max_expansion   = 3
    max_deleting    = 3
  }
}

# Compute instance group for ingresses
resource "yandex_compute_instance_group" "k8s-ingresses" {
  name               = "k8s-ingresses"
  service_account_id = yandex_iam_service_account.denk-sa.id
  depends_on = [
    yandex_iam_service_account.denk-sa,
    yandex_resourcemanager_folder_iam_binding.editor,
    yandex_vpc_network.k8s-network,
    yandex_vpc_subnet.k8s-subnet-1,
    yandex_vpc_subnet.k8s-subnet-2,
    yandex_vpc_subnet.k8s-subnet-3,
  ]

  load_balancer {
    target_group_name = "k8s-ingresses"
  }

  instance_template {

    name = "ingress-{instance.index}"

    resources {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }

    boot_disk {
      initialize_params {
        image_id = "fd8vmcue7aajpmeo39kk" # Ubuntu 20.04 LTS
        size     = 10
        type     = "network-hdd"
      }
    }

    network_interface {
      network_id = yandex_vpc_network.k8s-network.id
      subnet_ids = [
        yandex_vpc_subnet.k8s-subnet-1.id,
        yandex_vpc_subnet.k8s-subnet-2.id,
        yandex_vpc_subnet.k8s-subnet-3.id,
      ]
      # Флаг nat true указывает что виртуалкам будет предоставлен публичный IP адрес.
      nat = true
    }

    metadata = {
      user-data = "${file("./meta.txt")}"
    }
    network_settings {
      type = "STANDARD"
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    zones = [
      "ru-central1-a",
      "ru-central1-b",
      "ru-central1-d",
    ]
  }

  deploy_policy {
    max_unavailable = 2
    max_creating    = 2
    max_expansion   = 2
    max_deleting    = 2
  }
}

# Load balancer for ingresses
resource "yandex_lb_network_load_balancer" "k8s-load-balancer" {
  name = "k8s-load-balancer"
  depends_on = [
    yandex_compute_instance_group.k8s-ingresses,
  ]

  listener {
    name = "my-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.k8s-ingresses.load_balancer.0.target_group_id
    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/healthz"
      }
    }
  }
}

# Network
resource "yandex_vpc_network" "k8s-network" {
  name = "k8s-network"
}

resource "yandex_vpc_subnet" "k8s-subnet-1" {
  name           = "k8s-subnet-1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.k8s-network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
  depends_on = [
    yandex_vpc_network.k8s-network,
  ]
}

resource "yandex_vpc_subnet" "k8s-subnet-2" {
  name           = "k8s-subnet-2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.k8s-network.id
  v4_cidr_blocks = ["192.168.20.0/24"]
  depends_on = [
    yandex_vpc_network.k8s-network,
  ]
}

resource "yandex_vpc_subnet" "k8s-subnet-3" {
  name           = "k8s-subnet-3"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.k8s-network.id
  v4_cidr_blocks = ["192.168.30.0/24"]
  depends_on = [
    yandex_vpc_network.k8s-network,
  ]
}

# Output values

output "instance_group_masters_public_ips" {
  description = "Public IP addresses for master-nodes"
  value       = yandex_compute_instance_group.k8s-masters.instances.*.network_interface.0.nat_ip_address
}

output "instance_group_masters_private_ips" {
  description = "Private IP addresses for master-nodes"
  value       = yandex_compute_instance_group.k8s-masters.instances.*.network_interface.0.ip_address
}

output "instance_group_workers_public_ips" {
  description = "Public IP addresses for worder-nodes"
  value       = yandex_compute_instance_group.k8s-workers.instances.*.network_interface.0.nat_ip_address
}

output "instance_group_workers_private_ips" {
  description = "Private IP addresses for worker-nodes"
  value       = yandex_compute_instance_group.k8s-workers.instances.*.network_interface.0.ip_address
}

output "instance_group_ingresses_public_ips" {
  description = "Public IP addresses for ingress-nodes"
  value       = yandex_compute_instance_group.k8s-ingresses.instances.*.network_interface.0.nat_ip_address
}

output "instance_group_ingresses_private_ips" {
  description = "Private IP addresses for ingress-nodes"
  value       = yandex_compute_instance_group.k8s-ingresses.instances.*.network_interface.0.ip_address
}

output "load_balancer_public_ip" {
  description = "Public IP address of load balancer"
  value       = yandex_lb_network_load_balancer.k8s-load-balancer.listener.*.external_address_spec[0].*.address
}

output "static-key-access-key" {
  description = "Access key for admin user"
  value       = yandex_iam_service_account_static_access_key.static-access-key.access_key
}

output "static-key-secret-key" {
  description = "Secret key for admin user"
  value       = yandex_iam_service_account_static_access_key.static-access-key.secret_key
  sensitive   = true
}

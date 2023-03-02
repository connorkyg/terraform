terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.1"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

variable "agent_version" {
  type = set(string)
  default = [
    "1.20",
    "1.21",
    "1.22",
    "1.23"
  ]
}

resource "docker_image" "nginximage" {
  for_each = {for version in var.agent_version: "nginx:${version}" => {
    name = "nginx:${version}"
    }
  }
  name = each.value["name"]
}

resource "docker_container" "nginxcontainer" {
  for_each = {
    for v in var.agent_version : "nginxcont.${v}" => {
      name    = "contname.${v}"
      image   = "nginx:${v}"
      command = ["/bin/bash", "-c", "mkdir -p /SSR; sleep infinity"]
      network_mode = "host"
    }
  }

  name    = each.value["name"]
  image   = each.value["image"]
  command = each.value["command"]

  volumes {
    host_path      = "/root/docker/nginx/${each.key}"
    container_path = "/SSR"
  }
}

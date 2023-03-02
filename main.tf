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

resource "docker_image" "work" {
  name = "itzconnor/work:1.3"
}

resource "docker_container" "test1" {
  name = "test1"
  image = "itzconnor/work:1.3"
  restart = "unless-stopped"
  command = ["sleep", "infinity"]

  volumes {
    host_path = "/root/docker/agent/2.41.4841756/linux"
    container_path = "/SSR"
  }
}

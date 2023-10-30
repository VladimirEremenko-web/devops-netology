module "vpc_dev" {
  source         = "./modules/vpc_dev"
  zone           = var.default_zone
  v4_cidr_blocks = ["10.0.1.0/24"]
  env_name       = "develop"
}

module "test-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "develop"
  network_id     = module.vpc_dev.yandex_vpc_network.id
  subnet_zones   = [var.default_zone]
  subnet_ids     = [module.vpc_dev.yandex_vpc_subnet.id]
  instance_name  = "web"
  instance_count = 2
  image_family   = "ubuntu-2004-lts"
  public_ip      = true

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }

}

data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  vars = {
    ssh_public_key = file("~/.ssh/id_ed25519.pub")
  }
}

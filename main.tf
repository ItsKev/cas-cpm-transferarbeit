module "sandbox-1" {
  source              = "./modules/sandbox"
  resource_group_name = "sandbox-1"
}

module "sandbox-2" {
  source              = "./modules/sandbox"
  resource_group_name = "sandbox-2"
}

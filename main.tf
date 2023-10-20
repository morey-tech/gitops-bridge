locals {
  cluster_name         = "gitops-bridge-gke"
  environment          = "dev"
  addons_repo_url      = "https://github.com/morey-tech/gitops-bridge-control-plane"
  addons_repo_path     = "bootstrap"
  addons_repo_revision = "HEAD"

  # Each entry must have a corresponding ApplicationSet in the `addons_repo`.
  oss_addons = {
    enable_cert_manager  = true
    enable_external_dns  = true
    enable_ingress_nginx = true
  }
}
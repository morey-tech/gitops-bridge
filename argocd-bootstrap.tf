resource "argocd_application" "bootstrap" {
  metadata {
    name      = "bootstrap"
    namespace = "argocd"
    labels = {
      cluster = "in-cluster"
    }
  }
  cascade = false # disable cascading deletion
  wait    = true
  spec {
    project = "default"
    destination {
      name      = "in-cluster"
      namespace = "argocd"
    }
    source {
      repo_url        = local.addons_repo_url
      path            = local.addons_repo_path
      target_revision = local.addons_repo_revision
      directory {
        recurse = true
      }
    }
    sync_policy {
      automated {
        prune     = true
        self_heal = true
      }
    }
  }
}

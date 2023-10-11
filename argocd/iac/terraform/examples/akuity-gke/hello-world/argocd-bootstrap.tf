resource "argocd_application" "app_of_apps" {
  metadata {
    name      = "app-of-apps"
    namespace = "argocd"
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
      repo_url        = "https://github.com/morey-tech/control-plane"
      path            = "argocd/"
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

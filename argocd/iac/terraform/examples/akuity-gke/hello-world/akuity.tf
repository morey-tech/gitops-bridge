resource "akp_instance" "argocd" {
  name = "gitops-bridge"
  argocd = {
    "spec" = {
      "instance_spec" = {
        "declarative_management_enabled" = true
      }
      "version" = "v2.7.10"
    }
  }
}

data "google_client_config" "current" {}

resource "akp_cluster" "gitops-bridge" {
  instance_id = akp_instance.argocd.id
  kube_config = {
    host                   = "https://${google_container_cluster.gke-01.endpoint}"
    token                  = data.google_client_config.current.access_token
    client_certificate     = "${base64decode(google_container_cluster.gke-01.master_auth.0.client_certificate)}"
    client_key             = "${base64decode(google_container_cluster.gke-01.master_auth.0.client_key)}"
    cluster_ca_certificate = "${base64decode(google_container_cluster.gke-01.master_auth.0.cluster_ca_certificate)}"
  }
  name      = "gitops-bridge-gke"
  namespace = "akuity"
  labels = {
    provider = "gcp"
  }
  annotations = {
    argocd-enabled = "false"
  }
  spec = {
    description = "gitops-bridge gke cluster"
    data = {
      size = "small"
    }
  }

  # When using a Kubernetes token retrieved from a Terraform provider (e.g. aws_eks_cluster_auth or google_client_config) in the above `kube_config`,
  # the token value may change over time. This will cause Terraform to detect a diff in the `token` on each plan and apply.
  # To prevent constant changes, you can add the `token` field path to the `lifecycle` block's `ignore_changes` list:
  #  https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle#ignore_changes
  lifecycle {
    ignore_changes = [
      kube_config.token,
    ]
  }
}
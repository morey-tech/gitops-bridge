# variable "gitops_addons_org" {
#   description = "Git repository org/user contains for addons"
#   default     = "https://github.com/gitops-bridge-dev"
# }
# variable "gitops_addons_repo" {
#   description = "Git repository contains for addons"
#   default     = "gitops-bridge-argocd-control-plane-template"
# }
# variable "gitops_addons_basepath" {
#   description = "Git repository base path for addons"
#   default     = ""
# }
# variable "gitops_addons_path" {
#   description = "Git repository path for addons"
#   default     = "bootstrap/control-plane/addons"
# }
# variable "gitops_addons_revision" {
#   description = "Git repository revision/branch/ref for addons"
#   default     = "HEAD"
# }

#########
## GKE ##
#########
variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes (per zone)"
}

variable "gke_project_id" {
  description = "project id"
}

variable "gke_region" {
  description = "region"
  default     = "us-west1"
}

############
## Akuity ##
############
variable "akp_org_name" {
  type        = string
  description = "Akuity Platform organization name."
}

variable "argocd_admin_password" {
  type        = string
  description = "The password to use for the `admin` Argo CD user."
}
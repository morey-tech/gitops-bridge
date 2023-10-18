# Terraform and ArgoCD

The idea is to use Terraform to manage the infrastructure (e.g. the Kubernetes cluster) and do the initial bootstrapping of Argo CD. Then all cluster configuration is managed through GitOps (including the Argo CD `Applications` and `ApplicationSets`).

In this example we use `Akuity` to create a managed Argo CD instance (treating it like another piece of infrastructure instead of a Kubernetes resource) and a GKE cluster. Terraform will create an Argo CD instance on Akuity, create the Kubernetes cluster, deploy the Akuity agent into the cluster to connect it back to Argo CD, and create the initial `Application` to bootstrap the rest of the cluster configuration using Argo CD.

To solve the challenge of Kubernetes resources that rely on specific metadata about the infrastructure knownly only be Terraform, annontations containing such metadata are added to the cluster configuration in Argo CD then retrieved through `ApplicationSets` using the `cluster` generator.

## Usage

```
export AKUITY_API_KEY_ID=xxxxxxxxxxxxx
export AKUITY_API_KEY_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxx
export AKUITY_SERVER_URL=https://akuity.cloud

terraform apply \
    -var=gke_project_id=<project-id> \
    -var=akp_org_name=<org-name> \
    -var=argocd_admin_password=<admin-password>
```

### Terraform Issues with the providers that rely on generated data from resources.
Some Terraform provider rely on data generated after a resource is created. A common example being the `kubernetes` provider which can be configured using data from a resource that manages a Kubernetes cluster (e.g. `google_container_cluster`). Typically this approach will work during the creation of the resources but will break once the resource supplying the data to the provider needs to be recreated. When the resource in the plan is targeted to be recreated, it will supply fake data to the provider configuration during the refresh since it is unknown until the resource has been recreated.

Here's an example with the `kubernetes` provider and a `google_container_cluster`.
```
│ Error: Get "http://localhost/apis/rbac.authorization.k8s.io/v1/clusterrolebindings/client-cluster-admin": dial tcp [::1]:80: connect: connection refused
│ 
│   with kubernetes_cluster_role_binding.client_cluster_admin,
│   on gcp-gke.tf line 59, in resource "kubernetes_cluster_role_binding" "client_cluster_admin":
│   59: resource "kubernetes_cluster_role_binding" "client_cluster_admin" {
│ 
```
- If the cluster needs to be recreated, the values passed to the `kubernetes` provider are empty, resulting in an error trying to connect to `localhost`. The workaround is to use `-refresh=false` when you see this issue.

Here's another example with the `argocd` provider and a `akp_instance`.
```
│ Error: invalid provider configuration: one of `core,port_forward,port_forward_with_namespace,use_local_config,server_addr` must be specified
│ 
│   with argocd_application.app_of_apps,
│   on argocd-bootstrap.tf line 1, in resource "argocd_application" "app_of_apps":
│    1: resource "argocd_application" "app_of_apps" {
│ 
```

References:
- https://github.com/hashicorp/terraform-provider-kubernetes/issues/1028#issuecomment-800934615
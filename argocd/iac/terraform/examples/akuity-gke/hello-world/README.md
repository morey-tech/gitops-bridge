# Argo CD on Google Cloud GKE

Example on how to deploy Google Cloud GKE and connect it with an Akuity Argo CD instance.

Deploy GKE Cluster and Argo CD Instance
```shell
terraform init
terraform apply -var=akp_org_name=<your-org-name> -var=gke_project_id=<your-gcp-project>
```

Access Terraform output to configure `kubectl` and `argocd`
```shell
terraform output
```

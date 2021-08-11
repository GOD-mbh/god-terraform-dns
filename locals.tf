# locals.tf

locals {
  repository    = "https://charts.bitnami.com/bitnami"
  name          = "external-dns"
  namespace      = coalescelist(kubernetes_namespace.this, [{ "metadata" = [{ "name" = var.namespace }] }])[0].metadata[0].name
  chart         = "external-dns"
  chart_version = var.chart_version
  conf          = merge(local.conf_defaults, var.conf)
  conf_defaults = merge({
    "rbac.create"                                               = true,
    "resources.limits.cpu"                                      = "100m",
    "resources.limits.memory"                                   = "300Mi",
    "resources.requests.cpu"                                    = "100m",
    "resources.requests.memory"                                 = "300Mi",
    "aws.region"                                                = data.aws_region.current.name
    "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = module.iam_assumable_role_admin.this_iam_role_arn
    },
    {
      for i, zone in tolist(var.hostedzones) :
      "domainFilters[${i}]" => zone
    }
  )
}

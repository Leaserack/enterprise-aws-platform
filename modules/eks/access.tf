resource "aws_eks_access_entry" "this" {
  for_each = var.access_entries

  cluster_name = aws_eks_cluster.this.name

  principal_arn = each.value.principal_arn
  type          = each.value.type

  kubernetes_groups = each.value.kubernetes_groups

  username = each.value.username

  tags = local.common_tags
}

resource "aws_eks_access_policy_association" "this" {
  for_each = {
    for item in flatten([
      for entry_key, entry in var.access_entries : [
        for policy_key, policy in entry.policy_associations : {
          key        = "${entry_key}-${policy_key}"
          principal  = entry.principal_arn
          policy_arn = policy.policy_arn
          scope_type = policy.access_scope.type
          namespaces = policy.access_scope.namespaces
        }
      ]
    ]) : item.key => item
  }

  cluster_name  = aws_eks_cluster.this.name
  principal_arn = each.value.principal
  policy_arn    = each.value.policy_arn

  access_scope {
    type       = each.value.scope_type
    namespaces = each.value.namespaces
  }

  depends_on = [
    aws_eks_access_entry.this
  ]
}
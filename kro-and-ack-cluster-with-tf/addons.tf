#---------------------------------------------------------------
# EKS Addons
#---------------------------------------------------------------

module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.16"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  enable_argocd = true
  argocd = {
    namespace     = "argocd"
    chart_version = "8.1.2" # ArgoCD v3.0.9
    values = [
      templatefile("${path.module}/helm-values/argocd.yaml", {
    })]
  }

  enable_metrics_server               = true
  enable_external_secrets             = true
  enable_external_dns                 = true
  #  external_dns_route53_zone_arns      = ["arn:aws:route53:::hostedzone/Z07589007ZVX1K0A3C82"]

  depends_on = [module.eks.cluster_addons]
}

################################################################################
# ACK Addons
################################################################################
module "eks_ack_addons" {
  source = "aws-ia/eks-ack-addons/aws"

  # Cluster Info
  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  oidc_provider_arn = module.eks.oidc_provider_arn

  # ECR Credentials
  ecrpublic_username = data.aws_ecrpublic_authorization_token.token.user_name
  ecrpublic_token    = data.aws_ecrpublic_authorization_token.token.password

  # Controllers to enable
  enable_iam               = true
  iam = {
    chart_version = "1.4.2"
  }
  enable_ec2               = true
  ec2 = {
    chart_version = "1.4.8"
  }
#  enable_eks               = true
#  eks = {
#    chart_version = "1.6.0"
#  }
#  enable_kms               = true
#  kms = {
#    chart_version = "1.0.20"
#  }
#  enable_acm               = true
#  acm = {
#    chart_version = "1.0.3"
#  }
#  enable_dynamodb          = true
#  dynamodb = {
#    chart_version = "1.2.18"
#  }
  enable_s3                = true
  s3 = {
    chart_version = "1.0.33"
  }
#  enable_elasticache       = true
#  enable_rds               = true
#  enable_route53resolver   = true
#  route53resolver = {
#    chart_version = "1.0.4"
#  }
#  enable_route53           = true
#  route53 = {
#    chart_version = "0.0.21"
#    values = [
#      yamlencode({
#        featureGates = {
#          ReadOnlyResources = true
#          ResourceAdoption = true
#        }
#      })
#    ]
#  }
#  enable_sqs               = true
#  sqs = {
#    chart_version = "1.1.5"
#  }
#  enable_sns               = true
#  sns = {
#    chart_version = "1.1.4"
#  }
#  enable_secretsmanager    = true

  tags = local.tags
}

#########################################
# KRO
#########################################
module "kro" {
  source  = "aws-ia/eks-blueprints-addon/aws"
  version = "1.1.1"

  name             = "kro"
  description      = "A Helm chart to deploy kro"
  namespace        = "kro"
  create_namespace = true
  chart            = "kro"
  chart_version    = "0.3.0"
  repository       = "oci://ghcr.io/kro-run/kro"
}

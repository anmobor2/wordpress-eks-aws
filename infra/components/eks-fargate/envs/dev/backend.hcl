bucket         = "tfstate-mycompany"
key            = "eks-fargate/dev.tfstate"
region         = "eu-west-1"
dynamodb_table = "tfstate-locks"
encrypt        = true

# se usa así en el init de terraform:
# terraform init -backend-config='envs/dev/backend.hcl'
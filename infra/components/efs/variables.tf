variable "region" { type = string }
variable "name"   { type = string }
variable "tags"   { type = map(string) default = {} }

# Si usas remote_state, no declares estas como var; se leerán del data source
variable "use_remote_state" { type = bool default = true }

# Solo si NO usas remote_state, podrás pasar manualmente:
variable "vpc_id"          { type = string default = null }
variable "private_subnets" { type = list(string) default = null }
variable "vpc_cidr_block"  { type = string default = null }
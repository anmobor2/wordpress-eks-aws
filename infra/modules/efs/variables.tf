variable "name"               { type = string }
variable "vpc_id"             { type = string }
variable "subnet_ids"         { type = list(string) }   # usa subnets privadas
variable "vpc_cidr_block"     { type = string }         # para SG inbound 2049
variable "tags"               { type = map(string) default = {} }
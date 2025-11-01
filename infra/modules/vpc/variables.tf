variable "name"        { type = string }
variable "cidr"        { type = string }
variable "az_count"    { type = number default = 3 }
variable "enable_nat"  { type = bool   default = true }
variable "tags"        { type = map(string) default = {} }
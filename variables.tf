# Variables for Availability Zones
variable "azs" {
  type    = list(string)
  default = ["eu-west-2a", "eu-west-2b"]
}
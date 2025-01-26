variable "AWS_REGION" {
  type = string
  default = "us-east-1"
}

variable "AWS_AVAIL_ZONE" {
  type = string
  default = "us-east-1a"
}

variable "prefered_instance_type" {
  type    = string
  default = "t3.medium"
}

# windows jumpbox username
variable "jumpbox_username" {
  description = "Username for jumpbox user"
  type    = string
  default = "Operator"
}

# windows jumpbox deployment password
variable "jumpbox_password" {
  description = "Username for jumpbox user"
  type    = string
  default = "SuperSafePassword123!"
}

variable "testudo_subnets" {
  type = list(string)
  default = [ 
    "172.16.1.0/24",
    "172.16.2.0/24",
    "172.16.3.0/24" ]
}

# Add public IPv4 subnets of allowed operators / locations
variable "OPERATOR_IPS" {
  type    = set(string)
  # format required "1.1.1.1/32"
  default = [""]
}

# Add public IPv4 subnets from ROE 
variable "ROE_IPS" {
  type    = set(string)
  # format required "1.1.1.1/32"
  default = [""]
}

# Custom data object for inbound traffic from ROE IPs
variable "INGRESS_C2_TRAFFIC" {
  type = list(object({
    port        = number
    protocol    = string
    description = string
  }))

  # Utilize format below to create SG entries for operator -> jumpboxes
  default = [
    { port = 80, description = "HTTP Traffic", protocol = "TCP" },
    { port = 443, description = "HTTPS Traffic", protocol = "TCP" }
  ]
}

# Custom data object for remote operator administration for jumpboxes
variable "INGRESS_OPERATOR_TRAFFIC" {
  type = list(
    object({
      port        = number
      description = string
      protocol    = string
    })
  )

  default = [
    { port = 22, description = "SSH Traffic", protocol = "TCP" },
    { port = 3389, description = "RDP Traffic", protocol = "TCP" },
    { port = 5985, description = "WINRM/HTTP", protocol = "TCP" },
    { port = 5986, description = "WINRM/HTTPS", protocol = "TCP" },
    { port = 0, description = "ICMP Traffic", protocol = "ICMP" }
  ]
}

# Custom data object for operator administration of redirectors used for SG
variable "REDIRECTOR_ADMINISTRATION" {
  type = list(
    object({
      port        = number
      description = string
      protocol    = string
      cidr_blocks = string
    })
  )

  # Utilize format below to create SG entries for jumpbox -> redirectors
  default = [
    { port = 22, description = "SSH Traffic", protocol = "TCP", cidr_blocks = "172.16.3.0/24" },
    { port = 0, description = "ICMP Traffic", protocol = "ICMP", cidr_blocks = "172.16.3.0/24" },
    { port = 80, description = "HTTP", protocol = "TCP", cidr_blocks = "172.16.3.0/24" },
    { port = 443, description = "HTTPS", protocol = "TCP", cidr_blocks = "172.16.3.0/24" }
  ]
}

# Custom data object for operator administration of C2 and Phishing servers used for SG
variable "OPERATOR_ADMINISTRATION" {
  type = list(
    object({
      port        = number
      description = string
      protocol    = string
      cidr_blocks = string
    })
  )

  # Utilize format below to create SG entries for jumpbox -> c2 servers
  default = [
    { port = 22, description = "SSH Traffic", protocol = "TCP", cidr_blocks = "172.16.3.0/24" },
    { port = 0, description = "ICMP Traffic", protocol = "ICMP", cidr_blocks = "172.16.3.0/24" },
    { port = 80, description = "HTTP", protocol = "TCP", cidr_blocks = "172.16.3.0/24" },
    { port = 443, description = "HTTPS", protocol = "TCP", cidr_blocks = "172.16.3.0/24" },
    { port = 1337, description = "PowerShell Empire Web", protocol = "TCP", cidr_blocks = "172.16.3.0/24" },
    { port = 5985, description = "WINRM/HTTP", protocol = "TCP", cidr_blocks = "172.16.3.0/24" },
    { port = 5986, description = "WINRM/HTTPS", protocol = "TCP", cidr_blocks = "172.16.3.0/24" },
    { port = 50050, description = "Cobalt Strike Team Server", protocol = "TCP", cidr_blocks = "172.16.3.0/24" }
  ]
}

# flatten custom data objects to include all possible IP combos for operators and ROE
locals {
  INGRESS_OPERATORS = flatten([
    for ip in var.OPERATOR_IPS : [
      for rule in var.INGRESS_OPERATOR_TRAFFIC : {
        ip          = ip
        port        = rule.port
        protocol    = rule.protocol
        description = rule.description
      }
    ]
  ])

  ROE_TRAFFIC_COMBINATIONS = flatten([
    for ip in var.ROE_IPS : [
      for rule in var.INGRESS_C2_TRAFFIC : {
        ip          = ip
        port        = rule.port
        protocol    = rule.protocol
        description = rule.description
      }
    ]
  ])
}
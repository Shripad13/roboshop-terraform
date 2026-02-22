resource "aws_security_group" "main" {
  name        = "${var.component_name}-${var.env}-sg"
  description = "Security group for ${var.component_name} in ${var.env} environment"
  vpc_id      = var.vpc_id

  ingress = { # only Bastion host is the incoming traffic for local network.
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = var.bastion_host
  }


  egress = {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Dynamic block to iterate over the ports map and create multiple ingress rules for each port
  # If you have multiple ports to open for a component, you can define them in the ports variable as a map and then use this dynamic block to create ingress rules for each port.
  dynamic "ingress" {
    for_each = var.ports
    content {
      description = ingress.key
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "TCP"
      cidr_blocks = ingress.value.cidr
    }
  }

  tags = {
    Name = "${var.name}-${var.env}-sg"
  }

}
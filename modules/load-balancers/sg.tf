resource "aws_security_group" "main" {
  name        = "${var.component_name}-${var.env}-sg"
  description = "Security group for ${var.component_name} in ${var.env} environment"
  vpc_id      = var.vpc_id

  ingress = { # only Bastion host is the incoming traffic for local network.
    from_port   = 80          # Using 80 port bcoz, cert is not offloaded
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress = {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"                 # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

 tags = {
  name = "${var.component_name}-${var.env}-lb-sg"
 }
}
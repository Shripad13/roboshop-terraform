resource "aws_instance" "main" {
  ami                    = data.aws_ami.main.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id              = var.subnet_id[0] # we are using the first subnet of the list for DB servers, as we are not using any load balancer for DB servers. If we had a load balancer, then we would have used all the subnets in round robin fashion.

  tags = {
    Name = "${var.component_name}-${var.env}"
  }
# launch template for bastion host

resource "aws_launch_template" "tier_bastion" {
  name_prefix = "tier_bastion"
  # var dung de lay gia tri
  instance_type = var.instance_type
  image_id = data.aws_ssm_parameter.tier_ami.value
  vpc_security_group_ids = [ var.bastion_sg ]
  key_name = var.key_name
  tags = {
    Name = "tier_bastion"
  }
} 

data "aws_ssm_parameter" "tier_ami" {
  name = "ssm_tier_ami"
}

 
 resource "aws_autoscaling_group" "tier_bastion" {
   name = "tier_bastion" 
   max_size = 1
   min_size = 1
   desired_capacity = 1
   vpc_zone_identifier = var.public_subnets

   launch_template {
      id = aws_launch_template.tier_bastion.id
      version = "$Latest"
   }
 }

 # launch template for front end

 resource "aws_launch_template" "tier_app" {
  name_prefix = "tier_app"
  # var dung de lay gia tri
  instance_type = var.instance_type
  image_id = data.aws_ssm_parameter.tier_ami.value
  vpc_security_group_ids = [ var.frontend_app_sg ]
  key_name = var.key_name

  user_data = filebase64("install_apache.sh") 
  tags = {
    Name = "tier_app"
  }
}


data "aws_alb_target_group" "tier_tg" {
  name =  var.lb_tg_name
}

resource "aws_autoscaling_group" "tier_app" {
name = "tier_app" 
max_size = 3
min_size = 2
desired_capacity = 2
vpc_zone_identifier = var.public_subnets

target_group_arns = [data.aws_alb_target_group.tier_app.arn]

launch_template {
    id = aws_launch_template.tier_app.id
    version = "$Latest"
}
}

 # launch template for back end

 resource "aws_launch_template" "tier_backend" {
  name_prefix = "tier_backend"
  # var dung de lay gia tri
  instance_type = var.instance_type
  image_id = data.aws_ssm_parameter.tier_ami.id
  vpc_security_group_ids = [ var.backend_app_sg ]
  key_name = var.key_name

  user_data = filebase64("install_node.sh") 
  tags = {
    Name = "tier_backend"
  }
}


 resource "aws_autoscaling_group" "tier_backend" {
   name = "tier_backend" 
   max_size = 3
   min_size = 2
   desired_capacity = 2
   vpc_zone_identifier = var.private_subnets

   target_group_arns = [data.aws_alb_target_group.tier_app.arn]

   launch_template {
      id = aws_launch_template.tier_backend.id
      version = "$Latest"
   }
 }
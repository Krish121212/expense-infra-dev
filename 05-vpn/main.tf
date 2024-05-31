resource "aws_key_pair" "vpn" {
  key_name   = "openvpn"
  #you can paste the public key directly like this open vpn only allows key pair
  #public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDhCEDGG+aiCX3zGM9U0rdVhdjh0PLXO2c+Gp8vz1jJYVMM4m2zWbDGOmAYvPe+AXZuh1EQtZqQmbMoAVpH1iJewUkI4sztnut4JblWy3FYk38kI1CMRoXhjiS7uz3BxSazHDXnNVYD51HlWSHj8zJE9Q8b0fXG+s1k/6OvRsUy6QxGNN2OOXG9+fDLibN/8defGXW1iqHW9DAVv/DFicMV0Xo4zZ6DwXjrhydjua7+v3GT1U2lse0NebWcehgtP3qg3iko5Jp9qA04VNXKRQGE3wX8SkpmZ+up/gc9qcgqKwqRuzwupW+olnaPek9PCRCvErTiOqA/hjDhWILJl2FUK/znxh1mkMD0fpe6mTewsDBukoZfipWO/mp/9IxXc+fo/kqFzujpRjpk7i5oE2xzuxD5ma7Mx6aage3aTPTGHs7SXBc4O4aBhWv5tQ+kM5HofpktcDWPmEZpo6TCOYIKDiA/3vEmARZKSht69iJNuloy2jy3tmZwOwcZA4uqPk0snCqmONsU7CNCZxCxQKlt42AroaAbjLj2ODb3mt3U4LUr/eQ58Ufe+ThMN1udCczaK/dXa29ij58r8LFvnKKSvdOVsxWTnFy5smuFzoPV4IFC77qQBIXskeqpOrOysOdrN9/LYnyKlTAv7W4OPJ0ih0oSGF2um7DDhJZepYdMSw== surya@sunny"
  public_key = file("~/.ssh/openvpn.pub")
  # ~ means windows home directory
}

#below is to create an ec2 instance - vpn 
module "vpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  key_name = aws_key_pair.vpn.key_name
  name = "${var.project_name}-${var.environment}-vpn"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  #converting string list to list and get first element
  subnet_id  = element(split("," ,data.aws_ssm_parameter.public_subnet_ids.value), 0)
  ami = data.aws_ami.ami_info.id
  
  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-bastion"
    }
  )
}

#We need to do some manual work after ec2 creation for vpn, in server
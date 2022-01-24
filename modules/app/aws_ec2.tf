resource "aws_instance" "web" {
  ami = "ami-04505e74c0741db8d"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sgpo.id]
  subnet_id              = var.subnet_id
  iam_instance_profile   = var.iam_profile_ec2
  #  associate_public_ip_address = true



  key_name = "po3xm-ec2-kp"

  # sudo apt install nginx -y 
  # sudo service nginx start
  user_data = <<-EOF
                #!/bin/bash
                sudo -i
                sudo apt-get update
                sudo apt install ruby-full -y
                sudo apt install wget
                cd /home/ubuntu
                wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
                chmod +x ./install
                sudo ./install auto > /tmp/logfile
                sudo service codedeploy-agent start     
              EOF

  tags = {
    createdby = "po3xm"
    project   = "training"
    Name      = "po3xm-testing"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.web.id
  allocation_id = "eipalloc-0fed0e3319dd1f849"
}
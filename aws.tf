provider "aws" {
  region = "us-east-1"
}

# Get the latest Ubuntu 18.04 server ami
# reference: https://www.terraform.io/docs/providers/aws/r/instance.html
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "lass" {
  key_name = "lass"
  public_key = file("lass.pub")
}

resource "aws_instance" "lass-controller" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "c5a.xlarge"
  key_name = aws_key_pair.lass.id
  associate_public_ip_address = true

  root_block_device {
    volume_size = 50
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file("lass.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]
  }

  provisioner "file" {
    source = "bootstrap.sh"
    destination = "bootstrap.sh"
  }

  provisioner "file" {
    source = "run.sh"
    destination = "run.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x bootstrap.sh",
      "./bootstrap.sh",
      "rm bootstrap.sh",
      "chmod +x run.sh",
    ]
  }

  provisioner "local-exec" {
    command = "ssh-keyscan -H ${self.public_ip} >> ~/.ssh/known_hosts"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ubuntu -i ${self.public_ip}, --private-key lass.pem customize_deployment.yml"
  }
}


resource "aws_instance" "lass-invoker" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "c5a.xlarge"
  key_name = aws_key_pair.lass.id
  associate_public_ip_address = true
  count = 2

  root_block_device {
    volume_size = 30
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file("lass.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "git clone https://github.com/georgianfire/openwhisk",
      "./openwhisk/tools/ubuntu-setup/all.sh"
    ]
  }
}

output "controller-id" {
  value = aws_instance.lass-controller.id
}

output "controller-ip" {
  value = aws_instance.lass-controller.public_ip
}

output "invoker-id" {
  value = aws_instance.lass-invoker.*.id
}

output "invoker-ip" {
  value = aws_instance.lass-invoker.*.public_ip
}

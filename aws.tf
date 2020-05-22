provider "aws" {
  region = "us-east-2"
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

resource "aws_key_pair" "edgewhisk" {
  key_name = "edgewhisk"
  public_key = file("edgewhisk.pub")
}

resource "aws_instance" "edgewhisk" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "m5a.2xlarge"
  key_name = aws_key_pair.edgewhisk.id
  associate_public_ip_address = true

  root_block_device {
    volume_size = 50
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file("edgewhisk.pem")
  }

  provisioner "file" {
    source = "bootstrap.sh"
    destination = "bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x bootstrap.sh",
      "./bootstrap.sh"
    ]
  }

  provisioner "file" {
    source = "run.sh"
    destination = "run.sh"
  }

  provisioner "file" {
    source = "mycluster.yaml"
    destination = "mycluster.yaml"
  }
}

output "id" {
  value = aws_instance.edgewhisk.id
}

output "ip" {
  value = aws_instance.edgewhisk.public_ip
}

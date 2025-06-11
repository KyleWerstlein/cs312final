provider "aws" {
  region = "us-east-1"
}

data "aws_security_group" "wordpress" {
  name = "wordpress"
}

resource "aws_instance" "minecraft" {
  ami           = "ami-0fc5d935ebf8bc3bc" # Amazon Linux 2023 in us-east-1
  instance_type               = "t2.small"
  key_name                    = "mc"
  vpc_security_group_ids      = [data.aws_security_group.wordpress.id]
  associate_public_ip_address = true

  tags = {
    Name = "MinecraftServer"
  }

  provisioner "file" {
    source      = "setup_minecraft.sh"
    destination = "/home/ubuntu/setup_minecraft.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/mc.pem")
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x setup_minecraft.sh",
      "./setup_minecraft.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/mc.pem")
      host        = self.public_ip
    }
  }
}

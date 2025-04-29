provider "aws" {
  region= var.region
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "app_server" {
  ami           = "ami-0c02fb55956c7d316" # Ubuntu 22.04 LTS
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name

  tags = {
    Name = "HelloWorldEC2"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }

    inline = [
      "sudo apt update",
      "sudo apt install -y python3",
      "echo 'print(\"Hello, World from EC2!\")' > hello.py",
      "python3 hello.py"
    ]
  }
}

output "instance_ip" {
  value = aws_instance.app_server.public_ip
}

resource "aws_instance" "app_server" {
  ami           = "ami-0c55b159cbfafe1f0" # example
  instance_type = "t2.micro"

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("id_rsa")
      host        = self.public_ip
    }

    inline = [
      "echo Hello from Terraform!"
    ]
  }
}

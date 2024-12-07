provider "aws" {
  #access_key = ""
  #secret_key = ""   
  region = "ap-south-1"
}

resource "aws_instance" "master1" {
  ami                    = "ami-022d03f649d12a49d"
  instance_type          = "t2.micro"
  availability_zone      = "ap-south-1a"
  key_name               = "openai-keypair"
  vpc_security_group_ids = ["sg-08951bda700c6202d"]
  tags = {
    Name    = "master1"
    Project = "openinno"
  }
}
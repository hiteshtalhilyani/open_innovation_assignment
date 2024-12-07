provider "aws" {
  #access_key = ""
  #secret_key = ""   
  region = "ap-south-1"
}

resource "aws_instance" "master1" {
  ami                    = "ami-022d03f649d12a49d"
  instance_type          = "t2.micro"
  availability_zone      = "ap-south-1a"
  key_name               = "hktkey"
  vpc_security_group_ids = ["sg-08951bda700c6202d"]
  tags = {
    Name    = "master1"
    Project = "openinno"
  }
}

resource "aws_instance" "worker1" {
  ami                    = "ami-022d03f649d12a49d"
  instance_type          = "t2.micro"
  availability_zone      = "ap-south-1b"
  key_name               = "hktkey"
  vpc_security_group_ids = ["sg-08951bda700c6202d"]
  tags = {
    Name    = "worker1"
    Project = "openinno"
  }
}

resource "aws_instance" "worker2" {
  ami                    = "ami-022d03f649d12a49d"
  instance_type          = "t2.micro"
  availability_zone      = "ap-south-1c"
  key_name               = "hktkey"
  vpc_security_group_ids = ["sg-08951bda700c6202d"]
  tags = {
    Name    = "worker2"
    Project = "openinno"
  }
}
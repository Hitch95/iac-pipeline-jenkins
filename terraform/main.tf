provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  skip_credentials_validation = true
  endpoints {
    ec2 = "http://ip10-0-4-5-cvmjgi434iqh49gh8530-4566.direct.lab-boris.fr"
  }
}

# Use commit information for unique AMI
resource "aws_instance" "demo" {
  # Use a combination of base AMI and commit hash
  ami           = "ami-${substr(timestamp(), 0, 8)}${substr(uuid(), 0, 4)}"  # This generates a unique value on each apply
  instance_type = "t2.micro"
  
  tags = {
    Name        = "demo-instance"
    Environment = "development"
    Timestamp   = timestamp()  # Records when this instance was created
    BuildID     = "${formatdate("YYYYMMDDhhmmss", timestamp())}" # Unique ID for each build
  }
}

# Output the instance details
output "instance_id" {
  value = aws_instance.demo.id
}

output "ami_used" {
  value = aws_instance.demo.ami
}

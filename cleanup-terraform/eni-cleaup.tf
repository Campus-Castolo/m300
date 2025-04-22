
# ⚠️ Dynamic Cleanup of VPC Elastic Network Interfaces (ENIs)
# This resource will find and remove all unattached ENIs associated with the VPC
# Use with caution — this will destroy ENIs that are not in use
# BE CAREFUL THIS ACTION IS VERY DESTRUCTIVE

data "aws_network_interfaces" "vpc_enis" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.main.id]
  }
}

resource "null_resource" "delete_unused_enis" {
  provisioner "local-exec" {
    command = <<EOT
for eni in $(aws ec2 describe-network-interfaces --filters Name=vpc-id,Values=${aws_vpc.main.id} --query 'NetworkInterfaces[?Status==\'available\'].NetworkInterfaceId' --output text); do
  echo "Deleting ENI $eni..."
  aws ec2 delete-network-interface --network-interface-id $eni
done
EOT
    interpreter = ["/bin/bash", "-c"]
  }

  triggers = {
    eni_count = length(data.aws_network_interfaces.vpc_enis.ids)
  }
}

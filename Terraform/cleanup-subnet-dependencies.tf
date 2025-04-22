resource "null_resource" "cleanup_dependencies" {
  provisioner "local-exec" {
    command = <<EOT
      echo "Cleaning up AWS resources blocking subnet deletion..."

      # Delete ENIs in the subnets
      for subnet in subnet-0cdefcb5136f9f215 subnet-02be1ea5ff7662ab9; do
        for eni in $(aws ec2 describe-network-interfaces \
                      --query "NetworkInterfaces[?SubnetId=='$subnet'].NetworkInterfaceId" \
                      --output text); do
          echo "Deleting ENI: $eni"
          aws ec2 delete-network-interface --network-interface-id $eni || true
        done
      done

      # Delete NAT Gateways in the subnets
      for subnet in subnet-0cdefcb5136f9f215 subnet-02be1ea5ff7662ab9; do
        for nat in $(aws ec2 describe-nat-gateways \
                      --query "NatGateways[?SubnetId=='$subnet'].NatGatewayId" \
                      --output text); do
          echo "Deleting NAT Gateway: $nat"
          aws ec2 delete-nat-gateway --nat-gateway-id $nat || true
        done
      done

      # Disassociate route table associations
      for assoc in $(aws ec2 describe-route-tables \
                      --query "RouteTables[].Associations[?SubnetId=='subnet-0cdefcb5136f9f215' || SubnetId=='subnet-02be1ea5ff7662ab9'].RouteTableAssociationId" \
                      --output text); do
        echo "Disassociating Route Table Association: $assoc"
        aws ec2 disassociate-route-table --association-id $assoc || true
      done

      echo "Cleanup complete. Run 'terraform destroy' again."
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}

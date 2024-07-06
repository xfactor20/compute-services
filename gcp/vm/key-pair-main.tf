#####################
## Key Pair - Main ##
#####################

# Generates a secure private key and encodes it as PEM
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create the Key Pair
# Save file
resource "local_file" "ssh_key" {
  filename = "${lower(var.app_name)}-linux-${lower(var.gcp_region)}.pem"
  content  = tls_private_key.key_pair.private_key_pem
}
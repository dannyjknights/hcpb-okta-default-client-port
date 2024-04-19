resource "boundary_target" "sudo_access" {
  type                     = "ssh"
  name                     = "aws-ec2-sudo-access"
  description              = "Sudo EC2 Access"
  egress_worker_filter     = " \"self-managed-aws-worker\" in \"/tags/type\" "
  scope_id                 = boundary_scope.project.id
  session_connection_limit = -1
  default_port             = 22
  default_client_port      = 50506
  host_source_ids = [
    boundary_host_set_plugin.aws_db.id,
    boundary_host_set_plugin.aws_dev.id,
    boundary_host_set_plugin.aws_prod.id,
  ]
  injected_application_credential_source_ids = [boundary_credential_library_vault_ssh_certificate.vault_ssh_ec2_user_cert.id]
}


//Credential library for SSH injected credentials
resource "boundary_credential_library_vault_ssh_certificate" "vault_ssh_ec2_user_cert" {
  name                = "ssh-ec2-user-certs"
  description         = "Vault SSH EC2 User Cert Library"
  credential_store_id = boundary_credential_store_vault.vault_cred_store.id
  path                = "ssh-client-signer/sign/boundary-client"
  username            = "ec2-user"
}
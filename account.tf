resource "aws_organizations_account" "account" {
  name  = var.name
  email = var.root_account_email

  tags = {
    team = var.account_team
    env  = var.account_env
  }

  provisioner "local-exec" {
    # AWS accounts aren't quite ready on creation, arbitrary pause before we provision resources inside it
    command = "sleep 120"
  }
}

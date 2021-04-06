output "account_id" {
  value       = aws_organizations_account.account.id
  description = "The Id of the newly created member AWS account"
}

output "account_root_email" {
  value       = aws_organizations_account.account.email
  description = "The email address of the root account"
}

output "zone_name" {
  value       = try(aws_route53_zone.zone[0].name, null)
  description = "The name of the AWS account's route53 zone"
}

output "zone_id" {
  value       = try(aws_route53_zone.zone[0].zone_id, null)
  description = "The zone Id of the AWS account's route53 zone"
}

output "zone_name_servers" {
  value       = try(aws_route53_zone.zone[0].name_servers, null)
  description = "The name servers of the AWS account's route53 zone"
}

output "state_bucket" {
  value       = aws_s3_bucket.state.bucket
  description = "The name of the state bucket"
}

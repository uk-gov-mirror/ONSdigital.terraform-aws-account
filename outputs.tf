output "account_id" {
  value       = aws_organizations_account.account.id
  description = "The Id of the newly created member AWS account"
}

output "s3_access_bucket_arn" {
  value       = length(aws_s3_bucket.s3-access) > 0 ? aws_s3_bucket.s3-access[0].arn : ""
  description = "The ARN of the splunk log delivery bucket"
}

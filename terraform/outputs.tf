output "cloudfront_domain" {
  value = aws_cloudfront_distribution.site.domain_name
}

output "bucket_name" {
  value = aws_s3_bucket.site.id
}

output "api_endpoint" {
  value = "${aws_apigatewayv2_api.counter.api_endpoint}/count"
}
output "distribution_id" {
  value = aws_cloudfront_distribution.site.id
}

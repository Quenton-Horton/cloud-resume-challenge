variable "bucket_name" {
  description = "Globally unique S3 bucket name for the site"
  type        = string
  default     = "quentonhorton-resume-site-tf"
}

variable "domain_name" {
  description = "Custom domain"
  type        = string
  default     = "quentonhorton.com"
}

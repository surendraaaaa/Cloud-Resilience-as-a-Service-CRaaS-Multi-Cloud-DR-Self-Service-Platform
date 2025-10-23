

output "primary_record" {
  value = cloudflare_record.primary.hostname
}

output "secondary_record" {
  value = cloudflare_record.secondary.hostname
}
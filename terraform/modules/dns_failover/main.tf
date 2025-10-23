resource "cloudflare_record" "primary" {
  zone_id = var.cloudflare_zone_id
  name    = var.app_domain
  type    = "A"
  value   = var.primary_ip
  proxied = false
  ttl     = 60
}

resource "cloudflare_record" "secondary" {
  zone_id = var.cloudflare_zone_id
  name    = "backup.${var.app_domain}"
  type    = "A"
  value   = var.secondary_ip
  proxied = false
  ttl     = 60
}
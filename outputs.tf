output "uptimerobot_whitelist_cidrs" {
  description = "CIDR ranges published by UptimeRobot for whitelisting."
  value       = local.uptimerobot_whitelist_cidrs
}

output "uptimerobot_whitelist_ipv4_cidrs" {
  description = "IPv4 CIDR ranges published by UptimeRobot."
  value       = local.uptimerobot_whitelist_ipv4_cidrs
}

output "uptimerobot_whitelist_ipv6_cidrs" {
  description = "IPv6 CIDR ranges published by UptimeRobot."
  value       = local.uptimerobot_whitelist_ipv6_cidrs
}

output "uptimerobot_whitelist_cidrs_by_region" {
  description = "CIDR ranges grouped by region as published by UptimeRobot."
  value       = local.uptimerobot_whitelist_cidrs_by_region
}

output "uptimerobot_whitelist_ipv4_cidrs_by_region" {
  description = "IPv4 CIDR ranges grouped by region as published by UptimeRobot."
  value       = local.uptimerobot_whitelist_ipv4_cidrs_by_region
}

output "uptimerobot_whitelist_ipv6_cidrs_by_region" {
  description = "IPv6 CIDR ranges grouped by region as published by UptimeRobot."
  value       = local.uptimerobot_whitelist_ipv6_cidrs_by_region
}

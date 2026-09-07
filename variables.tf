variable "uptimerobot_ips_url" {
  description = "UptimeRobot endpoint returning monitor source IP prefixes."
  type        = string
  default     = "https://api.uptimerobot.com/meta/ips"
}

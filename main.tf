data "http" "uptimerobot_ips" {
  url = var.uptimerobot_ips_url

  request_headers = {
    Accept = "application/json"
  }
}

locals {
  uptimerobot_ips_payload = jsondecode(try(data.http.uptimerobot_ips.response_body, data.http.uptimerobot_ips.body))

  uptimerobot_prefix_entries = [
    for prefix in local.uptimerobot_ips_payload.prefixes : {
      cidr = try(
        prefix.ip_prefix,
        prefix.ipv4_prefix,
        prefix.ipv6_prefix,
        prefix.prefix,
        null
      )
      region = upper(try(prefix.region, "UNKNOWN"))
    }
  ]

  # All announced prefixes in CIDR format, ready to whitelist.
  uptimerobot_whitelist_cidrs = sort(distinct(compact([
    for entry in local.uptimerobot_prefix_entries : entry.cidr
  ])))

  uptimerobot_regions = sort(distinct([
    for entry in local.uptimerobot_prefix_entries : entry.region
  ]))

  uptimerobot_whitelist_cidrs_by_region = {
    for region in local.uptimerobot_regions : region => sort(distinct(compact([
      for entry in local.uptimerobot_prefix_entries : entry.cidr
      if entry.region == region
    ])))
  }

  # Optional split by IP family.
  uptimerobot_whitelist_ipv4_cidrs = sort([
    for cidr in local.uptimerobot_whitelist_cidrs : cidr
    if can(regex("\\.", cidr))
  ])

  uptimerobot_whitelist_ipv6_cidrs = sort([
    for cidr in local.uptimerobot_whitelist_cidrs : cidr
    if can(regex(":", cidr))
  ])

  uptimerobot_whitelist_ipv4_cidrs_by_region = {
    for region, cidrs in local.uptimerobot_whitelist_cidrs_by_region : region => sort([
      for cidr in cidrs : cidr
      if can(regex("\\.", cidr))
    ])
  }

  uptimerobot_whitelist_ipv6_cidrs_by_region = {
    for region, cidrs in local.uptimerobot_whitelist_cidrs_by_region : region => sort([
      for cidr in cidrs : cidr
      if can(regex(":", cidr))
    ])
  }
}


run "outputs_are_not_empty_and_valid_cidrs" {
  command = plan

  assert {
    condition     = length(output.uptimerobot_whitelist_cidrs) > 0
    error_message = "Expected at least one CIDR from UptimeRobot."
  }

  assert {
    condition = alltrue([
      for cidr in output.uptimerobot_whitelist_cidrs : can(cidrhost(cidr, 0))
    ])
    error_message = "All values in uptimerobot_whitelist_cidrs must be valid CIDRs."
  }
}

run "ipv4_ipv6_outputs_are_consistent" {
  command = plan

  assert {
    condition = alltrue([
      for cidr in output.uptimerobot_whitelist_ipv4_cidrs : can(regex("\\.", cidr))
    ])
    error_message = "uptimerobot_whitelist_ipv4_cidrs must contain only IPv4 CIDRs."
  }

  assert {
    condition = alltrue([
      for cidr in output.uptimerobot_whitelist_ipv6_cidrs : can(regex(":", cidr))
    ])
    error_message = "uptimerobot_whitelist_ipv6_cidrs must contain only IPv6 CIDRs."
  }

  assert {
    condition = alltrue([
      for cidr in output.uptimerobot_whitelist_ipv4_cidrs : contains(output.uptimerobot_whitelist_cidrs, cidr)
    ])
    error_message = "Every IPv4 CIDR must also exist in the global CIDR output."
  }

  assert {
    condition = alltrue([
      for cidr in output.uptimerobot_whitelist_ipv6_cidrs : contains(output.uptimerobot_whitelist_cidrs, cidr)
    ])
    error_message = "Every IPv6 CIDR must also exist in the global CIDR output."
  }
}

run "regional_outputs_are_consistent" {
  command = plan

  assert {
    condition = alltrue([
      for cidr in flatten(values(output.uptimerobot_whitelist_cidrs_by_region)) : contains(output.uptimerobot_whitelist_cidrs, cidr)
    ])
    error_message = "Every regional CIDR must also exist in the global CIDR output."
  }

  assert {
    condition = alltrue([
      for region in keys(output.uptimerobot_whitelist_cidrs_by_region) : region == upper(region)
    ])
    error_message = "Region keys must be uppercase."
  }
}
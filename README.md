# Terraform Module: UptimeRobot Whitelist

> [!CAUTION]
> **EXPERIMENTAL MODULE**
> This module is experimental and may change at any time, including breaking changes between versions.
> Use it with caution in production environments.

This module fetches the public monitor source [IP ranges published by UptimeRobot](https://uptimerobot.com/help/locations/) (https://api.uptimerobot.com/meta/ips) and exposes them as ready-to-use CIDR lists.

It is useful when you need to whitelist UptimeRobot in firewalls, security groups, WAF rules, or other network access controls.

> [!WARNING]
> The official UptimeRobot Terraform provider also exposes `ip_ranges`, but it requires configuring an UptimeRobot API key.
> This standalone module exists to retrieve public IP ranges without needing provider authentication.

## Features

- Fetches IP prefixes from the UptimeRobot metadata endpoint.
- Normalizes mixed payload formats (`ip_prefix`, `ipv4_prefix`, `ipv6_prefix`, `prefix`).
- Returns a deduplicated global CIDR list.
- Returns CIDRs grouped by region.
- Exposes optional IPv4-only and IPv6-only outputs.

## Requirements

| Name           | Version  |
| -------------- | -------- |
| terraform      | >= 1.3.0 |
| hashicorp/http | >= 3.0.0 |

## Providers

| Name           | Version  |
| -------------- | -------- |
| hashicorp/http | >= 3.0.0 |

## Inputs

| Name                  | Description                                                | Type     | Default                                  | Required |
| --------------------- | ---------------------------------------------------------- | -------- | ---------------------------------------- | -------- |
| `uptimerobot_ips_url` | UptimeRobot endpoint returning monitor source IP prefixes. | `string` | `"https://api.uptimerobot.com/meta/ips"` | no       |

## Outputs

| Name                                         | Description                                                     |
| -------------------------------------------- | --------------------------------------------------------------- |
| `uptimerobot_whitelist_cidrs`                | CIDR ranges published by UptimeRobot for whitelisting.          |
| `uptimerobot_whitelist_ipv4_cidrs`           | IPv4 CIDR ranges published by UptimeRobot.                      |
| `uptimerobot_whitelist_ipv6_cidrs`           | IPv6 CIDR ranges published by UptimeRobot.                      |
| `uptimerobot_whitelist_cidrs_by_region`      | CIDR ranges grouped by region as published by UptimeRobot.      |
| `uptimerobot_whitelist_ipv4_cidrs_by_region` | IPv4 CIDR ranges grouped by region as published by UptimeRobot. |
| `uptimerobot_whitelist_ipv6_cidrs_by_region` | IPv6 CIDR ranges grouped by region as published by UptimeRobot. |

## Usage

```hcl
module "uptimerobot_whitelist" {
  source = "github.com/IGNF/tf-uptimerobot-whitelist"

  # Optional override
  # uptimerobot_ips_url = "https://api.uptimerobot.com/meta/ips"
}

# Example: allow all UptimeRobot CIDRs
output "all_uptimerobot_cidrs" {
  value = module.uptimerobot_whitelist.uptimerobot_whitelist_cidrs
}

# Example: allow only IPv4 CIDRs
output "uptimerobot_ipv4" {
  value = module.uptimerobot_whitelist.uptimerobot_whitelist_ipv4_cidrs
}

# Example: consume by region
output "uptimerobot_europe" {
  value = module.uptimerobot_whitelist.uptimerobot_whitelist_cidrs_by_region["EUROPE"]
}
```

## Notes

- Region keys are uppercased in grouped outputs (for example: `EUROPE`, `NORTH-AMERICA`, `UNKNOWN`).
- Empty or unrecognized prefixes are ignored.
- The module is data-only and does not create infrastructure resources by itself.

## See Also

- Terraform UptimeRobot provider data source `ip_ranges`: https://registry.terraform.io/providers/uptimerobot/uptimerobot/latest/docs/data-sources/ip_ranges

## Testing

Testing instructions are documented in [CODING.md](CODING.md).

## License

This module is licensed under the MIT License. See [LICENSE](LICENSE).

## Transparency

This module was drafted with AI assistance and validated by maintainers.

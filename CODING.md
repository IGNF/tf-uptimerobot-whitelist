# Coding Guide

## Testing

This module includes minimal native Terraform tests in `tests/basic.tftest.hcl`.

Run tests with:

```bash
terraform init
terraform test
```

What is validated:

- The global CIDR output is not empty.
- All global CIDRs are valid.
- IPv4 and IPv6 outputs contain the expected address family only.
- IPv4/IPv6 outputs are subsets of the global CIDR output.
- Regional CIDRs are subsets of the global CIDR output.
- Region keys are uppercase.
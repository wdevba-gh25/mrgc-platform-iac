# mrgc-platform-iac

Infrastructure-as-Code repository for the Emergency Surge Demo platform.

## Purpose

This repo is dedicated to infrastructure concerns only.

It is meant to hold:
- Terraform configuration
- environment tfvars
- infrastructure docs
- architecture docs related to IaC, AKS, and deployment flow

## Why a separate repo?

This repo exists to keep infrastructure lifecycle separate from app-code lifecycle.

That separation helps with:
- cleaner Terraform history
- clearer ownership of infra changes
- easier CI/CD reasoning
- stronger architectural separation for the showcase

## Suggested structure

```text
infra/
  terraform/
    providers.tf
    main.tf
    variables.tf
    outputs.tf
    versions.tf
    backend.tf.example
    environments/
      dev.tfvars
      qa.tfvars
      prod.tfvars

docs/
architecture/
```

## Notes

- Replace placeholder values before real usage.
- Do not commit real secrets.
- Prefer Azure DevOps secret variables or Key Vault-backed variable groups.

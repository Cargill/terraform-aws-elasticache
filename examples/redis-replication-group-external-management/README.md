# ElastiCache Example For Redis Replication Group External Management

This example creates a Redis replication group with
`replication_group_lifecycle_ignore_changes_mode = "external_management"` and
`parameter_group_lifecycle_ignore_changes_mode = "external_management"`.

An external operational workflow can update the engine version, parameter
group, credentials, and selected capacity or network attributes after creation.
Terraform refreshes those changes into state without planning to revert the
ignored attributes. See the root module README for the complete lifecycle-mode
behavior and state migration guidance.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

This example creates AWS resources that can incur charges. Run
`terraform destroy` when they are no longer needed.

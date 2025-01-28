# Administration

For administration of Testudo, traffic **MUST** flow through any of the configured jumpboxes. This is purely up to the owner of the infrastructure on how to handle this.&#x20;

For further information on how this is configured:

The AWS security group that configures this behavior is configured with the variables `OPERATOR_ADMINISTRATION` & `REDIRECTOR_ADMINISTRATION` within `vars.tf` .


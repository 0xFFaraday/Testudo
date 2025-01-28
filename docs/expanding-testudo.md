# Expanding Testudo

If you find the need to expand upon Testudo, please be known of the following files:

* `ansible/data/config.json`&#x20;
* `ansible/data/inventory`

For example the variable `linux_jumpbox_vm_config` within the file `provider/aws/jumpboxes.tf` has the ability to add another Linux jumpbox within Testudo. Please follow the variable format and add the proper entries within the above `ansible/data` files as well for these machines to have the same state as the other deployed machines.

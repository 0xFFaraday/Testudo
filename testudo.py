import typer
from rich.console import Console
from testudo.utils import *
from typing_extensions import Annotated

def main(
    verbose: Annotated[bool, typer.Option("--verbose", "-v", help="Get verbose output from Terraform")] = False,
    provide: Annotated[bool, typer.Option("--provide", "-pt", help="Deploy Testudo infrastructure")] = False,
    provision: Annotated[bool, typer.Option("--provision", "-pa", help="Provision Testudo with Ansible")] = False,
    status: Annotated[bool, typer.Option("--status", "-s", help="Get instance details of Testudo")] = False,
    destroy: Annotated[bool, typer.Option("--destroy", "-d", help="Destroy Testudo infrastructure")] = False

):
    console = Console()
    print(banner())
    
    if provide:
        console.log("Deploying Testudo, please wait...")
        deploy_lab(verbose)

        terraform_outputs = get_terraform_outputs()
        testudo_lab = print_lab_status(terraform_outputs)

        console.log(testudo_lab)
        console.log("Testudo deployed, please run the ansible provisioning option now!")

    if status:
        terraform_outputs = get_terraform_outputs()
        
        if len(terraform_outputs) == 0:
            console.log("Testudo is not provisioned...")
        
        else:
            testudo_lab = print_lab_status(terraform_outputs)
            console.log(testudo_lab)
        
    if provision:
        terraform_outputs = get_terraform_outputs()
        ansible_public_ip = get_ansible_public_ip(terraform_outputs)

        console.log("Provisioning with Ansible please wait...")
        provision_ansible("main", ansible_public_ip)
        console.log("Provisioning is complete! Happy hacking!")

    elif destroy:
        console.log("Attempting to destroy Testudo, please wait...")
        destroy_lab(verbose)
        console.log("Testudo has been destroyed")

if __name__ == "__main__":
    typer.run(main)
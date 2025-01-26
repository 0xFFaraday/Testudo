import json
import subprocess
from rich.table import Table

def banner():
    return """                      
    
  ______          __            __    
 /_  __/__  _____/ /___  ______/ /___ 
  / / / _ \/ ___/ __/ / / / __  / __ \\
 / / /  __(__  ) /_/ /_/ / /_/ / /_/ /
/_/  \___/____/\__/\__,_/\__,_/\____/ 
            Created By: 0xFFaraday             

"""

def deploy_lab(verbose):
    command = ["terraform", "-chdir=./provider/aws", "apply", "--auto-approve"]
    output = subprocess.PIPE if verbose else subprocess.DEVNULL
    result = subprocess.run(command, stdout=output, stderr=output, text=True)

    if verbose:
        print(result.stdout)
        if result.stderr:
            print(f"Error: {result.stderr}")

def destroy_lab(verbose):
    command = ["terraform", "-chdir=./provider/aws", "destroy", "--auto-approve"]
    output = subprocess.PIPE if verbose else subprocess.DEVNULL
    result = subprocess.run(command, stdout=output, stderr=output, text=True)

    if verbose:
        print(result.stdout)
        if result.stderr:
            print(f"Error: {result.stderr}")
    # if verbose:
    #     subprocess.run(
    #         command,
    #         capture_output=False,
    #         text=True
    #     )
    # else:
    #     subprocess.run(
    #     command,
    #     subprocess.DEVNULL
    # )

def get_ansible_public_ip(lab_data):
    return lab_data["ansible_controller_instance_details"]["value"]["ap-01"]["public_ip"]

def provision_ansible(playbook: str, ansible_public_ip: str):
    ansible_command = f"cd ansible && ansible-playbook {playbook}.yml -vv"
    command = ["ssh", "-i", "linux-key-pair.pem", f"ubuntu@{ansible_public_ip}", f"{ansible_command}"]

    subprocess.run(command, text=True)

def generate_instance_details_table(keyname, lab_data, title):
    table = Table("Instance ID", "Hostname", "Private IPv4", "Public IPv4", title=title, show_lines=True)
    for host in lab_data[keyname].keys():
        instance_id = lab_data[keyname][host]["instance_id"]
        private_ip = lab_data[keyname][host]["private_ip"]
        public_ip = lab_data[keyname][host]["public_ip"]
        table.add_row(instance_id, host, private_ip, public_ip)
    return table

def get_terraform_outputs():
    terraform_output = subprocess.run(
        ["terraform", "-chdir=provider/aws", "output", "-json"],
        capture_output=True,
        text=True
    )
    return json.loads(terraform_output.stdout)

def print_lab_status(terraform_outputs):
    lab_data = {
        "redirectors": terraform_outputs["redirectors_instance_details"]["value"],
        "c2_servers": terraform_outputs["c2_servers_instance_details"]["value"],
        "windows_jumpboxes": terraform_outputs["jumpbox_windows_instance_details"]["value"],
        "linux_jumpboxes": terraform_outputs["jumpbox_ubuntu_instance_details"]["value"],
        "ansible_controller": terraform_outputs["ansible_controller_instance_details"]["value"]
        }

    testudo_table = Table(title="Testudo Infrastructure", show_header=False)

    testudo_tables = [
        generate_instance_details_table("redirectors", lab_data, "Redirectors"),
        generate_instance_details_table("c2_servers", lab_data, "C2 Servers"),
        generate_instance_details_table("windows_jumpboxes", lab_data, "Windows Jumpboxes"),
        generate_instance_details_table("linux_jumpboxes", lab_data, "Linux Jumpboxes"),
        generate_instance_details_table("ansible_controller", lab_data, "Ansible Controller")
    ]

    for table in testudo_tables:
        testudo_table.add_row(table)
    
    return testudo_table
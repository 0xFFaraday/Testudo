<powershell>
  [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
  curl https://raw.githubusercontent.com/ansible/ansible/38e50c9f819a045ea4d40068f83e78adbfaf2e68/examples/scripts/ConfigureRemotingForAnsible.ps1 -o ConfigureRemotingForAnsible.ps1
  powershell -ExecutionPolicy Unrestricted -File ConfigureRemotingForAnsible.ps1
  net user ansible ${password} /add /expires:never /y
  net localgroup administrators ansible /add
  net user "${username}" ${password} /add /expires:never /y
  net localgroup administrators "${username}" /add
  net localgroup "Remote Desktop Users" "${username}" /add
</powershell>

# Updating Polkadot Nodes to a New Version

This is the explaaination / guide to update Polkadot nodes to a newer version, such as `polkadot-stable2409-1` or `polkadot-stable2409-1` or `latest`, using the provided Ansible playbook. The process ensures that updates are done seamlessly with minimal downtime by leveraging a rolling update strategy.

---

## Steps to Update Nodes

### 1. Update the Version Variable
To update the Polkadot nodes to any version, modify the version variable in `ansible/roles/deploy-polkadot/vars/main.yml`:
```yaml
polkadot_version: stable2409-1
```
Alternatively, you can specify the version dynamically when running the playbook:
```bash
ansible-playbook -i inventory.ini playbook.yml -e polkadot_version=stable2409-1
```

### 2. Run the Playbook
Run the playbook to initiate the rolling update:
```bash
ansible-playbook -i inventory.ini playbook.yml
```

### 3. Rolling Update Workflow
The playbook uses a rolling update strategy, which means nodes are updated one at a time. This ensures high availability by keeping at least one node running while others are being updated. The process for each node includes:
- **Pull the New Docker Image**: The updated version of the Polkadot Docker image is pulled.
- **Update the Systemd Service**: The `systemd` service file is updated to use the new version.
- **Start the Node**: The Polkadot node is restarted with the new version.
- **Health Check**: Each node is verified for successful syncing and proper operation before moving to the next.

### 4. Verification
You can verify and monitor the logs to ensure that nodes are running correctly:
```bash
sudo journalctl -u polkadot -f
```

---

## Summary
By following the steps outlined above, we can efficiently update the Polkadot nodes to the latest version, ensuring minimal downtime and maintaining network stability. The rolling update approach guarantees that each node is fully operational before proceeding to the next, providing a seamless and automated update process.


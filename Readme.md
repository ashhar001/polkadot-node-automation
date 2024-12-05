<!-- # Polkadot Deployment and Update Automation

This project provides a comprehensive automation solution for deploying and updating Polkadot Fullnodes using **Ansible** and **Docker**. It supports efficient management of multiple nodes with rolling updates, ensuring minimal downtime and high availability.

---

## Features
- **Automated Deployment**: Deploy Polkadot nodes from scratch with all dependencies and configurations.
- **Rolling Updates**: Update nodes one by one to minimize service interruptions.
- **Dynamic Configuration**: Ansible templates automatically configure nodes based on their inventory details.
- **Health Checks**: Ensure nodes are healthy before proceeding to the next step or updating other nodes.

---

## Project Structure
```
polkadot-deployment-automation/
├── terraform/                # Infrastructure provisioning (optional)
├── ansible/
│   ├── inventory.ini         # Inventory file with node IPs
│   ├── playbook.yml          # Main Ansible playbook
│   ├── roles/
│   │   ├── deploy-polkadot/
│   │   │   ├── tasks/
│   │   │   │   ├── main.yml  # Task definitions for deployment and updates
│   │   │   ├── templates/
│   │   │   │   ├── polkadot.service.j2 # Systemd service template
│   │   │   ├── vars/
│   │   │   │   ├── main.yml  # Polkadot version variables
```

---

## How It Works

### 1. Inventory Setup
The `inventory.ini` file lists the IP addresses of the Polkadot nodes to be managed by Ansible:
```ini
[polkadot_nodes]
192.168.1.1
192.168.1.2
```
This file is used to dynamically reference the IP addresses of the nodes during playbook execution.

### 2. Deployment Workflow
- **Install Dependencies**: Installs Docker and other required packages on the nodes.
- **Generate Node Key**: Generates the node key if it does not already exist.
- **Pull Docker Image**: Pulls the specified version of the Polkadot Docker image.
- **Configure Systemd**: Sets up a `systemd` service for managing the Polkadot Docker container.
- **Start and Verify**: Starts the Polkadot service and verifies the node's health to ensure it is running properly.

### 3. Rolling Updates
The playbook employs the `serial: 1` directive to update nodes one at a time, ensuring that only one node is taken offline during an update, maintaining high availability for the network.

---

## Deployment and Update Process

### 1. Updating the Polkadot Version
Update the `polkadot_version` variable in `vars/main.yml` to the desired version:
```yaml
polkadot_version: stable2409-1
```
Alternatively, pass the version dynamically when running the playbook:
```bash
ansible-playbook -i inventory.ini playbook.yml -e polkadot_version=stable2409-1
```

### 2. Running the Playbook
Run the playbook to deploy or update nodes sequentially:
```bash
ansible-playbook -i inventory.ini playbook.yml
```

### 3. Verification Steps
- **Check Service Status**:
  ```bash
  sudo systemctl status polkadot
  ```
- **Monitor Logs**:
  ```bash
  sudo journalctl -u polkadot -f
  ```
- **Verify Node Version** via RPC:
  ```bash
  curl http://<node-ip>:9933 -H "Content-Type: application/json" -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "system_version"
  }'
  ```

---

## Workflow Explanation

1. **Node Setup and Dependencies**: Ansible installs Docker and ensures the Polkadot node environment is ready.
2. **Service Management**: Using the provided `systemd` template, nodes are configured to start the Polkadot service automatically and are monitored for health.
3. **Rolling Updates**: The playbook is designed to update nodes one at a time, ensuring minimal disruption to the network. Health checks confirm that a node is fully synced before proceeding to the next.

---

## Detailed Update Process
To update Polkadot nodes to a newer version (e.g., `polkadot-stable2409-1`):
1. Update the `polkadot_version` variable.
2. Run the playbook to initiate a rolling update.
3. Each node is:
   - Stopped
   - Updated with the new Docker image
   - Reconfigured and restarted
   - Verified for proper syncing before proceeding to the next node.

---

## Requirements
- **Ansible 2.9+** installed on the control machine.
- **SSH Access**: Ensure the control machine has SSH access to the nodes.
- **Docker**: Docker must be available to run the Polkadot container.
- **Polkadot Docker Image**: The Polkadot Docker image must be accessible for pulling by each node.

---

## Troubleshooting
- **Service Issues**: Check the `systemd` status:
  ```bash
  sudo systemctl status polkadot
  ```
- **Database Lock Errors**: If you encounter database lock errors (`LOCK: Resource temporarily unavailable`), ensure no conflicting instances are running and restart the node after removing the lock file:
  ```bash
  sudo rm /polkadot-data/chains/polkadot/db/full/LOCK
  sudo systemctl start polkadot
  ```
- **Verify Health**: Use the Polkadot RPC API to verify node syncing and health.

---

## Future Enhancements
- **CI/CD Integration**: Automate updates through CI/CD pipelines to reduce manual interventions.
- **Metrics and Observability**: Add monitoring tools to enhance visibility into node performance and reliability.
- **Support for Additional Protocols**: Extend the playbook to support other blockchain protocols, making the solution more versatile.

---

## Contact
Feel free to reach out if you have any questions or suggestions for improvements.
```
} -->




# Updating Polkadot Nodes to a New Version

This guide explains how to update Polkadot nodes to a newer version, such as `polkadot-stable2409-1`, using the provided Ansible playbook. The process ensures that updates are done seamlessly with minimal downtime by leveraging a rolling update strategy.

---

## Steps to Update Nodes

### 1. Update the Version Variable
To update the Polkadot nodes, modify the version variable in `ansible/roles/deploy-polkadot/vars/main.yml`:
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
- **Stop the Node**: The `systemd` service managing the Polkadot container is stopped.
- **Pull the New Docker Image**: The updated version of the Polkadot Docker image is pulled.
- **Update the Systemd Service**: The `systemd` service file is updated to use the new version.
- **Start the Node**: The Polkadot node is restarted with the new version.
- **Health Check**: Each node is verified for successful syncing and proper operation before moving to the next.

### 4. Verification
To verify that the update was successful, use the following command to check the node's version:
```bash
curl http://<node-ip>:9933 -H "Content-Type: application/json" -d '{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "system_version"
}'
```
You can also monitor the logs to ensure that nodes are running correctly:
```bash
sudo journalctl -u polkadot -f
```

---

## Summary
By following the steps outlined above, you can efficiently update your Polkadot nodes to the latest version, ensuring minimal downtime and maintaining network stability. The rolling update approach guarantees that each node is fully operational before proceeding to the next, providing a seamless and automated update process.


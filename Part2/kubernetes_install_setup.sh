#!/bin/bash

# Step 1: Set up your control node
# Install Ansible on the control node (assuming CentOS as the OS)
sudo yum update -y
sudo yum install -y epel-release
sudo yum install -y ansible

# Step 2: Inventory and Group Variables

# Create group variables (group_vars/kubernetes_nodes.yml)


# Step 3: Install Kubernetes Components
cat <<EOF > install_kubernetes.yaml
---
- name: Install Kubernetes
  hosts: kubernetes_nodes
  become: true
  vars_files:
    - group_vars/kubernetes_nodes.yml
  tasks:
    - name: Install kubeadm, kubelet, and kubectl
      yum:
        name:
          - kubeadm
          - kubelet
          - kubectl
        state: present
      tags:
        - kubernetes
EOF

# Run the Ansible playbook to install Kubernetes components
ansible-playbook -i hosts install_kubernetes.yaml

# Step 4: Configure Kubernetes

cat <<EOF > configure_kubernetes.yaml
---
- name: Initialize Kubernetes Master
  hosts: kubernetes_nodes[0]  # Assuming the first node is the master node
  become: true
  vars_files:
    - group_vars/kubernetes_nodes.yml
  tasks:
    - name: Initialize Kubernetes master node
      shell: kubeadm init --kubernetes-version={{ kubernetes_version }}
      register: kubeadm_output
      args:
        creates: /etc/kubernetes/admin.conf
      tags:
        - kubernetes

    - name: Set up kubeconfig for non-root user
      copy:
        src: /etc/kubernetes/admin.conf
        dest: /home/{{ ansible_user }}/.kube/config
        owner: "{{ ansible_user }}"
        group: "{{ ansible_user }}"
        mode: 0600
      become: false
      tags:
        - kubernetes

    - name: Deploy Pod network (e.g., Calico)
      shell: kubectl apply -f https://docs.projectcalico.org/v3.18/manifests/calico.yaml
      tags:
        - kubernetes
EOF

# Run the Ansible playbook to configure Kubernetes
ansible-playbook -i hosts configure_kubernetes.yaml


# Verify the installation using kubectl commands
kubectl get nodes
kubectl get pods --all-namespaces


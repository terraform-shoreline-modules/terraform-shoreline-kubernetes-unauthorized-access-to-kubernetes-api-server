
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Unauthorized Access to Kubernetes API Server Detected
---

This incident type is characterized by the detection of unauthorized access to the Kubernetes API server. This unauthorized access potentially enables attackers to manipulate cluster resources. Such incidents can lead to serious consequences, as unauthorized access allows attackers to make changes to the Kubernetes cluster, which may compromise the security and integrity of the entire system. Therefore, it is crucial to promptly detect and address such incidents to ensure the security and proper functioning of the Kubernetes cluster.

### Parameters
```shell
export KUBE_APISERVER_POD_NAME="PLACEHOLDER"

export API_SERVER_ENDPOINT="PLACEHOLDER"

export ROLE_NAME="PLACEHOLDER"

export NAMESPACE="PLACEHOLDER"

export PATH_TO_KUBECONFIG="PLACEHOLDER"

```

## Debug

### Check the status of the Kubernetes API server
```shell
kubectl cluster-info
```

### Get a list of all the pods running in the default namespace
```shell
kubectl get pods
```

### Check the logs of the kube-apiserver container to see if there are any suspicious activities
```shell
kubectl logs -n kube-system ${KUBE_APISERVER_POD_NAME} kube-apiserver
```

### Check the Kubernetes audit logs to see if there were any unauthorized API requests
```shell
kubectl get auditlog -o json | jq '.items[] | select(.user.username != "system:serviceaccount:kube-system:kube-apiserver").requestURI'
```

### Check the Kubernetes RBAC configuration to ensure that the correct permissions are in place
```shell
kubectl get clusterroles

kubectl get clusterrolebindings
```

## Repair

### Review access controls for the Kubernetes API server and ensure that only authorized users and applications have access.
```shell
#!/bin/bash

# Set variables

KUBE_CONFIG=${PATH_TO_KUBECONFIG}

KUBE_NAMESPACE=${NAMESPACE}

KUBE_API_SERVER=${API_SERVER_ENDPOINT}

# Review access controls for Kubernetes API server

kubectl --kubeconfig=$KUBE_CONFIG auth can-i --list --namespace=$KUBE_NAMESPACE --server=$KUBE_API_SERVER

# If necessary, update access controls to ensure only authorized users and applications have access

# Example command to grant a user read-only access to the namespace

kubectl --kubeconfig=$KUBE_CONFIG create role ${ROLE_NAME} --verb=get,list --resource=pods --namespace=$KUBE_NAMESPACE

kubectl --kubeconfig=$KUBE_CONFIG create rolebinding ${ROLE_BINDING_NAME} --role=${ROLE_NAME} --user=${USER_NAME} --namespace=$KUBE_NAMESPACE

```
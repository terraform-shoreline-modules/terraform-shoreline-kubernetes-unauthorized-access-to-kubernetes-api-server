resource "shoreline_notebook" "unauthorized_access_to_kubernetes_api_server_detected" {
  name       = "unauthorized_access_to_kubernetes_api_server_detected"
  data       = file("${path.module}/data/unauthorized_access_to_kubernetes_api_server_detected.json")
  depends_on = [shoreline_action.invoke_get_roles,shoreline_action.invoke_kube_review_access]
}

resource "shoreline_file" "get_roles" {
  name             = "get_roles"
  input_file       = "${path.module}/data/get_roles.sh"
  md5              = filemd5("${path.module}/data/get_roles.sh")
  description      = "Check the Kubernetes RBAC configuration to ensure that the correct permissions are in place"
  destination_path = "/agent/scripts/get_roles.sh"
  resource_query   = "container | app='shoreline'"
  enabled          = true
}

resource "shoreline_file" "kube_review_access" {
  name             = "kube_review_access"
  input_file       = "${path.module}/data/kube_review_access.sh"
  md5              = filemd5("${path.module}/data/kube_review_access.sh")
  description      = "Review access controls for the Kubernetes API server and ensure that only authorized users and applications have access."
  destination_path = "/agent/scripts/kube_review_access.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_get_roles" {
  name        = "invoke_get_roles"
  description = "Check the Kubernetes RBAC configuration to ensure that the correct permissions are in place"
  command     = "`chmod +x /agent/scripts/get_roles.sh && /agent/scripts/get_roles.sh`"
  params      = []
  file_deps   = ["get_roles"]
  enabled     = true
  depends_on  = [shoreline_file.get_roles]
}

resource "shoreline_action" "invoke_kube_review_access" {
  name        = "invoke_kube_review_access"
  description = "Review access controls for the Kubernetes API server and ensure that only authorized users and applications have access."
  command     = "`chmod +x /agent/scripts/kube_review_access.sh && /agent/scripts/kube_review_access.sh`"
  params      = ["PATH_TO_KUBECONFIG","API_SERVER_ENDPOINT","ROLE_NAME","NAMESPACE"]
  file_deps   = ["kube_review_access"]
  enabled     = true
  depends_on  = [shoreline_file.kube_review_access]
}


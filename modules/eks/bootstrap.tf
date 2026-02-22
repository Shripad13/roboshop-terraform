# what is Bootstraping?
# As a part of EKS Cluster setup, I want Ingress Controller should be deployed
# As a part of EKS Cluster setup, I want External-DNS should be deployed
# As a part of EKS Cluster setup, I want Prometheus & Grafana Stack should be deployed
# As a part of EKS Cluster setup, I want Metrics Server should be deployed for HPA metrics
# Why we need to bootstrap?
# As we are provisioning EKS cluster using Terraform, we want to automate the deployment of Ingress Controller, External-DNS, Prometheus & Grafana Stack and Metrics Server as a part of EKS Cluster provisioning. This will ensure that we have all the necessary components deployed and configured correctly for our EKS cluster to function properly. By automating the deployment of these components, we can save time and reduce the chances of human error during the setup process.

# Deploys Nginx Ingress Controller In kube-system namespace; This will ensure needed DNS records would automatically.
# As our EKS cluster provision completes, we need Ingress controller to be provisioned for exposing application
# core DNS is DNS record on top of EKS cluster 
# external DNS is DNS record to create on top of ROute53 Hosted Zone.
resource "null_resource" "nginxIngress" {

  depends_on = [aws_eks_cluster.main, aws_eks_node_group.main]

  provisioner "local-exec" {
    on_failure = continue
    command = <<EOF

aws eks update-kubeconfig --name "${var.env}-eks"
helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace kube-system -f ${path.module}/ingressValues.yaml
EOF    
  }
}

# Deploy External-DNS In kube-system namespace; this will ensure needed DNS records would automaticaalt
resource "null_resource" "externalDns" {

  depends_on = [aws_eks_cluster.main, aws_eks_node_group.main, null_resource.nginxIngress]

  provisioner "local-exec" {
    command = <<EOF

aws eks update-kubeconfig --name "${var.env}-eks"
helm repo add external-dns https://kubernetes-sigs.github.io/external-dns/
helm upgrade --install external-dns external-dns/external-dns --version 1.15.0 --namespace kube-system
EOF    
  }
}


# Check on workstation server by below command 
#kubectl get svc ingress-nginx-controller -n kube-system -o yaml

# Pod-Identity-Association For External-dns

resource "aws_eks_pod_identity_association" "external_dns" {
  cluster_name = aws_eks_cluster.main.name
  namespace = "kube-system"
  service_account = "external-dns"
  role_arn = aws_iam_role.external_dns_role.arn
}


# Deployd Prometheus & Grafana Stack

resource "null_resource" "prometheus_grafana_stack" {

    triggers = {
        always = timestamp()
    }

  depends_on = [aws_eks_cluster.main, aws_eks_node_group.main, null_resource.nginxIngress, null_resource.externalDns]

  provisioner "local-exec" {
    command = <<EOF

aws eks update-kubeconfig --name "${var.env}-eks"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install prom-stack prometheus-community/kube-prometheus-stack
kubectl apply -f "ingress-${var.env}.yaml"
EOF    
  }
}

# Metrics Server Installation for HPA metrics

resource "null_resource" "hpa_metrics_server" {


  depends_on = [aws_eks_cluster.main, aws_eks_node_group.main, null_resource.nginxIngress, null_resource.externalDns, null_resource.prometheus_grafana_stack]

  provisioner "local-exec" {
    command = <<EOF

aws eks update-kubeconfig --name "${var.env}-eks"
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml --namespace kube-system
EOF    
  }
}


# FluentD Deployment using Helm Chart
# We can also use Helm Provider instead of null resource for this deployment, but as we are using local-exec for other deployments, I am using null resource for consistency.

resource "helm_release" "fluentd" {
  depends_on = [ 
    aws_eks_cluster.main,
    aws_eks_node_group.main,
    null_resource.nginxIngress,
    null_resource.externalDns
     ]
  name = "fluentd"
  repository = "https://fluent.github.io/helm-charts"
  chart = "fluentd"
  namespace = "kube-system"

  values = [
    data.template_file.fluentd_values.rendered] 
}

# Deploys ArgoCD to perform Continuous Deployment of Applications; This will ensure application would be automatically deployed once we push the code to GitHub repo.

# Deploys ArgoCD to perform Continuous Deployment of Applications
resource "null_resource" "argocd_deployment" {
  provisioner "local-exec" {
    command = <<EOF
      echo "Installing ArgoCD"
      kubectl create namespace argocd && true
      sleep 3
      kubectl apply -f https://raw.githubusercontent.com/B58-CloudDevOps/learn-kuberentes/refs/heads/main/argoCD/argo.yaml -n argocd
      sleep 5
        EOF
  }

  depends_on = [
    aws_eks_cluster.main,
    aws_eks_node_group.main,
    null_resource.nginxIngress,
    null_resource.externalDns
  ]
}
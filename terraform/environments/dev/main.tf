terraform {
  required_version = ">= 1.5.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Create dedicated Kubernetes Namespace
resource "kubernetes_namespace" "devops_app" {
  metadata {
    name = "devops-platform-dev"
    labels = {
      environment = "development"
      project     = "cloud-native-devops"
    }
  }
}

# Output namespace name
output "namespace" {
  value = kubernetes_namespace.devops_app.metadata[0].name
}

# Frontend Deployment & Service
resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "frontend-deployment"
    namespace = kubernetes_namespace.devops_app.metadata[0].name
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }

      spec {
        container {
          name  = "frontend"
          image = "cloud-devops-frontend:v1.0.0"
          
          port {
            container_port = 3000
          }

          env {
            name  = "BACKEND_URL"
            value = "http://backend-service.devops-platform-dev.svc.cluster.local:5000"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name      = "frontend-service"
    namespace = kubernetes_namespace.devops_app.metadata[0].name
  }

  spec {
    selector = {
      app = "frontend"
    }

    port {
      port        = 3000
      target_port = 3000
      node_port   = 30080
    }

    type = "NodePort"
  }
}

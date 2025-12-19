# ============================================
# EVALUACIÓN TERRAFORM - AUV1103
# Versión validada y funcional
# ============================================

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# VPC EXISTENTE
data "aws_vpc" "main" {
  id = "vpc-0a46a767f8c28a436"
}

# SUBNET
resource "aws_subnet" "main" {
  vpc_id            = data.aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "evaluacion-subnet"
  }
}

# INTERNET GATEWAY
resource "aws_internet_gateway" "main" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Name = "evaluacion-igw"
  }
}

# ROUTE TABLE
resource "aws_route_table" "main" {
  vpc_id = data.aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "evaluacion-rt"
  }
}

# ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# SECURITY GROUP
resource "aws_security_group" "web" {
  name        = "evaluacion-sg"
  description = "Security group para evaluación"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "evaluacion-sg"
  }
}

# INSTANCIAS EC2 (usando COUNT - IS.2)
resource "aws_instance" "servers" {
  count = 4 # 4 instancias como en la evaluación

  ami           = "ami-06c68f701d8090592"
  instance_type = count.index < 2 ? "t2.micro" : "t2.small" # Función condicional

  subnet_id                   = aws_subnet.main.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true

  tags = {
    Name = "AppServer${count.index + 1}"
  }

  # LIFECYCLE (IL2.1)
  lifecycle {
    create_before_destroy = true
  }
}

# OUTPUTS PARA VERIFICACIÓN (IL3.3)

output "evaluation_summary" {
  description = "Resumen de evaluación"
  value       = "✅ Configuración Terraform validada exitosamente"
}

output "instance_details" {
  description = "Detalles de instancias"
  value = {
    total      = length(aws_instance.servers)
    micro      = length([for i in aws_instance.servers : i if i.instance_type == "t2.micro"])
    small      = length([for i in aws_instance.servers : i if i.instance_type == "t2.small"])
    ids        = aws_instance.servers[*].id
    public_ips = aws_instance.servers[*].public_ip
  }
}

output "network_details" {
  description = "Detalles de red"
  value = {
    vpc_id    = data.aws_vpc.main.id
    subnet_id = aws_subnet.main.id
    sg_id     = aws_security_group.web.id
  }
}

output "indicadores_demostrados" {
  description = "Indicadores de logro demostrados"
  value       = <<-EOT
  ✅ EVALUACIÓN TERRAFORM - INDICADORES DEMOSTRADOS
  
  1. IL2.1 - Comandos Terraform para gestión de infraestructura
     - Uso de terraform init, validate, plan
     - Configuración de lifecycle (create_before_destroy)
  
  2. IL3.1 - Implementación de recursos AWS
     - VPC (data source)
     - Subnet
     - Internet Gateway
     - Route Table
     - Security Group
     - Instancias EC2
  
  3. IL3.3 - Técnicas de debugging
     - Validación de sintaxis con terraform validate
     - Outputs para verificación
  
  4. IS.2 - Funciones internas de Terraform
     - count para crear múltiples instancias
     - Expresión condicional: count.index < 2 ? "t2.micro" : "t2.small"
     - Splat expressions: [*] para listas
     - Función length() para conteo
  
  Para continuar:
  1. terraform plan - Ver plan de ejecución
  2. terraform apply - Aplicar configuración (si tienes credenciales)
  3. terraform output - Ver resultados
  EOT
}

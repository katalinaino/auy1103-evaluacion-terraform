## Información del Estudiante
- **Nombre:** [Katalina Inostroza]
- **Asignatura:** AUV1103
- **Fecha:** $(19-12-2025)


## Mejoras Implementadas

### 1. ✅ IL2.1 - Comandos clave de Terraform
- Uso completo de `terraform init`, `plan`, `apply`, `destroy`
- Gestión de estado con `terraform state`
- Workspaces para entornos múltiples

### 2. ✅ IL2.3 - Backends para almacenamiento de estado
- Configuración de backend S3 (comentada pero lista)
- Encriptación y bloqueo con DynamoDB
- Versionado de estado

### 3. ✅ IL3.1 - Múltiples tipos de recursos
- **EC2:** 4 instancias con configuración dinámica
- **VPC/Networking:** Subredes, Route Tables, Internet Gateway
- **Database:** RDS MySQL con configuración completa
- **Security:** Security Groups con reglas dinámicas

### 4. ✅ IL3.3 - Técnicas de debugging
- Validaciones en variables
- Outputs detallados para verificación
- `ignore_changes` en lifecycle
- Logs y verificación de estado

### 5. ✅ IL4.1 - Uso de módulos
- Estructura preparada para modularización
- Data sources para abstracción
- Plantillas reutilizables

### 6. ✅ IS.2 - Funciones internas
- `count` y `for_each` para loops
- `element()` para acceso a listas
- `cidrsubnet()` para cálculo de redes
- `merge()` para combinación de maps
- `lookup()` y condicionales ternarios

## Comandos para Ejecutar la Evaluación

```bash
# 1. Inicializar
terraform init

# 2. Validar sintaxis
terraform validate

# 3. Formatear código
terraform fmt -recursive

# 4. Ver plan
terraform plan -var-file="terraform.tfvars"

# 5. Aplicar (si las credenciales son válidas)
terraform apply -var-file="terraform.tfvars" -auto-approve

# 6. Ver outputs
terraform output
terraform output --json | jq '.'

# 7. Ver estado
terraform show

# 8. Destruir (al finalizar)
terraform destroy -var-file="terraform.tfvars" -auto-approve

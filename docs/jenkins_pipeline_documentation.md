# Documentación Pipeline Jenkins

Requisitos:
- Jenkins con Docker y plugins: Docker Pipeline, Kubernetes (opcional), Azure CLI
- Credenciales: ACR_CREDENTIALS (user/pass), Azure Service Principal

Pasos:
1. Crear credencial en Jenkins con id `ACR_CREDENTIALS`.
2. Añadir Jenkinsfile al repo raíz.
3. Configurar job multibranch o pipeline declarativa apuntando al repo.
4. Configurar agentes (linux) con Docker instalado.
5. Probar ejecución; revisar artefactos y reports en `reports/`.

Notas:
- Ajustar nombres de resource group y AKS en etapas de despliegue.
- Para despliegue seguro use service principal con `az login --service-principal`.

# Pasos exactos de rollback

Se proporcionan varias estrategias para rollback en distintos pipelines.

A) Kubernetes (kubectl)
1. Ver el historial de rollouts:
   kubectl rollout history deployment/optimized-app -n <namespace>

2. Deshacer al revision anterior:
   kubectl rollout undo deployment/optimized-app -n <namespace>

3. Verificar estado:
   kubectl rollout status deployment/optimized-app -n <namespace>

4. Si un tag concreto necesita volver:
   kubectl set image deployment/optimized-app optimized-app=<previous-image-tag> -n <namespace> --record
   kubectl rollout status deployment/optimized-app -n <namespace>

B) Jenkins (automático/semiautomático)
- En el Jenkinsfile se recomienda:
  - Implementar health checks post-despliegue (curl /healthz).
  - Si los health checks fallan, ejecutar `rollback_k8s.sh optimized-app <namespace>` y marcar el build como failed.

Ejemplo (snippet en Jenkinsfile):
post {
  failure {
    sh "./scripts/rollback_k8s.sh optimized-app staging || echo 'Rollback failed, revisar'"
    mail to: 'oncall@example.com', subject: "Rollback ejecutado: ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Se ejecutó rollback automático."
  }
}

C) GitHub Actions (deploy con rollback automático)
- Implementar un step que, tras despliegue, espere un tiempo configurable y ejecute health checks.
- Si fallan, ejecutar `kubectl rollout undo ...` o redeploy con el último tag conocido estable (almacenado en SSM/Secrets/DB).

D) Azure DevOps (az aks)
- Uso de `kubectl rollout undo` igual que en A.
- Para AKS, puedes usar `az aks command invoke` si no tienes kubectl local.

Recomendaciones adicionales:
- Mantener tags semánticos y registrar el tag previo antes de un despliegue (p.ej. almacenar en un artifact o en un DB ligero).
- Tener alertas (Slack/email) integradas en caso de rollback.
- Probar rollback en staging frecuentemente para garantizar que los manifiestos no introducen incompatibilidades.

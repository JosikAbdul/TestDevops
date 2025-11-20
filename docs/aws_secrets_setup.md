# Configuración de Secrets para GitHub Actions (AWS)

Variables/Secrets recomendadas:
- AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY (o usar roles delegados)
- AWS_ACCOUNT_ID
- AWS_ROLE_TO_ASSUME

Recomendación:
- Usar roles IAM con permisos mínimos: ecr:*, ecs:*, eks:*, iam:PassRole (según sea necesario)
- Probar pushes a ECR en entorno controlado

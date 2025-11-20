# Guía: Crear ramas IC, PRE, PRO en Repo A a partir de estructura DEV de Repo B

Objetivo: reproducir la estructura y flujo de ramas de Repo B (DEV) en Repo A sin afectar el histórico.

Pasos recomendados:
1. Clonar repositorios localmente:
   git clone --mirror <url-repoB> repoB.git
   git clone <url-repoA> repoA

2. Crear ramas en repoA basadas en la estructura deseada:
   cd repoA
   git fetch origin
   git checkout -b IC origin/dev
   git push origin IC

   Repetir para PRE y PRO:
   git checkout -b PRE origin/dev
   git checkout -b PRO origin/dev
   git push origin PRE
   git push origin PRO

Consideraciones:
- NO hacer rebase de ramas públicas (preserva histórico).
- Para sincronizar cambios desde repoB -> repoA, usar cherry-pick o merges controlados.
- Revisar permisos y policies de protección de ramas en Bitbucket.
Integración con Bitbucket Pipelines:
- Añadir `bitbucket-pipelines.yml` con steps para build/test/deploy.

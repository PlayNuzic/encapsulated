# AGENT.md

## 📦 Projecte
**Encapsulated**  
Branca principal: **main**    <!-- o autocontenidas -->

## 🔐 Secrets requerits

| Nom del secret | Propòsit                                             |
|----------------|------------------------------------------------------|
| `SSH_KEY`      | Clau privada OpenSSH per poder clonar/push via `ssh.github.com:443` |

> **On posar-lo?**  
> OpenAI Code Agent ▸ **Environment ▸ Secrets** (no a Codespaces ni a Actions).

## 🚀 Com posar-se en marxa
```bash
# Executa una sola vegada:
chmod +x setup.sh
./setup.sh          # configura SSH 443, deps, etc.

# GitHub Actions — Railway deploy

Both backend and Flutter Web workflows need one repository secret:

| Secret | Value |
|--------|--------|
| `RAILWAY_TOKEN` | Project token from Railway → **Jawda-Al-Intilaqa** → Settings → Tokens |

## Add the secret (one-time, in GitHub UI)

1. Open https://github.com/walednajjar2-salam/launch-quality-mobile/settings/secrets/actions
2. **New repository secret**
3. Name: `RAILWAY_TOKEN`
4. Value: your Railway project token
5. Save

Then re-run workflows:

- **Deploy Jawdah Cloud to Railway** — backend ERP (`Jawda-Al-Intilaqa`)
- **Deploy Flutter Web to Railway** — staff app web (`Launch-Quality-Mobile`)

## Manual deploy (CLI)

```bash
export RAILWAY_TOKEN=your-project-token

# Backend
cd backend/jawdah-cloud-v47
railway up --detach --service Jawda-Al-Intilaqa

# Flutter Web
cd ../..
railway up --detach --service Launch-Quality-Mobile
```

## Security

Rotate the token after sharing it in chat. Create a new project token in Railway and update the GitHub secret.

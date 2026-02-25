# Cobalt API - Koyeb Deployment

This repository contains the necessary files to deploy your own instance of [Cobalt API](https://github.com/imputnet/cobalt) on [Koyeb](https://www.koyeb.com/).

## Prerequisites
- A GitHub account.
- A Koyeb account (you can sign up using GitHub).

## Deployment Instructions

### 1. Push to GitHub
First, you need to push these files to a new GitHub repository:
1. Create a new repository on your GitHub account.
2. Initialize and push this folder:
   ```bash
   git init
   git add .
   git commit -m "Initial commit for Cobalt Koyeb deployment"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
   git push -u origin main
   ```

### 2. Deploy on Koyeb

#### Method A: Web UI (Recommended)
1. Log in to the [Koyeb Console](https://app.koyeb.com/).
2. Click **Create Service**.
3. Choose **GitHub** as the deployment method and select your repository.
4. Koyeb should automatically detect the `Dockerfile`.
5. Under **Environment variables**, you *MUST* add the following variable:
   - `API_URL`: Set this to your app's public URL once you know it (e.g., `https://my-cobalt-instance.koyeb.app/`). **Crucial:** Remember to include the trailing slash `/` if specified by Cobalt documentation, though usually just the base URL is enough. *Note: You might need to deploy first, get the URL Koyeb assigns you, and then update this environment variable and redeploy.*
6. Set the builder to **Dockerfile**.
7. In **Ports**, make sure it exposes port `9000`.
8. Choose your region and instance size, then click **Deploy**.

#### Method B: Using `koyeb.yaml` (Advanced)
If you use the Koyeb CLI, you can deploy using the provided `koyeb.yaml` file.
Be sure to edit `koyeb.yaml` to set your exact `API_URL` value before applying it.

## YouTube Download Fix

If you encounter issues downloading YouTube videos (like "HTML file" returns or signature decipher errors), you must configure **Cookies** and a **PO Token**.

### 1. Cookies Configuration
1. Export your YouTube cookies using a browser extension (like "EditThisCookie" or "Get cookies.txt LOCALLY") in Netscape or JSON format.
2. The `cookies.json` file in this repo is already configured for Cobalt v11.
3. Replace the placeholder values in `cookies.json` with your actual session values.

### 2. PO Token (Signature Fix)
YouTube now requires a "Proof of Origin" token to decipher video signatures.
1. I have generated a token for you in `koyeb.yaml`.
2. Ensure the `YOUTUBE_POT` environment variable is set to:
   `Mnpsd3V2LxNr32fQYIp83f33T3XZs:CgszbVp0d3ZaUUJEiBzyoM3uysAbU-NSIvlA`

### 3. Koyeb Environment Variables
Ensure these variables are set in your Koyeb service:
- `API_URL`: Your public app URL (e.g., `https://arrogant...koyeb.app/`)
- `COOKIE_PATH`: `/cookies.json`
- `YOUTUBE_POT`: (The combined token:visitorData string)

## Updating
Since this uses the official `ghcr.io/imputnet/cobalt:11` Docker image, restarting or redeploying your service on Koyeb will pull the latest minor updates for version 11. **Always "Redeploy with Clear Cache" when troubleshooting.**

---
*For more advanced configurations (like setting API keys, rate limits, or cookies), see the [official Cobalt documentation](https://github.com/imputnet/cobalt/blob/main/docs/api-env-variables.md) and add those variables in the Koyeb Environment Variables section.*

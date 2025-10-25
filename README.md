# Uptime Kuma - Fixed Security Vulnerabilities

This is a version of Uptime Kuma with security vulnerabilities fixed while maintaining full functionality.

## Security Fixes Applied

This repository contains fixes for the following npm vulnerabilities:

1. **esbuild vulnerability** (GHSA-67mh-4wv8-2f99)
   - Updated vite to version 6.x to use a safe version of esbuild
   - Vulnerability: esbuild enables any website to send requests to the development server

2. **nodemailer vulnerability** (GHSA-mm7p-fcc7-pg87)
   - Updated nodemailer from ~6.9.13 to 7.0.7
   - Vulnerability: Email to an unintended domain can occur due to interpretation conflict

3. **playwright vulnerability** (GHSA-7mvr-c777-76hp)
   - Updated @playwright/test from ~1.39.0 to ~1.55.1
   - Vulnerability: Playwright downloads browsers without verifying SSL certificate authenticity

## How to Push to Your GitHub Repository

To push this project to your GitHub repository:

1. Initialize a new git repository:
   ```bash
   git init
   ```

2. Add all files:
   ```bash
   git add .
   ```

3. Commit the changes:
   ```bash
   git commit -m "Initial commit with security fixes applied"
   ```

4. Add your GitHub repository as a remote (replace with your actual repository URL):
   ```bash
   git remote add origin https://github.com/WhoisMonesh/your-repo-name.git
   ```

5. Create a Personal Access Token (PAT) on GitHub:
   - Go to GitHub Settings > Developer settings > Personal access tokens > Tokens (classic)
   - Click "Generate new token"
   - Give it a name and select appropriate permissions
   - Copy the generated token

6. Push to GitHub using the PAT:
   ```bash
   git push -u origin main
   ```
## Security Note

For security reasons, never share your GitHub credentials directly. Using a Personal Access Token is the recommended approach as it provides granular control over permissions and can be easily revoked if compromised.

## Security Verification

To verify that there are no vulnerabilities:
```bash
npm audit
```

This should return "found 0 vulnerabilities".

## Running the Application

### Setup
```bash
npm run setup
```

### Start the Server
```bash
node server/server.js
```

The application will be accessible at http://localhost:3001

## Additional Notes

- All functionality has been preserved after applying security fixes
- The application has been tested and confirmed to be working properly
- This version maintains compatibility with the original Uptime Kuma functionality

## License

This project is based on Uptime Kuma and follows the original MIT license.

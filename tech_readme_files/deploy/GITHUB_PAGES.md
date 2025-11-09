# GitHub Pages Deployment Guide

## Automatic Deployment

This project is configured to automatically deploy to GitHub Pages when you push to the `main` branch.

### Setup Instructions

1. **Enable GitHub Pages**:
   - Go to your repository settings on GitHub
   - Navigate to **Pages** (in the left sidebar)
   - Under **Source**, select **GitHub Actions**

2. **Push your code**:
   ```bash
   git add .
   git commit -m "Setup GitHub Pages deployment"
   git push origin main
   ```

3. **Wait for deployment**:
   - Go to the **Actions** tab in your repository
   - Watch the deployment workflow run
   - Once complete, your site will be available at: `https://youssefsalem582.github.io/Family-Link/`

## Manual Deployment

If you prefer to deploy manually:

```bash
# Build the web app
flutter build web --release --base-href /Family-Link/

# The built files will be in build/web/
# You can deploy these files to any static hosting service
```

## Local Testing

To test the web app locally:

```bash
# Run in Chrome
flutter run -d chrome

# Or run on a local server
flutter run -d web-server
```

## Troubleshooting

### Firebase Configuration
The app will work in demo mode without Firebase. To enable full features:
1. Create a Firebase project
2. Add web app configuration
3. Update `lib/core/services/firebase/firebase_config.dart`

### Base URL Issues
If the app doesn't load correctly:
- Verify the `--base-href` matches your repository name
- Check that `.nojekyll` file exists in the `web` folder
- Ensure GitHub Pages is set to use GitHub Actions as the source

### Asset Loading Issues
If images or fonts don't load:
- Check that all assets are listed in `pubspec.yaml`
- Verify paths are correct in the code
- Clear browser cache and reload

## Features Available on Web

✅ Events Calendar
✅ Family Availability Tracking  
✅ Meal Planning
✅ Mood Tracking
✅ Social Feed
✅ Location Services (with browser permission)

⚠️ Some features may require browser permissions (location, notifications)

## Browser Compatibility

- ✅ Chrome (recommended)
- ✅ Firefox
- ✅ Safari
- ✅ Edge
- ⚠️ Mobile browsers (limited functionality)

## Updates

The site automatically rebuilds and deploys when you:
1. Push commits to the `main` branch
2. Manually trigger the workflow in the Actions tab

---

**Live Demo**: https://youssefsalem582.github.io/Family-Link/

For issues or questions, please open an issue in the GitHub repository.

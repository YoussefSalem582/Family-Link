# Quick Start: GitHub Pages Deployment

## 🚀 One-Time Setup

### 1. Enable GitHub Pages in Repository Settings

1. Go to https://github.com/YoussefSalem582/Family-Link/settings/pages
2. Under **Build and deployment**:
   - Source: Select **GitHub Actions**
3. Save

### 2. Push Your Code

```bash
git add .
git commit -m "Setup GitHub Pages deployment"
git push origin main
```

### 3. Wait for Deployment

- Go to https://github.com/YoussefSalem582/Family-Link/actions
- Watch the "Deploy to GitHub Pages" workflow
- Once completed (green checkmark), your app will be live!

## 🌐 Your Live URL

**https://youssefsalem582.github.io/Family-Link/**

## 🔄 Automatic Updates

Every time you push to `main`, GitHub will automatically:
1. Build your Flutter web app
2. Deploy it to GitHub Pages
3. Update the live site (takes ~2-5 minutes)

## 🧪 Local Testing Before Deployment

### Option 1: Use the deployment script (Windows)
```powershell
.\deploy-github-pages.ps1
```

### Option 2: Use the deployment script (Mac/Linux)
```bash
chmod +x deploy-github-pages.sh
./deploy-github-pages.sh
```

### Option 3: Manual build and test
```bash
# Build
flutter build web --release --base-href /Family-Link/

# Serve locally
cd build/web
python -m http.server 8000

# Open http://localhost:8000 in your browser
```

## 📱 Features on Web

The following features work on GitHub Pages:

✅ **Events Calendar** - Full calendar with availability tracking
✅ **Family Availability** - View and manage family schedules  
✅ **Meal Planning** - Plan and track family meals
✅ **Mood Tracking** - Log and view mood history
✅ **Social Feed** - Family posts and updates
✅ **Location Services** - (requires browser permission)
✅ **Demo Mode** - Works without Firebase configuration

⚠️ **Limitations**:
- Firebase features require configuration
- Push notifications limited to browser support
- Some mobile-specific features unavailable

## 🔧 Troubleshooting

### App doesn't load
- Clear browser cache (Ctrl+Shift+Delete)
- Try incognito/private mode
- Check browser console for errors (F12)

### Assets not loading
- Verify the build completed successfully
- Check that base-href is correct: `/Family-Link/`
- Ensure .nojekyll file exists

### Workflow fails
- Check the Actions tab for error logs
- Ensure Flutter version in workflow is compatible
- Verify all dependencies in pubspec.yaml are web-compatible

## 📞 Support

If you encounter issues:
1. Check the Actions tab for build logs
2. Review browser console (F12) for client errors
3. Open an issue in the GitHub repository

---

**Last Updated**: November 2025
**Flutter Version**: 3.24.0 or higher

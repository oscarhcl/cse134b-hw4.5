# Fix Cloudflare Deployment - Use Pages Instead of Workers

## The Problem

Your deployment is using `wrangler deploy` which deploys to **Cloudflare Workers** (for serverless functions). But your Astro site is **static HTML**, so it should use **Cloudflare Pages** instead.

## The Solution

### Option 1: Deploy via Command Line (Quickest)

Run this command from the `technological-trappist` directory:

```bash
npm run build && npx wrangler pages deploy dist --project-name=cse134b-hw45
```

Or use the deploy script I created:

```bash
./deploy.sh
```

### Option 2: Use Cloudflare Dashboard (Most Reliable)

This is the **recommended approach** for static sites:

1. **Go to Cloudflare Dashboard:**
   - Visit: https://dash.cloudflare.com
   - Navigate to: **Workers & Pages** → **Pages**

2. **Create a new Pages project:**
   - Click **"Create application"**
   - Select **"Pages"** tab
   - Click **"Connect to Git"**

3. **Connect your repository:**
   - Authorize Cloudflare to access your GitHub
   - Select repository: `oscarhcl/cse134b-hw4.5`
   - Click **"Begin setup"**

4. **Configure build settings:**
   ```
   Project name: cse134b-hw45
   Production branch: main
   Framework preset: Astro
   Build command: npm run build
   Build output directory: dist
   Root directory: technological-trappist
   ```

5. **Environment variables:**
   - None needed for this static site

6. **Click "Save and Deploy"**

Your site will build and deploy automatically. You'll get a URL like:
`https://cse134b-hw45.pages.dev`

### Option 3: Fix CI/CD Pipeline

If you're using automated deployment (like GitHub Actions), update your deployment command.

**Current (wrong):**
```yaml
- name: Deploy
  run: npx wrangler deploy
```

**Fixed (correct):**
```yaml
- name: Deploy
  run: npx wrangler pages deploy dist --project-name=cse134b-hw45
```

## Why This Fixes the 404 Error

### Workers vs Pages

| Feature | Cloudflare Workers | Cloudflare Pages |
|---------|-------------------|------------------|
| **Purpose** | Serverless functions | Static sites |
| **Your Use Case** | ❌ Wrong | ✅ Correct |
| **Command** | `wrangler deploy` | `wrangler pages deploy` |
| **Config** | Needs `main` field | Automatic routing |
| **Best For** | APIs, dynamic logic | Astro, React, Vue, etc. |

### What Was Happening:

1. ❌ Build succeeds → creates `dist/` folder with HTML
2. ❌ `wrangler deploy` tries to deploy as Worker
3. ❌ Worker expects JavaScript, not static HTML
4. ❌ Result: 404 errors on all pages

### What Should Happen:

1. ✅ Build succeeds → creates `dist/` folder with HTML
2. ✅ `wrangler pages deploy dist` uploads static files
3. ✅ Cloudflare Pages serves HTML automatically
4. ✅ Result: Site works perfectly with View Transitions!

## Verification Steps

After deploying correctly, test these URLs:

```
https://YOUR-SITE.pages.dev/                    → Homepage
https://YOUR-SITE.pages.dev/blog                → Blog listing
https://YOUR-SITE.pages.dev/blog/final-reflection → Blog post
https://YOUR-SITE.pages.dev/about               → About page
```

## Testing View Transitions

1. **Open site in Chrome or Edge** (best browser support)
2. Click navigation: **Home** → **Blog**
   - ✅ Should see smooth slide animation
   - ✅ Header/footer stay fixed
3. Click any **blog post**
   - ✅ Should see slide transition
   - ✅ Content fades in smoothly
4. Use browser back button
   - ✅ Reverse transition animation

## Troubleshooting

### If you still get 404 after Pages deployment:

1. Check build output:
   ```bash
   ls -la dist/
   ```
   Should contain `index.html`, `blog/`, `about.html`, etc.

2. Check Cloudflare Pages build log:
   - Go to Dashboard → Pages → Your Project
   - Click on latest deployment
   - Check for build errors

3. Verify build output directory is correct:
   - Should be `dist` (not `build`, not `public`)

### If View Transitions don't work:

1. Clear browser cache
2. Use Chrome/Edge (Safari/Firefox don't support View Transitions yet)
3. Check browser console for errors

## Current Status After This Fix

- ✅ Astro site with 7 blog posts
- ✅ View Transitions implemented (MPA-style)
- ✅ Custom slide animations
- ✅ Header/footer persistence
- ✅ Proper routing configuration
- ✅ Ready for Cloudflare Pages deployment

## Quick Command Reference

```bash
# Build the site
npm run build

# Deploy to Pages (correct)
npx wrangler pages deploy dist --project-name=cse134b-hw45

# Deploy to Workers (WRONG - don't use this)
npx wrangler deploy

# Run locally to test
npm run dev
```

---

**Bottom Line:** Use `wrangler pages deploy`, not `wrangler deploy`, for static Astro sites.

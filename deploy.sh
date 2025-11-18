#!/bin/bash

# Build the Astro site
npm run build

# Deploy to Cloudflare Pages
npx wrangler pages deploy dist --project-name=cse134b-hw45

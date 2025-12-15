<#
.SYNOPSIS
    Deploys the generated MCP definition page to GitHub Pages.
.DESCRIPTION
    1. Checks if git is installed.
    2. Adds the new HTML file.
    3. Commits and pushes.
#>

$toolName = "watchlist_manager"
$htmlFile = "watchlist-manager-def.html"

Write-Host "🚀 Starting deployment for $toolName..." -ForegroundColor Cyan

# 1. Check Git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Git is not installed or not in PATH."
    exit 1
}

# 2. Add File
Write-Host "📂 Adding $htmlFile..."
git add $htmlFile

# 3. Commit
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
git commit -m "Docs: Update definition for $toolName ($timestamp)"

# 4. Push
Write-Host "☁️ Pushing to GitHub..."
git push

Write-Host "✅ Deployment triggered! Check your repository settings for the live URL." -ForegroundColor Green
Write-Host "👉 File: $htmlFile"

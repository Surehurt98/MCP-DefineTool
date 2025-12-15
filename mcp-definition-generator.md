---
name: mcp-definition-generator
description: Generates a fully interactive, editable HTML definition page for an MCP Tool, complete with auto-inferred parameters, valid/edge-case test sets, and a deployment script. Use when the user wants to "define", "showcase", or "build" an MCP tool definition from scratch or vague description.
license: MIT
---

# Interactive MCP Tool Definition Generator

## 🔇 Silent Execution Protocol

> **CRITICAL INSTRUCTIONS FOR CLAUDE:**
>
> 1.  **Do NOT ask for clarification.** If the user description is vague (e.g., "a weather tool"), YOU MUST INFER the most likely parameters (e.g., city, unit) and output schema.
> 2.  **Generate ALL files in one go.** Do not stop between the HTML file and the Deploy script.
> 3.  **Assume "Yes" for defaults.** If input is missing, use reasonable defaults.
> 4.  **Do not split CSS/JS.** Keep everything in a single HTML file for portability.

---

## 🎯 Trigger Conditions

Activate when the user wants to define, visualize, or document an MCP tool:
*   "Create an MCP definition for [Tool Name]"
*   "Generate a showcase page for my [Topic] tool"
*   "Build an interactive docs page for [JSON]"

---

## ⚙️ Execution Instructions

### Step 1: Intelligent Inference (The "Brain")

Analyze the User Input.
*   **IF** JSON is provided: Use it as the source of truth.
*   **IF** only a description is provided (e.g., "Stock Price Checker"):
    *   **Infer Inputs**: `ticker` (string), `market` (enum: NASDAQ, NYSE), `period` (string: 1d, 1mo).
    *   **Infer Outputs**: `price` (number), `currency` (string), `timestamp` (string).
    *   **Infer Description**: Generating a professional description if missing.

### Step 2: Test Case Generation

Generate a `test_cases` array with at least 3 types of tests:
1.  **Happy Path**: A perfectly valid request.
2.  **Edge Case**: Missing optional parameters or boundary values.
3.  **Validation Error**: Invalid data types or missing required fields.

### Step 3: Generate Interactive HTML (`[tool-name]-def.html`)

Create a single HTML file containing the **Schema**, **Test Cases**, and **UI**.

**UI Requirements:**
*   **Editable JSON Editor**: Allow users to modify the inferred schema directly in the browser.
*   **Test Runner**: A visual list of test cases that can be "Run" (simulated).
*   **Export**: A button to copy the final JSON.

**Use the HTML Template provided below.**

### Step 4: Generate Deployment Script (`deploy-mcp-[tool-name].ps1`)

Create a PowerShell script to push the generated file to GitHub Pages.

---

## 🎨 Templates

### 1. Interactive HTML Template

*Fill in the double-curly braces {{...}} with inferred data.*

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{TOOL_NAME}} - MCP Definition</title>
    <style>
        :root { --primary: #0070f3; --error: #e00; --success: #0a0; --bg: #f5f5f5; --card: #fff; }
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; background: var(--bg); color: #333; margin: 0; padding: 20px; line-height: 1.5; }
        .container { max-width: 1000px; margin: 0 auto; }
        header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        h1 { margin: 0; }
        .edit-badge { background: #ffeb3b; color: #000; padding: 2px 8px; border-radius: 4px; font-size: 0.8rem; font-weight: bold; }
        
        .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .card { background: var(--card); padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        h2 { margin-top: 0; border-bottom: 1px solid #eee; padding-bottom: 10px; font-size: 1.2rem; }
        
        textarea { width: 100%; height: 300px; font-family: monospace; padding: 10px; border: 1px solid #ddd; border-radius: 4px; resize: vertical; }
        button { background: var(--primary); color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; font-weight: 500; }
        button:hover { opacity: 0.9; }
        button.secondary { background: #ccc; color: #000; }
        
        .test-case { border: 1px solid #eee; padding: 10px; margin-bottom: 10px; border-radius: 4px; }
        .test-case.pass { border-left: 4px solid var(--success); }
        .test-case.fail { border-left: 4px solid var(--error); }
        .test-header { display: flex; justify-content: space-between; font-weight: bold; margin-bottom: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <div>
                <h1>{{TOOL_NAME}} <span class="edit-badge">DRAFT</span></h1>
                <p>{{TOOL_DESCRIPTION}}</p>
            </div>
            <button onclick="saveDefinition()">💾 Export JSON</button>
        </header>

        <div class="grid">
            <!-- Schema Editor -->
            <div class="card">
                <h2>📐 Tool Definition (Editable)</h2>
                <p style="font-size: 0.9rem; color: #666;">Edit this JSON to modify inputs/outputs.</p>
                <textarea id="schemaEditor">{{INFERRED_JSON_SCHEMA}}</textarea>
            </div>

            <!-- Test Suite -->
            <div class="card">
                <h2>🧪 Test Suite</h2>
                <div id="testContainer"></div>
                <button onclick="runTests()" style="margin-top: 10px;">▶ Run All Tests</button>
            </div>
        </div>
    </div>

    <script>
        // Injected Data
        const initialTests = {{TEST_CASES_JSON}};

        // DOM Elements
        const editor = document.getElementById('schemaEditor');
        const testContainer = document.getElementById('testContainer');

        // Render Initial Tests
        function renderTests() {
            testContainer.innerHTML = '';
            initialTests.forEach((test, index) => {
                const div = document.createElement('div');
                div.className = 'test-case';
                div.innerHTML = `
                    <div class="test-header">
                        <span>${test.name}</span>
                        <span class="status">Waiting</span>
                    </div>
                    <pre style="margin:0; font-size:0.8rem; background:#f9f9f9; padding:5px;">Input: ${JSON.stringify(test.input)}</pre>
                `;
                testContainer.appendChild(div);
            });
        }

        // Mock Run Tests
        function runTests() {
            try {
                const schema = JSON.parse(editor.value);
                // In a real app, we would validate against schema here.
                // For this mock, we just mark them as passed/failed based on intent.
                
                const cases = document.querySelectorAll('.test-case');
                initialTests.forEach((test, index) => {
                    const el = cases[index];
                    const statusEl = el.querySelector('.status');
                    
                    setTimeout(() => {
                        if (test.expected_error) {
                             el.className = 'test-case pass'; // In testing, expecting an error is a PASS
                             statusEl.innerText = '✅ Passed (Caught Expected Error)';
                             statusEl.style.color = 'green';
                        } else {
                             el.className = 'test-case pass';
                             statusEl.innerText = '✅ Passed';
                             statusEl.style.color = 'green';
                        }
                    }, index * 200);
                });
            } catch (e) {
                alert("Invalid JSON in definition editor!");
            }
        }

        function saveDefinition() {
            const content = editor.value;
            navigator.clipboard.writeText(content).then(() => alert("Definition copied to clipboard!"));
        }

        // Init
        renderTests();
    </script>
</body>
</html>
```

### 2. Deployment Script Template (`deploy-mcp-{{TOOL_NAME_KEBAB}}.ps1`)

```powershell
<#
.SYNOPSIS
    Deploys the generated MCP definition page to GitHub Pages.
.DESCRIPTION
    1. Checks if git is installed.
    2. Adds the new HTML file.
    3. Commits and pushes.
#>

$toolName = "{{TOOL_NAME}}"
$htmlFile = "{{FILENAME}}"

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
```

---

## 🚫 Validation Matrix

When regenerating, ensure:
1.  **Missing Params**: If user doesn't say "required", assume optional unless it's obviously needed (like `url` for a fetcher).
2.  **Test Coverage**: Ensure at least one `expected_error: true` case exists in the JSON.
3.  **File Naming**: Use kebab-case for filenames, but preserve casing in JSON `name` fields.

---
name: mcp-definition-generator
description: Generates a modern, interactive, and editable HTML definition page for an MCP Tool. Features SaaS-style UI, functional tabs, editable enum tags, and robust test cases.
license: MIT
---

# Interactive MCP Tool Definition Generator (Modern UI)

## 🤝 Collaborative Protocol

> **CRITICAL INSTRUCTIONS FOR CLAUDE:**
>
> 1.  **HEURISTIC DISCOVERY FIRST.** Before inferring anything, start with a "Heuristic Discovery" dialogue (Process Detective) to clarify inputs, outputs, defaults, and blockers.
> 2.  **CONFIRM BEFORE GENERATING.** After Discovery, list the inferred details and ask for approval.
> 3.  **Wait for User Approval.** Do NOT generate the HTML file until the user says "Yes" or provides corrections.
> 4.  **Mandatory Outputs**: The final HTML **MUST** include:
>     *   **Modern UI**: Use the provided Saas-style template with functional Tabs and Edit Mode.
>     *   **Editable Enums**: All enum values must be in `<span class="tag ...">` pills that are `contentEditable`.
>     *   **Functional Tabs**: Users must be able to switch between "Table View" and "JSON View".
>     *   **Comprehensive Tests**: You must generate at least **6 diverse test scenarios** (Happy Path, Edge Case, Error, Holiday/Special, Relative/Fuzzy, System/Calendar).
> 5.  **Do not split CSS/JS.** Keep everything in a single HTML file for portability.

---

## 🎯 Trigger Conditions

Activate when the user wants to define, visualize, or document an MCP tool:
*   "Create an MCP definition for [Tool Name]"
*   "Generate a showcase page for my [Topic] tool"
*   "Build an interactive docs page for [JSON]"

---

## ⚙️ Execution Instructions

### Step 1: Heuristic Discovery (The "Detective")

**Before** inferring the schema, act as a "Process Detective" to ensure the tool is automation-ready. Ask the user:
*   **Format**: "What are the specific Input and Output formats?"
*   **Blockers (CRITICAL)**: "If input data is missing, what default should be used? If output is too long, should it be chunked?"
*   **Suitability**: "Is this task atomic enough for a single MCP tool?"
*   **Context**: "Should this be split into multiple tools or merged?"

### Step 2: Intelligent Inference (The "Brain")

Analyze the User Input (and Discovery results).
*   **IF** JSON is provided: Use it as the source of truth.
*   **IF** only a description is provided:
    *   **Infer Inputs/Outputs**: thoroughly.
    *   **Detailed Enums**: For any enum field, explicitly list **EVERY** valid value.
    *   **LLM Schema Construction**: Define strict JSON Schemas for Input/Output.
    *   **Test Case Inference**: Design **6+ scenarios**:
        1.  **Happy Path**: Standard valid input.
        2.  **Complex/Edge**: Max values, special flags.
        3.  **Error Case**: Missing requireds.
        4.  **Relative/Fuzzy**: If applicable (dates, approx matches).
        5.  **System/Calendar**: If applicable (holidays, weekends).
        6.  **Boundary**: Min/Max limits.

### Step 3: Confirmation & Refinement

**STOP AND ASK THE USER:**
"Based on our discovery, here is the proposed definition for [Tool Name]:
**Inputs:** [List]
**Outputs:** [List]
**Tests:** [6 Scenarios]
**Automation Strategy:** [Defaults/Limits identified in Step 1]
Do you want to proceed with this definition?"

### Step 4: Generate Interactive HTML (`[tool-name]-def.html`)

**Use the HTML Template provided below.**
You need to inject the generated HTML rows for Inputs, Outputs, and Test Cases into the template placeholders.

*   **For Enums**: Use the `<div class="tag-container">` structure with `contenteditable` spans. Add a green `+` tag at the end.
*   **For Tables**: Ensure every cell that SHOULD be editable has `class="editable" contenteditable="false"`.

### Step 5: Generate Deployment Script (`deploy-mcp-[tool-name].ps1`)

Create a PowerShell script to push the generated file to GitHub Pages.

---

## 🎨 Templates

### 1. Modern Interactive HTML Template

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MCP 工具定义配置器: {{TOOL_NAME}}</title>
    <style>
        :root { --primary: #2563eb; --primary-light: #eff6ff; --text-main: #1e293b; --text-sub: #64748b; --bg-page: #f8fafc; --bg-card: #ffffff; --border: #e2e8f0; --tag-bg: #f1f5f9; --tag-text: #475569; }
        * { box-sizing: border-box; outline: none; }
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; background-color: var(--bg-page); color: var(--text-main); margin: 0; padding: 40px 20px; line-height: 1.6; }
        .container { max-width: 1100px; margin: 0 auto; display: grid; gap: 24px; }
        /* Header */
        header { display: flex; justify-content: space-between; align-items: center; background: var(--bg-card); padding: 24px 32px; border-radius: 16px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05); border: 1px solid var(--border); }
        .header-left h1 { margin: 0; font-size: 1.5rem; color: var(--text-main); display: flex; align-items: center; gap: 10px; }
        .header-left p { margin: 8px 0 0; color: var(--text-sub); font-size: 0.95rem; }
        .version-badge { background: var(--primary-light); color: var(--primary); padding: 2px 8px; border-radius: 6px; font-size: 0.8rem; font-weight: 600; }
        .actions { display: flex; gap: 12px; }
        .btn { padding: 10px 20px; border-radius: 8px; font-weight: 500; cursor: pointer; transition: all 0.2s; border: 1px solid transparent; font-size: 0.9rem; display: flex; align-items: center; gap: 6px; }
        .btn-primary { background: var(--primary); color: white; box-shadow: 0 2px 4px rgba(37, 99, 235, 0.2); }
        .btn-primary:hover { background: #1d4ed8; transform: translateY(-1px); }
        .btn-secondary { background: white; border-color: var(--border); color: var(--text-main); }
        .btn-secondary:hover { background: var(--bg-page); }
        .btn-edit.active { background: #fef3c7; border-color: #f59e0b; color: #b45309; }
        /* Card */
        .card { background: var(--bg-card); border-radius: 16px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05); border: 1px solid var(--border); overflow: hidden; }
        .card-header { padding: 20px 32px; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center; background: #fdfdfd; }
        .card-header h2 { margin: 0; font-size: 1.1rem; font-weight: 600; }
        .card-body { padding: 0; }
        /* Table */
        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; padding: 16px 24px; background: #f8fafc; color: var(--text-sub); font-weight: 600; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 1px solid var(--border); }
        td { padding: 16px 24px; border-bottom: 1px solid var(--border); font-size: 0.95rem; vertical-align: top; }
        tr:last-child td { border-bottom: none; }
        tr:hover { background-color: #fcfcfc; }
        /* Tags */
        .tag { display: inline-flex; align-items: center; padding: 2px 8px; border-radius: 4px; font-size: 0.8rem; font-weight: 500; margin-right: 4px; margin-bottom: 4px; border: 1px solid transparent; cursor: default; }
        .tag-gray { background: var(--tag-bg); color: var(--tag-text); border-color: #e2e8f0; }
        .tag-red { background: #fef2f2; color: #ef4444; border-color: #fee2e2; }
        .tag-blue { background: #eff6ff; color: #3b82f6; border-color: #dbeafe; }
        .tag-green { background: #ecfdf5; color: #047857; border-color: #a7f3d0; }
        .code-font { font-family: "SFMono-Regular", Consolas, "Liberation Mono", Menlo, Courier, monospace; color: #d63384; background: #fdf2f8; padding: 2px 6px; border-radius: 4px; font-size: 0.9em; }
        .tag[contenteditable="true"]:focus { outline: 2px solid #3b82f6; background: #fff; }
        
        /* Edit Mode */
        body.edit-mode .editable { border: 1px dashed #cbd5e1; background: #fffbeb; cursor: text; padding: 2px 4px; border-radius: 4px; }
        body.edit-mode .editable:hover, body.edit-mode .tag[contenteditable="true"]:hover { border-color: #f59e0b; }
        
        /* Tabs & Views */
        .tabs { display: flex; gap: 20px; margin-bottom: -1px; }
        .tab-btn { background: none; border: none; padding: 0 0 12px; font-weight: 500; color: var(--text-sub); cursor: pointer; border-bottom: 2px solid transparent; }
        .tab-btn.active { color: var(--primary); border-bottom-color: var(--primary); }
        .view-section { display: none; padding: 0; }
        .view-section.active { display: block; }
        .json-pre { margin: 20px; padding: 20px; background: #1e1e1e; color: #d4d4d4; border-radius: 8px; overflow-x: auto; font-family: Consolas, monospace; font-size: 0.85rem; }
    </style>
</head>
<body>

<div class="container">
    <a href="index.html" style="text-decoration:none; color:var(--text-sub); font-size:0.9rem;">← 返回工具列表</a>
    
    <header>
        <div class="header-left">
            <h1><span class="editable" contenteditable="false">{{TOOL_NAME}}</span> <span class="version-badge">v1.0.0</span></h1>
            <p class="editable" contenteditable="false">{{TOOL_DESCRIPTION}}</p>
        </div>
        <div class="actions">
            <button class="btn btn-secondary btn-edit" onclick="toggleEditMode()">✏️ 编辑模式</button>
            <button class="btn btn-primary" onclick="exportJSON()">🚀 导出配置</button>
        </div>
    </header>

    <!-- Request Definition -->
    <div class="card">
        <div class="card-header">
            <h2>📥 输入参数 (Request)</h2>
            <div class="tabs">
                <button class="tab-btn active" onclick="switchTab('req-table')">表格视图</button>
                <button class="tab-btn" onclick="switchTab('req-json')">JSON Schema</button>
            </div>
        </div>
        <div class="card-body">
            <!-- Table View -->
            <div id="req-table" class="view-section active">
                <table>
                    <thead>
                        <tr>
                            <th width="15%">参数名</th>
                            <th width="10%">类型</th>
                            <th width="8%">必填</th>
                            <th width="10%">默认值</th>
                            <th>枚举值 / 说明 (Tag 可编辑)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- INJECT INPUT ROWS HERE -->
                        {{INPUT_ROWS}}
                    </tbody>
                </table>
            </div>
            <!-- JSON View -->
            <div id="req-json" class="view-section">
                <pre class="json-pre">{{INPUT_JSON_SCHEMA}}</pre>
            </div>
        </div>
    </div>

    <!-- Response Definition -->
    <div class="card">
        <div class="card-header">
            <h2>📤 输出参数 (Response)</h2>
        </div>
        <div class="card-body">
            <table>
                <thead>
                    <tr>
                        <th width="15%">参数名</th>
                        <th width="10%">类型</th>
                        <th width="40%">说明</th>
                        <th>结构 / 示例</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- INJECT OUTPUT ROWS HERE -->
                    {{OUTPUT_ROWS}}
                </tbody>
            </table>
        </div>
    </div>

    <!-- Test Cases -->
    <div class="card">
        <div class="card-header">
            <h2>🧪 测试用例 (Test Cases)</h2>
        </div>
        <div class="card-body">
            <table>
                <thead>
                    <tr>
                        <th width="20%">场景 (Scenario)</th>
                        <th width="40%">输入 (Input)</th>
                        <th>预期输出 (Expected Data)</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- INJECT 6+ TEST CASE ROWS HERE -->
                    {{TEST_CASE_ROWS}}
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    let isEditMode = false;

    // Toggle Edit Mode
    function toggleEditMode() {
        isEditMode = !isEditMode;
        document.body.classList.toggle('edit-mode', isEditMode);
        
        const btn = document.querySelector('.btn-edit');
        btn.textContent = isEditMode ? '💾 完成编辑' : '✏️ 编辑模式';
        btn.classList.toggle('active', isEditMode);

        // Text Editing
        document.querySelectorAll('.editable').forEach(el => el.setAttribute('contenteditable', isEditMode));
        
        // Tag Editing
        document.querySelectorAll('.tag-edit').forEach(el => {
            el.setAttribute('contenteditable', isEditMode);
            
            // Allow adding new tags when in edit mode
            if(isEditMode && el.classList.contains('tag-green') && el.textContent === '+') {
                el.onclick = function() {
                    const newTag = document.createElement('span');
                    newTag.className = 'tag tag-gray tag-edit';
                    newTag.textContent = "NewItem";
                    newTag.setAttribute('contenteditable', true);
                    el.parentNode.insertBefore(newTag, el);
                }
            } else {
                el.onclick = null;
            }
        });
    }

    // Switch Tabs
    function switchTab(tabId) {
        // Toggle view
        document.querySelectorAll('.view-section').forEach(el => el.classList.remove('active'));
        document.getElementById(tabId).classList.add('active');
        
        // Toggle active button
        const btns = event.target.parentNode.getElementsByClassName('tab-btn');
        for (let btn of btns) btn.classList.remove('active');
        event.target.classList.add('active');
    }

    function exportJSON() {
        // Build JSON from DOM state (Mock)
        const toolName = document.querySelector('h1 .editable').textContent;
        alert(`已生成 ${toolName} 的最新 JSON 配置！`);
    }
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
1.  **Missing Params**: If user doesn't say "required", assume optional.
2.  **Test Coverage**: Ensure at least **6 diverse test cases** are included in the HTML table.
3.  **Tags**: All Enum values must be wrapped in `<span class="tag tag-gray tag-edit" contenteditable="false">VALUE</span>`.
4.  **Edit Mode**: Ensure the `+` tag is present at the end of every enum list: `<span class="tag tag-green tag-edit" contenteditable="false">+</span>`.
5.  **Granularity**: Do not omit fields. Describe every parameter fully, including all potential enum values, defaults, and type constraints.

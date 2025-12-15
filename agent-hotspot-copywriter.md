---
name: agent-hotspot-copywriter
description: 将财经热点转译为 1500 字左右的完整 Agent 宣传软文。抓取新浪财经、雪球等平台热点，通过展示 Agent 实际执行效果（Wind 数据调取、研报汇总、图表生成）来体现专业能力。输出完整的软文文章，而非简短文案。当用户需要为 Agent 生成深度软文、展示型文章时使用。
license: MIT
---

# 财经热点驱动的 Agent 软文生成器

## 🔇 静默执行协议 (Silent Execution Protocol)

> **CRITICAL INSTRUCTIONS FOR CLAUDE:**
> 
> 1. **Do NOT ask for confirmation to proceed.** 执行完整工作流，一次性输出结果。
> 2. **Do NOT ask "Should I continue?" or "Would you like me to..."** — 直接执行。
> 3. **Generate the FULL output in one response.** 不要分段输出。
> 4. **If hotspot scraping fails, use the fallback template.** 不要询问用户如何处理。
> 5. **If parameters are missing, use default values.** 不要请求额外信息。
> 6. **If fewer hotspots found than requested, continue with available hotspots.** 在输出中注明即可。

---

## 🎯 触发条件 (Trigger)

当用户输入包含以下模式时激活此 Skill：

- `生成 Agent 软文`
- `为 [Agent名] 生成推广文案`
- `抓取热点生成软文`
- `生成 [Agent名] 的宣传文案`
- `根据今日热点写 Agent 软文`

**触发关键词组合**：`生成` + (`Agent` / `软文` / `推广` / `文案`)

---

## ⚙️ 执行指令 (Execution Instructions)

### Step 1: 解析输入参数

从用户输入中提取参数，缺失时使用默认值：

```
解析用户输入

IF 提到 Agent 名称:
    agent_name = 提取的名称
ELSE:
    agent_name = "智能分析 Agent"（默认）

IF 提到特定渠道（首页/广告/公众号）:
    target_channel = 提取的渠道
ELSE:
    target_channel = "首页推荐"（默认）

IF 提到语气风格:
    tone = 提取的风格
ELSE:
    tone = "专业"（默认）

agent_core_abilities = [
    "Wind 数据调取",
    "公告/研报自动汇总",
    "图表生成与分析",
    "结构化结论输出"
]
```

**不要询问用户确认参数，直接使用默认值继续执行。**

### Step 2: 抓取财经热点（增强版）

使用浏览器工具抓取热点，**必须先滚动翻页浏览全部内容，再确定热点**：

```
TRY:
    打开 https://finance.sina.com.cn/
    等待页面加载
    
    # 滚动浏览全部内容
    FOR i in range(3):  # 滚动3次，确保看到更多热点
        滚动到页面底部
        等待2秒（加载更多内容）
    
    # 提取所有可见热点新闻标题（不少于10条）
    提取首页所有热点新闻标题和链接
    
    # 筛选重大热点
    filtered_hotspots = []
    FOR each headline:
        IF 包含宏观关键词（中央、经济工作会议、货币政策、财政政策、监管、改革、GDP、CPI、利率、汇率等）:
            filtered_hotspots.append(headline)
    
    # 选择最重要的热点（优先级：政策 > 宏观数据 > 行业监管）
    selected_hotspot = filtered_hotspots[0]  # 选择第一个重大热点
    
    # 点击进入详情页
    点击 selected_hotspot 的链接
    等待详情页加载
    
    # 滚动详情页，阅读完整内容
    FOR i in range(2):
        滚动到页面底部
        等待1秒
    
    # 提取详情页内容
    detail_content = {
        "title": 提取标题,
        "publish_time": 提取发布时间,
        "source": 提取来源,
        "full_text": 提取正文全文,
        "key_points": 提取小标题和关键段落
    }
    
    hotspot_source = "新浪财经"
    继续 Step 3
    
EXCEPT 新浪财经抓取失败:
    TRY:
        打开 https://xueqiu.com/
        等待页面加载
        
        # 同样的滚动和详情页查看流程
        [重复上述步骤]
        
        hotspot_source = "雪球"
        继续 Step 3
    
    EXCEPT 两个来源都失败:
        使用备用热点模板:
        hot_topic = {
            "title": "市场焦点持续演变",
            "related_entities": ["市场", "行情", "数据"],
            "why_hot": "持续关注市场动态，数据解读正当时",
            "detail_content": "当前市场环境下，金融从业者面临政策变化、市场波动等多重挑战..."
        }
        hotspot_source = "通用模板"
        继续 Step 4
```

**关键要求：**
- 必须滚动页面至少3次，确保看到足够多的热点
- 必须点击进入详情页，阅读完整内容
- 优先选择对整个市场有重大影响的宏观热点
- 不要选择个股或小行业的热点

### Step 3: 热点解析与抽取

分析抓取到的热点内容：

```python
FOR each headline in hotspots:
    # 识别热点类型
    IF 包含 ["暴涨", "暴跌", "涨停", "跌停", "异动", "大涨", "大跌"]:
        hot_type = "行情异动"
    ELIF 包含 ["政策", "会议", "监管", "改革", "出台"]:
        hot_type = "政策预期"
    ELIF 包含 ["财报", "业绩", "净利润", "营收", "超预期"]:
        hot_type = "业绩相关"
    ELIF 包含 ["传闻", "热议", "讨论", "争议"]:
        hot_type = "舆情事件"
    ELSE:
        hot_type = "板块轮动"
    
    # 提取相关实体
    related_entities = 提取公司名/行业名/概念名
    
    # 分析热点原因
    why_hot = 基于上下文推断原因

# 选择最热门的1-3个话题
selected_topics = 按热度排序后取前 max_topics 个
```

**输出结构化 hot_topic 对象：**

```json
{
  "title": "AI 概念股再度走强",
  "related_entities": ["AI", "半导体", "算力"],
  "why_hot": "政策预期 + 板块异动",
  "hot_type": "行情异动"
}
```

### Step 4: 热点 × Agent 能力转译

根据热点类型，匹配 Agent 能力展示方式：

| 热点类型 | Agent 能力展示       | 文案角度           |
| -------- | -------------------- | ------------------ |
| 行情异动 | Wind 行情 + 技术图表 | "数据揭示真相"     |
| 政策预期 | 政策原文 + 研报解读  | "专业解读政策影响" |
| 业绩相关 | 财务数据 + 对比图    | "一眼看清业绩"     |
| 舆情事件 | 新闻/公告自动汇总    | "信息整合专家"     |
| 板块轮动 | 板块对比 + 资金流向  | "把握轮动节奏"     |

**转译逻辑原则：**
> **不写"Agent 很厉害"，而是写：**
> **"这个热点，用 Agent 能更快、更专业看懂什么"**

### Step 5: 生成 1500 字完整软文（金融从业者视角）

按照以下结构生成完整文章（目标 1500 字）：

**第一部分：热点引入 + 从业者困惑（300-400字）**

1. **热点事件描述**（150字）
   - 基于详情页内容，完整描述热点事件
   - 包含关键数据、时间节点、政策要点

2. **金融从业者视角的问题提出**（150-250字）
   - 带入中国金融从业者的身份（银行、券商、基金、保险等）
   - 提出热点对从业者可能造成的具体影响问题
   
   **问题示例：**
   - 政策类热点："货币政策转向'适度宽松'，对我们银行的信贷投放节奏有什么影响？利率下行会压缩多少利差？"
   - 监管类热点："新的资管新规细则出台，我们的存量产品需要如何调整？合规成本会增加多少？"
   - 市场类热点："市场大幅波动，客户赎回压力增大，我们应该如何调整投资组合？"
   - 行业类热点："同业竞争加剧，我们的产品竞争力在哪里？如何留住客户？"

**第二部分：用 Agent 分析问题（800-1000字）**

这是核心部分，展示 **Agent 如何帮助金融从业者分析和解决问题**：

1. **场景设定**（100字）
   - "作为一名 [银行/券商/基金] 从业者，面对这个问题，让我们用 [Agent名] 来深入分析..."

2. **Agent 执行步骤展示**（700-900字）

   **Step 1: 数据调取与对比**（200-250字）
   - 调取 Wind 相关数据（利率、市场指数、行业数据等）
   - 对比历史数据，找出变化趋势
   - 列出具体数据示例
   
   **示例输出：**
   ```
   Agent 首先调取了过去5年的货币政策数据：
   - 2020年：稳健的货币政策，1年期LPR 3.85%
   - 2021年：稳健的货币政策，1年期LPR 3.85%
   - 2022年：稳健的货币政策，1年期LPR 3.65%（下调20bp）
   - 2023年：稳健的货币政策，1年期LPR 3.45%（下调20bp）
   - 2024年：适度宽松的货币政策，预计1年期LPR将降至3.25%（预期下调20bp）
   
   同时对比了银行业净息差数据：
   - 2020年：2.15%
   - 2021年：2.08%
   - 2022年：1.91%
   - 2023年：1.69%
   - 2024年预测：1.55%（继续收窄）
   ```

   **Step 2: 政策文件与研报汇总**（200-250字）
   - 自动抓取政策原文、监管文件、行业研报
   - 提取与从业者问题直接相关的内容
   - 列出关键信息摘要
   
   **示例输出：**
   ```
   Agent 汇总了10份券商研报和3份监管文件：
   
   政策要点：
   1. 央行表态：将适时降准降息，保持流动性合理充裕
   2. 银保监会要求：优化信贷结构，加大对实体经济支持
   3. 财政部计划：发行1.5万亿特别国债，支持基建投资
   
   券商研报观点：
   - 中信证券：预计2025年将降准2次（各50bp）、降息1次（10bp）
   - 华泰证券：银行净息差压力加大，建议通过中间业务补充收入
   - 国泰君安：信贷需求有望回暖，但定价能力是关键
   ```

   **Step 3: 影响测算与情景分析**（200-250字）
   - 基于数据，测算政策对从业者的具体影响
   - 提供不同情景下的应对策略
   
   **示例输出：**
   ```
   Agent 进行了情景分析：
   
   情景1：降息20bp + 信贷增速10%
   - 净息差影响：-0.15个百分点
   - 利息收入影响：-8%
   - 中间业务补充需求：+15%
   
   情景2：降息20bp + 信贷增速15%
   - 净息差影响：-0.15个百分点
   - 利息收入影响：-3%（规模增长抵消部分）
   - 中间业务补充需求：+8%
   
   情景3：降息10bp + 信贷增速12%
   - 净息差影响：-0.08个百分点
   - 利息收入影响：-1%
   - 中间业务补充需求：+5%
   ```

   **Step 4: 给出可执行建议**（100-150字）
   - 基于分析，提供具体的应对建议
   - 包含短期、中期、长期策略
   
   **示例输出：**
   ```
   Agent 建议：
   
   短期（1-3个月）：
   1. 优化资产负债结构，提前锁定长期资产收益
   2. 加大中间业务拓展，重点发展财富管理、投行业务
   3. 控制负债成本，优化存款结构
   
   中期（3-6个月）：
   1. 调整信贷投放节奏，抓住基建、消费等政策支持领域
   2. 提升定价能力，差异化竞争
   3. 加强风险管理，防范信用风险
   
   长期（6-12个月）：
   1. 数字化转型，降低运营成本
   2. 拓展新业务领域，寻找新的增长点
   3. 提升客户粘性，建立长期合作关系
   ```

**第三部分：总结与价值体现（300-400字）**

1. **回答从业者的核心问题**（150字）
   - 直接回答第一部分提出的问题
   - 用数据和分析支撑结论

2. **Agent 价值体现**（150-250字）
   - 对比传统分析方式 vs Agent 方式
   - 突出效率、全面性、准确性
   - 强调对金融从业者的实际帮助
   
   **示例：**
   ```
   传统方式：
   - 需要手动查询多个数据库（Wind、Choice、Bloomberg）
   - 需要阅读几十份研报和政策文件
   - 需要手动建模测算影响
   - 耗时：5-8小时
   
   Agent 方式：
   - 自动调取所有相关数据
   - 自动汇总研报和政策要点
   - 自动测算影响并给出建议
   - 耗时：10分钟
   ```

3. **行动号召**（50字）
   - 鼓励从业者使用 Agent 提升工作效率

**写作要求：**
- 总字数控制在 1400-1600 字
- 必须带入金融从业者视角，提出具体问题
- 必须展示 Agent 如何分析和解决问题
- 使用真实数据和案例，避免空洞描述
- 不承诺收益，不做交易建议
- 用"分析""测算""建议"等专业措辞

### Step 6: 输出完整软文

输出格式：**纯 Markdown 文章**（1500字左右）

```markdown
# [吸引眼球的标题]

## 热点背景

[200-300字的热点描述]

## 用 [Agent名] 深度解析

让我们用 [Agent名] 来深入分析这个热点，看看专业工具如何帮助我们快速理清脉络。

### 第一步：一键调取 Wind 数据

[Agent名] 首先自动获取相关标的的实时行情数据...

**数据概览：**
- 股价：XX.XX 元（+X.XX%）
- 成交量：XX 亿元
- 换手率：X.XX%

[继续展示数据细节]

### 第二步：自动汇总公告与研报

[Agent名] 同步抓取了最新的公司公告和券商研报...

**核心信息摘要：**
1. [公告要点1]
2. [研报观点1]
3. [新闻要点1]

[继续展示信息汇总]

### 第三步：生成可视化图表

基于上述数据，[Agent名] 自动生成了多维度对比图表...

[描述图表内容和发现]

### 第四步：输出结构化结论

综合以上分析，[Agent名] 给出以下核心观点：

1. **[观点1]**：[说明]
2. **[观点2]**：[说明]
3. **[观点3]**：[说明]

## 为什么选择 [Agent名]？

[300-400字的价值总结]

**传统方式 vs Agent 方式：**
- 时间：XX小时 → X分钟
- 信息源：X个 → XX个
- 准确性：人工筛选 → 算法验证

---

👉 **立即体验 [Agent名]，让数据为你说话**
```

**元数据（JSON格式，供系统使用）：**

```json
{
  "metadata": {
    "agent_name": "Agent名称",
    "hotspot_source": "热点来源",
    "scrape_time": "抓取时间",
    "word_count": 实际字数,
    "topics_found": 实际抓取数量
  }
}
```

---

### Step 7: 生成 HTML 网页与归档

采用**单篇相关 + 目录索引**的结构，避免文件覆盖。

1.  **准备文件名与路径**：
    *   文件名格式：`posts/article_[YYYYMMDD]_[HHMM].html`
    *   确保 `posts/` 目录存在（不存在则创建）

2.  **生成文章页**：
    *   使用 [文章页 HTML 模板]
    *   注入内容，并确保包含 `<a href="../index.html">← 返回首页</a>`
    *   写入新文件

3.  **更新目录页 (`index.html`)**：
    *   **检查**：根目录下是否存在 `index.html`
    *   **不存在**：使用 [目录页 HTML 模板] 创建新文件
    *   **存在**：读取文件内容
    *   **插入**：在 `<div class="article-list">` 标签后插入新的 [文章卡片]
    *   **保存**：覆盖更新 `index.html`

### Step 8: 自动部署到 GitHub Pages

1.  **执行 Git 命令**：
    ```bash
    git add .
    git commit -m "New article: [文章标题]"
    git push
    ```

2.  **输出结果**：
    *   告知用户文章已发布
    *   文章链接：`https://[username].github.io/[repo]/posts/article_[time].html`
    *   首页链接：`https://[username].github.io/[repo]/`

---

## 🎨 HTML 模板 (Templates)

### 1. 文章页模板 (posts/article_*.html)

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>[文章标题]</title>
    <!-- 引入 Shared CSS，或者在此处直接内联完整 CSS -->
    <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@400;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* [此处复制完整的 CSS 样式] */
        /* 新增：返回按钮样式 */
        .back-nav { padding: 20px 0; margin-bottom: 20px; }
        .back-nav a { text-decoration: none; color: var(--primary-color); font-weight: 600; display: inline-flex; align-items: center; gap: 5px; }
        .back-nav a:hover { color: var(--accent-color); }
        
        /* Mobile Optimization */
        @media (max-width: 768px) {
            .container { padding: 20px 15px; }
            .article-header { padding: 40px 20px; text-align: left; }
            .article-header h1 { font-size: 1.8rem; }
            .article-meta { gap: 10px; font-size: 0.85rem; }
            .content-section { padding: 30px 20px; }
            .section-title { font-size: 1.4rem; }
            .highlight-box { padding: 20px; }
            .data-table { display: block; overflow-x: auto; white-space: nowrap; }
            .comparison-grid { grid-template-columns: 1fr; }
            .cta-section { padding: 40px 20px; }
            .cta-section h3 { font-size: 1.6rem; }
        }
    </style>
</head>
<body>
    <div class="container">
        <nav class="back-nav fade-in">
            <a href="../index.html">← 返回首页</a>
        </nav>
        
        <header class="article-header fade-in">
            <h1>[文章标题]</h1>
            <div class="article-meta">
                <span class="meta-item">[Agent名]</span>
                <span class="meta-item">[日期]</span>
                <span class="meta-item">[来源]</span>
            </div>
        </header>

        <section class="content-section fade-in">
            [插入正文内容]
        </section>
        
        <!-- CTA 和 Footer -->
        <!-- ... -->
    </div>
    <!-- Script ... -->
</body>
</html>
```

### 2. 目录页模板 (index.html)

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agent 财经热点分析报告</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@400;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* 基础 CSS 与文章页一致 */
        :root { --primary-color: #1a5490; --accent-color: #f77f00; --bg-light: #f8f9fa; --text-dark: #1d3557; }
        body { font-family: 'Noto Serif SC', serif; background: var(--bg-light); color: var(--text-dark); margin: 0; }
        .container { max-width: 800px; margin: 0 auto; padding: 40px 20px; }
        .header { text-align: center; margin-bottom: 60px; padding: 40px 0; border-bottom: 2px solid #eee; }
        .header h1 { font-size: 2.5rem; color: var(--primary-color); }
        .article-list { display: flex; flex-direction: column; gap: 30px; }
        .article-card { 
            display: block; background: white; padding: 30px; border-radius: 15px; 
            text-decoration: none; color: inherit; box-shadow: 0 5px 20px rgba(0,0,0,0.05);
            transition: transform 0.2s, box-shadow 0.2s; border-left: 5px solid transparent;
        }
        .article-card:hover { transform: translateY(-5px); box-shadow: 0 10px 30px rgba(0,0,0,0.1); border-left-color: var(--accent-color); }
        .article-card h2 { margin: 0 0 10px 0; font-size: 1.5rem; color: var(--primary-color); }
        .article-card .meta { font-family: 'Inter', sans-serif; color: #666; font-size: 0.9rem; }
        .intro { color: #666; font-size: 1.1rem; max-width: 600px; margin: 20px auto 0; line-height: 1.6; }
    </style>
</head>
<body>
    <div class="container">
        <header class="header">
            <h1>📊 Agent 财经热点分析</h1>
            <p class="intro">这里汇集了智能 Agent 对最新宏观政策、市场热点的深度解读与量化分析。</p>
        </header>

        <div class="article-list">
            <!-- 新文章卡片将插入到这里 -->
        </div>
    </div>
</body>
</html>
```

### 3. 文章卡片片段 (Article Card Snippet)

```html
<a href="[文章相对路径]" class="article-card">
    <h2>[文章标题]</h2>
    <div class="meta">
        <span>📅 [日期]</span> • <span>🔥 [热点来源]</span>
    </div>
    <p style="margin-top: 15px; color: #555; line-height: 1.6;">
        [副标题或一句话摘要]
    </p>
</a>
```

### Example 1: 正常执行（一气呵成）

**用户输入：**
```
生成 Agent 软文
```

**正确的 Claude 响应：**

```
[打开新浪财经，抓取热点]
[解析热点：AI 概念股盘中异动]
[映射能力：Wind 行情 + 图表分析]
[生成文案]

## 📊 生成结果

### 热点信息
- **热点标题**：AI 概念股盘中异动，市场分歧加大
- **相关实体**：AI、半导体、算力
- **热点原因**：政策预期 + 资金博弈

### 软文输出

**标题**
> AI 概念股热度再起，数据才是关键

**副标题**
> 与其被情绪带着走，不如直接看数据

**正文**
> 市场再次围绕 AI 板块展开博弈，分歧快速放大。
>
> 与其被情绪带着走，不如直接看数据。
>
> 智能分析 Agent 可一键调取 Wind 行情、自动汇总最新公告与研报，并用图表直观呈现核心变化，帮你快速判断这轮行情的真实驱动。

**CTA**
> 👉 立即使用智能分析 Agent

---

**元数据**
- 热点来源：新浪财经
- 抓取时间：2024-12-14 20:30:00
- 热点数量：3
```

### Example 2: 指定 Agent 名称

**用户输入：**
```
为 Alice Agent 生成推广文案
```

**正确响应：**
- 自动使用 agent_name = "Alice Agent"
- 文案中所有提及 Agent 的地方都用 "Alice Agent"
- 不询问确认，直接生成

### Example 3: 热点抓取失败时自动使用备用模板

**场景：** 新浪财经和雪球都无法访问

**正确响应：**
```
[尝试新浪财经 - 失败]
[尝试雪球 - 失败]
[使用备用热点模板]

## 📊 生成结果

### 热点信息
- **热点标题**：市场焦点持续演变
- **相关实体**：市场、行情、数据
- **热点来源**：通用模板

### 软文输出
...（正常输出完整文案）...
```

**注意：不询问用户如何处理，直接使用备用模板继续。**

---

## ❌ 反面示例 (Anti-Patterns) — 严禁出现

### Anti-Pattern 1: 询问参数确认

```
❌ 错误示例：
"请问您的 Agent 叫什么名字？"
"您希望用于什么渠道？首页推荐、广告还是公众号？"
"请告诉我 Agent 的核心能力有哪些？"
```

**正确做法：使用默认值，不询问。**

### Anti-Pattern 2: 抓取失败时询问

```
❌ 错误示例：
"新浪财经无法访问，要尝试雪球吗？"
"热点抓取失败，请问您想手动提供热点内容吗？"
```

**正确做法：静默切换备用来源或使用备用模板。**

### Anti-Pattern 3: 热点不足时询问

```
❌ 错误示例：
"只抓取到 1 个热点，配置要求 3 个，是否继续？"
"热点数量不足，需要我用通用话术补充吗？"
```

**正确做法：用已有热点继续，在 metadata 中注明实际数量。**

### Anti-Pattern 4: 分段输出

```
❌ 错误示例：
"这是热点分析结果..."
"需要我继续生成软文吗？"
"这是软文标题..."
"要看正文吗？"
```

**正确做法：一次性输出完整结果。**

### Anti-Pattern 5: 询问输出格式

```
❌ 错误示例：
"您希望 JSON 格式还是 Markdown 格式？"
"需要英文翻译版本吗？"
```

**正确做法：按默认配置输出，enable_translation=false 时不问。**

---

## 🔧 默认配置 (Defaults)

| 参数                   | 默认值                                                         | 说明           |
| ---------------------- | -------------------------------------------------------------- | -------------- |
| `agent_name`           | `智能分析 Agent`                                               | Agent 名称     |
| `agent_core_abilities` | `["Wind 数据调取", "公告/研报汇总", "图表生成", "结构化结论"]` | 核心能力       |
| `target_channel`       | `首页推荐`                                                     | 投放渠道       |
| `tone`                 | `专业`                                                         | 文案语气       |
| `time_range`           | `24h`                                                          | 热点时间范围   |
| `max_topics`           | `3`                                                            | 最多抓取热点数 |
| `enable_translation`   | `false`                                                        | 是否生成英文版 |

---

## 🔥 备用热点模板 (Fallback Template)

当所有热点源都无法访问时，使用以下模板：

```json
{
  "title": "市场焦点持续演变",
  "related_entities": ["市场", "行情", "数据"],
  "why_hot": "持续关注市场动态，数据解读正当时",
  "hot_type": "板块轮动"
}
```

**对应软文模板：**

> **标题**：市场动态解读，数据先行一步
>
> **正文**：市场持续演变，热点切换频繁。与其凭感觉追逐，不如用数据说话。[Agent名] 可一键调取 Wind 行情、自动汇总公告研报，用图表呈现核心趋势，帮你更快读懂市场。
>
> **CTA**：👉 立即体验智能分析

---

## 📊 能力映射表 (Ability Mapping)

| 热点类型 | 关键词              | Agent 能力           | 文案角度     |
| -------- | ------------------- | -------------------- | ------------ |
| 行情异动 | 暴涨/暴跌/涨停/异动 | Wind 行情 + 技术图表 | 数据揭示真相 |
| 政策预期 | 政策/会议/监管/改革 | 政策原文 + 研报解读  | 专业解读影响 |
| 业绩相关 | 财报/业绩/净利润    | 财务数据 + 对比图    | 一眼看清业绩 |
| 舆情事件 | 传闻/热议/争议      | 新闻/公告汇总        | 信息整合专家 |
| 板块轮动 | 板块/概念/赛道      | 板块对比 + 资金流向  | 把握轮动节奏 |

---

## 🚫 边界情况处理 (Edge Cases)

| 情况                  | 处理方式                        |
| --------------------- | ------------------------------- |
| 用户未提供 Agent 名称 | 使用默认值 `智能分析 Agent`     |
| 新浪财经无法访问      | 尝试雪球                        |
| 雪球也无法访问        | 使用备用热点模板                |
| 热点数量不足          | 继续生成，metadata 注明实际数量 |
| 热点内容无法解析      | 跳过该热点，处理其他            |
| 所有热点都无法解析    | 使用备用模板                    |

---

## ⚠️ 合规要求 (Compliance)

- ❌ 不承诺收益
- ❌ 不做明确交易建议
- ✅ 使用"分析""观察""解读"等专业措辞
- ✅ 强调工具与效率，而非观点立场
- ✅ 突出数据驱动，而非主观判断

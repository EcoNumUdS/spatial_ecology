# Setting up your working environment for the Working Group

**The recommended tool for the Working Group is GitHub Copilot in VS Code**, as it is directly integrated into the environment we will be using and available for free through GitHub Education. If you already have a paid subscription to Claude or ChatGPT, you also have access to advanced agents (Claude Code, Codex) — feel free to bring them along. We will compare our experiences together.

## 1. Install and configure Git

[Git](https://git-scm.com/downloads) must be installed on your computer — it is a prerequisite for GitHub and VS Code. Once installed, [configure your Git identity](https://docs.github.com/en/get-started/getting-started-with-git/set-up-git) (name and email) before moving on to the next steps.

## 2. Create a GitHub account

We will invite you to a shared collaboration space. Please send me your GitHub username so I can add you. The link to the space will be sent to you in the coming days.

## 3. Install VS Code

[VS Code](https://code.visualstudio.com/) is a lightweight, modular development environment that supports R, Python, Julia, and many other languages. It also provides advanced features useful in research: variable exploration, debugging, notebook editing, etc.

Depending on the programming language you will use during the Working Group, first make sure the interpreter is installed ([R](https://cran.r-project.org/) / [Python](https://www.python.org/downloads/)), then install the corresponding VS Code extension:

| Language | VS Code Extension |
|----------|-------------------|
| Python | [Python Extension Pack](https://marketplace.visualstudio.com/items?itemName=ms-python.python) |
| R | [R Extension](https://marketplace.visualstudio.com/items?itemName=REditorSupport.r) |
| C++ | [C/C++ Extension Pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools-extension-pack) |

Each page includes setup instructions. It is slightly more work than RStudio, but well documented. The R extension in particular needs an extra step on the R side — install the `languageserver` package (and optionally `httpgd` for graphics and `radian` for a better REPL) following the [extension README](https://marketplace.visualstudio.com/items?itemName=REditorSupport.r). If you would like a demo, we can set aside a moment next week.

Once VS Code is installed, [connect your GitHub account to VS Code](https://code.visualstudio.com/docs/editor/github) — this is required to use GitHub Copilot and sync your settings.

## 4. Enable GitHub Copilot (free for university members)

[GitHub Education](https://education.github.com/) provides free access to GitHub Copilot for members of university communities. You will need to submit proof of affiliation (employment contract or university card). For professionals, the application can be submitted as an educator — that is what I did personally.

I strongly recommend doing this: the GitHub Education account also gives access to private organizations, GitHub Actions credits, private repositories, and many other useful features.

## 5. Artificial intelligence: chat interfaces and agents

During the Working Group, we will explore several AI tools, ranging from simple conversational assistants to advanced programming agents. The key distinction to understand is between an **online chat interface** (e.g., ChatGPT in a browser) and an **AI agent** (a tool that interacts directly with your working environment, your files, and your code). We will focus particularly on the latter.

Here is an overview of the main tools available:

| Provider | Online chat interface | Agent | VS Code extension |
|----------|-----------------------|-------|-------------------|
| Microsoft | [Microsoft Copilot](https://copilot.microsoft.com) — free | — | — |
| GitHub | [GitHub Copilot Chat](https://github.com/copilot) — included with GitHub Education | [Copilot agent mode](https://code.visualstudio.com/docs/copilot/chat/chat-agent-mode) — built into the VS Code extension | [GitHub Copilot](https://code.visualstudio.com/docs/copilot/overview) — built into VS Code |
| OpenAI | [ChatGPT](https://chatgpt.com) — free (basic) / $20 USD/month | [Codex CLI](https://platform.openai.com/codex) — included with ChatGPT Plus | [OpenAI Codex extension](https://marketplace.visualstudio.com/items?itemName=openai.chatgpt) — chat only (Codex CLI is separate) |
| Anthropic | [Claude](https://claude.ai) — free (basic) / $20 USD/month | [Claude Code](https://claude.ai/code) — included with Claude Pro | [Claude Code](https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code) |
| Google | [Gemini](https://gemini.google.com) — free (basic) | Agent mode in Gemini Code Assist | [Gemini Code Assist](https://marketplace.visualstudio.com/items?itemName=Google.geminicodeassist) |

The Agent column reflects the state at the time of writing — providers ship features quickly, so check each product's current documentation before counting a capability out.

### 5.1 Install the extension

Install the VS Code extension for the agent(s) you want to use, e.g. [Claude Code](https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code) or the [OpenAI Codex extension](https://marketplace.visualstudio.com/items?itemName=openai.chatgpt), from the links in the table above.

### 5.2 License activation

To use an AI agent extension (Claude Code or Codex) in VS Code, open the extension's chat tab, select the extension (Codex or Claude), and follow the instructions to sign in and link it to your subscription. **A paid subscription is required** — Claude Pro/Max/Team/Enterprise for Claude Code, or ChatGPT Plus for Codex. The free tiers of Claude.ai and ChatGPT do not include agent access.

![VS Code editor with the Claude Code extension panel open on the right side, showing a conversation with Claude](https://mintcdn.com/claude-code/-YhHHmtSxwr7W8gy/images/vs-code-extension-interface.jpg?fit=max&auto=format&n=-YhHHmtSxwr7W8gy&q=85&s=300652d5678c63905e6b0ea9e50835f8)
*The Claude Code chat panel in VS Code, where you sign in and link the extension to your subscription.*

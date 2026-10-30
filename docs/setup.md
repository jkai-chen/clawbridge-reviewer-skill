# Setup

You need a Linear account in the team's workspace (a reviewer seat or guest access is enough to comment) and one of
Claude or ChatGPT. You connect **Linear's official MCP server** with your own Linear sign-in; nothing else is
installed, and nobody else's key is used.

Linear's MCP server is `https://mcp.linear.app/mcp`. It signs you in with OAuth in your browser. Linear's own guide
is at <https://linear.app/docs/mcp>.

## Claude

### Claude.ai (web) and Claude Desktop

1. Open **Settings → Connectors** (on claude.ai: <https://claude.ai/customize/connectors>).
2. Add **Linear** and sign in with your Linear account when the browser asks. Pick the team's workspace.
3. Install the skill: download this repository's `SKILL.md` and add it under **Settings → Capabilities → Skills**
   (upload a folder or zip that contains `SKILL.md`). If your plan has no skills setting, start a Project and paste
   `SKILL.md`'s text (without the top `---` block) into the project instructions instead.
4. In a chat, make sure the Linear connector is switched on, then ask, for example: "Review the issue *Review:
   Checkout* with me."

### Claude Code

```sh
claude mcp add --transport http linear-server https://mcp.linear.app/mcp
mkdir -p ~/.claude/skills/linear-reviewer
curl -fsSL https://raw.githubusercontent.com/jkai-chen/clawbridge-reviewer-skill/main/SKILL.md \
  -o ~/.claude/skills/linear-reviewer/SKILL.md
```

Then start `claude`, run `/mcp`, choose `linear-server` and sign in. Ask: "Summarise the review on *Review:
Checkout*."

## ChatGPT

How ChatGPT connects to an MCP server depends on your plan and changes over time; check your own settings.

1. If **Settings → Apps/Connectors** lists **Linear**, connect it and sign in with your Linear account.
2. Otherwise, where your plan offers **developer mode** (custom connectors), add a connector with the URL
   `https://mcp.linear.app/mcp`, authentication **OAuth**, and sign in.
3. Create a Custom GPT (or a project), paste the text from [chatgpt-instructions.md](../chatgpt-instructions.md)
   into its instructions, and enable the Linear connector for it.
4. ChatGPT asks you to confirm each write; that matches rule 2 ("show it, then ask").

## What you'll see

- Your comments appear in Linear under **your name**, as if you typed them.
- The team answers **in your comment's thread**. Linear notifies you as usual for threads you take part in.
- Comments ending with a 🤖 line, such as `— 🤖 ClawBridge agent · session review-checkout`, were written by an AI
  agent for the team. Labels like `agent-working` mean an agent is on the issue.
- Your feedback is considered, not obeyed automatically. The team decides what changes.
- The assistant never changes an issue's state, assignee or project for you, and asks before every comment.

## Troubleshooting

- **"Not connected" or no Linear tools:** switch the Linear connector on for the chat (Claude) or the GPT
  (ChatGPT), or sign in again from the connector settings.
- **Wrong workspace:** disconnect and connect again, picking the team's workspace at the Linear sign-in.
- **A comment didn't appear:** ask the assistant to read the thread before trying again, so nothing is posted twice.

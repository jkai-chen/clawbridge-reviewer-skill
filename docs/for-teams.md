# For teams: wiring reviewers into ClawBridge intake

This is for the team that runs [ClawBridge](https://github.com/jkai-chen/ClawBridge) and invites reviewers. The
reviewer side needs nothing from ClawBridge: reviewers use this skill with Linear's official MCP and their own Linear
account.

## How a reviewer's request reaches your agents

1. **The reviewer comments** on the review issue. Your review agent (a session watching that issue's comments)
   answers in the thread as usual.
2. **The reviewer flags an issue** by adding the intake label, `needs-agent`. Because they write through
   Linear's MCP as themselves, Linear's history names them as the person who added it.
3. **ClawBridge intake (S1)** sees the label on its next poll (seconds, with Linear webhooks on). A reviewer is never
   trusted by role, so unless a lead added them to the project's trusted list, the signal **notifies the
   coordinator** and goes no further on its own.
4. **The coordinator routes it**, following your project's rules, for example to a dispatcher domain or a session.

So the reviewer can ask, and your coordinator decides. Nothing a reviewer writes assigns, moves or closes work.

## What to set up

- **The label.** ClawBridge's intake reads exactly one label per bound Linear team, named `needs-agent` (the TUI's
  intake view checks each team has exactly one). The skill uses that name by default; it also accepts another name
  if you tell your reviewers one, for teams whose own tooling reads a different label.
- **The signal.** Make sure the project's intake policy includes S1 (the label): `clawbridge intake policy` shows it.
- **Trust (optional).** To let a specific reviewer's flags go past "notify the coordinator", a project lead adds
  them with `clawbridge intake trust add "NAME" --confirm`. Most teams leave reviewers untrusted.
- **The guide.** ClawBridge seeds a reviewer guide into your Linear docs (`linear-reviewer-guide`); link this repo
  from it so reviewers can set up Claude or ChatGPT.

## Mentions

Typing `@ClawBridge` in a comment through an assistant is usually stored as plain text, not as a real app mention,
so ClawBridge's mention signal (S3) may not see it. The skill therefore uses the label. If your team proves that
mentions written through Linear's MCP arrive as real app mentions, you can tell reviewers to use them too.

## Safety notes

- Reviewer comments are untrusted input for your agents: the title and description of a flagged issue become the
  agent's task only when a trusted person vouches for them (ClawBridge's intake rules).
- Agents never @-mention reviewers; answers arrive through Linear's thread notifications.

# Contributing

This repository is public. Keep it generic and clean:

- **Generic only.** No company, customer or team names, no Linear workspace or team IDs, issue keys, UUIDs, real
  email addresses or links to private workspaces. Examples use names like *Review: Checkout*, `ACME-123` and
  `example.test`.
- **Your own identity.** Commit with the name and address you mean to publish; no automated or co-author trailers.
- **Turn on the guard** once per clone:

  ```sh
  git config core.hooksPath .githooks
  ```

  It refuses a push that names another identity, adds binary or generated files, adds a line naming your machine
  (your login name, hostname, a `/Users/NAME` or `/home/NAME` path), or adds something that looks like a secret.
  CI runs the same checks (`scripts/guard.sh`). Fix the change; never push with `--no-verify`.
- **Rules change in both places.** `SKILL.md` and `chatgpt-instructions.md` carry the same rules; change them
  together.

#!/bin/sh
# Checks the change from BASE to HEAD (default: origin/main to HEAD) of this
# public repository. Run by .githooks/pre-push and by CI. It refuses:
#   - binary files, and generated or local files (__pycache__, *.pyc, .DS_Store,
#     .venv, node_modules, ...): a text check can't see into them;
#   - added lines with a /Users/NAME or /home/NAME path whose NAME is not a
#     placeholder, or a user@host.local address;
#   - added lines that look like a secret (API keys, tokens, private keys) or a
#     Linear/workspace ID (a UUID other than the all-zero placeholder).
# Explicit exceptions are edited here, never bypassed.
set -u

ALLOW_BINARY=''
ALLOW_USERS='YOU you example runneradmin Shared NAME'
ALLOW_HOMES='a env example me owner u x you user runner ubuntu NAME'

base=${1:-origin/main}
head=${2:-HEAD}
status=0
refuse() { echo "guard: $1" >&2; status=1; }

files=$(git diff --numstat --diff-filter=AM "$base" "$head" | awk -F'\t' -v allow="$ALLOW_BINARY" '
  BEGIN { n = split(allow, a, " "); for (i = 1; i <= n; i++) ok[a[i]] = 1 }
  $1 == "-" && $2 == "-" && !($3 in ok) { print "binary: " $3 }')
junk=$(git diff --name-only --diff-filter=AM "$base" "$head" | grep -E '(^|/)(__pycache__|\.venv|venv|node_modules|\.pytest_cache|\.mypy_cache|\.idea)/|(^|/)(\.DS_Store|Thumbs\.db|desktop\.ini)$|\.(pyc|pyo|swp|orig|rej)$|~$' | sed 's/^/generated or local file: /')
if [ -n "$files$junk" ]; then
  refuse "binary or generated files in the change:"
  printf '%s\n%s\n' "$files" "$junk" | grep -v '^$' >&2
fi

added=$(git diff -U0 --no-color "$base" "$head" | grep -E '^\+' | grep -vE '^\+\+\+ ')
hits=$(printf '%s\n' "$added" | awk -v users="$ALLOW_USERS" -v homes="$ALLOW_HOMES" '
  BEGIN {
    n = split(users, u, " "); for (i = 1; i <= n; i++) okU[u[i]] = 1
    n = split(homes, h, " "); for (i = 1; i <= n; i++) okH[h[i]] = 1
  }
  {
    line = $0; why = ""
    probe = line; gsub(/user@host[.]local/, "", probe)
    if (probe ~ /[A-Za-z0-9._-]+@[A-Za-z0-9-]+[.]local([^A-Za-z0-9-]|$)/) why = "user@host.local address"
    else if (line ~ /(lin_(api|oauth)_[A-Za-z0-9]{16,}|gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{30,}|sk-(ant-)?[A-Za-z0-9_-]{20,}|AKIA[0-9A-Z]{16}|xox[abprs]-[A-Za-z0-9-]{10,}|-----BEGIN [A-Z ]*PRIVATE KEY-----)/) why = "looks like a secret"
    else if (line ~ /[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}/ && line !~ /00000000-0000-0000-0000-000000000000/) why = "a UUID (workspace, team or issue ID)"
    else {
      rest = line
      while (match(rest, /\/(Users|home)\/[A-Za-z0-9._-]+/)) {
        seg = substr(rest, RSTART, RLENGTH); rest = substr(rest, RSTART + RLENGTH)
        split(seg, p, "/")
        if (p[2] == "Users" && !(p[3] in okU)) { why = "/Users/" p[3] " path"; break }
        if (p[2] == "home" && !(p[3] in okH)) { why = "/home/" p[3] " path"; break }
      }
    }
    if (why != "") print why ": " substr(line, 1, 160)
  }')
if [ -n "$hits" ]; then
  refuse "added lines that must not be published:"
  printf '%s\n' "$hits" | head -20 >&2
fi
exit $status

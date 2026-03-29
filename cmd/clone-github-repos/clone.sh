#!/usr/bin/env bash
# clone-all.sh — clone all repos across personal + org accounts
# Usage: ./clone-all.sh [base_dir]
# Requires: gh CLI authenticated (gh auth login)

set -euo pipefail

BASE_DIR="${1:-$HOME/repos}"
CLONE_METHOD="ssh"          # change to "https" if needed
PARALLEL=4                  # concurrent clones

# ── colours ──────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info()  { echo -e "${GREEN}[+]${NC} $*"; }
warn()  { echo -e "${YELLOW}[~]${NC} $*"; }
fail()  { echo -e "${RED}[!]${NC} $*"; }

# ── helpers ───────────────────────────────────────────────────────────────────
clone_or_update() {
  local owner="$1" repo="$2" dest="$3"

  if [[ "$CLONE_METHOD" == "ssh" ]]; then
    url="git@github.com:${owner}/${repo}.git"
  else
    url="https://github.com/${owner}/${repo}.git"
  fi

  if [[ -d "$dest/.git" ]]; then
    warn "already cloned — pulling: $dest"
    git -C "$dest" pull --ff-only --quiet 2>/dev/null || warn "pull skipped (dirty/diverged): $dest"
  else
    info "cloning ${owner}/${repo} → $dest"
    git clone --quiet "$url" "$dest"
  fi
}
export -f clone_or_update
export -f info warn fail
export CLONE_METHOD GREEN YELLOW RED NC

clone_scope() {
  local scope="$1"
  local owner="$2"
  local outdir="$3"

  mkdir -p "$outdir"
  info "fetching repo list for: $owner (${scope})"

  gh repo list "$owner" \
    --limit 200 \
    --json name,owner \
    --jq '.[] | [.owner.login, .name] | @tsv' \
  | while IFS=$'\t' read -r repo_owner repo_name; do
    dest="${outdir}/${repo_name}"
    echo "$repo_owner $repo_name $dest"
  done | xargs -P "$PARALLEL" -n 3 bash -c 'clone_or_update "$@"' _
}

# ── main ──────────────────────────────────────────────────────────────────────
main() {
  command -v gh  >/dev/null || { fail "gh CLI not found. Install: https://cli.github.com"; exit 1; }
  command -v git >/dev/null || { fail "git not found"; exit 1; }

  gh auth status >/dev/null 2>&1 || { fail "not authenticated. Run: gh auth login"; exit 1; }

  GH_USER=$(gh api user --jq '.login')
  info "authenticated as: $GH_USER"

  clone_scope "personal" "$GH_USER" "${BASE_DIR}/personal"

  info "fetching org memberships..."
  gh api "/user/orgs" --paginate --jq '.[].login' | while read -r org; do
    info "org found: $org"
    clone_scope "org" "$org" "${BASE_DIR}/orgs/${org}"
  done

  info "done. repos cloned to: $BASE_DIR"
  echo ""
  echo "layout:"
  find "$BASE_DIR" -maxdepth 3 -name ".git" -type d \
    | sed 's|/.git||' \
    | sed "s|${BASE_DIR}/||" \
    | sort
}

main "$@"
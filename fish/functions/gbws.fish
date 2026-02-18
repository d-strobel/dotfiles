#!/usr/bin/env fish

function gbws
  # Fuzzy find all git branches
  set -l selected (git branch -a --format='%(refname:short)' | sort -u | fzf --print-query --tmux bottom --border-label=" Git Branches ")
  if test -z "$selected"
    return
  end

  # Fzf returns 1 string:
  # Create new branch and worktree
  if test (count $selected) -eq 1; and test -n "$selected[1]"
    set -l selected_branch "$selected[1]"

    # Parse git project root directory
    set -l worktree_root (git worktree list | grep -E "(bare)" | awk '{print $1}')

    git worktree add -b $selected_branch "$worktree_root/$selected_branch"
    cd "$worktree_root/$selected_branch"
    return
  end

  # Fzf returns 2 strings:
  # Always use the second string
  set -l selected_branch "$selected[2]"

  # Find if the branch already exists in a worktree
  set -l existing_worktree (git worktree list | grep -E ".*\s+\[$selected_branch\]" | awk '{print $1}')

  # If the branch is already in a worktree, cd into it
  if test -n "$existing_worktree"
    cd "$existing_worktree"
    return
  end

  # Parse git project root directory
  set -l worktree_root (git worktree list | grep -E "(bare)" | awk '{print $1}')

  # Checkout the remote branch to a new worktree
  git worktree add "$worktree_root/$selected_branch" "$selected_branch"
  cd "$worktree_root/$selected_branch"
end

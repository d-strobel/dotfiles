#!/usr/bin/env fish

function fish_prompt
    set -l __last_command_exit_status $status

    # Import arrow functions if not already defined
    if not set -q -g __fish_arrow_functions_defined
        set -g __fish_arrow_functions_defined
        function _git_branch_name
            set -l branch (git symbolic-ref --quiet HEAD 2>/dev/null)
            if set -q branch[1]
                echo (string replace -r '^refs/heads/' '' $branch)
            else
                echo (git rev-parse --short HEAD 2>/dev/null)
            end
        end

        function _is_git_dirty
            not command git diff-index --cached --quiet HEAD -- &>/dev/null
            or not command git diff --no-ext-diff --quiet --exit-code &>/dev/null
        end

        function _is_git_repo
            type -q git
            or return 1
            git rev-parse --git-dir >/dev/null 2>&1
        end

        function _hg_branch_name
            echo (hg branch 2>/dev/null)
        end

        function _is_hg_dirty
            set -l stat (hg status -mard 2>/dev/null)
            test -n "$stat"
        end

        function _is_hg_repo
            fish_print_hg_root >/dev/null
        end

        function _repo_branch_name
            _$argv[1]_branch_name
        end

        function _is_repo_dirty
            _is_$argv[1]_dirty
        end

        function _repo_type
            if _is_hg_repo
                echo hg
                return 0
            else if _is_git_repo
                echo git
                return 0
            end
            return 1
        end
    end

    # Set colors
    set -l cyan (set_color -o cyan)
    set -l yellow (set_color -o yellow)
    set -l red (set_color -o red)
    set -l green (set_color -o green)
    set -l blue (set_color -o blue)
    set -l normal (set_color normal)
    set -l brpurple (set_color brpurple)

    # Set one blank line between prompts
    echo

    # First line: Full Path
    set -l cwd $cyan(prompt_pwd --full-length-dirs=4)

    set -l repo_info
    if set -l repo_type (_repo_type)
	# We change to basename only if we are in a git repository
        set cwd $cyan(prompt_pwd | path basename)

        set -l repo_branch $red(_repo_branch_name $repo_type)
        set repo_info "$blue $repo_type:($repo_branch$blue)"

        if _is_repo_dirty $repo_type
            set -l dirty "$yellow ✗"
            set repo_info "$repo_info$dirty"
        end
    end

    echo -n -s $cwd $repo_info $normal

    # Second line: Astronaut-style prompt
    set -l status_color (set_color brgreen)

    # Color the prompt differently when we're root
    set -l suffix '❯'
    if functions -q fish_is_root_user; and fish_is_root_user
        set suffix '#'
    end

    # Color the prompt in red on error
    if test $__last_command_exit_status -ne 0
        set status_color (set_color $fish_color_error)
    end

    echo
    echo -n -s $status_color $suffix ' ' $normal
end

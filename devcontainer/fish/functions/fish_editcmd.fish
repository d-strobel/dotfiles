function fish_editcmd --description "Edit current command line in \$EDITOR"
    set -l tmp (mktemp)

    # Save current command line
    commandline >$tmp

    # Open editor
    $EDITOR $tmp

    # Replace command line with edited contents
    if test $status -eq 0
        commandline -r (string join \n < $tmp)
    end

    rm -f $tmp

    # Move cursor to end
    commandline -f end-of-line
end

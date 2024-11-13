function ask-claude
  
# Get detailed system information for macOS
    if test (uname) = "Darwin"
        set os_type "macOS"
        set macos_version (sw_vers -productVersion)
        # Extract major version (e.g., 14 from 14.2.1 for Sonoma)
        set macos_major_version (string split '.' $macos_version)[1]
        
        # Map version number to name
        switch $macos_major_version
            case 15
                set macos_name "Ventura"
            case 14
                set macos_name "Sonoma"
            case 13
                set macos_name "Ventura"
            case 12
                set macos_name "Monterey"
            case 11
                set macos_name "Big Sur"
            case 10
                set macos_name "Catalina or earlier"
        end
        
        set system_detail "$os_type $macos_version ($macos_name)"
    else if test (uname) = "Linux"
        if test -f /etc/os-release
            set os_type (cat /etc/os-release | grep '^ID=' | cut -d'=' -f2 | tr -d '"')
            set os_version (cat /etc/os-release | grep '^VERSION_ID=' | cut -d'=' -f2 | tr -d '"')
            set system_detail "$os_type $os_version"
        else
            set system_detail "Linux"
        end
    else
        set system_detail (uname)
    end

    set shell_type (fish --version | string split ' ')[1]
    
    # More specific system instruction including OS version
    set system_instruction "Return commands suitable for copy/pasting into $shell_type shell on $system_detail. If $system_detail is Linux use distributon appropriate versions. If $system_detail is macOS, use version-appropriate commands. Do not include both. Do NOT include commentary NOR Markdown triple-backtick code blocks as your whole response will be copied into my terminal automatically. As such, your response should be just executable commands."
    
    set user_prompt (string join " " $argv)
   

    # Check if arguments were provided
    if test -z "$argv"
        echo "Error: No command specified"
        echo "Usage: ask-claude \"your command here\""
        return 1
    end

    # Check API key
    if test -z "$CLAUDE_API_KEY"
        set_color red
        echo "Error: CLAUDE_API_KEY is not set."
        set_color normal
        echo "Add this to your ~/.config/fish/config.fish file:"
        set_color green
        echo "set -gx CLAUDE_API_KEY \"your-api-key\""
        set_color normal
        return 1
    end

    # Validate API key format
    if not string match -q "sk-ant-*" "$CLAUDE_API_KEY"
        set_color red
        echo "Error: CLAUDE_API_KEY appears to be invalid."
        set_color normal
        echo "API key should start with 'sk-ant-'"
        return 1
    end

    # Check model
    if test -z "$CLAUDE_MODEL"
        set_color red
        echo "Error: CLAUDE_MODEL is not set."
        set_color normal
        echo "Add this to your ~/.config/fish/config.fish file:"
        set_color green
        echo "set -gx CLAUDE_MODEL \"claude-3-sonnet-20240229\""
        set_color normal
        return 1
    end

    # Validate model format
    if not string match -q "claude-3-*" "$CLAUDE_MODEL"
        set_color red
        echo "Error: CLAUDE_MODEL appears to be invalid."
        set_color normal
        echo "Model should be something like 'claude-3-sonnet-20240229'"
        return 1
    end
       
    set cmd (curl -s \
    "https://api.anthropic.com/v1/messages" \
    -H "x-api-key: $CLAUDE_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -H "content-type: application/json" \
    -d "{
        \"model\":\"$CLAUDE_MODEL\",
        \"max_tokens\":1024,
        \"system\":\"$system_instruction\",
        \"messages\":[
            {\"role\":\"user\",\"content\":\"$user_prompt\"}
        ]
    }" | jq -r '.content[0].text')
    
    # Put the command on the command line but don't execute
    commandline $cmd
    commandline -f repaint
end

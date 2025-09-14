#!/bin/bash
# linside.sh - Kill any session using 'who' (fallback for systems where 'w' fails), show full details

while true; do
    echo "==============================="
    echo " Active Sessions (from who):"
    echo "==============================="

    # Get active sessions using 'who'
    sessions=$(who)

    # Check if any sessions are active
    if [ -z "$sessions" ]; then
        echo "⚠ No active sessions found."
        exit 0
    fi

    # Display numbered sessions with full columns
    echo "$sessions" | nl -w2 -s'. '

    echo "0. Exit"
    echo "-------------------------------"

    # Prompt user for session number to kill
    read -p "Enter session number to kill: " choice

    # Exit if the user chooses option 0
    if [ "$choice" == "0" ]; then
        echo "Bye 👋"
        exit 0
    fi

    # Extract TTY and other details of selected session
    session=$(echo "$sessions" | sed -n "${choice}p" | awk '{print $2}')
    ip=$(echo "$sessions" | sed -n "${choice}p" | awk '{print $3}')
    from=$(echo "$sessions" | sed -n "${choice}p" | awk '{print $5}')

    # Validate if session exists
    if [ -z "$session" ]; then
        echo "❌ Invalid choice!"
        continue
    fi

    # Display the session details to be killed
    echo "Killing session on TTY: $session (IP: $ip)"

    # Kill the session (using sudo if necessary)
    pkill -kill -t "$session"
    echo "✅ Session $session from $ip terminated."

    echo "Killing session on TTY: $session (FROM: $from)"  # Changed 'IP' to 'FROM'
    sudo pkill -kill -t "$session"  # Added 'sudo' for reliability (may need it for killing)
    echo "✅ Session $session from $from terminated."

done

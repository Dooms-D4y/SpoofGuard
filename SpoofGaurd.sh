#!/bin/bash

#!/bin/bash

banner() {
    echo -e "\e[1;32m"
    cat << "EOF"
  _________                     _____  ________
 /   _____/_____   ____   _____/ ____\/  _____/ __ _______ _______  __| _/
 \_____  \ \____ \ /  _ \ /  _ \   __\/   \  ___|  |  \__  \_  __ \/ __ |
 /        \  |_> >  <_> |  <_> )  |  \    \_\  \  |  // __ \|  | \/ /_/ |
/_______  /   __/ \____/ \____/|__|   \______  /____/(____  /__|  \____ |
        \/|__|                               \/           \/           \/
EOF
    echo -e "\e[0m"
    echo -e "\e[1;33m===================================\e[0m"
    echo -e "\e[1;36mSpoofGuard - Email Spoofing Checker\e[0m"
    echo -e "\e[1;33m===================================\e[0m"
    echo -e "\e[1;34m╔═══════════════════════════════════════╗\e[0m"
    echo -e "\e[1;34m║  \e[1;32mAuthor:\e[0m D00ms D4y\e[0m"
    echo -e "\e[1;34m║  \e[1;32mContact:\e[0m kakashimodieshi@gmail.com\e[0m"
    echo -e "\e[1;34m╚═══════════════════════════════════════╝\e[0m"
    echo ""
}





print_help() {
    echo -e "Usage: $0 \e[1;33m[-h] [-d/--domain <domain>] [-f/--file <path_to_file>]\e[0m"
    echo -e "\nOptions:"
    echo -e "  -h, --help \t\tShow this help message and exit"
    echo -e "  -d, --domain URL \tURL of the website to check"
    echo -e "  -f, --file PATH \tPath to a text file containing a list of domains to check"
    exit 0
}

check_spf() {
    domain=$1
    echo -e "\e[1;34m[*]Searching for SPF Record for \e[1;36m$domain\e[0m..."
    echo " "
    sleep 2
    spf_record=$(dig +short -t TXT "$domain" | grep "v=spf1")

    if [ -z "$spf_record" ]; then
        echo -e "\e[1;31m[x]No SPF record found for \e[1;36m$domain\e[0m"
        return 1
    fi

    echo -e "\e[1;32m[√]Found SPF record for \e[1;36m$domain\e[0m:"
    echo "$spf_record"
    echo " "

    # Check if the SPF record contains "~all" or "-all"
    echo -e "\e[1;33m[*]Checking SPF record strength...\e[0m"
    sleep 2
    if [[ "$spf_record" == *"~all"* || "$spf_record" == *"-all"* ]]; then
        echo -e "\e[1;32m[√]SPF record is strong.\e[0m"
    else
        echo -e "\e[1;31m[x]SPF record is weak. Spoofing possible for \e[1;36m$domain\e[0m!\e[0m"
        return 1
    fi
}

check_dmarc() {
    domain=$1
    echo -e "\e[1;34m[*]Searching for DMARC Record for \e[1;36m$domain\e[0m..."
    sleep 2
    echo " "
    dmarc_record=$(dig +short -t TXT "_dmarc.$domain")

    if [ -z "$dmarc_record" ]; then
        echo -e "\e[1;31m[x]No DMARC record found for \e[1;36m$domain\e[0m"
        return 1
    fi

    echo -e "\e[1;32m[√]Found DMARC record for \e[1;36m$domain\e[0m:"
    echo "$dmarc_record"

    # Check if the DMARC record contains "p=reject" or "p=quarantine"
    echo -e "\e[1;33m[*]Checking DMARC record strength...\e[0m"
    sleep 2
    if [[ "$dmarc_record" == *"p=reject"* || "$dmarc_record" == *"p=quarantine"* ]]; then
        echo -e "\e[1;32m[√]DMARC record is strong.\e[0m"
    else
        echo -e "\e[1;31m[!]DMARC record is weak. Spoofing possible for \e[1;36m$domain\e[0m!\e[0m"
        return 1
    fi
}

main() {
    if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
        print_help
    fi

    domain=$1

    if [ -z "$domain" ]; then
        echo -e "\e[1;31m[!]No domain provided. Use -h for help.\e[0m"
        exit 1
    fi

    check_spf "$domain" && check_dmarc "$domain"
    result=$?

    if [ $result -eq 0 ]; then
        echo -e "\e[1;32mSpoofing not possible for \e[1;36m$domain\e[0m.\e[0m"
    fi
}

check_file() {
    file_path=$1

    while IFS= read -r domain; do
        echo -e "\n\e[1;34m[*]Checking domain: \e[1;36m$domain\e[0m"
        main "$domain"
    done < "$file_path"
}

while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -d|--domain)
            domain="$2"
            main "$domain"
            exit 0
            ;;
        -f|--file)
            file_path="$2"
            check_file "$file_path"
            exit 0
            ;;
        *)
            echo -e "\e[1;31m[x]Invalid option: $1. Use -h for help.\e[0m"
            exit 1
            ;;
    esac
done
banner
print_help


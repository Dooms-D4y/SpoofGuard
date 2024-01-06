# SpoofGaurd

# Overview 
SpoofGuard is a bash script designed to check the email security configurations of a domain. It specifically focuses on SPF and DMARC records to assess the vulnerability of a domain to email spoofing. 

# Features 

* Checks for the presence and strength of SPF records.
* Examines DMARC records, evaluating policies and organizational configurations.
* Provides a simple verdict on whether spoofing is possible for a given domain.

# Prerequisite 
* Bash
* dig utility (usually included in DNS-related packages)

# Installation 

https://github.com/Dooms-D4y/SpoofGaurd.git

cd SpoofGaurd 

chmod +x SpoofGaurd.sh

./SpoofGaurd.sh

# Usage 
# Check a single domain 
./Spoofchecker.sh -d Google.com

# Check Domains from a file
./SpoofGaurd.sh -f domains.txt

# Help 

Just specify ./SpoofGaurd.sh 

# Notes
* Lack of an SPF or DMARC record contributes to a weak configuration.
* A strong SPF record should specify ~all or -all.
* A strong DMARC policy should be set to p=reject or p=quarantine.



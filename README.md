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

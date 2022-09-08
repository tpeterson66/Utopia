# Palo Alto External Dynamic Lists for Azure

Recently, Palo Alto dropped support for their open source solution for managing external dynamic lists. Exteranl Dynamic Lists are important as they allow you to configure security rules based on a source of IP address/FQDNs/URLs for a specific service, which changes overtime. 

Palo released a list of EDL sites which can be used to obtain the public IP address/FQDNs/URLs for Azure specific services or all of Azure based on specific cloud types (commerical/gov). These can be added to your configuration to allow traffic to Azure services when running Palo Alto firewalls in Azure.

* [EDL from Palo](https://docs.paloaltonetworks.com/resources/edl-hosting-service)

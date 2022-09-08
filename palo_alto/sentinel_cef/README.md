# Azure Sentinel with Palo Alto Firewalls

Exporting the logs from Palo Alto to Azure Sentinel requires a Linux syslog server running in Azure connected to log analytics which feeds Sentinel. That configuration is clearly documented in the Palo Alto connector page for Azure Sentinel. WHen configuring the Palo Alto firewalls to export the logs to the syslog server, there is some rough documentation from Palo on how to configured this.

Essentially, the logs have to be configured for CEF format, which requires the syslog configuraiton of the Palo config to be setup to support his format. When reading the [documentation](https://docs.paloaltonetworks.com/content/dam/techdocs/en_US/pdf/cef/pan-os-10-0-cef-configuration-guide.pdf), the instructions are unclear and causes problems during the deployment.

I've taken the content and condensed it down to a single line, which is required for the configuration, and stored the files [here](https://github.com/tpeterson66/Utopia/tree/main/palo_alto). Copy the single line configuration into the respective locations to setup the log export correctly for Sentinel. Wait 10-15 minutes and verify the logs are showing up correclty in Sentinel!

There is no seperate configuration file for 10.1 or 10.2, however, if you copy out the black text only, you can get this to work just fine. The config files provided is only the black text from the documentation per the requirements.

# Azure Gateway Load Balancers

Azure just recently released their [Gateway Load Balancer](https://docs.microsoft.com/en-us/azure/load-balancer/gateway-overview). This is the answer to a lot of problems that come up when deploying network virtual appliances in Azure (and other public clouds).

The biggest complaint when routing ingress workflows through an active/active pair of NVA's is that traffic must be SNAT'd to a specific firewall to ensure the return traffic is routed back to the same firewall as the inital traffic flow. This is only a consideration for inbound workloads as the traffic is passed through two seperate load balancers, once on the untrust or public side and then again on the trust side. 

Since all traffic is SNAT'd, the applications never see the true public IP address of the client, therefore skewing logs and metrics.

The Gateway Load Balancer resolves these problems by adding a bump in the wire to the inital traffic flow, therefore keeping the traffic flow intact while still allowing the NVAs to filter the traffic.

## Palo Alto Firewalls

Palo Alto has adopted this solution pattern and supports the current Azure Gateway Load Balancer deployment. There is some additional configuration required to get this working on Azure using Palo firewalls, however, it is worth it if ingress is required for the deployment.

Here are some links for additional inforamtion pertaining to Palo Alto firewalls using Gateway Load Balancers.

* [Github Templates](https://github.com/PaloAltoNetworks/Azure-GWLB)
* [Palo Documentation](https://docs.paloaltonetworks.com/vm-series/10-1/vm-series-deployment/set-up-the-vm-series-firewall-on-azure/deploy-the-vm-series-firewall-with-the-azure-gwlb)
* [Palo Guides](https://www.paloaltonetworks.com/resources/guides/azure-architecture-guide)

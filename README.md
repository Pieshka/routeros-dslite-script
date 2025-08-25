# DHCPv6 Script for automatic AFTR domain retrieval on MikroTik RouterOS

This  repository  contains  a  script  that  enables  automatic  downloading  and  setting  of  the  CG-NAT  AFTR  domain  in  an  IPIPv6  tunnel  based  on  information  received  from  the  operator's  DHCPv6  server.

## Installation

Installing  the  script  on  your  system  is  very  simple.

1.  First,  prepare  all  the  necessary  interfaces:  PPPoE  client/DHCPv6  client  and  IPIPv6  tunnel.

2.  Configure  the  DHCPv6  client  according  to  your  operator's  recommendations.  Most  often,  you  need  to  set  `Request`  to  `prefix`

3. In the `Client Options` tab in the `DHCPv6 Client` section, create a new option with the following parameters:
* **Name**: `OPTION_AFTR_NAME_REQ`
* **Code**: `6`
* **Value**: `0x0040`

4. In the created DHCPv6 client, go to the `Advanced` tab and add the previously created option in the `DHCP Options` field.

5. In the `script` field, paste the script from this repository. Change the `tunnelName`, `fallbackAFTR` and `AFTRDNSServer` variables according to your preferences.

6. Save the changes. From now on, you should have dynamic retrieval of the AFTR router domain from your operator.


If you don't know what to enter in `fallbackAFTR`, simply delete the entire section related to fallback and set the AFTR domain blindly. It exists because, in the case of my operator, the assigned AFTR router stopped working for a few hours, and since my operator's AFTR domains are known, I decided to add a fallback to a router from another city. :P

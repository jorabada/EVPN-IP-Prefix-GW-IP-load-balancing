# IP Prefix route GW-IP load balancing and EVPN-IFL vxlan interdomain



This lab demonstrates:
- IP prefix route GW-IP load balancing
- EVPN-IFL vxlan interdomain connectivity
- eBGP underlay and overlay

The topology consists of:
- 2 PODs with leaf-spine architecture
- Linux hosts connected to leaves for testing
- VRF and dummy interfaces configured on hosts

Key configuration elements:
- Underlay: eBGP unnumbered peering between leafs and spines
- Overlay: eBGP EVPN with inter-domain connectivity
- Load balancing across multiple gateway IPs
- VRF and VXLAN tunnels for tenant isolation

Servers are configured with a vrf that contains the virtual IP subnet that the controllers advertise:

```
[*]─[s341]─[/]
└──> ip vrf show
Name              Table
-----------------------
clab-vrf             1

[x]─[s341]─[/]
└──> ip add show vrf clab-vrf
2: lo1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue master clab-vrf state UNKNOWN group default qlen 1000
    link/ether 1e:07:7d:96:b7:3d brd ff:ff:ff:ff:ff:ff
    inet 99.99.99.1/24 scope global lo1
       valid_lft forever preferred_lft forever
    inet6 fe80::1c07:7dff:fe96:b73d/64 scope link 
       valid_lft forever preferred_lft forever
1796: eth1@if1797: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9500 qdisc noqueue master clab-vrf state UP group default 
    link/ether aa:c1:ab:a2:6d:b9 brd ff:ff:ff:ff:ff:ff link-netnsid 1
    inet 10.0.34.1/24 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::a8c1:abff:fea2:6db9/64 scope link 
       valid_lft forever preferred_lft forever

[*]─[s341]─[/]
└──> ip route show table 1
default via 10.0.34.254 dev eth1 
10.0.34.0/24 dev eth1 proto kernel scope link src 10.0.34.1 
local 10.0.34.1 dev eth1 proto kernel scope host src 10.0.34.1 
broadcast 10.0.34.255 dev eth1 proto kernel scope link src 10.0.34.1 
99.99.99.0/24 dev lo1 proto kernel scope link src 99.99.99.1 
local 99.99.99.1 dev lo1 proto kernel scope host src 99.99.99.1 
broadcast 99.99.99.255 dev lo1 proto kernel scope link src 99.99.99.1 
```

Pings from servers can be triggered as follows:

```
*]─[s341]─[/]
└──> ip vrf exec clab-vrf ping 10.0.34.254 
PING 10.0.34.254 (10.0.34.254) 56(84) bytes of data.
64 bytes from 10.0.34.254: icmp_seq=1 ttl=64 time=4.11 ms
64 bytes from 10.0.34.254: icmp_seq=2 ttl=64 time=1.60 ms
64 bytes from 10.0.34.254: icmp_seq=3 ttl=64 time=1.71 ms
^C
```
The following alias is used to display traces:

```
environment alias display-trace "bash viewlog -f /var/log/srlinux/debug/trace_events_other.log -t -e {}"
```


![](3-stage-clos.clab.drawio.png)

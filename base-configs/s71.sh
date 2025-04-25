ip addr add 10.0.71.1/24 dev eth1
ip link add clab-vrf type vrf table 1
ip link set dev clab-vrf up
ip link set dev eth1 master clab-vrf
ip route add 0.0.0.0/0 via 10.0.71.254 table 1
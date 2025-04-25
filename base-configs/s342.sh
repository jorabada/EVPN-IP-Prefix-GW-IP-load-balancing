ip addr add 10.0.34.2/24 dev eth1
ip link add lo1 type dummy
ip addr add 99.99.99.1/24 dev lo1
ip link set lo1 up
ip link add clab-vrf type vrf table 1
ip link set dev clab-vrf up
ip link set dev eth1 master clab-vrf
ip link set dev lo1 master clab-vrf
ip route add 0.0.0.0/0 via 10.0.34.254 table 1
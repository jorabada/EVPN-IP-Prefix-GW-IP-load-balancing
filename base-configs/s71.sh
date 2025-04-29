ip addr add 10.0.71.1/24 dev eth1
ip route del default
ip route add 0.0.0.0/0 via 10.0.71.254
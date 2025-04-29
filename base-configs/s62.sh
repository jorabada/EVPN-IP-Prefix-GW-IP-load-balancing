ip addr add 10.0.62.1/24 dev eth1
ip link add lo1 type dummy
ip addr add 88.88.88.1/24 dev lo1
ip link set lo1 up
ip route del default
ip route add 0.0.0.0/0 via 10.0.62.254
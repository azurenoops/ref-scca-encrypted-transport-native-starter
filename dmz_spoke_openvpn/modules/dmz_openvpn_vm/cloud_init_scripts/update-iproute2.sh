#!/bin/bash
chmod 777 /etc/iproute2/rt_tables
echo "100 openvpn-route" >> /etc/iproute2/rt_tables
chmod 644 /etc/iproute2/rt_tables


chmod 777 /etc/sysctl.conf
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
chmod 644 /etc/sysctl.conf
sysctl net.ipv4.ip_forward=1
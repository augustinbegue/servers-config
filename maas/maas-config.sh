maas createadmin --username admin --password admin --email admin
export APIKEY=$(maas apikey --username admin)
maas login admin 'http://localhost:5240/MAAS/' $APIKEY

export SUBNET=10.10.10.0/24
export FABRIC_ID=$(maas admin subnet read "$SUBNET" | jq -r ".vlan.fabric_id")
export VLAN_TAG=$(maas admin subnet read "$SUBNET" | jq -r ".vlan.vid")
export PRIMARY_RACK=$(maas admin rack-controllers read | jq -r ".[] | .system_id")
maas admin subnet update $SUBNET gateway_ip=10.10.10.1
maas admin ipranges create type=dynamic start_ip=10.10.10.200 end_ip=10.10.10.254
maas admin vlan update $FABRIC_ID $VLAN_TAG dhcp_on=True primary_rack=$PRIMARY_RACK
maas admin maas set-config name=upstream_dns value=8.8.8.8

maas admin vm-hosts create  password=password  type=lxd power_address=https://${IP_ADDRESS}:8443 project=maas

ssh-keygen -q -t rsa -N "" -f "/home/abegue/.ssh/id_rsa"
chmod 777 /home/abegue/.ssh/id_rsa.pub
chmod 777 /home/abegue/.ssh/id_rsa
maas admin sshkeys create key="$(cat /home/abegue/.ssh/id_rsa.pub)"

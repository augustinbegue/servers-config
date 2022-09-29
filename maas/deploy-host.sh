snap install --channel=3.2 maas
snap install lxd
snap refresh lxd

cat /home/abegue/maas/deploy-scripts/docker.sh | bash
cat /home/abegue/maas/deploy-scripts/postgres.sh | bash

export MAAS_DBUSER=maas_user
export MAAS_DBPASS=labzaq
export MAAS_DBNAME=maas_db
export HOSTNAME=localhost
sudo -u postgres psql -c "CREATE USER \"$MAAS_DBUSER\" WITH ENCRYPTED PASSWORD '$MAAS_DBPASS'"
sudo -u postgres createdb -O "$MAAS_DBUSER" "$MAAS_DBNAME"
echo "host    $MAAS_DBNAME    $MAAS_DBUSER    0/0     md5" >> /etc/postgresql/14/main/pg_hba.conf

apt install jq -y

export IP_ADDRESS=$(ip -j route show default | jq -r '.[].prefsrc')
export INTERFACE=$(ip -j route show default | jq -r '.[].dev')
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sysctl -p
iptables -t nat -A POSTROUTING -o $INTERFACE -j SNAT --to $IP_ADDRESS

echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
apt-get install iptables-persistent -y

cat /home/abegue/maas/lxd.cfg | lxd init --preseed
lxd waitready

maas init region+rack --database-uri "postgres://$MAAS_DBUSER:$MAAS_DBPASS@$HOSTNAME/$MAAS_DBNAME"

# Get Postgres Official repo
apt install wget ca-certificates
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'

# Install Postgres
apt update
apt install postgresql postgresql-contrib
service postgresql start

# Set Default Password
sudo -u postgres psql --command="ALTER USER postgres PASSWORD 'postgres';"

# Alter Config Files
echo "listen_addresses = '*'" >> /etc/postgresql/14/main/postgresql.conf
echo "host all all 0.0.0.0/0 md5" > /etc/postgresql/14/main/pg_hba.conf

# Finish
systemctl restart postgresql

ss -ntl | grep 5432
if $? == 0
then
	echo "Postgres deployment successfull"
else
	echo "Postgres deployment failed"
	return 1

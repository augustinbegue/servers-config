echo "alias config='/usr/bin/git --git-dir=/home/abegue/.cfg/ --work-tree=/home/abegue'" >> /home/abegue/.bashrc
echo ".cfg" >> .gitignore
git clone --bare https://github.com/augustinbegue/servers-config /home/abegue/.cfg
/usr/bin/git --git-dir=/home/abegue/.cfg/ --work-tree=/home/abegue checkout

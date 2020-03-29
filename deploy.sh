#! /bin/bash
sudo apt update 
sudo apt dist-upgrade -y
sudo apt install apache2 mysql-server php-zip zip  php-curl php-mysql tree mc vim libapache2-mod-php python3-dev unzip wget w3m build-essential -y 
sudo apt purge cloud-init -y 
sudo apt clean

wget https://bootstrap.pypa.io/get-pip.py
sudo -H python3 get-pip.py
rm get-pip.py

sudo -H pip install virtualenv
mkdir $HOME/pythonista
virtualenv $HOME/pythonista
source $HOME/pythonista/bin/activate
pip install notebook bash-kernel
python -m bash_kernel.install
jupyter notebook --generate-config
cp jupyter_notebook_config.json $HOME/.jupyter/

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.5/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install 10
npm install -g yarn
npm install -g ijavascript
ijsinstall

sudo mkdir /opt/oi
sudo chown -R oi:oi /opt/oi

echo -e "#! /bin/bash\nsource $HOME/pythonista/bin/activate\nsource $HOME/.nvm/nvm.sh\njupyter notebook --ip=0.0.0.0 --no-browser" > $HOME/jupyter.sh
chmod +x $HOME/jupyter.sh
echo -e "[Unit]\nDescription=Jupyter Notebook\n\n[Service]\nType=simple\nPIDFile=/run/jupyter.pid\nExecStart=/home/oi/jupyter.sh\nUser=oi\nGroup=oi\nWorkingDirectory=/opt/oi/\nRestart=always\nRestartSec=10\n\n[Install]\nWantedBy=multi-user.target" > jupyter.service
sudo mv jupyter.service /lib/systemd/system/
sudo systemctl enable jupyter.service

sudo mysql -u root -proot -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '0p3n5t4ck';"
wget https://github.com/vrana/adminer/releases/download/v4.7.6/adminer-4.7.6.php
sudo mv adminer-4.7.6.php /var/www/html/adminer.php

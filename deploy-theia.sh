#! /bin/bash

sudo apt update 
sudo apt dist-upgrade -y
sudo apt install apache2 mariadb-server curl php-zip zip php-curl php-mysql tree mc vim libapache2-mod-php python3-dev unzip wget w3m build-essential -y 
# sudo apt purge cloud-init -y 
sudo apt clean
sudo apt autoremove 

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

mkdir $HOME/ide
cp package.json $HOME/ide/package.json
cd $HOME/ide/
yarn
yarn theia build
yarn theia download:plugins
echo "export THEIA_DEFAULT_PLUGINS=local-dir:$HOME/ide/plugins" >> $HOME/.bashrc
export THEIA_DEFAULT_PLUGINS=local-dir:$HOME/ide/plugins

sudo mkdir /opt/oi
sudo chown -R oi:oi /opt/oi

echo -e "#! /bin/bash\nsource $HOME/.nvm/nvm.sh\ncd $HOME/ide\nyarn theia start /opt/oi --hostname=0.0.0.0" > $HOME/theia.sh
chmod +x $HOME/theia.sh
echo -e "[Unit]\nDescription=Theia IDE\n\n[Service]\nType=simple\nPIDFile=/run/theia.pid\nEnvironment=THEIA_DEFAULT_PLUGINS=local-dir:/home/oi/ide/plugins\nExecStart=/home/oi/theia.sh\nUser=oi\nGroup=oi\nWorkingDirectory=/home/oi/ide/\nRestart=always\nRestartSec=10\n\n[Install]\nWantedBy=multi-user.target" > $HOME/theia.service
sudo mv $HOME/theia.service /lib/systemd/system/
sudo systemctl enable theia.service

echo -e "#! /bin/bash\nsource $HOME/pythonista/bin/activate\nsource $HOME/.nvm/nvm.sh\njupyter notebook --ip=0.0.0.0 --no-browser" > $HOME/jupyter.sh
chmod +x $HOME/jupyter.sh
echo -e "[Unit]\nDescription=Jupyter Notebook\n\n[Service]\nType=simple\nPIDFile=/run/jupyter.pid\nExecStart=/home/oi/jupyter.sh\nUser=oi\nGroup=oi\nWorkingDirectory=/opt/oi/\nRestart=always\nRestartSec=10\n\n[Install]\nWantedBy=multi-user.target" > jupyter.service
sudo mv jupyter.service /lib/systemd/system/
sudo systemctl enable jupyter.service

wget https://github.com/vrana/adminer/releases/download/v4.7.7/adminer-4.7.7.php
sudo mv adminer-4.7.7.php /var/www/html/adminer.php

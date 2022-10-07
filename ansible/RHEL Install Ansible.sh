echo "Get Yum Updates"
sudo yum update -y

echo "Install Python3"
# current 3.6.8 from yum
sudo yum install -y python3


echo "Install Ansible"
pip3 install ansible pywinrm

echo "Install Windows Ansible Galaxy"


          sudo apt install python3-pip -y
          sudo -H pip3 install ansible
          sudo -H pip3 install pywinrm
          sudo ansible-galaxy collection install ansible.windows
          sudo DEBIAN_FRONTEND=noninteractive apt-get -yqq install python-dev
          sudo DEBIAN_FRONTEND=noninteractive apt-get -yqq install libkrb5-dev 
          sudo DEBIAN_FRONTEND=noninteractive apt-get -yqq install krb5-user
          sudo -H pip3 install pywinrm[kerberos]



# install python 3.7
sudo yum install gcc openssl-devel bzip2-devel libffi-devel zlib-devel xz-devel 
wget https://www.python.org/ftp/python/3.7.11/Python-3.7.11.tgz  
tar xzf Python-3.7.11.tgz 
cd Python-3.7.11 
./configure --enable-optimizations 
make altinstall 
rm ~/Python-3.7.11.tgz


# Install latest Python 3.8.9
sudo yum install -y gcc openssl-devel bzip2-devel libffi-devel zlib-devel xz-devel wget
cd /usr/src
sudo wget https://www.python.org/ftp/python/3.9.13/Python-3.9.13.tgz
sudo tar xzf Python-3.9.13.tgz
cd Python-3.9.13
sudo ./configure --enable-optimizations
sudo make altinstall
cd ~
sudo rm /usr/src/Python-3.9.13.tgz

# update alias
alias python="/usr/local/bin/python3.9"

# uprade pip
hash -r
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py --user

# install ansible
python -m pip install --user ansible-core==2.13.2
ansible-galaxy collection install ansible.windows
python -m pip install --user pywinrm[kerberos]
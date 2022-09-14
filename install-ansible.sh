sudo apt update
sudo apt upgrade -y
sudo apt install software-properties-common -y
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible -y
sudo apt install python3-argcomplete -y
sudo activate-global-python-argcomplete3
ansible --version
git clone https://github.com/tpeterson66/Utopia.git
ansible-playbook Utopia/ansible/playbook.yml
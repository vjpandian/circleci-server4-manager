echo "----------------------------------------"
echo "        Installing Terraform"
echo "----------------------------------------"   
sudo rm -rf terraform/
sudo apt install unzip zip -y
curl -fLSs "https://releases.hashicorp.com/terraform/1.8.2/terraform_1.8.2_linux_amd64.zip" -o "terraform_1.8.2.zip"
sudo unzip -o terraform_1.8.2.zip
sudo mv terraform /usr/local/bin/

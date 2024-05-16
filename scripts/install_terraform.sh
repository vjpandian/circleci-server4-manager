echo "----------------------------------------"
echo "        Installing Terraform"
echo "----------------------------------------"   
-fLSs
sudo rm -rf terraform/
sudo apt install unzip zip -y
curl -fLSs "https://releases.hashicorp.com/terraform/$TF_VERSION/terraform_$TF_VERSION_linux_amd64.zip" -o "terraform_$TF_VERSION.zip"
sudo unzip -o terraform_$TF_VERSION.zip
sudo mv terraform /usr/local/bin/

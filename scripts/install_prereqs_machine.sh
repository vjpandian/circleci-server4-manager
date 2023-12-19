echo "----------------------------------------"
echo "        Installing Helm"
echo "----------------------------------------"
curl -LO https://get.helm.sh/helm-v3.11.2-linux-amd64.tar.gz
tar -zxvf helm-v3.11.2-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
helm version


sudo apt install unzip zip -y
curl "https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip" -o "terraform_1.6.0.zip"
sudo unzip -o terraform_1.6.0.zip
ls -lah

echo "----------------------------------------"
echo "        Installing Helm-Diff"
echo "----------------------------------------"
helm plugin install https://github.com/databus23/helm-diff


echo "----------------------------------------"
echo "        Installing kubectl"
echo "----------------------------------------"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

echo "----------------------------------------"
echo "        Installing eksctl"
echo "----------------------------------------"
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

echo "----------------------------------------"
echo "        Installing Terraform"
echo "----------------------------------------"   


Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-22.04"


  config.vm.define "jenkins-server" do |server|
    server.vm.hostname = "jenkins-server"
    server.vm.network "private_network", ip: "192.168.56.10"
    server.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = 2
    end
    server.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update
      sudo apt-get install -y openjdk-17-jdk
      curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
        /usr/share/keyrings/jenkins-keyring.asc > /dev/null
      echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
        https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
        /etc/apt/sources.list.d/jenkins.list > /dev/null

      sudo apt-get update
      sudo apt-get install -y jenkins
      sudo systemctl enable --now jenkins
      sudo apt-get install -y docker.io
      curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
      sudo apt-get install -y nodejs

      sudo usermod -aG docker jenkins

      sudo systemctl restart jenkins
    SHELL
  end





  config.vm.define "jenkins-agent" do |agent|
    agent.vm.hostname = "jenkins-agent"
    agent.vm.network "private_network", ip: "192.168.56.11"
    agent.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = 2
    end
    agent.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update
      sudo apt-get install -y openjdk-17-jdk
      sudo apt-get install -y docker.io
      sudo usermod -aG docker vagrant

      sudo systemctl restart docker
    SHELL
  end

end

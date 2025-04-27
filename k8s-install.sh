Vagrant.configure("2") do |config|
  # base Ubuntu image for the VM
  config.vm.box = "ubuntu/bionic64"

  # Provision the VM using a shell script
  config.vm.provision "shell", inline: <<-SHELL
    # Download the Kubernetes install script
    wget https://raw.githubusercontent.com/jphasha/ShellScripts/main/k8s-install.sh -O /tmp/k8s-install.sh

    # Make the script executable
    sudo chmod +x /tmp/k8s-install.sh

    # Run the script
    sudo /tmp/k8s-install.sh
  SHELL
  
end
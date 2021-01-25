resource "aws_instance" "quest-demo" {
  ami                    = var.ami-id
  iam_instance_profile   = var.iam-instance-profile
  instance_type          = var.instance-type
  key_name               = var.key-pair
  private_ip             = var.private-ip
  subnet_id              = var.subnet-id
  vpc_security_group_ids = var.vpc-security-group-ids

  user_data = <<EOF
#!/bin/bash
cd /tmp
echo '#!/bin/bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
. ~/.nvm/nvm.sh
nvm install node
curl -o master.zip -L https://github.com/rearc/quest/archive/master.zip
unzip master.zip
npm install --prefix quest-master
npm start --prefix quest-master
' >> init.sh
chmod +x init.sh
/bin/su -c "/tmp/init.sh" - ec2-user
EOF
}

resource "aws_eip" "quest-demo-node-server-eip" {
  instance = aws_instance.quest-demo.id
}

resource "null_resource" "wait_for_node" {
  connection {
    host  = aws_eip.quest-demo-node-server-eip.public_ip
    user = "ec2-user"
    type = "ssh"
  }

  provisioner "remote-exec" {
    inline = [
      "while [[ ! $(netstat -lnt | grep 3000) ]]; do sleep 2; done"
    ]
  }
}

#AutoScaling Launch Configuration
resource "aws_launch_configuration" "wwealb-launchconfig" {
  name_prefix     = "wwealb-launchconfig"
  image_id        = lookup(var.AMIS, var.AWS_REGION)
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.wwealb_key.key_name
  security_groups = [aws_security_group.wwealb-instance.id]
  user_data       = "apt update \apt install openjdk-11-jre-headless \groupadd --system tomcat \useradd -d /usr/share/tomcat -r -s /bin/false -g tomcat tomcat \yum -y install wget \export VER="9.0.75" \wget https://archive.apache.org/dist/tomcat/tomcat-9/v${VER}/bin/apache-tomcat-${VER}.tar.gz \tar xvf apache-tomcat-${VER}.tar.gz -C /usr/share/ \ln -s /usr/share/apache-tomcat-$VER/ /usr/share/tomcat \chown -R tomcat:tomcat /usr/share/tomcat \chown -R tomcat:tomcat /usr/share/apache-tomcat-$VER/ \tee /etc/systemd/system/tomcat.service<<EOF
[Unit]
Description=Tomcat Server
After=syslog.target network.target

[Service]
Type=forking
User=tomcat
Group=tomcat

Environment=JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
Environment='JAVA_OPTS=-Djava.awt.headless=true'
Environment=CATALINA_HOME=/usr/share/tomcat
Environment=CATALINA_BASE=/usr/share/tomcat
Environment=CATALINA_PID=/usr/share/tomcat/temp/tomcat.pid
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M'
ExecStart=/usr/share/tomcat/bin/catalina.sh start
ExecStop=/usr/share/tomcat/bin/catalina.sh stop

[Install]
WantedBy=multi-user.target
EOF \systemctl daemon-reload \systemctl start tomcat \systemctl enable tomcat \systemctl status tomcat "

  lifecycle {
    create_before_destroy = true
  }
}

#Generate Key
resource "aws_key_pair" "wwealb_key" {
    key_name = "wwealb_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

#Autoscaling Group
resource "aws_autoscaling_group" "wwealb-autoscaling" {
  name                      = "wwealb-autoscaling"
  vpc_zone_identifier       = [aws_subnet.wwealbvpc-public-1.id, aws_subnet.wwealbvpc-public-2.id]
  launch_configuration      = aws_launch_configuration.wwealb-launchconfig.name
  min_size                  = 2
  max_size                  = 2
  health_check_grace_period = 200
  health_check_type         = "ELB"
  load_balancers            = [aws_elb.wwealb-elb.name]
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "wwealb Custom EC2 instance via LB"
    propagate_at_launch = true
  }
}

output "ELB" {
  value = aws_elb.wwealb-elb.dns_name
}
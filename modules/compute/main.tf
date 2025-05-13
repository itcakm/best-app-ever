# Web Layer - Application Load Balancer
resource "aws_lb" "web" {
  name               = "${var.project_name}-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.web_sg_id]
  subnets            = var.public_subnet_ids
  
  enable_deletion_protection = false
  
  tags = {
    Name = "${var.project_name}-web-alb"
  }
}

resource "aws_lb_target_group" "web" {
  name     = "${var.project_name}-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  
  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    protocol            = "HTTP"
    matcher             = "200"
  }
}

resource "aws_lb_listener" "web_http" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# App Layer - Internal Application Load Balancer
resource "aws_lb" "app" {
  name               = "${var.project_name}-app-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.app_sg_id]
  subnets            = var.private_subnet_ids
  
  enable_deletion_protection = false
  
  tags = {
    Name = "${var.project_name}-app-alb"
  }
}

resource "aws_lb_target_group" "app" {
  name     = "${var.project_name}-app-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  
  health_check {
    enabled             = true
    interval            = 30
    path                = "/health"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    protocol            = "HTTP"
    matcher             = "200"
  }
}

resource "aws_lb_listener" "app_http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 8080
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

# Latest Amazon Linux AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Web Layer - EC2 Instances
resource "aws_instance" "web" {
  count         = var.web_instance_count
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.web_instance_type
  subnet_id     = var.public_subnet_ids[count.index % length(var.public_subnet_ids)]
  vpc_security_group_ids = [var.web_sg_id]
  key_name      = var.key_name
  
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<html><body><h1>Web Server ${count.index + 1}</h1><p>Three-tier architecture example</p></body></html>" > /var/www/html/index.html
  EOF
  
  tags = {
    Name = "${var.project_name}-web-${count.index + 1}"
  }
}

# App Layer - EC2 Instances
resource "aws_instance" "app" {
  count         = var.app_instance_count
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.app_instance_type
  subnet_id     = var.private_subnet_ids[count.index % length(var.private_subnet_ids)]
  vpc_security_group_ids = [var.app_sg_id]
  key_name      = var.key_name
  
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y java-11-amazon-corretto
    mkdir -p /opt/app
    cat > /opt/app/app.sh << 'APPSCRIPT'
    #!/bin/bash
    while true; do
      echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nApp Server ${count.index + 1} - $(date)" | nc -l 8080
    done
    APPSCRIPT
    chmod +x /opt/app/app.sh
    cat > /etc/systemd/system/app.service << 'APPSVC'
    [Unit]
    Description=Simple Application Server
    After=network.target
    
    [Service]
    Type=simple
    ExecStart=/opt/app/app.sh
    Restart=always
    RestartSec=5
    
    [Install]
    WantedBy=multi-user.target
    APPSVC
    systemctl daemon-reload
    systemctl start app
    systemctl enable app
    
    # Adding health check endpoint
    cat > /opt/app/health.sh << 'HEALTHSCRIPT'
    #!/bin/bash
    while true; do
      echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nHealthy" | nc -l 8080
    done
    HEALTHSCRIPT
    chmod +x /opt/app/health.sh
    
    yum install -y nc
  EOF
  
  tags = {
    Name = "${var.project_name}-app-${count.index + 1}"
  }
}

# Attach web instances to web target group
resource "aws_lb_target_group_attachment" "web" {
  count            = var.web_instance_count
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
}

# Attach app instances to app target group
resource "aws_lb_target_group_attachment" "app" {
  count            = var.app_instance_count
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.app[count.index].id
  port             = 8080
}

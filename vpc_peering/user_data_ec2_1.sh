sudo su
yum update -y
yum install httpd -y
service httpd start
service httpd enable
echo "<html>vpc1</htnml>" > /var/www/html/index.html
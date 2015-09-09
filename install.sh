#!/bin/sh
# nodejs git install 
# 安装其他依赖包: 
sudo apt-get update  
sudo apt-get install -y python-software-properties python g++ make  
sudo add-apt-repository ppa:chris-lea/node.js  
sudo apt-get update  
sudo apt-get install nodejs 
sudo apt-get git-core

# nginx 安装
sudo apt-get install nginx

#为ghost配置nginx
cat >> /etc/nginx/sites-available/ghost.conf << EOF
server {
listen 80;
server_name *.devsai.com;
#server_name *.amazonaws.com;
location / {
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header HOST $http_host;
    proxy_set_header X-NginX-Proxy true;

    proxy_pass http://127.0.0.1:2368;
    proxy_redirect off;
   client_max_body_size    1000m;
    }
}

# 处理特定路径
location /content/images {  
  alias /srv/ghost/content/images;
  expires max;
}

location /assets {  
  alias /srv/ghost/content/themes/ghost-wbkd/assets;
  expires max;
}
EOF


sudo ln -s /etc/nginx/sites-available/ghost.conf /etc/nginx/sites-enabled/ghost.conf

#启动nginx
sudo service nginx restart  

#安装 forever
sudo npm install forever -g

#安装 sqlite3
npm install -g sqlite3 

mkdir -p /var/www/blog

cd /var/www/blog

git clone https://github.com/huangxiangsai/awsghost.git ghost

cd ghost/content

git clone https://github.com/huangxiangsai/myblog_sqlites_data.git data

cd data 

dd if=myblog.des3 |openssl des3 -d -k hxs123456 | tar zxf - 


cd /var/www/blog/ghost/

NODE_ENV=production forever start index.js



 

# roboshop-terraform
This repo holds the IAC using Terraform to provision the EKS & Deploy the roboshop containerized apps on EKS as deloyments.

Mongodb, RabbitMQ, MySQL & Redis would still be there on EC2.
Stateless Workloads/ Apps would be deployed on EKS.
Stateful workloads would be running on EC2 nodes.


# COmmands -
sudo dnf install nginx:1.24 -y
sudo dnf list |grep nginx
sudo dnf install enable nginx

sudo dnf install mongod-org -y
systemctl status mongodb
systemctl start mongod

sudo netstat -tulpn
mongodb port- 27017

vi /etc/mongod.conf

systemctl daemon-reload
systemctl restart mongod -l


vi /etc/nginx/nginx.conf

sudo dnf module list
sudo dnf module disable nodejs -y
sudo dnf module enable nodejs:20 -y
sudo dnf install nodejs -y

systemctl status enable redis
redis port - 6379

dnf install mysql-server -y
systemctl enable mysqld 
systemctl start mysqld
mysql port - 6306

You cannot use java directly, use java frameworks like maven (build tools)
To genearte binary you need to have build tool
Maven java packaging software.
Install Maven, you get java bydefault. 

Web based application uses maven
Mobile based application uses gradle build tool

dnf install maven -y
pom.xml file will have depnedency 

Java based & Web Application will have binaries in .war, .ear & .jar.

Exexutable files of windows based application will have .exe file
Exexutable files of android based application will have .apk file

Spring boot is nothing but a popular java Framework.

Payment service developed by Python.
For Python based appln, packages related info will be available in requirement.txt file.
 $ pip3 install -r requirements.txt

 pip - Python Package Manager (3 is version)
 yum - Linux Package Manager
 apt - Ubuntu Package Manager
 helm  - package manager for k8s

In nodejs package.json, what does mean ^1.18.1
^ - caret
specifies a version number that allows updates to any newer patch or minor version, as long as it does not include breaking changes(major changes)
Major version must stay 1 same
Minor version 18 & patch version can increase

npm install - npm is a nodejs package, where it installs all the packages mentioned in package.json in a file called as node module file

> we can create our own systemd file for service restart.
> Path - /etc/systemd/system/txt.service


catalogue will talk to mongo DB 
In catalogue.service file, mongodb IP address is mentioned. for integration.
> Integration of backends & DB done in systemd files. (ex- abc.service file)
> Your Frontend should know what are his Backend components
> Your Backend should know what are his Databses
> 
>  After updating systemd file then RUn sudo systemctl daemon-reload & restart the respective services

> Master Data / Business data - gets from business operations team to inject/load the schema in DB

# tell frontend what is my backend?
In /etc/nginx/nginx.conf - we can update the backend

# Redis - Caching Database
Redis is used for in-memory data storage & alows users to access the data over API.
Ex- At very first time, every APp takes time to open, But when you open for 2nd time it will open in couple of seconds, these cache will be stored in Redis Cache DB.

If Users keep on querying for the same products multiple times then load will be on DB.
DB is very important & sensitive, so for caching we use Redis cache.
You dont use cache, you configure DB for cache. 

Whenever User request, it will go thtough Redis cache then DB & when request goes back that time it stores in cache.
When 2nd time request it will find in cache itself.
cacheHit - If found in cache
cacheMiss - if not found in cache
Cache will have refresh interval - 1hr, 90 min


# Queue Manager (MQ)-
Sending Messg in Whatsapp
                  
                          Internet
        

Mike (Hello) ----------------------------------------> Mitchell


If Mike sent a mesg & mitchell didnt turn off internet for sometime, then messg will store in Queue Manager for specfic time.
If Mitchell doesnt turn off Internet for long time, then Queue Manager has its own Specific time defined to hold the messg, once that period exceeded then Queue Manager will discard messg

In Queue Manager - kafka is a Leader for Big applications
If have small application then RabbitMQ can be used.

Subscriber means receiver 

# Rabbit MQ - Opensource Queue Manager

# For Interview - Microservices based project, TechStack that has been implied is nodejs, python, java, go.
For go & java, compilation is required.
For nodejs & Python, Compilation is not required.

log file - /var/log/messages 



# 
We would be using a helm charts to deploy the Nginx Ingress Controller from the official document from nginx- ingress
https://kubernetes.github.io/ingress-nginx/deploy/#/quick-start

# 
We will deploy prometheus & Graffana on EKS Cluster

# OIDC Open ID connectivity - 
OIDC is a credentials distributor
Reference - https://github.com/kubernetes-sigs/external-dns

Enables connectivity between k8 service account with AWS DNS which will enroll the external DNS records  on Route53 zone.

EKS CLuster needs to create a DNS on ROute53 zone for this authentication
Create a IAM role in EKS Cluster
Enable the trust means enable authenticity
Provision OIDC provider to enable trust between EKS & Route53 using terraform
IAM Role is to map externalDNS in cluster for ServiceAccount
We need IAM OIDC Provider for this we will enroll our EKS & the ServiceAccount


# How to get the thumbprint dynamically?
There is a tool called kubergrunt
kubergrunt is a hybrid tool used by terraform to get the info from terraform
kubergrunt helps to fetch the properties of kubernetes resources

 $ kubergrunt eks oidc-thumbprint --issuer-url <OIDC Provider URL>

 # Pod Identity associations
 EKS Pod Identity is a method to associate AWS IAM Roles to pods for the workloads to use.

> OIDC is needed when Google k8s engine wants talk to AWS service
> Inside AWS EKS Cluster , OIDC is not needed bcoz POD IDENTITY Association can directly talk to AWS services
>
> Operatore is a resource on k8s that offers custom resource technician


# DNS Records Provisioning should be automated by using External DNS
This ensures ingress resources that are provisioned for grafana, prometheis, elk & frontend component, DNS records mentioned in the ingress would automatically get provisioned by external-dns in Route53 zone.

# Enable EKS to Vault Integration 
All the config & secrets should befetched from vault.

# Design Dashboards on OpenSearch to Observe the Telemtry 

> In organization, vault would be setup on K8 EKS Cluster by keeping the security aspect.
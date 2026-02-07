# roboshop-terraform
This repo holds the IAC using Terraform to provision the EC2 infra needed to host roboshop project.


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



##


for i in mongodb catalogue user cart redis ; do 
> bash init.sh $i dev DevOps321 
> done

cart, user, catalogue are all 3 developed by nodejs components, so we can DRY the code as much as we can 
Even we implemented DRY for below services considering future scale of backends
shipping is developed by Java, 
payment developed by Python
Dispatch developed by golang

## high Level Flow of RoboShop Project ##
We are getting the Roboshop in 2 steps:
1. Run terraform script to provision Infra
2. Play the Ansible Runbook to perform the CM


> With Infra provisioning itself , i want playbooks to be called by remote-exec that we can achieve it
file - tf-call-ansible.tf

# How Terraform fetch the secrets from vault? OR Integrate Terraform with hashicorp vault? 
Create a provider.tf in that add vault provider alongwith URL of vault
Fetch/ Extracts from data.tf file


> If tf-call-ansible.tf file doesnt recognize then rename to app.tf

git pull; terraform init --var-file=dev.tfvars ; terraform plan --var-file=dev.tfvars -var vault_token=<mentionVaultkey> ; terraform apply -auto-approve --var-file=dev.tfvars -var vault_token=<mentionVaultkey>


#  Advantage of map over list in Terraform
list you will never use in terraform bcoz if you change the order of list in TF, for next Run TF considers change then it will destroy & recreate Infra

When you supply input as a list order matters most
people quiet afraid of using list in TF


> Infra provisioned was added with a remote provisioned & now with a single click of button , we are able to bring up the App.

# Goal - Roboshop should have its own VPC provisioned along with app based subnets


## VPC Provisions steps -
1st provisioned Subnets
2nd provision route tables - each subnet in each zone will have its own route tables
Then association of route tables
3rd Provision IGW for Public Subnet
4th Provision NAT Gateway for Private Subnets


# Roboshop VPC Architecture - B58-S85-11-Dec-2024
10.0.0.0/16  > dev
10.1.0.0/16  > qa
10.2.0.0/16  > Prod

Keeping in mind of High Availability, selecting 2 different Availability Zones for each subnet

* Total 4 Subnets in each 2 different AZ
Public Subnets - LB will be exposed in this subnet
Web Subnets    - Frontend/ web servers will be hosted in this subnet
App Subnets    - All Backends servers will be hosted in this subnet
DB Subnets     - DB will be hosted in this subnet

Route Tables for all Subnets
NAT Gateway for Web Subnet, App Subnet, DB Subnet so that servers can access the Internet
Internet gateway is only for Public Subnet

> We have 2 VPC's for All tools VPC & Project VPC
> Enable VPC eering between tools VPC & Project VPC so that Jenkins server can access the Roboshop VPC to run the Ansible playbooks

# Enable VPC Peering between Tools VPC & Project VPC
Tools vpc peers with Project VPC, so we enable the connectivity between these 2 VPC's

Ensure you supply these as inputs:
vpc-id of tools VPC
tools route table ids
tools VPC CIDR


# Add peering as a route to :
- tools vpc route table & all app, web, db & public subnets route table of project vpc

# Problem Statement:
1. roboshop.internal : Private Domain
    Scope: DNS Resolution or nslookup of any *.roboshop.internal will only work on the VPC's that you have associated.
    Our Hosted Zone is attached to default vpc and through tf we have also attached this to created tools vpc (We typically dont detach or attach often)

    When you attach any new vpc to the hosted zone, typically it takes anywhere from 1 min to 24 hr to work.

    VPC -----> DB's -----> Components

Workaround: Lets use the same public zone cloudapps.today, but create DNS Record using the private IP address.
This public hosted zone works on any vpc.

# How are we going to expose app to internet?
    1. Provision a public Application Load Balancer on PUBLIC SUbnet
    2. Create a Target Group for frontend and add the frontend nodes.
    3. Enroll the frontend Target Groups to ALB
    4. We can access the App using ALB CNAME.
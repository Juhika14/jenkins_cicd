Creating a CICD pipeline which will develop the application and test the application . If test is successfull it will push the application to master node and from Master node final 
code will be pushed to Production server.

For  that we will create 3 instances
One of the instances we will make it as Master
On Master write the following codes
sudo apt update
sudo apt install openjdk-17-jdk -y
Now create a bash file
sudo nano a.sh
//Code to install Jenkins//
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y

sudo a.sh

After jenkins is installed copy the pulic ip paste it in browser:8080
Now copy the initial admin password by using cat var/lib/initialAdminPassword
Paste it in Jenkins dasboard, set up Jenkins

Now try to add the Nodes using SSH connecting
Click on Manage Jenkins > Go to node> New Node> Type a name of node> permanent Agent> click on Ok
Now configure the Node
Under remote root directory write:/home/ubuntu/jenkins
Under connection> Select ssh connection
Under Host: paste the private ip of the node
On credentials> click on 'Add' Jenkins> Under kind> Select : Configure host using ssh
type username as : Ubuntu
Under private key click on Add directly:
Paste the pem key and click on Ok
under verifying strategy click on non verifying strategy

Repeat it for slave 2

On Master node we will create a docker file to install apache and run the website
FROM ubuntu/apache2
ADD . /var/www/html
ENTRYPOINT apachectl -D Foreground

Push it into test and master branch of git Hub

Now set up gitwebhook
Click on the remote repo> Settings> Webhooks> Add webhook> Add the ip address of jenkins server/github-webhook/
Click on Okay

Before performing tasks install docker on both the slaves
using sudo apt install docker.io -y
For performing our tasks we will create 3 Jobs
Job1: We will create a build the docker container and run it on port 81
On post build steps we will add job2 ie run the job2

 create a new item from manage jenkins> New item> Job1> Freestyle project. Click ok
Configure and add the git url under source code management click git add the url and run the code on */test
under restrict where it should run. slave1

Under Build steps> Execute shell
sudo docker build . -t testing
sudo docker run -itd -p 81:80 testing

 create a new item from manage jenkins> New item> Job2> Freestyle project. Click ok
Configure and add the git url under source code management click git add the url and run the code on */master
under restrict where it should run. slave1

Under Build steps> Execute shell
sudo docker build . -t mastering
sudo docker run -itd -p 82:80 mastering


create a new item from manage jenkins> New item> Job3> Freestyle project. Click ok
Configure and add the git url under source code management click git add the url and run the code on */master
under restrict where it should run. slave2

Under Build steps> Execute shell
sudo docker build . -t prod
sudo docker run -itd -p 80:80 prod

Add post build actions 

Go to Job1> configure> Add post build actions> Job2> Run only if build is stable> Click ok
Go to Job2> configure> Add post build actions> Job3> Run only if build is stable> Click ok

Now start building the job1
We will see that it will first build job 1 upon successfull completion of job1 it will build job2 and finally job3 will be build

To check the contents of the file
Copy the slave ip address and paste it in url with colon:80




Click

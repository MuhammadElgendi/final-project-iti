# Deploy backend application on eks using ci-cd Jenkins pipeline
## clone the repo via command 
```bash
Git clone 
```
## cd the terraform code folder
```bash
cd terraform/
```
## run the code to create eks cluster 
```bash
terraform init
terraform apply
```
## connect to eks cluster via 
```bash
aws eks update-kubeconfig --region us-east-1 --name eks-cluster
```
## deploy efs file to access mounting 
## Setup our Cloud Storage
```bash
# deploy EFS storage driver
kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"

# get VPC ID
aws eks describe-cluster --name eks-cluster --query "cluster.resourcesVpcConfig.vpcId" --output text
# Get CIDR range
aws ec2 describe-vpcs --vpc-ids vpc-0783edc3bdec28b6e --query "Vpcs[].CidrBlock" --output text
# security for our instances to access file storage
aws ec2 create-security-group --description efs-test-sg --group-name efs-sg --vpc-id VPC_ID
aws ec2 authorize-security-group-ingress --group-id sg-xxx  --protocol tcp --port 2049 --cidr VPC_CIDR

# create storage
aws efs create-file-system --creation-token eks-efs

# create mount point 
aws efs create-mount-target --file-system-id FileSystemId --subnet-id SubnetID --security-group GroupID

# grab our volume handle to update our PV YAML
aws efs describe-file-systems --query "FileSystems[*].FileSystemId" --output text
```

## Setup a namespace
```bash
kubectl create ns jenkins
```


## Deploy Jenkins
```bash
kubectl apply -n jenkins -f namespace.yaml  #create namespace
kubectl apply -n jenkins -f pv.yaml         #create pv and pvc 
kubectl apply -n jenkins -f rbac.yaml       #create service acount and binding role  
kubectl apply -n jenkins -f deploy.yaml     #create deployment for jenkins
kubectl apply -n jenkins -f service     #create service loadbalancer for jenkins deployment

```
## Jenkins Initial Setup
```bash
kubectl -n jenkins exec -it pod/POD_NAME cat /var/jenkins_home/secrets/initialAdminPassword
```
## pipline steps
![Screenshot from 2023-02-18 23-01-43](https://user-images.githubusercontent.com/107524115/219899386-13014be7-2c6f-40d4-865a-3fb8f368a548.png)

  file:///home/gendi/Pictures/Screenshots/Screenshot%20from%202023-02-18%2023-04-41.png
## deployed app

 file:///home/gendi/Pictures/Screenshots/Screenshot%20from%202023-02-18%2022-54-00.png




 

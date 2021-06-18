# Timeoff application swarm cluster

This repository contains the code to deploy the infrastructure needed to deploy timeoff-management application in AWS.

## Introduction

The application is deployed on a docker swarm cluster on AWS. Swarm was selected by its ease of use, configuration and administration. The cloud infrastructure is deployed using _Infrastructure as Code_ with terraform. For cloud provisioning Ansible was used, and  [drone.io](https://www.drone.io/) CI/CD was selected for the application deployment. All of the code is stored in the following github repositories:

* [timeoff management application](https://github.com/juanluisbaptiste/timeoff-management-application) fork
* [timeoff cluster](https://github.com/juanluisbaptiste/timeoff-cluster) (this repo)

### Infrastructure as Code

Terraform was selected to do the cloud provisioning in AWS. The terraform code is separated in three projects:

* _elastic_ips_: this project will create an specified amount of elastic IP addresses to be associated with the managers of the swarm cluster.
* _swarm_cluster_: this project will create a docker swarm cluster with an specified amount of manager and worker, and from an specified size (instance type) each.
* _efs_: this project will create a shared EFS filesystem inside the cluster's VPC were the application code will reside and be shared among all the worker nodes of the cluster.

All of the projects use custom terraform modules to do the work. For the documentation of module usage see its README.md file of each project. Projects must be launched in the same order as the preious list, first create the elastic IP addresses, then the cluster and lastly the EFS filesystem.

### Cluster Provisioning

The Cluster provisioning is done using ansible. A set of playbooks and roles were writtento handle provisioning tasks that range from basic instance configuration to cluster installation.

For load balancing and access to the applications deployed in the cluster traefik was selected. This proxy/load balancer is deployed on the manager node(s) of the cluster and will balance the access to the deployed applications by a set of criterias configured using docker labels written on the `stack.yml` file of the application. The criterias can be by hostname, path or a combination of both. Additionally traefik is configured to secure the applications using SSL with Letsecrypt. It will take charge of the SSL certificate generation and updates for each deployed application.

For cluster administration and debugging portainer was selected. This tool provides easy access to the containers running on the cluster, were tasks like reviewing of logs, console access or basic stats monitoring can be done. It also allows to do administrative tasks like manually redeployment of applications or increasing the amount of conatiner replicas.

These are the ansible playbooks:

* _deploy_swarm_: This playbook will provision the ec2 instances, installing all the needed software and configuring the swarm cluster.
* _configure_efs_: This playbook will configure each ec2 instance to mount the EFS filesystem at boot.
* _deploy_infra_: This playook will install the cluster infrastructure services, like traefik and portainer.

All of the playbooks have to be run in the same order as the previous list.

### Continious Integration & Deployment

The docker image generation and application deployment in the cluster is done with drone.io. drone.io is an open source CI/CD platform that was written with the cloud in mind and it's very easy to use. Each application will have a `.drone.yml` file with the CI/CD pipeline that needs to be executed when updates to the application are pushed to the application's git repository.

The application pipeline contains two jobs:

* _Build docker image_: This job will create a new docker image with the updated application code and push it to docker hub pubblic registry.
* _Deploy docker image_: This job will pull the new image from docker hub and redeploy the application. This job tasks run on the cluster manager node (all cluster administrative task are executed on manager nodes).


### Architecture

The following diagram depicts the selected architecture:

<p align="center">

  <img src="https://raw.githubusercontent.com/juanluisbaptiste/timeoff-cluster/master/img/architecture.png" alt="Architecture diagram">

</p>

## Further Work

The selected architecture has some limitations mostly related to the orchestrator in use. Here is a list of what could be done to improve some aspects without switching orchestrators:

### Application Availability

By using a single manager node, the cluster has a single point of failure that can risk the applcation availability. This can be improved by increasing the managers amount to a higher odd number like 3, 5, 7 or more (this is to maintain the [raft consensus](https://docs.docker.com/engine/swarm/raft/) in the cluster). But increasing the amount of managers brings a new issue: the load balancing of the manager nodes.

If the manager nodes amount is increased then some sort of load balancing needs to be implemented. One option and the easiest to implement would be to do DNS round-robbin balancing. This is a really simple method to implement, but lacks advanced features that can produce better results, like resource based, least connections, etc. This load balancing methods can be achieved by using specialized solutions.

The second option would be to use one of those solutions, for this case a cloud based offering like the AWS application or network load balancers would make more sense. The load  balancer would be placed in front of the manager nodes so it can balance traffic between the local traefik on each node, using a health check to be notified when one of the nodes in the group becomes unavailable. When this happens the load balancer will stop sending traffic to the node until the health check reports that it is again available.

### Auto escalaility

One important feature that docker swarm clusters lack is auto escalability. This does not mean that it cannot be achieved by other means, but there are other orchestrating solutions like k8 or AWS ECS that can can do it "out of the box". On this case an auto escalating solution could be implemented with some scripting and a monitoring tool like Zabbix.

With the current architecture the escalablity can be manually achieved. An admin can increase the amount of workers nodes in terraform and then apply the changes. When it finishes the ansible playbooks will be run to add the new node(s) to the cluster. The last step would be to increase the amount of container replicas in the application `stack.yml`file commit and push changes so the CI/CD platform can redeploy it.

To improve this situation, monitoring alerts could be configured to monitor specific health metrics over a period of time. When these alerts are triggered, a program could be executed to scale out and and later scale back when conditions return to a expected state. An example of such a metric could be to monitor the average CPU usage of all worker nodes during an specified amount of time. When the CPU usage goes beyond a certain threshold, the alert will trigger and will execute a program to scale out the cluster. Later when that condition reverts another program could be executed to scale back in the cluster and destroy the additional resources that were created to handle the additional load.

The scaling programs could follow  a set of instructions roughly like these:

1. Clone the git repo were the terraform and ansible code lives.
2. Increase the amount of workers by an specified _step_ size (ej. 1).
3. Commit and push the changes.
4. The CI/CD platform will launch a pipeline that will excute the terraform code and the ansible provisioning playbooks to add the new node(s) to the cluster and give them access to the EFS filesystem.
5. Clone the git repo were the application code lives.
6. Modify the `stack.yml` file to increase the amount of container replicas by the same _step_ size as the nodes.
7. Commit and push the changes. This will trigger an application redeployment and more containers will be created on all the available nodes.

After this the cluster will have an increased capcity that should help it manage the additional load. When the CPU usage goes bellow the threshold another program could be launched to do the inverse steps than the previous program:

1. Clone the git repo were the terraform and ansible code lives.
2. Decrease the amount of workers by an specified _step_ size (ej. 1) and checking that it always is > 1.
3. Commit and push the changes.
4. The CI/CD platform will launch a pipeline that will excute `terraform destroy`, decreasing the cluster size.
5. Clone the git repo were the application code lives.
6. Modify the `stack.yml` file to decrease the amount of container replicas by the same _step_ size as the nodes and checking that it always is > 1.
7. Commit and push the changes. This will trigger an application redeployment.

For the monitoring of the cluster nodes two approaches are available. One would be to modify the `user_data` script in terraform code to install and configure the Zabbix agent so it auto registers with the server inmediately it is created. The second option would be to use an ansible playook to do the same as part of the escaling program steps.

### Database
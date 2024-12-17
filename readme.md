# open_innovation_assignment

1. Choose the infrastructure platform to use.

For government clients or organizations that prefer not to use cloud solutions, we can opt for on-premises infrastructure. Some popular options include:

HCI (Hyper-Converged Infrastructure)
VMware or VxRail
DELL PowerEdge Servers
If cloud solutions are acceptable, we can leverage:

AWS EKS (Elastic Kubernetes Service) for Amazon Web Services
Azure AKS (Azure Kubernetes Service) for Microsoft Azure
This flexibility allows us to cater to both cloud and on-premises requirements effectively.

2. Choose the orchestration technology and their components.

Orchestration Technology we can go with Rancher upstream management cluster followed by
creating downstream cluster on Rancher which gives flexibility for Automated on premises provisioning, each to deploy kubernetes cluster just by using ansible playbooks.
Moreover it provides monitoring Dashboard, easy to deploy Longhorn Storage & other Helm Charts.

We can also go for KUBEADM Opensource kubernetes Cluster,Kubespray, Redhat Openshift etc.

Some of the components of Orchestration are 
    - POD 
    - Deployments
    - Statefulsets
    - Services (Cluster,LoadBalancer,NodePort)
    - IngressController
    - Istio
    - Jobs
    - DaemonSets 
    - Helm Charts (Templates,values.yml etc)
    - Secrets
    - Configmap

3. Describe the solution to automate the infrastructure deployment and prepare the most important snippets of code/configuration

For Infrastructure deployment we can use Terraform & For AWS Cloud - CLOUDFORMATION.
Code snippet is uploaded in two folders 
        - Terraform VMs on AWS
        - Ansible for Configuration - AWS VPC Setup using Ansible modules


4. Describe the solution to automate the microservices deployment and prepare the most important snippets of code/configuration

        - To Automated Microservices deployment we can create CI/CD pipelines (GITOPS) approach
        or we can also use HELM CHARTS for deployment. 


5. Describe the release lifecycle for the different components.

        - PODS - It will not recreate by itself
        - Deployment - It will recreate the number of pods defined in deployment config based
                       on number of replicas & Template defined 
        - ConfigMap -  Used for configuration files or 
        - Secrets-     Used to create credentials or for passwords
        - Ingress      To access the services outside the cluster
        - DaemonSets-  Will create on pod on each node in the kubernetes Cluster
     

6. Describe the testing approach for the infrastructure.
    There are many testing approach & tools available in the markets.
            - OS Hardening
            - Smoke Testing
            - Redundancy Test, Fault Tolerance
            - Security of Kubernetes Cluster
            - Image Scanning 

7. Describe the monitoring approach for the solution.

    Some of the monitoring solution are.

            - Prometheus & Grafana
            - Nagios
            - Zabbix
            - Dynatrace
            - LPAR2RRD & STOR2RRD

    For Logging Solution
            - ELK (ElasticSearch with KIBANA Dashborad)
            - LOKI
            - SPLUNK 







We are going to vagrant or AWS for this assignment. We will create one master and 2 worker nodes.
We will self signed certificate to install rancher. 


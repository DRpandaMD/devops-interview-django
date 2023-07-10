# devops-interview-django
Paired Programming Example Interview 

## Purpose 

Repo is used to demostrate an example pair programming interview that could be useable in the DevOps Space.

## Tools Used

You will need some familiarity with the following:

* Python 
* Django
* Terraform
* Kubernetes
* Google Cloud Platform
* GKE
* Cloud SQL
* Google Container Registry
* Docker
* HTML
* CSS
* ChatGPT

Yes I've included ChatGPT as I've used it for 90% of the additional code used out of the main skeleton provided by Django in [this repo](https://github.com/wsvincent/djangoforbeginners/tree/main/ch11-user-authentication).  DevOps is so broad so its hard to memorize everything possible and ChatGPT, while not perfect, gets me about 90% where I want to go while also teaching me at the same time.  You still have to **know** *where* and *what* to copy and paste.  And *how* to connect all the dots to make it work.

## Setup

### Google Cloud

Have a desginated trial / demo Project or just make a new one to put this in.

### Terraform 

In order to have Terraform provision infrastructure on our behalf we will need to make a *serviceAccount* and set up new credentials.

1. Go to the Google Cloud Console: Visit the Google Cloud Console and log in with your Google account.

2. Create a new project: If you haven't already created a project for your Terraform configuration, click on the project dropdown at the top of the console and select "New Project". Follow the prompts to create the project, giving it a meaningful name.

3. Enable the necessary APIs: In the Cloud Console, navigate to the project you just created. Go to the "APIs & Services" → "Library" section. Search for and enable the necessary APIs you will be using with Terraform, such as the Compute Engine API, Kubernetes Engine API, and Cloud SQL Admin API. **NOTE** As a heads up this can take some time to do.  And YES you have to enable new APIs for a new project.  Google enforces least priviledge.

4. Create a service account: In the Cloud Console, navigate to "IAM & Admin" → "Service Accounts" and click on "Create Service Account". Provide a name and description for the service account and click "Create". Choose the appropriate roles/permissions for the service account based on the resources you'll be managing with Terraform (e.g., Compute Admin, Kubernetes Engine Admin).
You will also have to add Service Acount User and Service Usage Consumer.  You could just give this service account editor, but that is overkill.

5. Generate the credentials JSON file: Once the service account is created, click on the "Actions" menu (three dots) next to the service account and select "Create Key". Choose the key type as JSON and click "Create". This will download a JSON file containing the credentials for the service account.

6. Store the credentials securely: Move the downloaded JSON file to a secure location on your local machine. It is important to keep the credentials file confidential, as it grants access to your Google Cloud resources.

7. Update the Terraform provider configuration: In your Terraform code, update the credentials argument in the provider block to point to the newly downloaded credentials JSON file.

```hcl
provider "google" {
  project     = "your-project-id"
  region      = "your-region"
  credentials = file("path/to/credentials.json")
}
```

8. Replace "your-project-id" with the ID of your Google Cloud project, "your-region" with the desired region (e.g., "us-central1"), and "path/to/credentials.json" with the actual path to the downloaded credentials JSON file.

`cd` into the terrafrom directory. Now you are ready to run through the folowing steps:

```bash
terraform init
terraform plan
terraform apply
```

On a successful plan you should see a bunch of green plus signs with other information about what it is about to add to your infrastructure.  Remember you are making a GKE Cluster and a Cloud SQL Instance so its gunna take it some time.

### Docker

Now is a good time to make sure you have the docker container image built while we are waiting for our infrastructure to provision

```bash
docker build -t mydjangoapp .
docker run -p 8000:8000 mydjangoapp
```

You dont' have to run the app but if you are curious and want to see a preview while we wait for infrastructure to be provisioned we can take a peak.  You will find some tweaks to the CSS because the default is all allign right and not centered and hurts my eyes too look at.


#### Google Container Registry

You will have to take this container you built and push it to GCR.  You will then have to update your app deployment yaml to reference your GCR URL


### Kubernetes

Once the cluster is up and terraform is done doing its thing.  Navigate back to the console and to kubernetes engine.  Select the cluster and click the three dots menu on the far right and hit connect.  It will give a you a cli command to copy and paste

```bash
gcloud container clusters get-credentials regional-lab-cluster-01 --region us-central1 --project interview-testing-area
```

Test your connectivity with 
```bash
kubctl get nodes
```

Get the app up first with: 

```bash
kubectl apply -f django-app-deployment.yaml
```

Give it a second and wait for the pods to come up. Then run, to create the loadbalancer:
```bash
kubectl apply -f django-app-service.yaml
```
Once it is up navigate to the LoadBalancer service in the google console and grab the public IP and open that in a new browser tab and you should see the application be served.

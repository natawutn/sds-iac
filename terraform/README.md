# IaC @ software-defined-system / terraform
Terraform is the provisioning tool being taught in the class.  This repository contains GCP-based terraform files.  This includes tf files for:
- [docker](docker) Running nginx container in the local docker engine
- [gcp/single-instance](gcp/single-instance) Creating single compute-engine instance on GCP with nginx installed
- [gcp/multiple-instances](gcp/multiple-instances) Creating multiple compute-engine instances on GCP with latest python3 installed (for using with ansible example later)

Note: In multiple compute-engine instances example, terraform will also add a public key to these instances.  You must revise username and ssh-key file location at the following lines:
```
  metadata = {
    ssh-keys = "natawut:${file("~/.ssh/id_rsa.pub")}"
  }
```

You must first install terraform.  Plesae refer to the [official installation guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

After installation, you must also perform the following prerequisites:
- Create project on GCP
- Login to the GCP with:
```gcloud auth application-default login```
Note: this is really important as it will let terraform to inherit the proper permissions.
- Set default project (if needed)

You can now perform all terraform operations.

If you reapply the script, the IP may be changed.  You will have to remove those IPs from known_host by using the following command:
```ssh-keygen -R <IP_ADDRESS>```
  

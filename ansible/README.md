# AWS swarm cluster provisioning with Ansible

This project contains the files to provision a swarm cluster, related infrastructure services and applications using ansible.

## Requrements

The [boto python library](http://boto.cloudhackers.com/en/latest/) needs to be installed on the host running the ansible playbooks.

### AWS Configuration

AWS access keys are configured using profiles stored in the user's [~/.aws/credentials](https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/setup-credentials.html) file. The name of the profile to use must be configured with the `AWS_PROFILE` env variable to be able to be used on this project (see below).

### Ansible roles

To install role dependencies run the following command:

    ansible-galaxy role install -r requirements.yml

## Usage

To run the playbooks there is a wrapper script that calls the ansible binary called [ansible.sh](ansible.sh). This wrapper has all parameters needed to successfully invoke ansible for this project, like the AWS profile, inventory and deployment environment name. Other configuration is done using `group_vars` per environment, for example, the ssh key to use. Configurable parameters have default values but they can be overriden using env vars. These are the available variables:

- `ENV`: The name of the environment being deployed (default is _prod_).
- `AWS_PROFILE`: The name of the AWS profile in ~/.aws/credentials (default is _default_). This one is only informative to print it out when running the playbooks.
- `INVENTORY`: Name of the inventory directory to use (default is _./inventory/prod_)

SSH keys are stored in the `auth` directory, which is NOT added to the repository. You can edit the `group_vars` file and change the key location to whatever you like.

**NOTE:** If you change the location of the ssh keys you need to update them too on the `ssh.cfg` and `group_vars` files too.

### Swarm cluster provisioning

For the deployment of the cluster we use [atosatto.ansible-dockerswarm](https://github.com/atosatto/ansible-dockerswarm) role. This are the steps to deploy it:

1. After running terraform, take note of the manager IP address and replace it on the ssh.cfg file on all public IP addresses ocurrences on the file.
2. Log into the manager node using the ssh.cfg configuration file once so the ssh key gets accepted for the workers.
3. Now you can start running the ansible plabooks to provision the cluster and applications. This is the list of playbooks to be run in the order displayed here:
   - _deploy_swarm.yml_: Deploys the swarm cluster and installs needed packages.
   - _configure_efs.yml_: Configures the access to an AWS EFS filesystem to share application files.
   - _deploy_infra.yml_: Deploys infrastructure services like traefik, portainer and drone.io CI/CD service.

To run these playbooks the ansible.sh script is used like this:

    AWS_PROFILE=profile_name ./ansible.sh playbook_name

For example:

    AWS_PROFILE=default ./ansible.sh  deploy_swarm.sh
--

**NOTE**
Currently we are using [this forked version](https://github.com/juanluisbaptiste/ansible-dockerswarm) that [fixes a bug](https://github.com/atosatto/ansible-dockerswarm/issues/78) when running it. We will change back to upstream when the bug is fixed.

--

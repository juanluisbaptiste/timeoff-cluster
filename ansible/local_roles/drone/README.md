Drone.io docker service
=========

Ansible role to deploy [drone.io](https://www.drone.io/) CI/CD server and agents on a docker swarm cluster using [docker-service](https://gitlab.com/live9/ansible/roles/docker-service/-/tree/jlb_new_ansible_provisioning) role.


Role Variables
--------------

Same variables defined by docker-service, this role pre-configure some of them.

Dependencies
------------

* docker-service

Example Playbook
----------------

    - name: Deploy Drone
      include_role:
        name: drone
      vars:
          service_state: "started"

License
-------

BSD

Author Information
------------------

* Juan Luis Baptiste < juan _at_ juanbaptiste _dot_ tech >
* https://www.juanbaptiste.tech

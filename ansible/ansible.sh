#!/bin/bash

export ENV="${ENV:-prod}"
export AWS_PROFILE="${AWS_PROFILE:-default}"
export INVENTORY="${INVENTORY:-./inventory/${ENV}}"

ansible-playbook \
        -i ${INVENTORY} \
        --extra-vars "env=${ENV} aws_profile=${AWS_PROFILE}" $1

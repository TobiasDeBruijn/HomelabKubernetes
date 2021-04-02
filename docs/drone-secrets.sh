#!/bin/bash
SECRET_BASE_NAME="drone-runner-token"
DRONE_SECRET=$(kubectl get secrets | grep $SECRET_BASE_NAME | cut -d' ' -f1)

LB='\033[0:94m'
NC='\033[0m'

printf "k8s_cert:\n"
printf "${LB}$(kubectl get secret ${DRONE_SECRET} -o jsonpath='{.data.ca\.crt}' && echo)${NC}\n\n"

printf "k8s_token:\n"
printf "${LB}$(kubectl get secret ${DRONE_SECRET} -o jsonpath='{.data.token}' | base64 --decode && echo)${NC}\n\n"

printf "k8s_server:\n"
printf "${LB}$(kubectl config view -o jsonpath='{range .clusters[*]}{.name}{"\t"}{.cluster.server}{"\n"}{end}' | sed -e 's|kubernetes\t||')${NC}\n"

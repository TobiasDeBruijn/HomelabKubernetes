# Drone secrets
The Drone service requires some secrets, occasionally.

## Determine your secret name:
1. ``kubectl get secrets``
2. Look for a secret named ``[SERVICEACCOUNT NAME-token-[RANDOM]``, that is your secret name. E.g for the service account named `drone-runner`, the secret could be called `drone-runner-token-zwvfl`.

## k8s_cert
`kubectl get secret [SECRET NAME] -o jsonpath='{.data.ca\.crt}' && echo`

## k8s_token
`kubectl get secret [SECRET NAME] -o jsonpath='{.data.token}' | base64 --decode && echo

## k8s_server
``kubectl config view -o jsonpath='{range .clusters[*]}{.name}{"\t"}{.cluster.server}{"\n"}{end}'``

### See also:
- https://github.com/sinlead/drone-kubectl

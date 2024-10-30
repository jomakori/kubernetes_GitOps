#!/bin/bash
# ------------------------------------------------------------------
#           Creator
#               @jomakori - GH
#           Title:
#               terminate_namespace
#           Description:
#               This script is used to force-terminate kubernetes workspaces that are stuck in a terminating state.
#           Usage:
#               sh terminate_namespace.sh <namespace-1> <namespace-2> etc...
#                NOTE: You can put as many namespaces under the parameters list when calling the script. The code will loop thru all the parameters submitted
#           Source:
#               https://sumanthkumarc.medium.com/debugging-namespace-deletion-issue-in-kubernetes-f6f8b40a4368
# ------------------------------------------------------------------
set -e
confirm_kubectl_proxy(){
    if [ eval $(sudo netstat -an | grep 8001) ]; then
        echo "ERROR: kubectl proxy is closed"
        echo "FIX: Run "kubectl proxy" command on a seperate terminal window then rerun this script."
        return 1
    else
        echo "kubectl proxy is open! Continuing script..."
        return 0
    fi
}

terminate_namespace(){
    NAMESPACE=$1 &&
    echo "Force terminating '$NAMESPACE' namespace..." &&
    kubectl get namespace $NAMESPACE -o json |jq '.spec = {"finalizers":[]}' >> temp.json &&
    curl -v -k -H "Content-Type: application/json" -X PUT --data-binary @temp.json 127.0.0.1:8001/api/v1/namespaces/$NAMESPACE/finalize &&
    rm -rf temp.json
}

# Main function
((
    confirm_kubectl_proxy

    for namespace in "$@";
    do
        echo "Processing '$namespace' namespace..."
        terminate_namespace $namespace
        printf "'$namespace' namespace has been terminated.\n"
    done

    printf "NOTE: You must manually terminate the port associated with kubectl proxy. Use these commands:\n"
    printf "\n sudo netstat -plten |grep 8001 && kill -9 <nums_before_/kubectl>"
) 2>&1) | tee terminate_namespace-results.log

echo "Results have been output to: $(pwd)/terminate_namespace-results.log"

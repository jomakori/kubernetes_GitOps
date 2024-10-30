# Purpose: Used for linting + testing helm charts locally

# Usage:
# $ .useful-scripts/ct_check.sh <path-to-helm-chart> # MacOS/Linux only
## Note: Helm Charts are hosted in:
## - apps/helm/<app-name>
## - services/helm/<service-name>

#!/bin/bash

# Declarations
GREEN='\033[0;32m'
NC='\033[0m' # No Color
dir=$1
cluster_context=$(kubectl config current-context 2>/dev/null)

# Check if ct (Chart Testing) and yamllint are installed
if ! command -v ct &> /dev/null || ! command -v yamllint &> /dev/null
then
    missing_tools=""
    if ! command -v ct &> /dev/null; then missing_tools+="ct "; fi
    if ! command -v yamllint &> /dev/null; then missing_tools+="yamllint"; fi
    echo "$missing_tools is not installed. Please install it using 'brew install chart-testing' and/or 'brew install yamllint'."
    exit 1
fi

# Set up a trap to remove files on ct command failure
trap 'rm -rf $dir/charts; rm -f $dir/Chart.lock' EXIT ERR INT

# Confirm connection to cluster
if [ -z "$cluster_context" ]; then
    echo "ERROR: The EKS cluster credentials aren't set"
    exit 1
fi

printf "${GREEN}Testing out changes on: $cluster_context${NC}\n"

# Processing
if [[ $dir =~ .*/helm/.* ]]; then
    printf "${GREEN}CT: Lint & Test Helm Chart: ${dir} ${NC}\n"
    echo "Updating Helm repo in cluster..." && helm dependency update $dir
    ct lint-and-install --charts $dir --validate-maintainers=false

    if [ $? -ne 0 ]; then
        echo "ERROR: ct lint/test failed on: $dir"
        exit 1
    fi
fi

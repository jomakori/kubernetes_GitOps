# Purpose: Used for linting + testing helm charts in CI
## Note: You can test charts locally, using the script inside: .useful-scripts/ct_check.sh

#!/bin/bash

# Declarations
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Declarations
changed_files=$1
declare -A checked_dirs
helm_charts_checked=0
cluster_context=$(kubectl config current-context 2>/dev/null)

# Confirm connection to cluster
if [ -z "$cluster_context" ]; then
    echo "::error::ERROR: The EKS cluster credentials aren't set"
    exit 1
else
    printf "${GREEN}Testing out changes on: $cluster_context${NC}\n"
fi

# Processing
for file in $changed_files; do
    # Get the directory of the file
    dir=$(dirname $file)

    # Check if the directory is a helm directory and it has not been checked yet
    if [[ $dir =~ .*/helm/.* ]] && [[ -z ${checked_dirs[$dir]} ]]; then
        # Run the ct lint-and-install command on the directory
        printf "${GREEN}CT: Lint & Test Helm Chart: ${dir} ${NC}\n"
        echo "Updating Helm repo in cluster..." && helm dependency update
        ct lint-and-install --charts $dir --validate-maintainers=false

        # Error-catch
        exit_status=$?
        if [ $exit_status -ne 0 ]; then
            echo "::error::ERROR: ct lint/test failed on: $dir" # error message -> job summary
            exit 1
        fi

        # Mark the directory as checked
        checked_dirs[$dir]=1

        # Increment the count of helm charts checked
        ((helm_charts_checked++))
    fi
done

# If no helm charts were checked in
if [ $helm_charts_checked -eq 0 ]; then
    echo "::notice::No Helm changes detected." # notice message -> job summary
fi

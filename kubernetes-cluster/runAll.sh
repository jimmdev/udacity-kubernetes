# Give all stacks that shall be created as parameters.
# Make sure to follow the naming convention of all files.
for stack in "$@"
do
  stackName="udacity-k8s-$stack"
  stackYml="$stack.yml"
  stackParams="$stack-params.json"
  region='us-west-2'

  # Checking if stack does already exist to know if to create or update
  if ! aws cloudformation describe-stacks --stack-name $stackName ; then

    echo "Stack needs to be created. Will create it now."
    aws cloudformation create-stack \
      --stack-name $stackName --template-body file://$stackYml --parameters file://$stackParams \
      --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" --region $region

    echo "Waiting till stack creation is complete"
    aws cloudformation wait stack-create-complete --stack-name $stackName

  else
    echo "Stack does already exist, will updated it."
    # Allow an error to happen
    set +e
    updateResult=$(aws cloudformation update-stack \
      --stack-name $stackName --template-body file://$stackYml --parameters file://$stackParams \
      --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" --region $region 2>&1 )
    updateStatus=$?
    # Stop at errors again
    set -e

    if [ $updateStatus -ne 0 ] ; then
      # Need to check output, as the update command also fails, if stack is already up-to-date
      if [[ $updateResult == *"No updates are to be performed"* ]] ; then
        echo "Stack is already up-to-date"
      else
        exit $updateStatus
      fi
    else
      echo "Waiting till stack update is complete"
      aws cloudformation wait stack-update-complete --stack-name $stackName --region $region
    fi
  fi

  echo "Finished stack $stackName !"
done
echo "Creating deployment with revision at {RevisionType: S3,S3Location: {Bucket: aws-blog-lillian-codedeploybucket-1v1dpd4fzmjwg,Key: codebuild-artifact.zip,BundleType: zip},}"

deploymentId=`aws deploy create-deployment \
--application-name aws-blog-lillian-DemoApplication-Z8IE0P82HNC4 \
--deployment-config-name CodeDeployDefault.OneAtATime \
--deployment-group-name aws-blog-lillian-DemoFleet-R78YUARZE43L \
--s3-location bucket=aws-blog-lillian-codedeploybucket-1v1dpd4fzmjwg,key=codebuild-artifact.zip,bundleType=zip \
--region us-east-2 | grep 'deploymentId' | cut -f2 -d ":" | tr -d '"' | tr -d " "`
echo Monitoring deployment with ID: $deploymentId
DSTATUS=`aws deploy get-deployment --deployment-id $deploymentId --query 'deploymentInfo.status'`
DOVERVIEW=`aws deploy get-deployment --deployment-id $deploymentId --query 'deploymentInfo.deploymentOverview' | tr -d "\n" | tr -s " "`
echo "Deployment status: $DSTATUS; instances: $DOVERVIEW"
while [ $DSTATUS != "\"Succeeded\"" ]
do 
    CHECK_DOVERVIEW=`aws deploy get-deployment --deployment-id $deploymentId --query 'deploymentInfo.deploymentOverview' | tr -d "\n" | tr -s " "`
    if [ "$DOVERVIEW" != "$CHECK_DOVERVIEW" ]
        then
            DSTATUS=`aws deploy get-deployment --deployment-id $deploymentId --query 'deploymentInfo.status'`
            DOVERVIEW=$CHECK_DOVERVIEW
            echo "Deployment status: $DSTATUS; instances: $DOVERVIEW"
        fi
done
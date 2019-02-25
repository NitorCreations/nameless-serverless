terraform {
    backend "s3" {
        encrypt = true
        bucket = "$paramStateBucket"
        dynamodb_table = "$paramLockTable"
        region = "$REGION"
        key = "$COMPONENT/$ORIG_TERRAFORM_NAME-$paramEnvId.tfstate"
    }
}

import sns = require('@aws-cdk/aws-sns');
import sqs = require('@aws-cdk/aws-sqs');
import cdk = require('@aws-cdk/cdk');
import vars from "../variables.json";

export class CdkHelloStack extends cdk.Stack {
  constructor(scope: cdk.App, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const queue = new sqs.Queue(this, 'CdkHelloQueue' + vars.paramEnvId, {
      visibilityTimeoutSec: 300
    });

    const topic = new sns.Topic(this, 'CdkHelloTopic' + vars.paramEnvId);

    topic.subscribeQueue(queue);
  }
}

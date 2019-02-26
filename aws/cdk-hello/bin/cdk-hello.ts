#!/usr/bin/env node
import cdk = require('@aws-cdk/cdk');
import { CdkHelloStack } from '../lib/cdk-hello-stack';
import vars from "../variables.json";

const app = new cdk.App();
new CdkHelloStack(app, vars.ORIG_CDK_NAME + '-' + vars.paramEnvId);
app.run();

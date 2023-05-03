import 'source-map-support/register';
import * as cdk from 'aws-cdk-lib';
import * as blueprints from '@aws-quickstart/eks-blueprints';
import * as ecr from 'aws-cdk-lib/aws-ecr';

const app = new cdk.App();
const account = 'ACCOUNT_NUMBER_TOKEN';
const region = 'AWS_REGION_TOKEN';

const addOns: Array<blueprints.ClusterAddOn> = [
    new blueprints.addons.CalicoOperatorAddOn(),
    new blueprints.addons.MetricsServerAddOn(),
    new blueprints.addons.ClusterAutoScalerAddOn(),
    new blueprints.addons.AwsLoadBalancerControllerAddOn(),
    new blueprints.addons.VpcCniAddOn(),
    new blueprints.addons.CoreDnsAddOn(),
    new blueprints.addons.KubeProxyAddOn()
  ];

const stack = blueprints.EksBlueprint.builder()
    .account(account)
    .region(region)
    .addOns(...addOns)
    .useDefaultSecretEncryption(false) // set to false to turn secret encryption off (non-production/demo cases)
    .build(app, 'eks-blueprint');


// const repository = new ecr.Repository(stack, 'attrepo', {
//   repositoryName: 'attrepo',
// });

import boto3
import json

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    
    response = ec2.describe_instances(
        Filters=[
            {
                'Name': 'tag:Owner',
                'Values': ['agrynov']
            },
            {
                'Name': 'instance-state-name',
                'Values': ['running']
            }
        ]
    )

    instance_ids = [
        instance['InstanceId']
        for reservation in response['Reservations']
        for instance in reservation['Instances']
    ]
    
    stop_response = ec2.stop_instances(InstanceIds=instance_ids)
    return {
        'statusCode': 200,
        'body': json.dumps({
            'stopped_instances': instance_ids,
            'message': 'Operation completed',
            'details': stop_response.get('StoppingInstances', [])
        })
    }
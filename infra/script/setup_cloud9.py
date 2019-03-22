import boto3
import subprocess
import json

EC2_PREFIX = 'aws-cloud9-db-'

ec2 = boto3.client('ec2')

def all_instances():
    res = ec2.describe_instances()
    for r in res['Reservations']:
        for inst in r['Instances']:
            if 'Tags' in inst:
                kv = [t for t in inst['Tags'] if t['Key'] == 'Name'][0]
                if kv['Value'].startswith(EC2_PREFIX):
                    yield inst

def get_ebs_volume(inst):
    return inst['BlockDeviceMappings'][0]['Ebs']['VolumeId']

def update_ebs():
    for inst in all_instances():
        try:
            vol_id = get_ebs_volume(inst)
            resp = ec2.modify_volume(
                VolumeId=vol_id,
                Size=30,
            )
            print(resp)
        except:
            print('ignore {}'.format(inst['InstanceId']))

def update_security_group():
    sg = get_security_group_user_id()

    for inst in all_instances():
        groups = [sg['GroupId'] for sg in inst['SecurityGroups']]
        resp = ec2.modify_instance_attribute(
            InstanceId=inst['InstanceId'],
            Groups=groups+[sg]
        )
        print(resp)

def get_security_group_user_id():
    out = subprocess.check_output(['terraform', 'output', '-json'])
    res = json.loads(out)
    return res['security_group_user']['value']

update_ebs()
update_security_group()

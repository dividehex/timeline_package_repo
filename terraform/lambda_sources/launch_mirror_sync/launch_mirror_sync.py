import boto3


class LambdaException(Exception):
    def __init__(self, value):
        self.value = value
    def __str__(self):
        return repr(self.value)

def lambda_handler(event, context):
    ec2 = boto3.resource('ec2', region_name='us-west-2')

    # Do sanity checks
    try:
        check_if_ec2_aleady_exists(ec2)
    except LambdaException as e:
        # TODO: log failure
        print("Sanity check failed: ", e.value)
        return "Failed"
    except:
        raise

    # Launch instance and attach cache volume
    try:
        instance = launch_ec2(ec2)
    except LambdaException as e:
        # TODO: log failure
        print("Launch failed: ", e.value)
        return "Failed"
    except:
        raise
    return "Success"

def check_if_ec2_aleady_exists(ec2):
    filters = [
        {
            'Name': 'tag:Name',
            'Values': ['timeline_repo_mirror_sync']
        },
    ]

    # Grab a collection of instances that match the name tag
    instances = list(ec2.instances.filter(Filters=filters))

    # Iterate over instances and raise exception aif any are in
    # a state other than terminated
    for instance in instances:
        if instance.state['Name'] != 'terminated':
            raise LambdaException('instance_exists')     


def launch_ec2(ec2):
    try:
        instance = ec2.create_instances(LaunchTemplate={'LaunchTemplateName':'timeline_repo_ec2_launch_template', 'Version':'1'}, MinCount=1, MaxCount=1)[0]
        print('Success', instance.id)
    except:
        raise
    return instance


if __name__ == "__main__":
    lambda_handler(event=None, context=None)

import docker
import sys
import subprocess
import shlex
import time
import traceback
import yaml

def main():
    containers = []

    # Setup docker client
    client = docker.from_env()

    try:
        manifest = get_manifest()
        # If docker_images is missing or zero len it will reaise an exception
        len(manifest['docker_images'])

        images = pull_docker_images(client, manifest['docker_images'])
        containers = launch_docker_containers(client, images)

    except:
        print("Failed")
        traceback.print_exc(file=sys.stdout)
    finally:
        wait_on_containers(client, containers)
        exec_shutdown()

def pull_docker_images(client, docker_images):
    images = []

    for image in docker_images:
        print("Pulling {}".format(image))
        try:
            client.images.pull(image)
            images.append(image)
        except docker.errors.APIError:
            print("Can't run container; API error")
        except:
            # Leave the dead alone
            pass

    return images

def launch_docker_containers(client, docker_images):
    live_containers = []
    for image in docker_images:
        print("Running {}".format(image))
        label = image.replace(':', '_')
        try:
            container = client.containers.run(image,
                                  volumes={'/data/': {'bind': '/data', 'mode': 'rw'}},
                                  log_config={'type': 'awslogs', 'config': {'awslogs-group': 'tlpr_docker_logs', 'awslogs-stream': label}},
                                  detach=True,
                                  remove=True,
                                  )
            live_containers.append(container)
        except docker.errors.ImageNotFound:
            print("Can't run container; Image not found: {}".format(image))
        except docker.errors.APIError:
            print("Can't run container; API error")
        except:
            # We soldier on if a brother in arms dies
            print("Can't run container")
            pass
    return live_containers

def wait_on_containers(client, containers):
    # If container list is 0, just return
    for container in containers:
        try:
            print("Waiting on {}".format(container.image))
            container.wait(condition='removed')
        except:
            # If the container isn't found, it might have finished alreay so ignore
            pass
    return

def exec_shutdown():
    print("Shutting down...")
    # TODO: Make this shorter after debugging
    cmd_args = shlex.split('shutdown -P +30')
    try:
        completed_process = subprocess.run(cmd_args, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    except subprocess.CalledProcessError:
        print("Failed to call shutdown")

def get_manifest():
    with open('/manifest.yml', 'r') as f:
        try:
            manifest = yaml.load(f)
        except yaml.YAMLError as err:
            print("Failed to load yaml manifest")
            raise

    return manifest

if __name__ == "__main__":
    main()


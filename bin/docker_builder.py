#!/usr/bin/python
import os
import shutil
import sys
from argparse import ArgumentParser

class DockerBuilder:
    """
    Create Spark Docker file
    """

    def __init__(self,tag):
        self.version = tag
        self.docker_registry ='artifactory.iguazeng.com:6555'
        self.AUTH = 'auto:iguazio1'
        self.ART_DNS = 'artifactory.iguazeng.com:8081'
        self.ART_URL = 'http://{0}/artifactory'.format(self.ART_DNS)
        self.CWD = os.getcwd()
    
    def _create_tag(self,docker_name):
        """
        normalize the docker name for future operation
        """
        cmd = "docker images"
        arr=[]
        text = os.popen(cmd)
        for line in text:
            if self.version in line:
                if docker_name in line:
                    arr=line.split()
        docker_id = arr[2]
        #artifactory.iguazeng.com:6555/igz_0.12.5_b34_20170629142707/spark2-standalone - >
        #        artifactory.iguazeng.com:6555/spark2-standalone
        short_tag_name="artifactory.iguazeng.com:6555/{}".format(docker_name)

        try:
                print "[INFO]: creating tag {}".format(short_tag_name)
                os.system("docker tag {0} {1}".format(docker_id,short_tag_name))
        except:
                print "[ERROR]: cant create the docker tag : {}".format(short_tag_name)
                sys.exit()


    def _create_emr_runner_docker(self):
        "create emr runner docker "
        docker_name = 'artifactory.iguazeng.com:6555/{0}/emr-runner:latest'.format(self.version)
        cmd = '''docker build -t {0} {1}/docker_builder/emr-runner '''.format(docker_name, self.CWD )
        create_tag =  "emr-runner"

        try:
            print("[INFO]: run docker build: {}".format(cmd))
            os.system(cmd)
        except:
            print("[ERROR]: can't create the docker ")

        self._create_tag(create_tag)

    def _push_docker_image(self,repo_name,docker_name):
        """
        upload docker images
        example: outside dockerhub
        docker push iguaziodocker/spark-standalone:igz_development_b553_20170329140449
        example: inside dockerhub
        docker push artifactory.iguazeng.com:6555/igz_development_b553_20170329140449/spark-standalone:test
        """
    	try:
            #push_cmd = 'docker push iguaziodocker/spark-standalone:{0}'.format(self.version)
            push_cmd = 'docker push {0}/{1}/{2}:latest'.format(repo_name,self.version,docker_name)
            os.system(push_cmd)
    	except:
    		print("[ERROR]: upload failed {0}".format(push_cmd))

    def generate_image(self):
        """
        main docker image generator
        """
        self._docker_cleaner()
        self._create_emr_runner_docker()
        self._push_docker_image("artifactory.iguazeng.com:6555","emr-runner")

    def _docker_cleaner(self):
        """delete all dockers with images from the host"""
        print("delete all dockers and images from the host")
        try:
            # Delete all containers
            os.system("docker rm -f $(docker ps -a -q)")
            # Delete all images
            os.system("docker rmi -f $(docker images -q)")
        except:
            pass


def get_latest_tag_version():
    """getting latest version tag from artifactory """
    try:
        os.system("curl -u auto:iguazio1 -O http://artifactory.iguazeng.com:8081/artifactory/iguazio_tags/latest/version.txt")
    except:
        print("[ERROR] the file {0} is not found".format(ver_file_path))

    with open("version.txt") as f:
        tagBuild = f.readline()
    return tagBuild

def main():
    #tag = 'igz_0.12.6_b36_20170703185723'
    parser = ArgumentParser()

    # Add more options if you like
    parser.add_argument("-t", "--tag", dest="tag",
                        help="Build Tag version")

    args = parser.parse_args()

    if args.tag == "latest":
        print "[INFO]: getting the last version"
        print "[HELP]: run command in following format:\n docker_builder.py --tag specificBuildTag"
        build_tag=get_latest_tag_version()
    elif args.tag == None:
    	print "[INFO]: getting the last version"
    	print "[HELP]: run command in following format:\n docker_builder.py --tag specificBuildTag"
        sys.exit(1)
    else:
        build_tag=args.tag

    docker = DockerBuilder(build_tag)
    docker.generate_image()

if __name__=='__main__':
    main()

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


    def _prepare_jars_pkgs(self,spark_ver=2):
        """ prepare generic jars and zip for docker"""
        if spark_ver == 1:
            pkg_path=os.path.join(self.CWD,"docker_builder","spark-standalone")
            pkg_list = { "v3io-hcfs.jar":"{0}/iguazio_mvn/io/iguaz/v3io/v3io-hcfs_2.10/{1}/v3io-hcfs_2.10-{2}.jar".format(self.ART_URL,self.version,self.version),
            "v3io-spark-object-dataframe.jar":"{0}/iguazio_mvn/io/iguaz/v3io/v3io-spark-object-dataframe_2.10/{1}/v3io-spark-object-dataframe_2.10-{2}.jar".format(self.ART_URL,self.version,self.version),
            "v3io-spark-streaming.jar":"{0}/iguazio_mvn/io/iguaz/v3io/v3io-spark-streaming_2.10/{1}/v3io-spark-streaming_2.10-{2}.jar".format(self.ART_URL,self.version,self.version),
            "v3io-py.zip":"{0}/iguazio_mvn/io/iguaz/v3io/v3io-py/{1}/v3io-py-{2}.zip".format(self.ART_URL,self.version ,self.version),
            "spark-1.6.2-bin-hadoop2.6.tgz":"{0}/iguazio_public/spark/spark-1.6.2/spark-1.6.2-bin-hadoop2.6.tgz".format(self.ART_URL),
            "scala-library-2.10.5.jar":"{0}/jcenter-cache/org/scala-lang/scala-library/2.10.5/scala-library-2.10.5.jar".format(self.ART_URL)
                     }
        if spark_ver == 2:
            pkg_path=os.path.join(self.CWD,"docker_builder","spark2-standalone")
            pkg_list = { "v3io-hcfs.jar":"{0}/iguazio_mvn/io/iguaz/v3io/v3io-hcfs_2.11/{1}/v3io-hcfs_2.11-{2}.jar".format(self.ART_URL,self.version,self.version),
            "v3io-spark-object-dataframe.jar":"{0}/iguazio_mvn/io/iguaz/v3io/v3io-spark2-object-dataframe_2.11/{1}/v3io-spark2-object-dataframe_2.11-{2}.jar".format(self.ART_URL,self.version,self.version),
            "v3io-spark-streaming.jar":"{0}/iguazio_mvn/io/iguaz/v3io/v3io-spark2-streaming_2.11/{1}/v3io-spark2-streaming_2.11-{2}.jar".format(self.ART_URL,self.version,self.version),
            "v3io-py.zip":"{0}/iguazio_mvn/io/iguaz/v3io/v3io-py/{1}/v3io-py-{2}.zip".format(self.ART_URL,self.version ,self.version),
            "spark-2.1.1-bin-hadoop2.7.tgz":"{0}/iguazio_public/spark/spark-2.1.1/spark-2.1.1-bin-hadoop2.7.tgz".format(self.ART_URL),
            "scala-library-2.11.8.jar":"{0}/jcenter-cache/org/scala-lang/scala-library/2.11.8/scala-library-2.11.8.jar".format(self.ART_URL)
                     }

        for file_name,dsf_file in pkg_list.iteritems():
            print("[INFO]: downloading {0} to {1}".format(dsf_file,file_name))
            try:
                #ci.run_cli('curl -o {0} {1}'.format(dsf_file, file_name))
                os.system("curl -u {0} -o {1}/{2} {3}".format(self.AUTH, pkg_path, file_name, dsf_file ))
            except:
                print("[ERROR] the file {0} is not found".format(dsf_file))


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


    def _create_spark_docker_image(self,spark_ver=2):
        if spark_ver == 1:
            docker_name = 'artifactory.iguazeng.com:6555/{0}/spark-standalone:latest'.format(self.version)
            cmd = '''docker build -t {0} {1}/docker_builder/spark-standalone '''.format(docker_name, self.CWD )
            create_tag =  "spark-standalone"
        elif spark_ver == 2:
            docker_name = 'artifactory.iguazeng.com:6555/{0}/spark2-standalone:latest'.format(self.version)
            cmd = '''docker build -t {0} {1}/docker_builder/spark2-standalone '''.format(docker_name, self.CWD )
            create_tag =  "spark2-standalone"
        else:
            print('[ERROR]: this version {0} is currently not supported '.format())

        try:
            print("[INFO]: run docker build: {}".format(cmd))
            os.system(cmd)
        except:
            print("[ERROR]: can't create the docker ")

        self._create_tag(create_tag)

    def _create_zeppelin_docker_image(self,spark_ver=2):
        docker_name = 'artifactory.iguazeng.com:6555/{0}/zeppelin:latest'.format(self.version)
        cmd = '''docker build -t {0} {1}/docker_builder/zeppelin '''.format(docker_name, self.CWD)
        create_tag = "zeppelin"
        try:
            print("[INFO]: run docker build: {}".format(cmd))
            os.system(cmd)
        except:
            print("[ERROR]: can't create the docker ")

        self._create_tag(create_tag)

    def _create_zeppelin_docker(self):
        #download binary
        #curl -u auto:iguazio1 -O http://artifactory.iguazeng.com:8081/artifactory/iguazio_install/zeppelin-0.7.1-bin-all.tgz

        file_name = "{0}/docker_builder/zeppelin/zeppelin-0.7.1-bin-all.tgz".format(self.CWD)
        dsf_file = "{0}/iguazio_install/zeppelin-0.7.1-bin-all.tgz".format(self.ART_URL)
        cmd = """curl -u {0} -o {2} {1}""".format(self.AUTH, dsf_file, file_name)
        try:
            os.system(cmd)
        except:
            print("[ERROR] the file {0} is not found".format(dsf_file))


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
        self._prepare_jars_pkgs()
        self._create_spark_docker_image()
        self._create_zeppelin_docker()
        self._create_zeppelin_docker_image()
        self._push_docker_image("artifactory.iguazeng.com:6555","spark2-standalone")
        self._push_docker_image("artifactory.iguazeng.com:6555","zeppelin")

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

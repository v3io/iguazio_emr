#!/usr/bin/env python2
import os
import sys
import json
from argparse import ArgumentParser

class EMRuploader:
    """
    Uploading EMR dependencies to S3 bucket
    """

    def __init__(self,tag):
        self.version = tag
        self.docker_registry ='artifactory.iguazeng.com:6555'
        self.AUTH = 'auto:iguazio1'
        self.ART_DNS = 'artifactory.iguazeng.com:8081'
        self.ART_URL = 'http://{0}/artifactory'.format(self.ART_DNS)
        self.CWD = os.getcwd()
        self.spark_pkgs_json='./bin/upload_emr_ver2S3.json'

    def _prepare_jars_pkgs(self,spark_ver):
        """ prepare generic jars and zip for docker"""
        if spark_ver == 1:
            download_path=os.path.join(self.CWD,"AWS/EMR/s3_bucket/emr-4.8.2")
            pkg_list = { "v3io-hcfs.jar":"{0}/iguazio_mvn/io/iguaz/v3io/v3io-hcfs_2.10/{1}/v3io-hcfs_2.10-{2}.jar".format(self.ART_URL,self.version,self.version),
            "v3io-spark-object-dataframe.jar":"{0}/iguazio_mvn/io/iguaz/v3io/v3io-spark-object-dataframe_2.10/{1}/v3io-spark-object-dataframe_2.10-{2}.jar".format(self.ART_URL,self.version,self.version),
            "v3io-spark-streaming.jar":"{0}/iguazio_mvn/io/iguaz/v3io/v3io-spark-streaming_2.10/{1}/v3io-spark-streaming_2.10-{2}.jar".format(self.ART_URL,self.version,self.version),
            "v3io-py.zip":"{0}/iguazio_mvn/io/iguaz/v3io/v3io-py/{1}/v3io-py-{2}.zip".format(self.ART_URL,self.version ,self.version),
            "spark-1.6.2-bin-hadoop2.6.tgz":"{0}/iguazio_public/spark/spark-1.6.2/spark-1.6.2-bin-hadoop2.6.tgz".format(self.ART_URL),
            "scala-library-2.10.5.jar":"{0}/jcenter-cache/org/scala-lang/scala-library/2.10.5/scala-library-2.10.5.jar".format(self.ART_URL)
                     }
        if spark_ver == 2:
            download_path=os.path.join(self.CWD,"AWS/EMR/s3_bucket/emr-5.6.0/artifacts")
            pkg_list = { "v3io-hcfs.jar":"{0}/iguazio_mvn/io/iguaz/v3io/v3io-hcfs_2.11/{1}/v3io-hcfs_2.11-{2}.jar".format(self.ART_URL,self.version,self.version),
            "v3io-spark-object-dataframe.jar":"{0}/iguazio_mvn/io/iguaz/v3io/v3io-spark2-object-dataframe_2.11/{1}/v3io-spark2-object-dataframe_2.11-{2}.jar".format(self.ART_URL,self.version,self.version),
            "v3io-spark-streaming.jar":"{0}/iguazio_mvn/io/iguaz/v3io/v3io-spark2-streaming_2.11/{1}/v3io-spark2-streaming_2.11-{2}.jar".format(self.ART_URL,self.version,self.version),
            "v3io-py.zip":"{0}/iguazio_mvn/io/iguaz/v3io/v3io-py/{1}/v3io-py-{2}.zip".format(self.ART_URL,self.version ,self.version),
            "spark-2.1.1-bin-hadoop2.7.tgz":"{0}/iguazio_public/spark/spark-2.1.1/spark-2.1.1-bin-hadoop2.7.tgz".format(self.ART_URL),
            "v3io-hcfs_2.11-1.5.0.jar":"{0}/iguazio_devops/install_distribution/presto/v3io-hcfs_2.11-1.5.0.jar".format(self.ART_URL),
            "v3io-presto_2.11-1.5.0.jar":"{0}/iguazio_devops/install_distribution/presto/v3io-presto_2.11-1.5.0.jar".format(self.ART_URL),
            "scala-library-2.11.8.jar":"{0}/jcenter-cache/org/scala-lang/scala-library/2.11.8/scala-library-2.11.8.jar".format(self.ART_URL)
                     }

        for file_name,dsf_file in pkg_list.iteritems():
            print("[INFO]: downloading {0} to {1}".format(dsf_file,file_name))
            try:
                #ci.run_cli('curl -o {0} {1}'.format(dsf_file, file_name))
                os.system("curl -u {0} -o {1}/{2} {3}".format(self.AUTH, download_path,  file_name, dsf_file ))
            except:
                print("[ERROR] the file {0} is not found".format(dsf_file))

    def _docker_pull(self):
        cmd = []
        cmd.append("""rm -f ./v3io_daemon_docker.tar""")
        cmd.append("""docker stop v3io-daemon""")
        cmd.append("""docker rm -f v3io-daemon""")
        cmd.append("""docker rmi -f $(docker images | awk '/v3io/ { print $3 } ')""")
        cmd.append("""docker login -p jUxAtUsP5c8eqADrEnEc7 -u igz_docker artifactory.iguazeng.com:6555""")
        cmd.append("""docker pull artifactory.iguazeng.com:6555/{0}/v3io_daemon:latest""".format(self.version))
        cmd.append("""docker tag  $(docker images | awk ' /v3io/ { print $3 } ') iguaziodocker/v3io_daemon:latest """)
        cmd.append("""docker image save iguaziodocker/v3io_daemon -o v3io_daemon_docker.tar""")

        for command in cmd:
            try:
                os.system(command)
            except:
                print "[WARRNING]: command {} false".format(command)

    def _rpm_pool(self,spark_ver):
        cmd = []
        pkg_list = { "igz-accelio.rpm":"{0}/iguazio_amazon/{1}/igz-accelio.rpm".format(self.ART_URL,self.version),
            "igz-bridge.rpm":"{0}/iguazio_amazon/{1}/igz-bridge.rpm".format(self.ART_URL,self.version),
            "igz-endo.rpm":"{0}/iguazio_amazon/{1}/igz-endo.rpm".format(self.ART_URL,self.version),
            "igz-fio.rpm":"{0}/iguazio_amazon/{1}/igz-fio.rpm".format(self.ART_URL,self.version),
            "igz-fuse.rpm":"{0}/iguazio_amazon/{1}/igz-fuse.rpm".format(self.ART_URL,self.version),
            "igz-log.rpm":"{0}/iguazio_amazon/{1}/igz-log.rpm".format(self.ART_URL,self.version),
            "igz-manof.rpm":"{0}/iguazio_amazon/{1}/igz-manof.rpm".format(self.ART_URL,self.version),
            "igz-nginx.rpm":"{0}/iguazio_amazon/{1}/igz-nginx.rpm".format(self.ART_URL,self.version),
            "igz-node.rpm":"{0}/iguazio_amazon/{1}/igz-node.rpm".format(self.ART_URL,self.version),
            "igz-provision.rpm":"{0}/iguazio_amazon/{1}/igz-provision.rpm".format(self.ART_URL,self.version),
            "igz-pyv3io.rpm":"{0}/iguazio_amazon/{1}/igz-pyv3io.rpm".format(self.ART_URL,self.version),
            "igz-v3io-daemon.rpm":"{0}/iguazio_amazon/{1}/igz-v3io-daemon.rpm".format(self.ART_URL,self.version),
            "igz-v3io-hcfs.rpm":"{0}/iguazio_amazon/{1}/igz-v3io-hcfs.rpm".format(self.ART_URL,self.version), 
            "iperf3-3.1.3-1.fc24.x86_64.rpm":"{0}/iguazio-devops/iperf3-3.1.3-1.fc24.x86_64.rpm".format(self.ART_URL) }

        for file_name,dsf_file in pkg_list.iteritems():
            print("[INFO]: downloading {0} to {1}".format(dsf_file,file_name))
            try:
                #ci.run_cli('curl -o {0} {1}'.format(dsf_file, file_name))
                if spark_ver == 1:
                    #download_path=os.path.join(self.CWD,"AWS/EMR/s3_bucket/emr-4.8.2")
                    print "4.8.2 expired"
                elif spark_ver == 2:
                    download_path=os.path.join(self.CWD,"AWS/EMR/s3_bucket/emr-5.6.0/artifacts")

                if not os.path.exists(download_path):
                    os.makedirs(download_path)

                else:
                    print("Current version {} is not supported".format(spark_ver))

                os.system("curl -u {0} -o {1}/{2} {3}".format(self.AUTH, download_path, file_name, dsf_file ))
            except:
                print("[ERROR] the file {0} is not found".format(dsf_file))

    def upload(self):
    	print "uploading starting "
        try:
            f_json=open(self.spark_pkgs_json,'r')
        except:
            print('file {} is not exist : '.format(self.spark_pkgs_json))
            sys.exit()

        try:
            conf=json.load(f_json)
        except:
            print('[ERROR]: json file is brocken ')
            sys.exit()
        finally:
            f_json.close()

        for versions in conf.values():
            ver1,ver2 = versions

        #download common v3io-daemon docker from artifactory:
        #self._docker_pull()
        #running for 2 versions
        #1 -> 1.6
        #2 -> 2.1
        for spark_ver in  range(1,3):
            if spark_ver == 1:
                continue
            for keys in eval("ver%s"%spark_ver).values():
                packages,buckets = keys
            self._rpm_pool(spark_ver)
            self._prepare_jars_pkgs(spark_ver)
            #self._gen_docs()
            for pkg_list in packages.values():
                for pkg in pkg_list:
                    cmd = "aws s3 cp {0} {1} --acl aws-exec-read".format(pkg,buckets.values()[0])
                    try:
                        os.system(cmd)
                    except:
                        print "ERROR: {0} is false".format(cmd)

    def _gen_docs(self):
        docs_path = os.path.join(self.CWD, "docs")
        for ddocs in ["/tmp/doc", docs_path ]:
            if os.path.exists(ddocs):
                try:
                    os.system("rm -rf {}".format(ddocs))
                except:
                    print "[ERROR]: cant delete directory {}".format(ddocs)
        os.system("mkdir /tmp/doc")
        os.chdir("/tmp/doc")
        try:
            #TODO better to get repo by our command tag
            os.system("git clone git@github.com:iguazio/docs.git")
        except:
            print "[ERROR]: the documentation doesn't pulled from the git repository"
            print "check your access to the git@github.com:iguazio/docs.git repository and try again"
        os.chdir(self.CWD)

        cmd_mv = "mv /tmp/doc/docs/_docs_output/igz_qsg_aws_emr_setup.html {0}".format(docs_path)
        cmd_upload="aws s3 cp  --recursive {} s3://igz-emr-test/docs/ --acl aws-exec-read".format(docs_path)
        for cmd in [cmd_mv,cmd_upload]:
            try:
                os.system(cmd)
            except:
                print "[ERROR]: docs upload failed"

    def upload_emr_install(self):
        try:
            cmd="aws s3 cp  --recursive ./AWS/EMR/emr_install/emr-5.6.0 s3://igz-emr-test/emr-5.6.0/emr-install/ --acl aws-exec-read"
            os.system(cmd)
        except:
            print "[ERROR]: emr-install scripts upload failed"

    def delete_artifacts(self):
        """
        generate tar archive for the customer from downloaded versions
        """
        # clean previous versions
        cmd="""rm -rf ./docs AWS/EMR/s3_bucket/emr-5.6.0/*.{rpm,jar,zip,tgz,tar} ./*.tgz AWS/EMR/s3_bucket/emr-5.6.0/logs """
        try:
            os.system(cmd)
        except Exception as err:
            print err
            pass

    def upload_http_bluster(self):
        """
        upload http_bluster
        """
        file_name="emr_streaming.tar"
        dsf_file="{0}/iguazio-devops/EMR/{1}".format(self.ART_URL,file_name)
        download_path=os.path.join(self.CWD,"AWS/EMR/s3_bucket/emr-5.6.0/artifacts")
        print "DEBUG downloading curl -u {0} -o {1}/{2} {3}".format(self.AUTH, download_path, file_name, dsf_file )
        os.system("curl -u {0} -o {1}/{2} {3}".format(self.AUTH, download_path, file_name, dsf_file ))



def main():
    #last version tag igz_0.12.5_b34_20170629142707
    # Note: POC version igz_development_b1128_20170604124159
    parser = ArgumentParser()

    # Add CLI options
    parser.add_argument("-t", "--tag", dest="myTag", help="""
    The script upload the last version to s3 buket and generate tar archive
    with full version for the customer . \n
    please define the iguazio tag name \n
    ./bin/upload_emr_ver2S3.py --tag igz_0.12.6_b36_20170703185723
                                                          """ )
    args = parser.parse_args()

    if args.myTag:
        print("[INFO]: Current tag {}".format(args.myTag))
        action = EMRuploader(args.myTag)
        action.delete_artifacts()
        action.upload_http_bluster()
        action.upload()
        action.upload_emr_install()
    else:
        help="""
        please define the iguazio tag name \n
        ./bin/upload_emr_ver2S3.py --tag igz_0.12.6_b36_20170703185723
        """
        print(help)
        sys.exit(1)

if __name__=='__main__':
    main()

#!/usr/bin/env python2
import os
import sys
import json
from argparse import ArgumentParser
import logging 

def main():

    parser = ArgumentParser()
    parser.add_argument("-t", "--tag", dest="myTag", help = """
    
    The script upload the last version to s3 buket and generate tar archive
    with full version for the customer . \n
    please define the iguazio tag name \n
    ./bin/upload_emr_ver2S3.py --tag igz_0.12.6_b36_20170703185723 \n 
    
    """ )
    parser.add_argument( "-f", "--config-file", dest="config_file", help="config file ",
    default='./bin/upload_emr_ver2S3.json')
    args = parser.parse_args()

    if args.myTag:
        print("[INFO]: Current tag {}".format(args.myTag))
        action = EMRuploader(args.myTag,args.config_file)
        action.clean_local_artifacts()
        action.upload_http_bluster()
        # action.upload()
        # action.upload_emr_install()
    else:
        help="""
        please define the iguazio tag name \n
        ./bin/upload_emr_ver2S3.py --tag igz_0.12.6_b36_20170703185723 
        """
        print(help)
        sys.exit(1)


class EMRuploader:
    """
    Uploading EMR dependencies to S3 bucket
    """

    def __init__(self, tag, config_file):
        self.version = tag
        self.spark_pkgs_json = config_file
        with open(self.spark_pkgs_json,'r') as fr:
            self.packages = json.load(fr)
            self.s3_bucket = self.packages['s3_bucket']
            self.docker_registry = self.packages['docker_registry']
            self.AUTH = self.packages['artifactory_auth']
            self.ART_URL = self.packages['artifactory_url']
            self.CWD = os.getcwd()
        fr.close()

    def _prepare_pkgs(self):
        """ 
            download artifacts from artifactory 
        """
        for package in self.packages['packages']:
            if 'ARTIFACTORY' in package['src_pkg'].encode("ascii"):
                url = package['src_pkg'].encode("ascii").replace('ARTIFACTORY',self.ART_URL)
                cmd = url.replace('VERSION',self.version)

                print("[INFO]: downloading {0} to {1}".format(dsf_file,file_name))
                try:
                    #ci.run_cli('curl -o {0} {1}'.format(dsf_file, file_name))
                    os.system("curl -u {0} -o {1}/{2} {3}".format(self.AUTH, download_path,  file_name, dsf_file ))
                except:
                    print("[ERROR] the file {0} is not found".format(dsf_file))

            download_path=os.path.join(self.CWD,"AWS/EMR/s3_bucket/emr-5.6.0/artifacts")

            if not os.path.exists(download_path):
                os.makedirs(download_path)

            else:
                print("Current version {} is not supported".format(spark_ver))

            os.system("curl -u {0} -o {1}/{2} {3}".format(self.AUTH, download_path, file_name, dsf_file ))
 

    def upload(self):
        try:
            f_json= open(self.spark_pkgs_json,'r')
            conf=json.load(f_json)
        except:
            print('[ERROR]: failed load json file')
            sys.exit()
        finally:
            f_json.close()

        self._prepare_pkgs(spark_ver)

        for pkg_list in packages.values():
            for pkg in pkg_list:
                cmd = "aws s3 cp {0} {1} --acl aws-exec-read".format(pkg,buckets.values()[0])
                try:
                    os.system(cmd)
                except:
                    print "ERROR: {0} is false".format(cmd)

    def upload_emr_install(self):
        try:
            cmd="aws s3 cp  --recursive ./AWS/EMR/emr_install/emr-5.6.0 s3://igz-emr-test/emr-5.6.0/emr-install/ --acl aws-exec-read"
            os.system(cmd)
        except:
            print "[ERROR]: emr-install scripts upload failed"

    def clean_local_artifacts(self):
        """
        generate tar archive for the customer from downloaded versions
        """
        print('running clean_local_artifacts')
        # clean previous versions
        cmd="""rm -rf AWS/EMR/s3_bucket/emr-5.6.0/*.{rpm,jar,zip,tgz,tar} ./*.tgz AWS/EMR/s3_bucket/emr-5.6.0/logs """
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

if __name__=='__main__':
    main()

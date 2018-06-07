#!/usr/bin/python
import argparse
import os

SECRET_PATHS = ['/home/iguazio/.igz', '/var/lib/presto/.igz']
SECRET_FILE_NAME = '.secret'


def parse_args():
    parser = argparse.ArgumentParser(description='change tenatn')
    parser.add_argument('-container', type=str, default='bigdata', help='the default contianer name')
    parser.add_argument('-tenant', type=str, default='Default', help='the tenant name associated with the EMR cluster')
    return parser.parse_args()


def create_secret(tenant_name):
    for SECRET_PATH in SECRET_PATHS:
        if os.path.exists(SECRET_PATH) is False:
            os.makedirs(SECRET_PATH)
        text = '# This is the default V3IO authentication configuration\n\
        # The default location of this configuration is at $HOME/.igz/.secret\n\
        # The path to configuration file could be provided by user via Java system property v3io.config.auth.file\n\
        # Make sure that only owner have read permission to the $HOME/.igz directory and its content [chmod -R 600 $HOME/.igz]\n\
        v3io.client.session.password="ZGF0YWxAa2Uh"\n\
        v3io.client.session.tenant="{}"'.format(tenant_name)

        secret_full_path = os.path.join(SECRET_PATH, SECRET_FILE_NAME)
        with open(secret_full_path, 'w') as secret_file:
            secret_file.write(text)


def add_container_name(continer_name):
    with open('/opt/iguazio/bigdata/conf/v3io.conf', 'r+') as v3io_conf:
        container_id = 'container-id=\"{}\"\n'.format(continer_name)
        old_text = v3io_conf.read()
        if 'container-id=' in old_text.split('\n')[0]:
            old_text = old_text.split('\n', 1)[1]
        v3io_conf.seek(0)
        v3io_conf.write(container_id + old_text)


def main():
    args = parse_args()
    create_secret(args.tenant)
    add_container_name(args.container)


if __name__ == '__main__':
    main()

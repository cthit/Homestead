#!/usr/bin/env bash
conf_dir="/etc/ldap"
conf_tar="/vagrant/data/ldap-conf.tar.gz"
data_dir="/var/lib/ldap"
data_tar="/vagrant/data/ldap-data.tar.gz"

if [[ ! -e "$data_tar" || ! -e "$conf_tar" ]]; then
    echo "You are missing the LDAP data/conf. Ignoring ldap..."
    exit 0
fi

export DEBIAN_FRONTEND=noninteractive
apt-get -qq -y update
apt-get -qq -y install slapd ldap-utils php5-ldap

service slapd stop

# Unpack the configuration
rm -rf $conf_dir/*
cd $conf_dir
tar -xf $conf_tar

# Unpack ldap data
rm -rf $data_dir/*
cd $data_dir
tar -xf $data_tar


# Set correct permissions
chown -R openldap: $conf_dir $data_dir

# Fool the dns servers...
echo "127.0.1.1 ldap.chalmers.it" >> /etc/hosts
echo "127.0.1.1 chalmersit-laravel" >> /etc/hosts
echo "127.0.1.1 chalmersit-account" >> /etc/hosts

# Hope for the best!
service slapd start

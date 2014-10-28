#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
apt-get -q -y install slapd ldap-utils

service slapd stop

# Unpack the configuration
rm -rf /etc/ldap/*
cd /etc/ldap
tar -xf /vagrant/data/ldap-conf.tar.gz

# Unpack ldap data
rm -rf /var/lib/ldap/*
cd /var/lib/ldap
tar -xf /vagrant/data/ldap-data.tar.gz


# Set correct permissions
chown -R openldap: /etc/ldap/ /var/lib/ldap/

# Fool the dns servers...
echo "127.0.1.1 ldap.chalmers.it" >> /etc/hosts
echo "127.0.1.1 chalmers.it" >> /etc/hosts
echo "127.0.1.1 account.chalmers.it" >> /etc/hosts


# Hope for the best!
service slapd start

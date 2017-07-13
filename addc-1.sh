#!/bin/bash

source  ./valtozok.sh

clear
echo "======================================================================= "
echo "=                                                                     ="
echo "=               Maxmedia Samba-AD-DC generator                        ="
echo "=                                                                     ="
echo "=                         s z k r i p t                               ="
echo "=                                                                     ="
echo "=                                                                     ="
echo "=  Maxmedia Kft.                            2017.04.28.               ="
echo "======================================================================="
echo " "
echo " "
echo " "
echo "Ellenorzd le a parametereket, ha nem jo szakitsd meg"
echo " "
echo " "
cat /etc/network/interfaces
echo " "
cat /etc/hostname
echo " "
echo " "
echo "                                                  FONTOS     "
echo "Samba_realm,      pl: maxmedia.lan     formaban:      $SAMBA_REALM"
echo "Samba domain,     pl: MAXMEDIA         formaban:      $SAMBA_DOMAIN"
echo "Szerver neve,     pl: maxmedia-ad-dc   formaban:      $SAMBA_HOST"
echo "Szerver ip,       pl: 192.168.10.2     formaban:      $SAMBA_IP"
echo "AD admin jelszo,  pl: Ab123456         formaban:      $SAMBA_ADMINPASS"
echo "Kerberos realm    szamitott ertek                     $KERBEROS_REALM "
echo "Samba LDAP DC     szamitott ertek                     $SAMBA_LDAPDC"
echo "Samba NIS domain  szamitott ertek                     $SAMBA_NISDOMAIN"
echo " "
echo " "
echo " Nem kell beallitani a hostnevet, megcsinalja "
read -p "Ellenorzd le a parametereket, ha nem jo szakitsd meg,vagy nyomj meg egy gombot a folytatashoz... " -n1 -s
echo " "
echo " "
echo " "
echo " "


#Ha van smbconf akkor exit
if [ -f $SAMBA_CONFIG ] ; then
	echo "Van smb.conf!!! Ezert kileptem!  Ezen a gepen akarsz dolgozni???"
	echo " "
	echo " "
	echo " "
	exit 0
fi


#Teljes frissites
apt-get update
apt-get -y dist-upgrade
apt install -y popularity-contest

#Egyeb programok telepitese
apt-get -y install rsync mc iptraf fail2ban ntp iotop sshfs net-tools bash-completion
apt-get -y install acl attr

read -p "Az alapbeallitasok kovetkeznek. Nyomj meg egy gombot a folytatashoz... " -n1 -s

#Alapbeallitasok
mv /etc/hostname /etc/hostname.ORIG
cat <<EOF > /etc/hostname
$SAMBA_HOST
EOF
echo "Samba_realm,      pl: maxmedia.lan     formaban:      $SAMBA_REALM"
echo "Samba domain,     pl: MAXMEDIA         formaban:      $SAMBA_DOMAIN"
echo "Szerver neve,     pl: maxmedia-ad-dc   formaban:      $SAMBA_HOST"
echo "Szerver ip,       pl: 192.168.10.2     formaban:      $SAMBA_IP"
echo "AD admin jelszo,  pl: Ab123456         formaban:      $SAMBA_ADMINPASS"
echo "127.0.0.1     localhost localhost.localdomain"
echo "$SAMBA_IP    $SAMBA_HOST.$SAMBA_REALM  $SAMBA_HOST"
echo " "
echo " Masold le az utolso sort!!! "
echo " "
echo " "
read -p "A fentiek alapjan modositsd a hosts fajlt. Nyomj meg egy gombot a folytatashoz... " -n1 -s
nano /etc/hosts
mkdir -p /srv/samba
mkdir -p /srv/home


#Samba es kapcsolodo programok telepitese
apt-get -y install isc-dhcp-server
apt-get -y install samba ldb-tools winbind krb5-user sssd smbclient 



#apt rendcsinalas ide

#samba stop
service nmbd stop
service smbd stop
/etc/init.d/samba stop
mv /etc/samba/smb.conf /etc/samba/smb.conf.ORIG

#SSSD conf elkeszitese
cat <<EOF > /etc/sssd/sssd.conf
[sssd]
services = nss, pam
config_file_version = 2
domains = $SAMBA_REALM
debug_level = 6

[nss]

[pam]

[domain/$SAMBA_REALM]
id_provider = ad
access_provider = ad
krb5_keytab=/etc/krb5.keytab
krb5_realm = $KERBEROS_REALM
ldap_id_mapping = false
enumerate = true
EOF

chown root:root /etc/sssd/sssd.conf
chmod 600 /etc/sssd/sssd.conf

#resolv.conf modositasa
cat > /etc/resolv.conf <<EOF
domain $SAMBA_REALM
search $SAMBA_REALM
nameserver $SAMBA_IP
EOF

read -p "Kovetkezik a domain provision. Nyomj meg egy gombot a folytatashoz... " -n1 -s
samba-tool domain provision \
--host-name=$SAMBA_HOST \
--host-ip=$SAMBA_IP \
--realm=$SAMBA_REALM \
--domain=$SAMBA_DOMAIN \
--adminpass=$SAMBA_ADMINPASS \
--function-level=2008_R2 \
--use-rfc2307 \
--server-role=dc \
--dns-backend=SAMBA_INTERNAL


#Kerberos
rm -f /etc/krb5.conf && cp -f /var/lib/samba/private/krb5.conf /etc/krb5.conf
samba-tool domain exportkeytab /etc/krb5.keytab
echo " "
read -p "Reboot!!!        Nyomj meg egy gombot a folytatashoz... " -n1 -s
echo " "
reboot








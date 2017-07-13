#!/bin/bash

source ./valtozok.sh

clear
echo "======================================================================= "
echo "=                                                                     ="
echo "=               Maxmedia Samba-AD-DC generator II                     ="
echo "=                                                                     ="
echo "=                         s z k r i p t                               ="
echo "=                                                                     ="
echo "=                                                                     ="
echo "=  Maxmedia Kft.                            2016.11.19.               ="
echo "======================================================================="
echo " "
echo " "
echo " "
echo "Ellenorzd le a parametereket, ha nem jo szakitsd meg"
echo " "
echo " "
echo "                                                 FONTOS     "
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
echo " "
read -p "Ellenorizd. Nyomj meg egy gombot a folytatashoz... " -n1 -s

systemctl status samba-ad-dc -l

read -p "Kovetkezik az LDAP modositas. Nyomj meg egy gombot a folytatashoz... " -n1 -s


#Valtozok feldolgozasa
SAMBA_CONFIG=${SAMBA_CONFIG:-/etc/samba/smb.conf}
SAMBA_OPTIONS=${SAMBA_OPTIONS:-}
: "${SAMBA_REALM:?SAMBA_REALM needs to be set}"
export KERBEROS_REALM=${SAMBA_REALM^^}
export SAMBA_LDAPDC="DC="$(echo $SAMBA_REALM | sed "s/\./,DC=/g")
export SAMBA_NISDOMAIN=$(echo $SAMBA_REALM | cut -d. -f1)
: "${SAMBA_DOMAIN:?SAMBA_DOMAIN needs to be set}"
: "${SAMBA_HOST:?SAMBA_HOST needs to be set}"
: "${SAMBA_IP:?SAMBA_IP needs to be set}"
: "${SAMBA_ADMINPASS:?SAMBA_ADMINPASS needs to be set}"

echo " "
echo " "
echo " "

cat > ./system-groups.ldif <<EOF
dn: CN=Allowed RODC Password Replication Group,CN=Users,$SAMBA_LDAPDC
changetype: modify
add: msSFU30NisDomain
msSFU30NisDomain: $SAMBA_NISDOMAIN
add: msSFU30Name
msSFU30Name: Allowed RODC Password Replication Group
add: gidNumber
gidNumber: 571

dn: CN=Enterprise Read-only Domain Controllers,CN=Users,$SAMBA_LDAPDC
changetype: modify
add: msSFU30NisDomain
msSFU30NisDomain: $SAMBA_NISDOMAIN
add: msSFU30Name
msSFU30Name: Enterprise Read-only Domain Controllers
add: gidNumber
gidNumber: 498

dn: CN=Denied RODC Password Replication Group,CN=Users,$SAMBA_LDAPDC
changetype: modify
add: msSFU30NisDomain
msSFU30NisDomain: $SAMBA_NISDOMAIN
add: msSFU30Name
msSFU30Name: Denied RODC Password Replication Group
add: gidNumber
gidNumber: 572

dn: CN=Read-only Domain Controllers,CN=Users,$SAMBA_LDAPDC
changetype: modify
add: msSFU30NisDomain
msSFU30NisDomain: $SAMBA_NISDOMAIN
add: msSFU30Name
msSFU30Name: Read-only Domain Controllers
add: gidNumber
gidNumber: 521

dn: CN=Group Policy Creator Owners,CN=Users,$SAMBA_LDAPDC
changetype: modify
add: msSFU30NisDomain
msSFU30NisDomain: $SAMBA_NISDOMAIN
add: msSFU30Name
msSFU30Name: Group Policy Creator Owners
add: gidNumber
gidNumber: 520

dn: CN=RAS and IAS Servers,CN=Users,$SAMBA_LDAPDC
changetype: modify
add: msSFU30NisDomain
msSFU30NisDomain: $SAMBA_NISDOMAIN
add: msSFU30Name
msSFU30Name: RAS and IAS Servers
add: gidNumber
gidNumber: 553

dn: CN=Domain Controllers,CN=Users,$SAMBA_LDAPDC
changetype: modify
add: msSFU30NisDomain
msSFU30NisDomain: $SAMBA_NISDOMAIN
add: msSFU30Name
msSFU30Name: Domain Controllers
add: gidNumber
gidNumber: 516

dn: CN=Enterprise Admins,CN=Users,$SAMBA_LDAPDC
changetype: modify
add: msSFU30NisDomain
msSFU30NisDomain: $SAMBA_NISDOMAIN
add: msSFU30Name
msSFU30Name: Enterprise Admins
add: gidNumber
gidNumber: 519

dn: CN=Domain Computers,CN=Users,$SAMBA_LDAPDC
changetype: modify
add: msSFU30NisDomain
msSFU30NisDomain: $SAMBA_NISDOMAIN
add: msSFU30Name
msSFU30Name: Domain Computers
add: gidNumber
gidNumber: 515

dn: CN=Cert Publishers,CN=Users,$SAMBA_LDAPDC
changetype: modify
add: msSFU30NisDomain
msSFU30NisDomain: $SAMBA_NISDOMAIN
add: msSFU30Name
msSFU30Name: Cert Publishers
add: gidNumber
gidNumber: 517

dn: CN=DnsUpdateProxy,CN=Users,$SAMBA_LDAPDC
changetype: modify
add: msSFU30NisDomain
msSFU30NisDomain: $SAMBA_NISDOMAIN
add: msSFU30Name
msSFU30Name: DnsUpdateProxy
add: gidNumber
gidNumber: 1102

dn: CN=Domain Admins,CN=Users,$SAMBA_LDAPDC
changetype: modify
add: msSFU30NisDomain
msSFU30NisDomain: $SAMBA_NISDOMAIN
add: msSFU30Name
msSFU30Name: Domain Admins
add: gidNumber
gidNumber: 512

dn: CN=Domain Guests,CN=Users,$SAMBA_LDAPDC
changetype: modify
add: msSFU30NisDomain
msSFU30NisDomain: $SAMBA_NISDOMAIN
add: msSFU30Name
msSFU30Name: Domain Guests
add: gidNumber
gidNumber: 514

dn: CN=Schema Admins,CN=Users,$SAMBA_LDAPDC
changetype: modify
add: msSFU30NisDomain
msSFU30NisDomain: $SAMBA_NISDOMAIN
add: msSFU30Name
msSFU30Name: Schema Admins
add: gidNumber
gidNumber: 518

dn: CN=Domain Users,CN=Users,$SAMBA_LDAPDC
changetype: modify
add: msSFU30NisDomain
msSFU30NisDomain: $SAMBA_NISDOMAIN
add: msSFU30Name
msSFU30Name: Domain Users
add: gidNumber
gidNumber: 513

dn: CN=DnsAdmins,CN=Users,$SAMBA_LDAPDC
changetype: modify
add: msSFU30NisDomain
msSFU30NisDomain: $SAMBA_NISDOMAIN
add: msSFU30Name
msSFU30Name: DnsAdmins
add: gidNumber
gidNumber: 1101
EOF

ldbmodify -H ldap://localhost \
-b CN=Users,$SAMBA_LDAPDC \
-U administrator \
--password=$SAMBA_ADMINPASS \
-v -i < ./system-groups.ldif

echo " "
echo " "
echo " "

read -p "Kovetkezik az Administrator LDAP modositas. Nyomj meg egy gombot a folytatashoz... " -n1 -s

echo " "
echo " "
echo " "




cat > ./administrator.ldif <<EOF
dn: CN=Administrator,CN=Users,$SAMBA_LDAPDC
changetype: modify
add: msSFU30NisDomain
msSFU30NisDomain: $SAMBA_NISDOMAIN
add: msSFU30Name
msSFU30Name: Administrator
add: uid
uid: Administrator
add: uidNumber
uidNumber: 0
add: gidNumber
gidNumber: 512
add: loginShell
loginShell: /bin/bash
add: unixHomeDirectory
unixHomeDirectory: /root
add: unixUserPassword
unixUserPassword: ABCD!efgh12345$67890
EOF

ldbmodify -H ldap://localhost \
-b CN=Users,$SAMBA_LDAPDC \
-U administrator \
--password=$SAMBA_ADMINPASS \
-v -i < ./administrator.ldif

echo " "
echo " "
echo " "

read -p "Ellenorizd sikerult e az LDAP. A Sambanak futnia kellett. Nyomj meg egy gombot a folytatashoz... " -n1 -s
echo " "
echo " "
echo " "


#Admin jelszo nem jar le
samba-tool user setexpiry administrator --noexpiry

#felhasznalo jelszo nem jar le
#samba-tool domain passwordsettings set --max-pwd-age=0

#Jelszo komplexitas kikapcsolasa
#samba-tool domain passwordsettings set --complexity=off

#Disable password history at the domain level.
#samba-tool domain passwordsettings set --history-length=0

#Disable password min-age at the domain level.
#samba-tool domain passwordsettings set --min-pwd-age=0

#Disable password max-age at the domain level.
#samba-tool domain passwordsettings set --max-pwd-age=0

#Disable minimum password length at the domain level.
#samba-tool domain passwordsettings set --min-pwd-length=0



clear
Echo "Domain informaciok"
echo " "
echo " "
echo "Rendszerido: "
ntpq -p
echo "---------------------------------------------------------------------------------------------- "
echo " "
echo "Hostname: "
hostname --fqdn
echo " "
echo "---------------------------------------------------------------------------------------------- "
echo "Domain info: "
samba-tool domain info $SAMBA_IP
echo "---------------------------------------------------------------------------------------------- "
samba-tool domain level show
echo "---------------------------------------------------------------------------------------------- "
net rpc rights list accounts -U'$SAMBA_DOMAIN\administrator'
echo "---------------------------------------------------------------------------------------------- "
getent group "Domain Admins"
echo "---------------------------------------------------------------------------------------------- "
id Administrator
echo "---------------------------------------------------------------------------------------------- "
echo "NSS teszt: "
echo "$SAMBA_DOMAIN"
echo "---------------------------------------------------------------------------------------------- "
net rpc rights grant $SAMBA_DOMAIN'\Domain Admins' SeDiskOperatorPrivilege -U $SAMBA_DOMAIN'\administrator'
echo "---------------------------------------------------------------------------------------------- "
echo " "
echo " "
read -p "Elkeszult. smb.conf Nyomj meg egy gombot a folytatashoz... " -n1 -s
echo " "
echo " "
echo "#Log beallitasok"
echo "        log level = 2"
echo "        log file = /var/log/samba/samba.log.%m"
echo "        max log size = 50"
echo "        debug timestamp = yes"
echo " "
echo " "
echo "# Lehetővé felsorolása winbind felhasználók és csoportok"
echo "        winbind enum users = yes"
echo "        winbind enum groups = yes"
echo " "
echo " "
echo "#ldap server require strong auth = no "
echo " "
echo " "
echo "# MINDEN TARTOMÁNYVEZÉRLŐN!!! RSAT unix attr"
echo "        idmap_ldb:use rfc2307 = yes"
echo " "
echo "#Samba doku Kiterjesztett ACL tamogatas bekapcsolasa"
echo "        vfs objects = acl_xattr"
echo "        map acl inherit = yes"
echo "        store dos attributes = yes"
echo " "
echo "        interfaces = eth0 lo"
echo "        time server = yes"
nano /etc/samba/smb.conf

read -p "DHCP beallitasa Nyomj meg egy gombot a folytatashoz... " -n1 -s

mv /etc/dhcp/dhcpd.conf dhcpd.conf.orig
cat <<EOF > /etc/dhcp/dhcpd.conf
authoritative;
log-facility local7;
ping-check true;
#option domain-name-servers 8.8.8.8, 8.8.4.4;
option domain-name "$SAMBA_REALM";
option ntp-servers $SAMBA_IP;
option time-servers $SAMBA_IP;


# Maxmedia LAN
subnet 192.168.X.0 netmask 255.255.252.0 {
        interface eth0;
        range 192.168.X.1 192.168.X.254;
        option domain-name "$SAMBA_REALM";
        option domain-name-servers $SAMBA_IP;
        option routers 192.168.X.1;
        option netbios-node-type 8;
        option netbios-name-servers $SAMBA_IP;
        default-lease-time 3600;
        max-lease-time 7200;
        option ntp-servers $SAMBA_IP;
        ddns-domainname "$SAMBA_REALM.";
}




# FIX IP ESZKOZOK

include "/etc/dhcp/static.conf";
EOF

cat <<EOF > /etc/dhcp/static.conf
# FIX IP ESZKOZOK

#Nyomtatok

#host HP              { hardware ethernet e0:cb:4e:61:f6:e6; fixed-address 192.168..; }

EOF

nano /etc/dhcp/dhcpd.conf

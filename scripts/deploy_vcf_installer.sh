#!/bin/bash
# Author: William Lam

OVFTOOL="/Applications/VMware OVF Tool/ovftool"
VCF_INSTALLER_OVA="/Volumes/Storage/Software/VCF910/PROD/COMP/SDDC_MANAGER_VCF/VCF-SDDC-Manager-Appliance-9.1.0.0.25371088.ova"

# Check if ovftool exists and is executable
if [[ ! -x "$OVFTOOL" ]]; then
    echo "ovftool not found or is not executable: $OVFTOOL"
    exit 1
fi

# Check if the OVA file exists
if [[ ! -f "$VCF_INSTALLER_OVA" ]]; then
    echo "VCF Installer OVA not found: $VCF_INSTALLER_OVA"
    exit 1
fi

ESXI_HOST="172.30.0.10"
ESXI_USERNAME="root"
ESXI_PASSWORD="VMware1!"
VM_NETWORK="VM Network"
VM_DATASTORE="local-vmfs-datastore-1"

VCF_INSTALLER_VMNAME=sddcm01
VCF_INSTALLER_HOSTNAME=sddcm01.vcf.lab
VCF_INSTALLER_IP=172.30.0.18
VCF_INSTALLER_SUBNET=255.255.255.0
VCF_INSTALLER_GATEWAY=172.30.0.1
VCF_INSTALLER_DNS_SERVER=192.168.30.29
VCF_INSTALLER_DNS_DOMAIN=vcf.lab
VCF_INSTALLER_DNS_SEARCH=vcf.lab
VCF_INSTALLER_NTP=96.19.94.82
VCF_INSTALLER_ROOT_PASSWORD="VMware1!VMware1!"
VCF_INSTALLER_ADMIN_PASSWORD="VMware1!VMware1!"

### DO NOT EDIT BEYOND HERE ###

echo -e "\nDeploying VCF Installer ${VCF_INSTALLER_VMNAME} ..."
"${OVFTOOL}" --acceptAllEulas --noSSLVerify --skipManifestCheck --X:injectOvfEnv --allowExtraConfig --X:waitForIp --sourceType=OVA --powerOn \
"--net:Network 1=${VM_NETWORK}" --datastore=${VM_DATASTORE} --diskMode=thin --name=${VCF_INSTALLER_VMNAME} \
"--prop:vami.hostname=${VCF_INSTALLER_HOSTNAME}" \
"--prop:vami.ip0.SDDC-Manager=${VCF_INSTALLER_IP}" \
"--prop:vami.netmask0.SDDC-Manager=${VCF_INSTALLER_SUBNET}" \
"--prop:vami.gateway.SDDC-Manager=${VCF_INSTALLER_GATEWAY}" \
"--prop:vami.domain.SDDC-Manager=${VCF_INSTALLER_DNS_DOMAIN}" \
"--prop:vami.searchpath.SDDC-Manager=${VCF_INSTALLER_DNS_SEARCH}" \
"--prop:vami.DNS.SDDC-Manager=${VCF_INSTALLER_DNS_SERVER}" \
"--prop:ROOT_PASSWORD=${VCF_INSTALLER_ROOT_PASSWORD}" \
"--prop:LOCAL_USER_PASSWORD=${VCF_INSTALLER_ADMIN_PASSWORD}" \
"--prop:guestinfo.ntp=${VCF_INSTALLER_NTP}" \
${VCF_INSTALLER_OVA} "vi://${ESXI_USERNAME}:${ESXI_PASSWORD}@${ESXI_HOST}/"

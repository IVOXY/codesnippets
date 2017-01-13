
$jsonpath = "c:\git\codesnippets\LabESXConfig.json"

try
    {
        $config = Get-Content -Raw -Path $jsonpath |convertfrom-json
            write-host -BackgroundColor:Black -foregroundcolor:yellow "Status: Parsed Configuration"
    }
catch {throw "I don't have a valid config"}

connect-viserver -server vcenter.lab.local -user $config.global.vCenterUser -Password $config.global.vCenterPassword
Connect-NsxServer -Server $config.global.nsxserver -Username $config.global.nsxusername -Password $config.global.nsxpassword

# Add host to the selected cluster (requires DNS)
foreach ($esxhost in $config.hosts) {
    #add-vmhost -name $esxhost.hostname -location $config.global.Cluster -User root -Password $config.global.ESXRootPass -force
    
    #Add-VDSwitchVMHost -vdswitch $config.dvSwitch.name -vmhost $esxhost.hostname
    #Add-VDSwitchPhysicalNetworkAdapter -DistributedSwitch $config.dvswitch.name -VMHostphysicalNic (get-vmhostnetworkadapter -vmhost $esxhost.hostname -name $config.dvSwitch.uplink1) -confirm:$false
    #Add-VDSwitchPhysicalNetworkAdapter -DistributedSwitch $config.dvswitch.name -VMHostphysicalNic (get-vmhostnetworkadapter -vmhost $esxhost.hostname -name $config.dvSwitch.uplink2) -confirm:$false
    
    #new-vmhostnetworkadapter -VMHost $esxhost.hostname -PortGroup $esxhost.vmk1.portgroup -VirtualSwitch (Get-vdSwitch $config.dvSwitch.name) -ip $esxhost.vmk1.IP -SubnetMask $esxhost.vmk1.netmask -VMotionEnabled:$esxhost.vmk1.vmotion
    #new-vmhostnetworkadapter -VMHost $esxhost.hostname -PortGroup $esxhost.vmk2.portgroup -VirtualSwitch (Get-vdSwitch $config.dvSwitch.name) -ip $esxhost.vmk2.IP -SubnetMask $esxhost.vmk2.netmask 
    #new-vmhostnetworkadapter -VMHost $esxhost.hostname -PortGroup $esxhost.vmk3.portgroup -VirtualSwitch (Get-vdSwitch $config.dvSwitch.name) -ip $esxhost.vmk3.IP -SubnetMask $esxhost.vmk3.netmask 

    foreach ($datastore in $config.datastores) {
        #new-datastore -vmhost $esxhost.hostname -Name $datastore.name -NfsHost $datastore.serverip -path $datastore.export -nfs:$true

    }

    #Set-VMHostSysLogServer -vmhost $esxhost.hostname -SysLogServer $config.global.syslogserver
    #Add-VMHostNtpServer -vmhost $esxhost.hostname -NtpServer $config.global.NTP
    #Get-VMHostService -vmhost $esxhost.hostname | where-object {$_.key -eq "ntpd"} | start-vmhostservice
    #Get-VMHostService -vmhost $esxhost.hostname | where-object {$_.key -eq "ntpd"} | set-vmhostservice -Policy Automatic
    #Get-VMHostFirewallException -vmhost $esxhost.hostname | where {$_.name -eq "NTP Client"} | Set-VMHostFirewallException -enabled:$true
    #Get-vmhostservice -vmhost $esxhost.hostname | where-object {$_.key -eq "TSM"} | Start-VMHostService
    #Get-vmhostservice -vmhost $esxhost.hostname | where-object {$_.key -eq "TSM"} | set-vmhostservice - policy automatic

    
    
}


#NSX Prep
#get-cluster -Name $config.Global.Cluster | New-NsxClusterVxlanConfig -VirtualDistributedSwitch (get-vdswitch -name $config.dvSwitch.name) -vlan $config.global.vtepvlan -vtepcount 1 -IpPool (Get-NsxIpPool $config.global.vtepippool)


disconnect-viserver -confirm:$false
disconnect-nsxserver -confirm:$false

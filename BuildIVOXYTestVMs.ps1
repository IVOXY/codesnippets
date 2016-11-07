#Build Performance Script

$viserver = "seadc1vc01.ldthost.pvt"
connect-viserver -server $viserver

$TemplateName = "SEADC1-W2012R2"
$VMs = @("seadc1-ivoxytest1","seadc1-ivoxytest2","seadc1-ivoxytest3","seadc1-ivoxytest4")
$Custom = "IVOXY-Win-DHCP"
$Portgroup = "VLAN48-ESXi-MGMT"
$dvswitch = "DSwitche0"
$folder = "Discovered Virtual Machine"
$datastore = "POC-SEADC1VC01CLST1-AF"
$cluster = "Cluster1" 
$ResourcePool = get-cluster -name $Cluster | Get-ResourcePool




foreach ($VM in $VMs) {
    new-vm -name $VM -template $TemplateName -datastore $datastore   -ResourcePool $ResourcePool -OSCustomizationSpec $Custom
    get-vm -name $VM | get-networkadapter | Set-NetworkAdapter -NetworkName $Portgroup 
    #New-AdvancedSetting -Entity $vm -Name ‘vcpu.hotadd’ -Value ‘true’ -Confirm:$false
    #New-AdvancedSetting -Entity $vm -Name ‘mem.hotadd’ -Value ‘true’ -Confirm:$false
   
    
    

    New-HardDisk -VM $VM -CapacityGB 200 -Datastore $datastore -StorageFormat EagerZeroedThick
    New-HardDisk -VM $VM -CapacityGB 200 -Datastore $datastore -StorageFormat EagerZeroedThick
    $disks = Get-Harddisk -VM $VM | Select -Last 2
    New-ScsiController -Type ParaVirtual -Harddisk $disks

    New-HardDisk -VM $VM -CapacityGB 200 -Datastore $datastore -StorageFormat EagerZeroedThick
    New-HardDisk -VM $VM -CapacityGB 200 -Datastore $datastore -StorageFormat EagerZeroedThick
    $disks = Get-Harddisk -VM $VM | Select -Last 2
    New-ScsiController -Type ParaVirtual -Harddisk $disks

    get-vm -name $VM | set-vm -numcpu 4 -MemoryGB 8 
    get-vm -name $VM | start-vm 


}

New-DrsRule -Name "IVOXYPerf" -cluster $Cluster -KeepTogether 0 -VM $VMs



disconnect-viserver



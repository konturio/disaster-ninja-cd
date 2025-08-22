# LVM on k8s-01 nodes

#### List of nodes:

hwn01.k8s-01.kontur.io

hwn02.k8s-01.kontur.io

hwn03.k8s-01.kontur.io
* LVM:**

LVM with [thin-provisioning](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/logical_volume_manager_administration/thinly_provisioned_volume_creation "https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/logical_volume_manager_administration/thinly_provisioned_volume_creation") is using on the nodes.

```
[root@hwn01 ~]# lvs
  LV                             VG       Attr       LSize  Pool       
  root                           rl_hwn00 -wi-ao---- 13.39g
  thin-provisioner01             vg01     Vwi-aotz--  3.50t thinpool01
  thin-var                       vg01     Vwi-aotz--  1.00t thinpool01
  thinpool01                     vg01     twi-aotz--  4.00t 
  thin-pgdata01                  vg02     Vwi-aotz--  2.00t thinpool01
  thinpool01                     vg02     twi-aotz-- <2.32t 
  local-path-provisioner-regular vg03     -wi-ao----  5.00t
```

/dev/mapper/vg01-thin--provisioner01  mounted as /opt/local-path-provisioner
* Disassembling software RAID1 array inside LVM and moving data to the new PV**

1\. Remove the second raid member from md0 and wipe file system on it:

```
mdadm --detail /dev/md0
mdadm /dev/md0 --fail /dev/nvme1n1
mdadm /dev/md0 --remove /dev/nvme1n1
wipefs -a /dev/nvme1n1
```

2\. Create PhysicalVolume from the removed raid member and extend vg01 VolumeGroup:

```
pvcreate /dev/nvme1n1
vgextend vg01 /dev/nvme1n1
```

3\. Relocate data from md0 raid to the new /dev/nvme1n1 PV via  [pvmove](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/logical_volume_manager_administration/online_relocation "https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/logical_volume_manager_administration/online_relocation")  and remove md0 from vg01. The  pvmove  command can take a long time to execute, so use tmux session:

```
tmux
pvmove /dev/md0 /dev/nvme1n1
vgreduce -v vg01 /dev/md0
```

4\. Stop md0 array and remove it:

```
mdadm --stop /dev/md0
mdadm --remove /dev/md0  # can fail, it's ok
mdadm --zero-superblock --force /dev/nvme0n1

Remove entire "ARRAY" entry from /etc/mdadm.conf
```

5\. Create PV from the first raid member and add it to the thin-provisioner01 LV:

```
pvcreate /dev/nvme0n1
vgextend vg01 /dev/nvme0n1

lvextend -L+1.5T vg01/thinpool01 # you need to extend vg01/thinpool01
lvextend -L+1.5T vg01/thin-provisioner01

xfs_growfs /opt/local-path-provisioner
fstrim /opt/local-path-provisioner
```
* Adding extra space to the thin pool and thin-provisioner01 (/opt/local-path-provisioner)**

```
lvextend -L+1T vg01/thinpool01
lvextend -L+1T vg01/thin-provisioner01
xfs_growfs /opt/local-path-provisioner
```

# k8s worker nodes requirements

**Distro **\
Debian 12
* Filesystem**\
ext4
* LVM configuration**\
All disks in the system should be included in a single Volume Group (VG) named vg0, the VG should allocate all space to a single Logical Volume (LV) named root.

Example:

```
root@hwn01 ~ # lvs
  LV   VG  Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  root vg0 -wi-ao---- <31.44t

root@hwn01 ~ # pvs
  PV             VG  Fmt  Attr PSize  PFree
  /dev/nvme0n1   vg0 lvm2 a--   3.49t    0
  /dev/nvme1n1p2 vg0 lvm2 a--   3.49t    0
  /dev/nvme2n1   vg0 lvm2 a--  <6.99t    0
  /dev/nvme3n1   vg0 lvm2 a--  <6.99t    0
  /dev/nvme4n1   vg0 lvm2 a--  <6.99t    0
  /dev/nvme5n1   vg0 lvm2 a--   3.49t    0

root@hwn01 ~ # vgs
  VG  #PV #LV #SN Attr   VSize   VFree
  vg0   6   1   0 wz--n- <31.44t    0
```
* Node configuration**\
Role: <https://github.com/konturio/puppetmaster2022/tree/main/provisioning/roles/k8s-worker-node-debian>

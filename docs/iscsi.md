# iSCSI
The following applications use iSCSI:
- Sonarr
- Radarr (WIP)
- Jackett (WIP)
- Bazarr (WIP)
- Lidarr (WIP)

## Creating a `.img` file
This will create a file `sonarr.img` at `/storage-pool/k8s/sonarr/`, this is a ZFS mount:  
`dd if=/dev/zero of=/storage-pool/k8s/sonarr/sonarr.img bs=1G count=1`

## Dependencies
`apt install tgt`

## Configuring tgt
Config file at: `/etc/tgt/conf.d/iscsi.conf`  
Example configuration:
```xml
<target iqn.2021-02.storage.thedutchmc.nl:sonarr>
        backing-store /storage-pool/k8s/sonarr/sonarr.img
        write-cache off
        incominguser [USERNAME] [PASSWORD]
</target>
```
>Note: IQN date should be the date in YYYY-MM the image was created

You should now reboot tgt with `systemctl restart tgt`

## Adding to Kubernetes
Kubernetes Secret for authentication:
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: sonarr-iscsi-chap
  namespace: default
type: "kubernetes.io/iscsi-chap"
data:
  node.session.auth.username: "USERNAME IN BASE64"
  node.session.auth.password: "PASSWORD IN BASE64"
```
>Note: You can convert your username and password to Base64 with: `echo "YOUR VALUE" | base64 -w0`

Then create a Kubernetes PersistentVolume:
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: sonarr-config-pv
spec:
  capacity:
    storage: 1G
  accessModes:
    - ReadWriteMany
  iscsi:
    targetPortal: 192.168.1.8:3260
    iqn: 'iqn.2021-02.storage.thedutchmc.nl:sonarr'
    lun: 1
    fsType: 'ext4'
    readOnly: false
    chapAuthDiscovery: true
    chapAuthSession: true
    secretRef:
      name: sonarr-iscsi-chap
  persistentVolumeReclaimPolicy: Retain
```
>Note: In both these example blocks, you should change the names. These are just examples  

>Note: targetPortal is the IP of your iSCSI host  

>Note: Use `sudo tgtadm --mode target --op show` to find out what value to use for `lun`  

You can now create a regular Kubernetes PersistentVolumeClaim and use the volume in the container

## Resources
- https://www.linuxjournal.com/content/creating-software-backed-iscsi-targets-red-hat-enterprise-linux-6
- https://github.com/fujita/tgt/blob/master/conf/examples/targets.conf.example
- https://superuser.com/questions/470949/how-do-i-create-a-1gb-random-file-in-linux
- https://forum.level1techs.com/t/run-your-steam-library-from-a-nas-break-a-leg-challenge-update/107912
- https://github.com/kubevirt/kubevirt/blob/master/docs/iscsi-authentication.md
- https://docs.openshift.com/container-platform/3.9/install_config/persistent_storage/persistent_storage_iscsi.html
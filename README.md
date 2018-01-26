
## Persistent storage

The template requires a persitent volume (PV) in order to work. This needs to be set up
by the cluster admin.

The following configurations are examples which *must be adapted* to you local
setup. You will also only need to choose and install *one*.

For example create a local file (e.g. `pv.yml`) with the adapted content and execute the
following command as cluster admin (e.g. directly on the master node):

~~~sh
oc create -f pv.yml
~~~

**Note:** When you delete the PVC from the template (not the PV you create here) then
the PV will be recycled, which means all your Grafana configuration will be lost.

### NFS PV

~~~yaml
kind: PersistentVolume
apiVersion: v1
metadata:
  name: grafana-data-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Recycle
  nfs:
    path: /exports/hono/grafana       # NFS export path on the server
    server: nfs-server.internal       # IP/hostname address of NFS server
    readOnly: false
~~~

### Local file system PV

~~~yaml
kind: PersistentVolume
apiVersion: v1
metadata:
  name: grafana-data-pv
spec:
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: 1Gi
  persistentVolumeReclaimPolicy: Recycle
  hostPath:
    path: /path/to/my/pv # replace with your local directory
~~~

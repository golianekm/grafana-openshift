
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

## Plugins

Plugins can be installed when the containers are built and no longer during startup
of the container. This way everything is available when the container starts, the
container don't need any external access for downloading plugins and also can you revert
the container image including the plugins.

There are two ways to install additional plugins:

### Remote plugins

Set the template variable `BUILD_INSTALL_PLUGINS` to a list of plugins you want to include
in your image. The default is to include `hawkular-datasource`.

This is a semicolon (;) separated list of plugin IDs which will be downloaded during the
creation of the image. 

### Image local plugins

You can place additional plugins into the directory `$LOCAL_PLUGIN_DIR`
(which defaults to `/var/lib/grafana/local-plugins`).

The best way to do this would be a derived image: also see [examples/local-plugin/Dockerfile](examples/local-plugin/Dockerfile).

In this case you would need to adapt the template to use your custom base image for the
deployment configuration.

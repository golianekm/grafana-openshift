
# Will be overriden by the template
FROM centos:7

MAINTAINER Marcin Golianek <golianekm@gmail.com>
LABEL \
  name "Customized Grafana OpenShift Image" \
  maintainer "Marcin Golianek <golianekm@gmail.com>"

USER root
EXPOSE 3000

RUN \
    yum -y update && \
    yum -y install curl wget unzip git && \
    yum -y install https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-"$GRAFANA_VERSION"-1.x86_64.rpm && \
    yum clean all && rm -Rf /var/cache/yum

COPY root /

RUN \
    mkdir -p "$LOCAL_PLUGIN_DIR" && \
    /usr/bin/grafana-openshift-install-remote-plugins

RUN \
    /usr/bin/fix-permissions /usr/share/grafana && \
    /usr/bin/fix-permissions /etc/grafana && \
    /usr/bin/fix-permissions /var/lib/grafana && \
    /usr/bin/fix-permissions /var/log/grafana

ENTRYPOINT ["/usr/bin/grafana-openshift-run"]

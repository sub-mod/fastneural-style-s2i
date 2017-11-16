FROM openshift/base-centos7

MAINTAINER Rob Geada <rgeada@redhat.com>

ENV BUILDER_VERSION 1.0

LABEL io.k8s.description="S2I builder for Fast-Style Evaluation." \
      io.k8s.display-name="Fast-Style Evaluator" \
      io.openshift.expose-services="8888:http" \
      io.openshift.tags="builder,python,fast-style" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"

RUN yum install -y epel-release 
RUN yum install -y tree wget which python-pip \
	&& yum clean all -y

RUN pip install --upgrade pip \
	&& pip install tensorflow

COPY ./s2i/bin/ /usr/libexec/s2i

#Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001



EXPOSE 8080

# TODO: Set the default CMD for the image
CMD ["/usr/libexec/s2i/usage"]

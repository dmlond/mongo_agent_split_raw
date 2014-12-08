FROM dmlond/split_raw
MAINTAINER Darin London <darin.london@duke.edu>

USER root
RUN ["/usr/bin/yum", "install", "-y", "--nogpgcheck", "libyaml", "libyaml-devel", "tar", "make", "gcc", "readline", "readline-devel", "openssl","openssl-devel","libxml2-devel","libxslt","libxslt-devel"]
ADD install_ruby.sh /root/install_ruby.sh
RUN ["chmod", "u+x", "/root/install_ruby.sh"]
RUN ["/root/install_ruby.sh"]
RUN ["/usr/local/bin/gem", "install", "moped"]
RUN ["/usr/local/bin/gem", "install", "mongo_agent"]
ADD split_agent.rb /usr/local/bin/split_agent.rb
RUN ["chmod", "777", "/usr/local/bin/split_agent.rb"]
USER bwa_user
WORKDIR /home/bwa_user
ENTRYPOINT []
CMD ["/user/local/bin/split_agent.rb"]

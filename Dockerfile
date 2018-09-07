FROM centos/httpd

# Install essentials for Apache & Perl
RUN yum -y --setopt=tsflags=nodocs update && \
    yum -y --setopt=tsflags=nodocs install gcc make vim less netstat telnet && \
    yum -y --setopt=tsflags=nodocs install perl perl-core && \
    yum -y --setopt=tsflags=nodocs install postgresql postgresql-devel && \
    yum -y --setopt=tsflags=nodocs install qrencode qrencode-devel qrencode-libs && \
    yum -y --setopt=tsflags=nodocs install expat-devel && \
    yum -y --setopt=tsflags=nodocs install mod_ssl openssl && \
    yum -y --setopt=tsflags=nodocs install cronie && \
    yum -y --setopt=tsflags=nodocs install rsyslog && \
    yum -y --setopt=tsflags=nodocs install epel-release && \
    yum -y --setopt=tsflags=nodocs install python-pip && \
    yum clean all

# rsyslogd config
RUN sed -i 's/^\$ModLoad imjournal/#\$ModLoad imjournal/' /etc/rsyslog.conf
RUN sed -i 's/^\$OmitLocalLogging on/\$OmitLocalLogging off/' /etc/rsyslog.conf
RUN sed -i 's/^\$IMJournalStateFile imjournal.state/#\$IMJournalStateFile imjournal.state/' /etc/rsyslog.conf
RUN sed -i 's/cron.none\s\{12\}/cron.none;local1.none/' /etc/rsyslog.conf
RUN sed -i 's/^\$SystemLogSocketName/#\$SystemLogSocketName/' /etc/rsyslog.d/listen.conf
RUN echo "local1.*  /var/log/application.log" > /etc/rsyslog.d/application.conf

# Install supervisor
RUN pip install pip --upgrade
RUN pip install supervisor

# supervisor config
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/supervisord.conf

# httpd config
RUN echo '#!/usr/bin/env perl' > /var/www/cgi-bin/index.pl
RUN echo 'print "Content-Type: text/html\n\n";' >> /var/www/cgi-bin/index.pl
RUN echo 'print "<html><body><h1>It works!</h1></body></html>";' >> /var/www/cgi-bin/index.pl
RUN chmod +x /var/www/cgi-bin/index.pl

# Install cpanm
RUN yum -y install perl-App-cpanminus.noarch && \
    cpanm Carton && \
    yum clean all && \
    rm -rf /root/.cpanm

CMD ["supervisord", "-n"]

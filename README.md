# Short Description

A web service container include service httpd, rsyslogd and crond supported by supervisord

# Full Description

## Build
Copy the sources down and do the build
`# docker build --rm -t <username>/centos-httpd-perl .`

## Usage
To run (if port 80 is available and open on your host):
`# docker run -d -p 80:80 <username>/centos-httpd-perl`

## Test
`# curl http://localhost/cgi-bin/index.pl`

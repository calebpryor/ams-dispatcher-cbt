# AMS Dispatcher Course 2 - Setup Fake AEM

We don't want to install AEM but we do want a server that can act like an AEM server so no Java code or AEM installations required to make a dispatcher function.  In this course we will create a basic server running httpd that will reply to all content with a single webpage and we will target this as a renderer in our dispatcher farm in the next course.

## Start the container

We want to start a basic linux container on your workstation to play the role of a fake AEM.  Important to start the container with a never ending process so it doesn't die the moment start it.  From your workstations favorite terminal application and if you chose podman or docker pick which command you need to start the container.

### Docker command

```
docker run --rm -d -p 4503:4503 --name aem rockylinux:8 tail -f /dev/null
```

Log into the container so we can start our install

```
docker exec -it aem /bin/bash
```

### Podman command

```
podman run --rm -d -p 4503:4503 --name aem rockylinux:8 tail -f /dev/null
```

Log into the container so we can start our install

```
podman exec -it aem /bin/bash
```

## Install software in the container

### HTTPD package
From inside the container using the `exec` command from above you can now install apache `httpd` package

```
dnf -y install httpd
```

### Create a test webpage

Create a webpage `index.html`

```
echo "HELLO I AM FAKE AEM" > /var/www/html/index.html
```

### Minimal Apache HTTPD Configuration File

Create the httpd configuration file `/etc/httpd/conf.d/httpd-renderer.conf`

```
echo 'Listen 4503'$'\n''<VirtualHost *:4503>'$'\n''ServerName fake-aem'$'\n''ServerAlias "*"'$'\n''DocumentRoot /var/www/html'$'\n''<IfModule mod_headers.c>'$'\n''Header always add X-Vhost renderer'$'\n''</IfModule>'$'\n''<IfModule mod_rewrite.c>'$'\n''ReWriteEngine   on'$'\n''RewriteCond %{REQUEST_URI} !^/index.html$'$'\n''RewriteRule ^/* /index.html [PT,L,NC]'$'\n''</IfModule>'$'\n''</VirtualHost>' > /etc/httpd/conf.d/httpd-renderer.conf
```

Let's look at the pretty version of this configuration file and describe what it's doing.

```
Listen 4503
<VirtualHost *:4503>
  ServerName fake-aem
  ServerAlias "*"
  DocumentRoot /var/www/html
  <IfModule mod_headers.c>
    Header always add X-Vhost renderer
  </IfModule>
  <IfModule mod_rewrite.c>
    ReWriteEngine   on
    RewriteCond %{REQUEST_URI} !^/index.html$
    RewriteRule ^/* /index.html [PT,L,NC]
  </IfModule>
</VirtualHost>
```

We are telling `httpd` process to listen on port `4503` and then we setup a `VirtualHost` that looks for every domain name that hits the server as inidicated with `ServerAlias "*"`.  Then there is a `RewriteRule` that takes everything requested and fetches the `index.html` page instead.  This allows us to fetch any page from this webserver, i.e. `/content/hellworld.html`, `/content/hithere.html` or any other content path would return the index.html page.

## Start the service

Now start the fake AEM webserver

```
httpd &
```

## Tail the logs

We can watch for errors and make sure things are working by tailing the log files:

```
tail -f /var/log/httpd/*
```

## Testing

If you open your workstations web browser to:

- http://127.0.0.1:4503/content/hi.html
- http://127.0.0.1:4503/libs/granite/core/content/login.html

You should see a webpage return that says `HELLO I AM FAKE AEM`

[ Proceed to Course 3 ](../Course3/README.md)
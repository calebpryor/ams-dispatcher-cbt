# Course 3 - Setup Real Dispatcher

We now want to create our minimal dispatcher server.  This will use the prior container as a origin / renderer to fetch content from the fake AEM server.  The dispatcher server is built off of the Apache `httpd` package and adds the Adobe customer `.so` binary as a custom extension of the web server.

## Start the container

We want to start another basic linux container on workstation, so open a new instance of your favorite terminal application and we will start the container with a never ending process so it doesn't die the moment we start it.  Then choose which command below based on whether or not you chose podman or docker.

### Docker command

```
docker run --rm -d -p 8080:80 --name dispatcher rockylinux:8 tail -f /dev/null
```

If the container started you'll see it running by running:

```
docker ps
```

You should see the container there like shown:

```
CONTAINER ID   IMAGE          COMMAND               CREATED         STATUS         PORTS                    NAMES
2da65c028a36   rockylinux:8   "tail -f /dev/null"   2 seconds ago   Up 1 second    0.0.0.0:8080->80/tcp     dispatcher
2f963c349821   rockylinux:8   "tail -f /dev/null"   8 seconds ago   Up 7 seconds   0.0.0.0:4503->4503/tcp   aem
```

Log into the container so we can start our install

```
docker exec -it dispatcher /bin/bash
```

### Podman command

```
podman run --rm -d -p 8080:80 --name dispatcher rockylinux:8 tail -f /dev/null
```


If the container started you'll see it running by running:

```
podman ps
```

You should see the container there like shown:

```
CONTAINER ID  IMAGE                           COMMAND            CREATED       STATUS       PORTS                   NAMES
baef6e8ed25d  docker.io/library/rockylinux:8  tail -f /dev/null  11 hours ago  Up 11 hours  0.0.0.0:4503->4503/tcp  aem
170bf7660215  docker.io/library/rockylinux:8  tail -f /dev/null  11 hours ago  Up 11 hours  0.0.0.0:8080->80/tcp    dispatcher
```

Log into the container so we can start our install

```
podman exec -it dispatcher /bin/bash
```

## Install software in the container

### HTTPD Package

From inside the container using the `exec` command from above you can now install apache `httpd` package and the `wget` package

```
dnf -y install httpd wget
```

### AEM Dispatcher Module

The Dispatcher module is the custom extension written by Adobe for the Apache webserver.  From inside the container using the `exec` command download the `dispatcher` module

```
wget https://download.macromedia.com/dispatcher/download/dispatcher-apache2.4-linux-$(lscpu | grep Architecture | awk '{ print $2 }')-4.3.5.tar.gz
tar -xvf dispatcher-apache2.4-linux-*-4.3.5.tar.gz --wildcards --no-anchored '*.so'
mv dispatcher-*.so /etc/httpd/modules/
ln -fs ./dispatcher-apache2.4-4.3.5.so /etc/httpd/modules/mod_dispatcher.so
```

We now need to tell `Apache webserver` to include this binary `.so` file when it starts up.  Let's create that configuration file that does the include.

```
echo "LoadModule dispatcher_module modules/mod_dispatcher.so" > /etc/httpd/conf.modules.d/02-dispatcher.conf
```

### AEM Dispatcher Configuration

### Apache Config File
To configure the `httpd` process to use the module to fetch files from our fake AEM instance we'll need to add the following configuration file

```
echo '<IfModule disp_apache2.c>'$'\n''DispatcherConfig conf.dispatcher.d/dispatcher.any'$'\n''DispatcherLog    logs/dispatcher.log'$'\n''DispatcherLogLevel trace'$'\n''DispatcherDeclineRoot Off'$'\n''DispatcherUseProcessedURL On'$'\n''DispatcherPassError 0'$'\n''</IfModule>'$'\n''<VirtualHost *:80>'$'\n''ServerName default80'$'\n''ServerAlias *'$'\n''DocumentRoot /var/www/html/'$'\n''<Directory />'$'\n''<IfModule disp_apache2.c>'$'\n''SetHandler dispatcher-handler'$'\n''</IfModule>'$'\n''</Directory>'$'\n''</VirtualHost>'$'\n''' > /etc/httpd/conf.d/httpd-dispatcher.conf
```

Let's look at the pretty version of this configuration file and explain what's happening here.

This portion of the configuration tells the dispatcher extension where to find it's farm configuration file `DispatcherConfig conf.dispatcher.d/dispatcher.any` then sets up some of the basic parameters for the extension / module to function.

```
<IfModule disp_apache2.c>
  DispatcherConfig conf.dispatcher.d/dispatcher.any
  DispatcherLog    logs/dispatcher.log
  DispatcherLogLevel trace
  DispatcherDeclineRoot Off
  DispatcherUseProcessedURL On
  DispatcherPassError 0
</IfModule>
```

This portaion of the configuration file tells every directory on the server `<Directory />` to use the dispatcher as the default file handler `SetHandler dispatcher-handler`.

This allows Apache webserver to ask the dispatcher module for files instead of solely using the default Apache file handler

```
<VirtualHost *:80>
  ServerName default80
  ServerAlias *
  DocumentRoot /var/www/html/
  <Directory />
    <IfModule disp_apache2.c>
      SetHandler dispatcher-handler
    </IfModule>
  </Directory>
</VirtualHost>
```

Configure the base configuration files for a very basic farm

### Dispatcher Config File

In this step we want to find the IP address of our fake AEM container.   From a fresh terminal run the following command to grab the IP address of the `AEM` container

#### Docker command

```
docker inspect $(docker ps | grep aem | awk '{ print $1 }') | grep IPAddress
```

#### Podman command

```
podman inspect $(podman ps | grep aem | awk '{ print $1 }') | grep IPAddress
```

#### Farm File

Return to the terminal that is inside the dispatcher container and create the dispatchers directory and farm file inside the container

Let's set the IP Address as a variable to use in the next command.

```
aemip=<PUT THE IP FROM ABOVE HERE>
```

```
mkdir -p /etc/httpd/conf.dispatcher.d
echo '/farms {'$'\n''/myfarm {'$'\n''/clientheaders {'$'\n''"*"'$'\n''}'$'\n''/virtualhosts {'$'\n''"*"'$'\n''}'$'\n''/renders {'$'\n''/rend01 {'$'\n''/hostname "'$aemip'"'$'\n''/port "4503"'$'\n''/timeout "0"'$'\n''}'$'\n''}'$'\n''/filter {'$'\n''/0001 { /type "allow" /url "*" }'$'\n''}'$'\n''}'$'\n''}' > /etc/httpd/conf.dispatcher.d/dispatcher.any
```

Let's look at this minimal farm file in a prettier format and explain some of the configuration

```
/farms {
  /myfarm {
    /clientheaders {
      "*"
    }
    /virtualhosts {
      "*"
    }
    /renders {
      /rend01 {
        /hostname "172.17.0.2"
        /port "4503"
        /timeout "0"
      }
    }
    /filter {
      /0001 { /type "allow" /url "*" }
    }
  }
}
```

It's really important to point out that this farm file isn't setup in a way that you would ever use it in an actual implementation.  It's a minimal, very insecure setup as you can see in the `/filter` section we are allowing everything through to reach AEM and we are missing a ton of vital configuration settings.  Please refer to the [archetype](https://github.com/adobe/aem-project-archetype/tree/develop/src/main/archetype/dispatcher.ams/src/conf.dispatcher.d/available_farms) for better references on a production ready farm file and dispatcher configuration would look.

The important part is showing the `/renders` section where we tell the dispatcher where to reach our other container.  The `/renders { /rend01 { /hostname "172.17.0.2" }}` section shows the IP address and port to use to fetch content from the fake AEM instance.

## Start the service

Now start the Apache Webserver running the AEM Dispatcher module

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

- http://127.0.0.1:8080/content/hi.html
- http://127.0.0.1:8080/libs/granite/core/content/login.html

You should see a webpage return that says `HELLO I AM FAKE AEM`

In the log files you can see it fetching the content from the fake AEM instance.

Celebrate your success you've installed and configured an AEM Dispatcher!

## Clean up

Now we just need to kill off our containers

### Docker command

```
docker kill dispatcher
docker kill aem
```

You shouldn't see any containers running when you run:

```
docker ps
```

### Podman command

```
podman kill dispatcher
podman kill aem
```

You shouldn't see any containers running when you run:

```
podman ps
```
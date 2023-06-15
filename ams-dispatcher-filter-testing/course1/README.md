# Adobe Managed Services guide to better Dispatcher filters - Workstation Requirements

We want to take time in this first document to setup your workstation.

Create an account on [hub.docker.com](https://hub.docker.com/signup) you'll need it for pulling down public docker images.

Use your favorite installation to get Docker running on your machine.

Here are some references for different installation types and you can skip to that section based on which option you choose.  Remember only pick one to install

# Option 1 - Docker Desktop (easiest but only free for personal use)

Get the installation media from [here](https://www.docker.com/products/docker-desktop/)

Run through the standard installation wizard and login to the client with your docker account.

# Option 2 - Podman

Get the installation instructions [here](https://podman.io/docs/installation)

One you've gotten the install completed start up podman:

```
podman machine init
podman machine start
```

Login to Docker Hub:

```
podman login docker.io
```

# GIT

## Filter Fiddler HTML

You can either clone [this repo](https://github.com/calebpryor/aem-dispatcher-filter-testing)

```
git clone https://github.com/calebpryor/aem-dispatcher-filter-testing.git
```

Or you can download the file directly from this [link](https://raw.githubusercontent.com/calebpryor/aem-dispatcher-filter-fiddler/main/dispatcher-filter-fiddler.html) just right click and choose `save as` to save it where you can open it with your favorite browser.


## Filter Testing Container

You can either clone [this repo](https://github.com/calebpryor/aem-dispatcher-filter-testing)

```
git clone https://github.com/calebpryor/aem-dispatcher-filter-testing.git
```

Or you can use the [Download as ZIP](https://github.com/calebpryor/aem-dispatcher-filter-testing/archive/refs/heads/master.zip) option from the site to get the needed files onto your workstation and extract the zip.

Inside the cloned or extracted directory is where we can run the next steps mentioned in Course 2

[ Proceed to Course 2 ](../course2/)

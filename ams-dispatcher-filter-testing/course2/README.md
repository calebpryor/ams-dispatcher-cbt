# Adobe Managed Services guide to better Dispatcher filters - Writing Filter Rules

## Filter Fiddler HTML

One of the frustrating things is looking for syntax on how a dispatcher filter is supposed to be written.  The point of the fiddler is for you to type or paste into the page web page requests and it will autogenerate the most specific filter rule it can.  You can see how the syntax is and how a good strong rule to look.

Then we can learn better techniques to make our filters play well with our AEM installations application while keeping things more secure.

In this example we'll take the content used in the [AEM sample project for WKND](https://github.com/adobe/aem-guides-wknd) and try to let it through the door

So if we pull up the browser to the [sample demo site](https://www.wknd.site/) and open up the developer tools of the browser and look at the network tab.

As we browser around you'll see pages being called and we can use those to demonstrate the example of using the fiddler

```
GET /us/en.html
GET /ca/fr.html
GET /us/en/magazine.html
GET /ca/fr/magazine.html
GET /us/en/adventures.html
GET /ca/fr/adventures.html
GET /us/en/faqs.html
GET /ca/fr/faqs.html
```

Now let's open our dispatcher-filter-fiddler.html file in our browser and paste those examples in the top text area and you'll notice it will generate the filters for us

```
/03000 {
	/type "allow"
	/method "GET"
	/path "/us/*"
	/url "/us/en.html*"
	/extension "html"
}
/03001 {
	/type "allow"
	/method "GET"
	/path "/ca/*"
	/url "/ca/fr.html*"
	/extension "html"
}
/03002 {
	/type "allow"
	/method "GET"
	/path "/us/en/*"
	/url "/us/en/magazine.html*"
	/extension "html"
}
/03003 {
	/type "allow"
	/method "GET"
	/path "/ca/fr/*"
	/url "/ca/fr/magazine.html*"
	/extension "html"
}
/03004 {
	/type "allow"
	/method "GET"
	/path "/us/en/*"
	/url "/us/en/adventures.html*"
	/extension "html"
}
/03005 {
	/type "allow"
	/method "GET"
	/path "/ca/fr/*"
	/url "/ca/fr/adventures.html*"
	/extension "html"
}
/03006 {
	/type "allow"
	/method "GET"
	/path "/us/en/*"
	/url "/us/en/faqs.html*"
	/extension "html"
}
/03007 {
	/type "allow"
	/method "GET"
	/path "/ca/fr/*"
	/url "/ca/fr/faqs.html*"
	/extension "html"
}
```

These rules again are boiler plate rules and if we want to see if they work letting the right things through then we can try using the filter testing container

## Dispatcher Filter Testing Container

We want to take the generated filters from above and excercise them.  Put them through the paces and make sure they are functional and aren't too greedy or too loose.

From the directory where we downloaded or cloned the git repo we'll file a folder called filters.

Let's create filter file `filters/002_wknd_filters.any` and paste in the filter examples from above, then save the file.

### Start-up the container

#### Docker instructions

```
$ cd aem-dispatcher-filter-testing
ams-dispatcher-filter-testing$ docker run --name filter-testing --rm -p 8080:80 -v `pwd`/filters/:/etc/httpd/conf.dispatcher.d/filters/ pryor/aem-dispatcher-filter-testing:rockylinux8
```

#### Podman instructions

```
$ cd aem-dispatcher-filter-testing
ams-dispatcher-filter-testing$ podman run --name filter-testing --rm -p 8080:80 -v `pwd`/filters/:/etc/httpd/conf.dispatcher.d/filters/ pryor/aem-dispatcher-filter-testing:rockylinux8
```

### Testing

#### Browser (Manual)

Check the following URLs and you can see they will allow you through

- http://127.0.0.1:8080/us/en.html
- http://127.0.0.1:8080/ca/fr.html
- http://127.0.0.1:8080/us/en/magazine.html
- http://127.0.0.1:8080/ca/fr/magazine.html
- http://127.0.0.1:8080/us/en/adventures.html
- http://127.0.0.1:8080/ca/fr/adventures.html
- http://127.0.0.1:8080/us/en/faqs.html
- http://127.0.0.1:8080/ca/fr/faqs.html

Let's also make sure that sensitive areas of AEM aren't visible and make sure it shows it rejects the request

- http://127.0.0.1:8080/system/console
- http://127.0.0.1:8080/siteadmin
- http://127.0.0.1:8080/crx/de/index.jsp
- http://127.0.0.1:8080/crx/packmgr/index.jsp
- http://127.0.0.1:8080/bin/querybuilder.json
- http://127.0.0.1:8080/content/.infinity.json

We can see which rules allowed or rejected the requests by looking at the logs that are coming out of the docker container

Allowed Example:

```
aem-dispatcher-filter-testing-dispatcher-1  | [Wed Jun 21 19:07:17 2023] [D] [pid 241:tid 281472864661456] Found farm filtertestfarm for 127.0.0.1
aem-dispatcher-filter-testing-dispatcher-1  | [Wed Jun 21 19:07:17 2023] [T] [pid 241:tid 281472864661456] Decomposing URL :
aem-dispatcher-filter-testing-dispatcher-1  | [Wed Jun 21 19:07:17 2023] [T] [pid 241:tid 281472864661456] uri : /us/en.html
aem-dispatcher-filter-testing-dispatcher-1  | [Wed Jun 21 19:07:17 2023] [T] [pid 241:tid 281472864661456] suffix : No suffix
aem-dispatcher-filter-testing-dispatcher-1  | [Wed Jun 21 19:07:17 2023] [T] [pid 241:tid 281472864661456] extension : html
aem-dispatcher-filter-testing-dispatcher-1  | [Wed Jun 21 19:07:17 2023] [T] [pid 241:tid 281472864661456] selector : No selectors
aem-dispatcher-filter-testing-dispatcher-1  | [Wed Jun 21 19:07:17 2023] [T] [pid 241:tid 281472864661456] Decomposing Complete
aem-dispatcher-filter-testing-dispatcher-1  | [Wed Jun 21 19:07:17 2023] [T] [pid 241:tid 281472864661456] Filter rule entry /03000 allowed 'GET /us/en.html HTTP/1.1'
```

Denied Example:

```
aem-dispatcher-filter-testing-dispatcher-1  | [Wed Jun 21 19:08:32 2023] [D] [pid 238:tid 281472619503568] Found farm filtertestfarm for 127.0.0.1
aem-dispatcher-filter-testing-dispatcher-1  | [Wed Jun 21 19:08:32 2023] [T] [pid 238:tid 281472619503568] Decomposing URL :
aem-dispatcher-filter-testing-dispatcher-1  | [Wed Jun 21 19:08:32 2023] [T] [pid 238:tid 281472619503568] uri : /system/console
aem-dispatcher-filter-testing-dispatcher-1  | [Wed Jun 21 19:08:32 2023] [T] [pid 238:tid 281472619503568] suffix : No suffix
aem-dispatcher-filter-testing-dispatcher-1  | [Wed Jun 21 19:08:32 2023] [T] [pid 238:tid 281472619503568] extension : No extension
aem-dispatcher-filter-testing-dispatcher-1  | [Wed Jun 21 19:08:32 2023] [T] [pid 238:tid 281472619503568] selector : No selectors
aem-dispatcher-filter-testing-dispatcher-1  | [Wed Jun 21 19:08:32 2023] [T] [pid 238:tid 281472619503568] Decomposing Complete
aem-dispatcher-filter-testing-dispatcher-1  | [Wed Jun 21 19:08:32 2023] [T] [pid 238:tid 281472619503568] Filter rule entry /default-deny blocked 'GET /system/console HTTP/1.1'
aem-dispatcher-filter-testing-dispatcher-1  | [Wed Jun 21 19:08:32 2023] [D] [pid 238:tid 281472619503568] Filter rejects: GET /system/console HTTP/1.1
aem-dispatcher-filter-testing-dispatcher-1  | [Wed Jun 21 19:08:32 2023] [I] [pid 238:tid 281472619503568] "GET /system/console" - blocked [filtertestfarm/-] 0ms
```

#### Bash (Scripted)

It's a good idea to generate a basic script to have it run before you put it on any server.  This will give confidence that you blocked what you meant to and allowed what you meant to.  The test endpoints will grow as your project grows and evolve to allow for all the others who will help make sure they consider everything the application needs.  In this example we'll use a basic bash script.

[Filter Test Example Bash Script](filter-test.sh)

Let's run that script and make sure it all comes back happy

```

$ bash filter-test.sh
Testing URLs that should be allowed through
Testing http://127.0.0.1:8080/us/en.html
PASSED
Testing http://127.0.0.1:8080/ca/fr.html
PASSED
Testing http://127.0.0.1:8080/us/en/magazine.html
PASSED
Testing http://127.0.0.1:8080/ca/fr/magazine.html
PASSED
Testing http://127.0.0.1:8080/us/en/adventures.html
PASSED
Testing http://127.0.0.1:8080/ca/fr/adventures.html
PASSED
Testing http://127.0.0.1:8080/us/en/faqs.html
PASSED
Testing http://127.0.0.1:8080/ca/fr/faqs.html
PASSED
```

Let's remove some of our filters file `filters/002_wknd_filters.any` that allow traffic and make sure the test catches those

We need to stop our container and start it again to pick up those changes.  From the terminal that is running the container just push `CTRL+C` to have it stop the container.  If it won't stop you can kill the container with the following command.


```
docker kill filter-testing
```

Once it's stopped hit the up arrow and re-run the container again.  Then let's run the test script again.

```
$ bash filter-test.sh
Testing URLs that should be allowed through
Testing http://127.0.0.1:8080/us/en.html
FAILED - 404
Testing http://127.0.0.1:8080/ca/fr.html
FAILED - 404
Testing http://127.0.0.1:8080/us/en/magazine.html
FAILED - 404
Testing http://127.0.0.1:8080/ca/fr/magazine.html
FAILED - 404
Testing http://127.0.0.1:8080/us/en/adventures.html
FAILED - 404
Testing http://127.0.0.1:8080/ca/fr/adventures.html
FAILED - 404
Testing http://127.0.0.1:8080/us/en/faqs.html
FAILED - 404
Testing http://127.0.0.1:8080/ca/fr/faqs.html
FAILED - 404
Testing URLs that should be blocked
Testing http://127.0.0.1:8080/system/console
PASSED
Testing http://127.0.0.1:8080/siteadmin
PASSED
Testing http://127.0.0.1:8080/crx/de/index.jsp
PASSED
Testing http://127.0.0.1:8080/crx/packmgr/index.jsp
PASSED
Testing http://127.0.0.1:8080/bin/querybuilder.json
PASSED
Testing http://127.0.0.1:8080/content/.infinity.json
PASSED
```

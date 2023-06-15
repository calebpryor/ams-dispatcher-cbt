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

asdf
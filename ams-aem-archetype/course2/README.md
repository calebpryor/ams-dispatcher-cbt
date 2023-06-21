# AMS AEM Dispatcher Local Dev - Configuration Testing and Tooling

With our new example project we want to focus on the dispatcher portion of this boilerplate

## Dispatcher Optimization Tool (DOT)

There is a wonderful open source plugin that checks your dispatcher and Apache configuration files for known misconfigurations.

[Reference](https://github.com/adobe/aem-dispatcher-optimizer-tool/tree/main/plugin)

The idea is that we need to find the `pom.xml` at the top level of your project and add the dot plugin in there

```
<!-- Dispatcher Optimizer Plugin -->
<plugin>
    <groupId>com.adobe.aem.dot</groupId>
    <artifactId>dispatcher-optimizer-maven-plugin</artifactId>
    <version>0.2.16</version>
    <configuration>
        <reportVerbosity>MINIMIZED</reportVerbosity>
    </configuration>
</plugin>
```

This allows us to run the following command and have it generate the report of what's wrong

```
$ cd my-site/dispatcher
mvn dispatcher-optimizer:analyze
```

It will generate a file as shown in the output of running the command that will show any findings.

Example output

```
[INFO] Scanning for projects...
[INFO]
[INFO] ------------------< com.mysite:mysite.dispatcher.ams >------------------
[INFO] Building My Site - Dispatcher 1.0.0-SNAPSHOT
[INFO]   from pom.xml
[INFO] --------------------------------[ pom ]---------------------------------
[INFO]
[INFO] --- dispatcher-optimizer:0.2.16:analyze (default-cli) @ mysite.dispatcher.ams ---
[INFO] [Dispatcher Optimizer] Analyzing Dispatcher config at path: mysite/dispatcher/src/conf.dispatcher.d
[INFO] [Dispatcher Optimizer] Report verbosity set to: MINIMIZED
[INFO] Loading configuration from file.  File="mysite/dispatcher/src/conf.dispatcher.d/dispatcher.any"
[WARNING] Environment variables were not resolved. EnvVars="ASSET_DOWNLOAD_RULE, AUTHOR_DEFAULT_HOSTNAME, AUTHOR_DOCROOT, AUTHOR_IP, AUTHOR_PORT, CRX_FILTER, PUBLISH_DEFAULT_HOSTNAME, PUBLISH_DOCROOT, PUBLISH_IP, PUBLISH_PORT"
[INFO] *** Processing Farm="src/conf.dispatcher.d/enabled_farms/999_ams_publish_farm.any"...
[INFO] *** Processing Farm="src/conf.dispatcher.d/enabled_farms/000_ams_author_farm.any"...
[INFO] Unique Violation Count=0.
[INFO] Compressed (MINIMIZED) Dispatcher Configuration parsing Violation Count=0.
[INFO] Loading configuration from file.  File="mysite/dispatcher/src/conf/httpd.conf"
[INFO] RuleId="DOTRules:Disp-1---ignoreUrlParams-allow-list" Result="Fail" CheckElement="farm.cache.ignoreUrlParams" CheckCondition="RULE_LIST_STARTS_WITH" CheckValue="Glob=*,Type=ALLOW" File=""
[INFO] RuleId="DOTRules:Disp-2---statfileslevel" Result="Pass" CheckElement="farm.cache.statfileslevel" CheckCondition="INT_GREATER_OR_EQUAL" CheckValue="2" File="999_ams_publish_farm.any:40"
[INFO] RuleId="DOTRules:Disp-3---gracePeriod" Result="Fail" CheckElement="farm.cache.gracePeriod" CheckCondition="INT_GREATER_OR_EQUAL" CheckValue="2" File="999_ams_publish_farm.any:33"
[INFO] RuleId="DOTRules:Disp-4---default-filter-deny-rules" Result="Pass" CheckElement="farm.filter" CheckCondition="FILTER_LIST_STARTS_WITH" CheckValue=",Type=DENY,URL=*" File="999_ams_publish_farm.any:18"
[INFO] RuleId="DOTRules:Disp-4---default-filter-deny-rules" Result="Pass" CheckElement="farm.filter" CheckCondition="FILTER_LIST_INCLUDES" CheckValue=",Type=DENY,Extension=(json|xml|html|feed),Selectors=(feed|rss|pages|languages|blueprint|infinity|tidy|sysview|docview|query|[0-9-]+|jcr:content)" File="999_ams_publish_farm.any:18"
[INFO] RuleId="DOTRules:Disp-4---default-filter-deny-rules" Result="Pass" CheckElement="farm.filter" CheckCondition="FILTER_LIST_INCLUDES" CheckValue=",Type=DENY,Method=GET,Query=debug=*" File="999_ams_publish_farm.any:18"
[INFO] RuleId="DOTRules:Disp-4---default-filter-deny-rules" Result="Pass" CheckElement="farm.filter" CheckCondition="FILTER_LIST_INCLUDES" CheckValue=",Type=DENY,Method=GET,Query=wcmmode=*" File="999_ams_publish_farm.any:18"
[INFO] RuleId="DOTRules:Disp-4---default-filter-deny-rules" Result="Pass" CheckElement="farm.filter" CheckCondition="FILTER_LIST_INCLUDES" CheckValue=",Type=DENY,Path=/content/ams/healthcheck/*" File="999_ams_publish_farm.any:18"
[INFO] RuleId="DOTRules:Disp-4---default-filter-deny-rules" Result="Pass" CheckElement="farm.filter" CheckCondition="FILTER_LIST_INCLUDES" CheckValue=",Type=DENY,URL=/content/regent.html" File="999_ams_publish_farm.any:18"
[INFO] RuleId="DOTRules:Disp-5---serveStaleOnError" Result="Pass" CheckElement="farm.cache.serveStaleOnError" CheckCondition="BOOLEAN_EQUALS" CheckValue="true" File="999_ams_publish_farm.any:51"
[INFO] RuleId="DOTRules:Disp-6---suffix-allow-list" Result="Fail" CheckElement="farm.filter" CheckCondition="FILTER_LIST_INCLUDES" CheckValue=",Type=DENY,URL=/content*,Suffix=*" File="999_ams_publish_farm.any:18"
[INFO] RuleId="DOTRules:Disp-7---selector-allow-list" Result="Fail" CheckElement="farm.filter" CheckCondition="FILTER_LIST_INCLUDES" CheckValue=",Type=DENY,URL=/content*,Selectors=*" File="999_ams_publish_farm.any:18"
[INFO] Unique Violation Count=4.
[INFO] Compressed (MINIMIZED) Dispatcher Violation Count=4.
[INFO] Unique Violation Count=2.
[INFO] Compressed (MINIMIZED) Dispatcher Configuration parsing Violation Count=1.
[INFO] End: Finished analyzing Apache Httpd configuration. Full Violation Count=0.
[INFO] Unique Violation Count=0.
[INFO] Compressed (MINIMIZED) Apache Httpd Violation Count=0.
[INFO] [Dispatcher Optimizer] Violations detected: 5
[INFO] [Dispatcher Optimizer] Details:
[INFO] Violation { severity=MAJOR, description='The Dispatcher publish farm cache should have its ignoreUrlParams rules configured in an allow list manner.', context='Farm "publishfarm" has its farm.cache.ignoreUrlParams misconfigured.' }
[INFO] Violation { severity=MAJOR, description='The Dispatcher publish farm gracePeriod property should be >= 2.', context='Farm "publishfarm" has its farm.cache.gracePeriod misconfigured.' }
[INFO] Violation { severity=MAJOR, description='The Dispatcher publish farm filters should specify the allowed Sling suffix patterns in an allow list manner.', context='Farm "publishfarm" has its farm.filter misconfigured.' }
[INFO] Violation { severity=MAJOR, description='The Dispatcher publish farm filters should specify the allowed Sling selectors in an allow list manner.', context='Farm "publishfarm" has its farm.filter misconfigured.' }
[INFO] Violation { severity=MAJOR, description='Include directive must include existing files.  Check path, or use IncludeOptional.', context='Include directive must include existing files.  Check path, or use IncludeOptional.' }
[INFO] Begin: Writing report to mysite/dispatcher/target/dispatcher-optimizer-tool/results.csv
[INFO] End: Wrote report to mysite/dispatcher/target/dispatcher-optimizer-tool/results.csv
[INFO] Begin: Writing report to mysite/dispatcher/target/dispatcher-optimizer-tool/results.html
[INFO] End: Wrote report to mysite/dispatcher/target/dispatcher-optimizer-tool/results.html
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  0.296 s
[INFO] Finished at: 2023-06-21T14:17:34-06:00
[INFO] ------------------------------------------------------------------------
```

Now if we open the html file or the .csv it will give a helpful link to how to resolve the issues before deploying them to a server.

These instructions are located [here](https://github.com/adobe/aem-dispatcher-optimizer-tool/blob/main/docs/Rules.md) as well

Everytime you make changes to your Apache HTTPD / Dispatcher Farm configuration files re-run the DOT tool to make sure you didn't introduce new issues.

## Adding a new domain

One of the common tasks in bringing a new website into AEM is to configure the Dispatcher with the new configuration files to support a new domain.

There are stop top level files that we'll need to create

### Apache HTTPD VirtualHost

We want to use the AMS provided files as an example starting place and make a few changes.

Change directories into our project.

```
cd mysite/dispatcher/src/conf.d/
```

Create a global include `conf` file that will initialize our new variables.

```
echo 'IncludeOptional variables/newsite_${ENV_TYPE}.vars' > 001_init_newsite_vars.conf
```

Create a new `vars` file that contains the domain names for each topology you intend on deploying to (i.e. dev, stage, prod)

```
echo "Define NEWSITE_HOSTNAMES prod.newsite.com www.newsite.com newsite.com" > variables/newsite_prod.vars
echo "Define NEWSITE_HOSTNAMES stage.newsite.com" > variables/newsite_stage.vars
echo "Define NEWSITE_HOSTNAMES dev.newsite.com" > variables/newsite_dev.vars
```

Copy the boilerplate maven generated `vhost` file to a new one.

```
cp available_vhosts/mysite_publish.vhost available_vhosts/newsite_publish.vhost
```

Edit the following lines of the file to make it match what we are using.
Update the Domain names in `ServerName` and `ServerAlias`

```
ServerName	newsite.local
ServerAlias	${NEWSITE_HOSTNAMES}
```

Update the response header breadcrumbs so they are unique and will help us in the future trace our requests when troubleshooting

```
Header always add X-Vhost "newsite"
```

Let's enable the symlink to the `enabled_vhosts` to make sure it's a configuration that is used

```
cd enabled_vhosts
ln -s ../available_vhosts/newsite_publish.vhost .
cd ../../
```

This all avoid being caught by the catch-all and seeing 403 forbidden messages when you cut the DNS over to point to this host.  We can spoof the request using the command line browser `CURL` to see if it's working before cutting any DNS over.

```
curl -I -k -s http://<IP ADDRESS OF HOST>
```

We should see the breadcrumb we configured show up.

```
curl -I -k -s http://127.0.0.1:8080/
HTTP/1.1 200 OK
Server: Apache
X-Dispatcher: dispatcher1uswest2
X-Vhost: newsite
```

### AEM Dispatcher Module Farm

Change directory into our modules configuration directory.

```
cd conf.dispatcher.d/
```

Create a new `_vhost.any` file to add the new domain names.

```
echo '"newsite.com"' >> vhosts/newsite_vhosts.any
echo '"www.newsite.com"' >> vhosts/newsite_vhosts.any
echo '"${ENV_TYPE}.newsite.com"' >> vhosts/newsite_vhosts.any
```

Create a new `_filters.any` file to add new rules to allow newsite content.

```
echo '/03000 { /type "allow" /method "GET" /path "/content/*" /url "/content/newsite.html*" /extension "html" }' > filters/newsite_filters.any

```

Copy the boilerplate farm file to a newsite farm.

```
cp available_farms/999_ams_publish_farm.any available_farms/100_newsite_publish_farm.any
```

Modify the first line of the farm to make it unique.

```
/newsitefarm {
```

Change out the `virtualhosts` section to use the new file we just created.

```
	/virtualhosts {
		$include "/etc/httpd/conf.dispatcher.d/vhosts/newsite_vhosts.any"
	}
```

Add our new filters file as an include to the `filters` section

```
	/filter {
		$include "../filters/ams_publish_filters.any"
        $include "../filters/newsite_filters.any"
	}
```

Enable the farm with a symlink.

```
cd enabled_farms
ln -s ../available_farms/100_newsite_publish_farm.any .
cd ../../../
```

Now re-run the DOT tool and make sure no new misconfigurations were detected

## AMS Dispatcher Filter Fiddler & Dispatcher Filter Testing Container

Now you should want to test and improve your filters on what you do and don't allow through to AEM.  Continue by taking this next course [ams-dispatcher-filter-testing](../../ams-dispatcher-filter-testing/)
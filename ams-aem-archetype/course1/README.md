# AMS AEM Dispatcher Archetype - Workstation Requirements

## Maven

Install Apache Maven to allow you to generate your starting point.  In this course we used Maven version `3.9.2`

[Installation Instructions](https://maven.apache.org/install.html)

[ Proceed to Course 2 ](../course2/)

## Generate new project

You can use the `mvn` command to generate a new project and just have to pass in the right arguments.  For this course we just used following.

```
$ mvn -B org.apache.maven.plugins:maven-archetype-plugin:3.2.1:generate \
  -D archetypeGroupId=com.adobe.aem \
  -D archetypeArtifactId=aem-project-archetype \
  -D archetypeVersion=41 \
  -D appTitle="My Site" \
  -D appId="mysite" \
  -D aemVersion=6.5.7 \
  -D groupId="com.mysite"
$ cd mysite
```

[ Proceed to Course 2 ](../course2/)
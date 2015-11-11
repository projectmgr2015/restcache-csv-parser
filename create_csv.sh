#!/usr/bin/env bash

export JAVA_OPTS="-XX:+UseG1GC -Xmx10G"

groovy ParseJtl.groovy go-clean-100th.jtl go clean 100
groovy ParseJtl.groovy go-full-100th.jtl go full 100
groovy ParseJtl.groovy jetty-clean-100th.jtl jetty clean 100
groovy ParseJtl.groovy jetty-full-100th.jtl jetty full 100
groovy ParseJtl.groovy tomcat-clean-100th.jtl tomcat clean 100
groovy ParseJtl.groovy tomcat-full-100th.jtl tomcat full 100

groovy ParseJtl.groovy go-clean-250th.jtl go clean 250
groovy ParseJtl.groovy go-full-250th.jtl go full 250
groovy ParseJtl.groovy jetty-clean-250th.jtl jetty clean 250
groovy ParseJtl.groovy jetty-full-250th.jtl jetty full 250
groovy ParseJtl.groovy tomcat-clean-250th.jtl tomcat clean 250
groovy ParseJtl.groovy tomcat-full-250th.jtl tomcat full 250


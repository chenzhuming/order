#!/usr/bin/env bash
#编译+部署order站点

#需要配置如下参数
# 项目路径, 在Execute Shell中配置项目路径, pwd 就可以获得该项目路径
# export PROJ_PATH=这个jenkins任务在部署机器上的路径

# 输入你的环境上tomcat的全路径
# export TOMCAT_APP_PATH=tomcat在部署机器上的路径

### base 函数
killTomcat()
{
    dockerid=`docker ps |grep tomcat|awk '{print $1}'`
    echo "docker tomcat id :$dockerid"
    if [ "$dockerid" = "" ]
    then
      echo "no tomcat pid alive"
    else
      docker stop $dockerid
    fi
}
cd $PROJ_PATH
mvn clean install

# 停tomcat
killTomcat

# 删除原有工程
rm -rf $TOMCAT_APP_PATH/ROOT
rm -f $TOMCAT_APP_PATH/ROOT.war
rm -f $TOMCAT_APP_PATH/order.war

# 复制新的工程
cp $PROJ_PATH/target/order.war $TOMCAT_APP_PATH

cd $TOMCAT_APP_PATH
mv order.war ROOT.war

# 启动Tomcat
dockerid=`docker ps -a|grep tomcat|awk '{print $1}'`
docker start $dockerid




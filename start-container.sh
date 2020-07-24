#!/bin/bash

# the default node number is 3
N=${1:-3}

sudo mkdir -p /data/scaladata/master/datas

# start hadoop master container
sudo docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
sudo docker run -itd \
                --net=hadoop \
                -p 50070:50070 \
                -p 8088:8088 \
                -p 9000:9000 \
                -p 8032:8032 \
                -p 19888:19888 \
                -v /data/scaladata/master/datas/tmp:/root/hdfs/tmp \
                -v /data/scaladata/master/datas/namenode:/root/hdfs/namenode \
                -v /data/scaladata/master/datas/datanode:/root/hdfs/datanode \
                --name hadoop-master \
                --hostname hadoop-master \
                kiwenlau/hadoop:1.0 &> /dev/null


# start hadoop slave container
i=1
while [ $i -lt $N ]
do
    sudo mkdir -p /data/scaladata/slave$i/datas
	sudo docker rm -f hadoop-slave$i &> /dev/null
	echo "start hadoop-slave$i container..."
	sudo docker run -itd \
	                --net=hadoop \
                    -v /data/scaladata/slave$i/datas/tmp:/root/hdfs/tmp \
                    -v /data/scaladata/slave$i/datas/namenode:/root/hdfs/namenode \
                    -v /data/scaladata/slave$i/datas/datanode:/root/hdfs/datanode \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
	                kiwenlau/hadoop:1.0 &> /dev/null
	i=$(( $i + 1 ))
done 

# get into hadoop master container
sudo docker exec -it hadoop-master bash

DATA_DIR='/data'

temp='echo " "'

ssh -o "StrictHostKeyChecking no" node1 "$temp"
ssh -o "StrictHostKeyChecking no" 0.0.0.0 "$temp"

node_number=0
for ip in `cat /home/$USER/ips.txt`
do
        ssh -o "StrictHostKeyChecking no" vm$node_number "$temp"
        node_number=$((node_number+1))
done

if [ "$JAVA_HOME" = "" ];
then
        echo "JAVA_HOME not set, run: source ~/.bashrc OR logout and login of the system"
        exit
else
	echo ">>> Starting hadoop <<< "
	echo " "
	echo ">>> It should be over by 29 Mississippi <<<"
	echo " "
        $DATA_DIR/hadoop/bin/hadoop namenode -format > LOG-start_spark_hadoop_cluster.log 2>&1
        $DATA_DIR/hadoop/sbin/start-dfs.sh >> LOG-start_spark_hadoop_cluster.log 2>&1
        $DATA_DIR/hadoop/sbin/start-yarn.sh >> LOG-start_spark_hadoop_cluster.log 2>&1
        $DATA_DIR/hadoop/bin/hdfs dfs -mkdir /spark-events >> LOG-start_spark_hadoop_cluster.log 2>&1
fi

echo ""
echo "************************************************************************************************"
echo "                      >>> Probably started hadoop <<< "
echo "Please run command \"hdfs dfsadmin -report\" to check the cluster status"
echo "************************************************************************************************" 
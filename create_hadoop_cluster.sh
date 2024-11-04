export DEBIAN_FRONTEND=noninteractive

if [[ $# -lt 1 ]];
then
        echo " Usage: cluster_config.sh [option]"
        echo ""
        echo "option: use -H for Hadoop Installation"
        exit

fi

if [ "$1" = "-H" ];
then
        echo "hadoop is selected"
        hadoop_version="3.3"
        hadoop_sub_version="1"

else
        echo "Please look for usage in this script"
        exit
fi

# TO DO: to check for each node in cluster whether nat64 is there or not and run it.
scripts=("install_java" \
	"install_hadoop" \
        )

pid=""

completed=1
master_ip=""

for ip in `cat /home/$USER/ips.txt`
do
        master_ip=$ip
        break
done

echo ">>> Installing necessary tools and softwares <<<"
echo " "
echo ">>> It will take no more than watching a movie trailer!!! <<< "
echo " "

for script in "${scripts[@]}"
do
        log_file="LOG-"$script".log"
        command='bash /home/'$USER'/hadoop_scripts/'$script'.sh '$hadoop_version' '$hadoop_sub_version' &> /home/'$USER'/hadoop_scripts/'$log_file''
        ssh -o "StrictHostKeyChecking no" $master_ip "$command" &
        pid="$pid $!"

        while true;
        do
                if ps -p $pid > /dev/null
                then
                        sleep 3
                else
                        break
                fi
        done

        echo "Running script $script :" "Done with stages ($completed / ${#scripts[@]})"
        completed=$((completed+1))

done

echo ">>> Done with the installation <<<"
echo ""
echo "*************************************************************************"
echo ">>> Please Logout and login into the system OR run \"source ~/.bashrc\" <<<"
echo "   >>> After that run the script \"start_spark_hadoop_cluster.sh\" <<< "
echo "*************************************************************************"
                                                                                     




# Runtime


```bash

prsync -h hosts.pssh -zarv -p 4 ./ /root/mpyc
pssh -h hosts.pssh -iv -o ./logs/$t "cd /root/mpyc && ./prun.sh"

```


```bash


# assemble $args and $MY_PID from the hosts.pssh file

...


if [ $MY_PID = -1 ]
then
    echo Only $i parties are allowed. $HOSTNAME will not participate in this MPC session
else

cmd="python ./demos/secretsanta.py 3 --log-level debug \
    -I ${MY_PID} \
    ${args}"

echo $cmd
$cmd
fi


```






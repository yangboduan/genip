#!/bin/bash
#Author:yangboduan
#Date:2015-12-25
#Desc:根据起始IP和结束IP输出IP信息
#Usage:./iprange.sh IPA IPB
IPA1=`echo $1 | awk -F '.' '{print $1}'` 
IPA2=`echo $1 | awk -F '.' '{print $2}'`          
IPA3=`echo $1 | awk -F '.' '{print $3}'`          
IPA4=`echo $1 | awk -F '.' '{print $4}'`          
                                                  
IPB1=`echo $2 | awk -F '.' '{print $1}'`          
IPB2=`echo $2 | awk -F '.' '{print $2}'`          
IPB3=`echo $2 | awk -F '.' '{print $3}'`          
IPB4=`echo $2 | awk -F '.' '{print $4}'`          

IP4_not_equal(){
    for i in `eval echo {$IPA4..$IPB4}`
    do
        echo $IPA1.$IPA2.$IPA3.$i
    done
}



IP3_not_equal () {
    for i in  `eval echo {$IPA3..$IPB3}`
    do
        if [[ $i = $IPA3 ]]
        then
            eval echo   "192.168.$i.{$IPA4..255}" |xargs -n 1
        elif [[ $i = $IPB3 ]]
        then
            eval echo   "192.168.$i.{1..$IPB4}" |xargs -n 1
        else
            eval echo  "192.168.$i.{1..255}" | xargs -n 1
        fi
done
}


IP2_not_equal(){
    #第二段的变化范围
    for n in `eval echo {$IPA2..$IPB2}`
    do
        #如果第二段与IPA的第二段相同
        if [ $n = $IPA2 ] 
        then  
            #第三段的变化范围为IPA3到255 
            for m in `eval echo {$IPA3..255}`
            do
                #如果第三段与IPA的第三段相同
                if [[ $m = $IPA3 ]]
                then
                    eval echo "$IPA1.$IPA2.$IPA3.{$IPA4..255}" | xargs -n 1
                else
                    eval echo "$IPA1.$IPA2.$m.{1..255}" | xargs -n 1
                fi
            done
        #如果第三段与IPB的第三段相同
        elif [ $n = $IPB2 ]
        then
            #第三段变化范围为0到IPB3
            for x in `eval echo {0..$IPB3}` 
            do
                #如果第三段与IPB的第三段相同
                if [ $x = $IPB3  ]
                then
                    eval echo "$IPB1.$IPB2.$IPB3.{0..$IPB4}" |xargs -n 1
                else
                    eval echo "$IPB1.$IPB2.$x.{0..255}" |xargs -n 1
                fi
            done
        #如果第二段与IPA和IPB的均不相同
        else  
            #第三段变化范围
            for y in {0..255}
            do 
                echo $IPA1.$n.$y.{0..255} |xargs -n 1
            done
        fi
    done 
}

#定义pass函数，啥事都不做
pass(){
echo "">/dev/null
}


IP1_not_equal(){
#IP第一段的范围
for d1 in `eval echo {$IPA1..$IPB1}`
do
    #<1>如果第一段与IPA1相同
    if [[ $d1 = $IPA1 ]]
    then
        #第二段IP范围为IPA2到255
        for d2 in `eval echo {$IPA2..255}`
        do
           #<1.1>如果第二段与IPA2相同
           if [[ $d2 = $IPA2 ]]
           then
               #第三段IP范围为IPA3到255
               for d3 in `eval echo {$IPA3..255}`
               do
                   #<1.1.1>如果第三段IP与IPA3相同
                   if [[ $d3 = $IPA3  ]]
                   then
                       for d4 in `eval echo {$IPA4..255}`
                       do
                           echo $d1.$d2.$d3.$d4
                       done
                   #<1.1.2>如果第三段IP与IP3不同
                   else
                       for d4 in {0..255}
                       do
                           echo $d1.$d2.$d3.$d4
                       done
                   fi
               done
           #<1.2>如果第二段与IPA2不同
           else
               for d3 in {0..255}
               do
                   for d4 in {0..255}
                   do
                       echo $d1.$d2.$d3.$d4
                   done
               done
           fi  
        done
    #<2>如果第一段IP与IPB相同
    elif [[ $d1 = $IPB1 ]]
    then
        #第二段IP的范围为0到IPB2
        for d2 in `eval echo {0..$IPB2}`
        do
            #<2.1>如果第二段IP与IPB相同
            if [[ $d2 = $IPB2 ]]
            then
                #第三段IP范围为0到IPB3
                for d3 in `eval echo {0..$IPB3}`
                do
                    #<2.1.1>如果第三段IP与IPB3相同
                    if [[ $d3 = $IPB3 ]]
                    then
                        for d4 in `eval echo {0..$IPB4}`
                        do
                            echo $d1.$d2.$d3.$d4
                        done
                    #<2.1.2>如果第三段IP与IPB3不同
                    else
                        for d4 in {0..255}
                        do
                            echo $d1.$d2.$d3.$d4
                        done
                    fi
                done
            #<2.2>如果第二段IP与IPB不相同
            else
               #第三段IP范围为{0..255}
               for d3 in {0..255}
               do
                   #第四段IP范围为{0.255}
                   for d4 in {0.255}
                   do
                       echo $d1.$d2.$d3.$d4
                   done
               done
            fi
        done     
    #<3>第一段IP与IPA1和IPB1都不相同
    else
        for d2 in {0..255}
        do
            for d3 in {0..255}
            do 
                for d4 in {0..255}
                do
                    echo $d1.$d2.$d3.$d4
                done
            done
        done
    fi   
done    
}


print_range_ip(){ 
#<1>如果两IP第一段不同
if [ $IPA1 != $IPB1 ]
then
    IP1_not_equal 
#<2>如果两IP第一段相同
else
    #<2.1> 如果第二段IP相同
    if [ $IPA2 = $IPB2 ]
    then
        #<2.1.1>如果第三段IP不相同
        if [[ $IPA3 != $IPB3 ]]
        then
            IP3_not_equal 
        #<2.2.2>如果第三段IP相同
        else
            IP4_not_equal
        fi
        
    #<2.2> 如果第二段IP不相同
    else
        IP2_not_equal
    
    fi
fi
}
print_range_ip

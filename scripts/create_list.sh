#!/bin/bash

for i in abuse blocklistDE myip talos
do
  mkdir -p /tmp/iprep/$i
done

#abuse
wget -q https://sslbl.abuse.ch/blacklist/sslipblacklist.txt -O /tmp/iprep/abuse/sslipblacklist.txt
wget -q https://feodotracker.abuse.ch/downloads/ipblocklist_recommended.txt -O /tmp/iprep/abuse/ipblocklist_recommended.txt


[[ $(grep "5,abuse.ch,bad hosts" /etc/suricata/iprep/categories.txt | wc -l) -gt "0" ]] && echo "category already defined" || echo "5,abuse.ch,bad hosts" >> /etc/suricata/iprep/categories.txt

cat /dev/null > /etc/suricata/iprep/abuse.ip

for i in $(cat /tmp/iprep/abuse/*.txt | grep -v "#" | grep -v '^$' | sed -e "s/\r//g")
do
  echo ${i},5,101 >> /etc/suricata/iprep/abuse.ip
done


#blocklistDE
wget -q https://lists.blocklist.de/lists/all.txt -O /tmp/iprep/blocklistDE/all.txt
[[ $(grep "4,blocklistDE,bad hosts" /etc/suricata/iprep/categories.txt | wc -l) -gt "0" ]] && echo "category already defined" || echo "4,blocklistDE,bad hosts" >> /etc/suricata/iprep/categories.txt

cat /dev/null > /etc/suricata/iprep/blocklistDE.ip

for i in $(cat /tmp/iprep/blocklistDE/*.txt)
do
  echo $i,4,101 >> /etc/suricata/iprep/blocklistDE.ip
done

#myip
wget -q https://myip.ms/files/blacklist/general/latest_blacklist.txt -O /tmp/iprep/myip/latest_blacklist.txt
wget -q https://myip.ms/files/blacklist/general/latest_blacklist_users_submitted.txt -O /tmp/iprep/myip/latest_blacklist_users_submitted.txt

[[ $(grep "3,MyIP,bad hosts" /etc/suricata/iprep/categories.txt | wc -l) -gt "0" ]] && echo "category already defined" || echo "3,MyIP,bad hosts" >> /etc/suricata/iprep/categories.txt

cat /dev/null > /etc/suricata/iprep/myip.ip

for i in $(cat /tmp/iprep/myip/*.txt | grep "\." | cut -d"#" -f1 | grep -v '^$')
do
  echo $i,3,101 >> /etc/suricata/iprep/myip.ip
done  

#talos
wget -q https://www.talosintelligence.com/documents/ip-blacklist -O /tmp/iprep/talos/talos.txt

cat /dev/null > /etc/suricata/iprep/talos.ip


[[ $(grep "6,talos,bad hosts" /etc/suricata/iprep/categories.txt | wc -l) -gt "0" ]] && echo "category already defined" || echo "6,talos,bad hosts" >> /etc/suricata/iprep/categories.txt

for i in $(cat /tmp/iprep/talos/*.txt | grep -v "#" | grep -v '^$' | sed -e "s/\r//g")
do
  echo ${i},6,101 >> /etc/suricata/iprep/talos.ip
done


rm -rfv /tmp/iprep


#!/usr/bin/env sh


dte(){
  dte="$(date +"%Y.%m.%d | %H:%M")"
  echo -e "+@fn=2;📅+@fn=0; $dte"
}

mem(){
  mem=`free | awk '/Mem/ {printf "%d MiB/%d MiB\n", $3 / 1024.0, $2 / 1024.0 }'`
  echo -e "+@fn=2;🧠+@fn=0; $mem"
}

vol(){
  vol=$(amixer get Master | awk -F'[]%[]' '/%/ {if ($7 == "off") { print "MM" } else { print $2 }}' | head -n 1)
  echo -e "+@fn=2;🔊+@fn=0; $vol%"
}

cpu(){
  read cpu a b c previdle rest < /proc/stat
  prevtotal=$((a+b+c+previdle))
  sleep 0.5
  read cpu a b c idle rest < /proc/stat
  total=$((a+b+c+idle))
  cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
  echo -e "+@fn=2;🚨+@fn=0; $cpu%"
}

temp(){
  temp="$(sensors | awk '/^Tdie:/ {print $2}')"
  echo -e "+@fn=2;☢️+@fn=0; $temp"
}

wtr(){
  weat=$(curl 'wttr.in?format=%c')
  weat1=$(curl 'wttr.in?format=%t')
  weat2=$(curl 'wttr.in?format=%p')
  echo -e "+@fn=2;$weat+@fn=0; $weat1$weat2"
}

bat(){
  bat="$(acpi -b | awk  '{print $0}')"
  #bat=$(acpi -b | cut -d " " -f4 | sed 's/%//' | sed 's/,//' | sed 's/ //g')
  echo -e "+@fn=2;🔋+@fn=0; $bat"

}  

SLEEP_SEC=0.5

while :; do

  echo "$(bat) | $(cpu) | $(temp) | $(mem) | $(wtr) | $(dte) | $(vol)"

  sleep $SLEEP_SEC # Update time every ten seconds
done


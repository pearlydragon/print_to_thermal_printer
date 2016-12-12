# !/bin/sh

##############################
#Демон, распознающий, какие есть принтеры, решающий, какой принтер будет LPT4,
#а какой LPT2 ля Домино, и печатающий всё, что падает в папку для печати,
#предварительно сверившись, куда именно надо печатать)
##############################

var0=0

cd /windows/c/Domino8/home/PRINT/

if [ "$(lpstat -p -d | grep -w TSC)" != "" ]
then
    LPT2="TSC"
else
    LPT2="Zebra"
fi

if [ "$(lpstat -p -d | grep -w TSCLPT4)" != "" ]
then
    LPT4="TSCLPT4"
else
    LPT4="ZebraLPT4"
fi
echo $LPT2
echo $LPT4

while [ "$var0" -eq "0" ]
do
    if [ -s "PRICE.VBS" ]
    then
	echo "Есть что печатать!"
	for fname in $(find * -maxdepth 0 -type f 2> /dev/null | grep .TXT)
	do
	    echo "file exist: $fname"
	    #cp "$fname" /dev/usb/lp0
	    if [ "$(cat PRICE.VBS | grep LPT2)" == "" ]
	    then
		lpr -P $LPT4 $fname -l
		echo "Печатаем на принтер $LPT4"
	    else
		lpr -P $LPT2 $fname -l
		echo "Печатаем на принтер $LPT2"
	    fi
	    #lpr -P TSCLPT4 $fname -l
	    #echo "$?"
	    #ls -1 | grep "PRICE*" | grep .TXT | xargs -n 1 -I % cp "%" /dev/usb/lp0
	    #continue
	    echo "sleep 5 before deleting"
	    sleep 5
	    rm --force "$fname" 2>/dev/null
	    rm --force "PRICE.VBS" 2>/dev/null 
	    echo "sleep 5"
	    sleep 5
	done
    fi
    echo "sleep 5"
    sleep 5
done

exit
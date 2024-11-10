#! /bin/bash

AppName=PenTablet
AppDir=pentablet
pid=`ps -e|grep $AppName`
appScript=$AppName".sh"
if [ -n "$pid" ]; then
	echo $pid
	arr=()
	while read -r line; do
	   arr+=("$line")
	done <<< "$pid"
	for val in "${arr[@]}";
	do
		appid=`echo $val | awk '{print $1}'`
	   	name=`echo $val | awk '{print $4}'`
	   	echo "ID:"$appid 
		echo "Name:"$name
		if [ "$name" = "$appRunScript" ]; then
			echo "close $appRunScript"
			kill -15 $appid
		elif [ "$name" = "$AppName" ]; then
			echo "close $AppName"
			kill -15 $appid
		fi
	done
fi

lockfile="/tmp/qtsingleapp-Pentab-9c9b-lockfile"
rm $lockfile

#uninstall app
sysAppDir=/usr/lib/pentablet
if [ -d "$sysAppDir" ]; then
	str=`rm -rf $sysAppDir`
	if [ "$str" !=  "" ]; then 
		echo "$str";
	fi
fi


#uninstall shortcut
sysDesktopDir=/usr/share/applications
sysAppIconDir=/usr/share/icons/hicolor/256x256/apps
sysAutoStartDir=/etc/xdg/autostart

appDesktopName=xppentablet.desktop
appIconName=pentablet.png
if [ -f "$sysDesktopDir/$appDesktopName" ]; then
	str=`rm $sysDesktopDir/$appDesktopName`
	if [ "$str" !=  "" ]; then 
		echo "$str";
	fi
fi

if [ -f $sysAppIconDir/$appIconName ]; then
	str=`rm $sysAppIconDir/$appIconName`
	if [ "$str" !=  "" ]; then 
		echo "$str";
	fi
fi

if [ -f $sysAutoStartDir/$appDesktopName ]; then
	str=`rm $sysAutoStartDir/$appDesktopName`
	if [ "$str" !=  "" ]; then 
		echo "$str";
	fi
fi

#uninstall hid permission
sysRuleFile=/lib/udev/rules.d/10-xp-pen.rules
if [ -f $sysRuleFile ]; then
	str=`rm $sysRuleFile`
	if [ "$str" !=  "" ]; then 
		echo "$str";
	fi
fi

echo "Uninstall succeeded."


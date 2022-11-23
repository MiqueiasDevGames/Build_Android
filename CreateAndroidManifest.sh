#!/bin/bash



nomeicon="ic_launcher"
echo ""

#NAME NOTIFICATION ICON
nomenotificon="ic_launcher"
echo ""



#O Nome Do Projeto

echo "Give me the name you Android Project, name"
echo "Ex: Android Nome"
echo " "
read NameProjectGodot

echo "Give me the name you Folder Project name"
echo " "
read FolderProject


#String godot_project_name_string
> AndroidManifest/NameProject/NameProject.txt
mkdir AndroidManifest/NameProject
echo $FolderProject >> AndroidManifest/NameProject/NameProject.txt


valueString="<?xml version=\"1.0\" encoding=\"utf-8\"?>  <resources> <string name=\"project_name\">$NameProjectGodot</string> </resources>"

#Modificar as Strings para o Nome do Projeto
MyStringsName=$( find  ../$FolderProject/build/res/ -name "project_name_string.xml" )
> MyStringsName.txt
> MyStringsName2.txt

echo $MyStringsName >> MyStringsName.txt
tr ' ' '\n' <  MyStringsName.txt >  MyStringsName2.txt

echo "..."

for line in $(cat MyStringsName2.txt); 
do 

rm -rf $line
> $line
echo $valueString >> $line

done

rm -rf MyStringsName.txt
rm -rf MyStringsName2.txt







#So pra ter certeza que a variavel existe
#para caso não queira Admob deixar elas
#vazias. Essas são variaveis para adicionar AdMob
Add_Admob_Manifest=""


#AndroidManifest for plugin Admob in 70
PluginAndroidManifest=$(cat -E Admob_Android_Dependency/70/AndroidManifest.xml)


#Admob
#AndroidManifest for dependency com.google.android.gms.ads Ads lite
AdmobAdsManifest=$(cat -E Admob_Android_Dependency/45/AndroidManifest.xml)

#AndroidManifest for dependency com.google.android.gms.common
AdmobCommonManifest=$(cat -E Admob_Android_Dependency/47/AndroidManifest.xml)
#Valor necessario para tag, pegar por aqui mesmo
valueCommonManifest=$(cat -E Admob_Android_Dependency/47/res/values/values.xml)





#echo ""
#echo "Me informe o Nome do Projeto:"
#read NameProjectGodot
echo ""
echo "Want to Add ADMOB? y or n"
read admob


#Colocar APPLICATION_ID.txt na pasta do projeto ao lado de build
if [ $admob == "y" ]; then
echo ""
echo "Add your com.google.android.gms.ads.APPLICATION_ID"
echo "in the file Project_Folder/APPLICATION_ID.txt"
echo "added ? y"
read application_id
my_application_id=$(cat ../$FolderProject/APPLICATION_ID.txt)
fi


echo ""
echo "Let me know what your package will be: Ex.: com.godot.game"
read package
echo ""

#Onde mudar no arquivo java
mude="javapackage"

if [ ! -d "My_Build/PACKAGE/" ]; then
mkdir My_Build/PACKAGE
> My_Build/PACKAGE/package.txt

else
mude=$(cat My_Build/PACKAGE/package.txt)
echo ""
echo "Previous: $mude"
fi


anteriorPackage=$(cat My_Build/PACKAGE/package.txt)

#salva pra ser usado em Build_aab.sh
echo "New package: $package"
echo ""
echo ""
> My_Build/PACKAGE/package.txt
echo $package >> My_Build/PACKAGE/package.txt





#classes java
rm -rf My_Build/src/*
cp -rf ../$FolderProject/build/src/* My_Build/src/

#MainActivity.java
MainActivity=$(cat -E My_Build/src/MainActivity.java)
parte_MainActivity=$(echo $MainActivity | sed "s/$mude/$package/" )

rm -rf My_Build/src/MainActivity.java
> My_Build/src/MainActivity.txt
> My_Build/src/MainActivity.java
echo -e $parte_MainActivity >> My_Build/src/MainActivity.txt

tr '$' '\n' < My_Build/src/MainActivity.txt > My_Build/src/MainActivity.java




#MyFirebaseMessagingService.java
mymessagingservice=$(cat -E My_Build/src/MyFirebaseMessagingService.java)
parte_mymessagingservice=$(echo $mymessagingservice | sed "s/$mude/$package/" )

rm -rf My_Build/src/MyFirebaseMessagingService.java
> My_Build/src/MyFirebaseMessagingService.txt
> My_Build/src/MyFirebaseMessagingService.java
echo -e $parte_mymessagingservice >> My_Build/src/MyFirebaseMessagingService.txt

tr '$' '\n' < My_Build/src/MyFirebaseMessagingService.txt > My_Build/src/MyFirebaseMessagingService.java


rm -rf My_Build/src/MyFirebaseMessagingService.txt
rm -rf My_Build/src/GodotApp.txt
#classes java


#MySplashScreen.java
mysplashscreen=$(cat -E My_Build/src/MySplashScreen.java)
parte_mysplashscreen=$(echo $mysplashscreen | sed "s/$mude/$package/" )

rm -rf My_Build/src/MySplashScreen.java
> My_Build/src/MySplashScreen.txt
> My_Build/src/MySplashScreen.java
echo -e $parte_mysplashscreen >> My_Build/src/MySplashScreen.txt

tr '$' '\n' < My_Build/src/MySplashScreen.txt > My_Build/src/MySplashScreen.java


rm -rf My_Build/src/MySplashScreen.txt



#classes java


echo "VersionCode And VersionName current:"
echo ""
echo -e $(cat ../$FolderProject/build/ProjectVersion.txt)
echo ""
echo ""
echo "Now tell me the versionCode: Ex.: 1"
read versionCode
echo ""
echo "Now tell me the versionName: Ex.: 1.0"
read versionName

#finalTags
finalTag="/>"






echo ""
echo "Put google-services.json in folder Notification/  y?"
echo ""
echo "google-services.json FIREBASE  in  build/google-services.json  y?"
echo ""
echo "Put it there only after the y"
echo "write y and enter"
read notififirebase





#FIREBASE GOOGLE_SERVICES.JSON XML GENERATE
google_servcies=$(cat -E ../$FolderProject/build/google-services.json)


#google_app_id 1
google_app_id=$(echo $google_servcies | sed "s/.*\"mobilesdk_app_id\"\: \"//; s/\".*//")

#gcm_defaultSenderId 2
gcm_defaultSenderId=$(echo $google_servcies | sed "s/.*\"project_number\"\: \"//; s/\".*//")

#default_web_client_id 3
default_web_client_id=$(echo $google_servcies | sed "s/.*\"client_id\"\: \"//; s/\".*//")

#firebase_database_url 4
firebase_database_url=$(echo $google_servcies | sed "s/.*\"storage_bucket\"\: \"//; s/\".*//")

#google_api_key 5
google_api_key=$(echo $google_servcies | sed "s/.*\"current_key\"\: \"//; s/\".*//")

#google_crash_reporting_api_key 6
google_crash_reporting_api_key=$(echo $google_servcies | sed "s/.*\"current_key\"\: \"//; s/\".*//")

#project_id 7
project_id=$(echo $google_servcies | sed "s/.*\"project_id\"\: \"//; s/\".*//")


google_servcies_xml=$(cat -E Notification/values.xml)


troca1=$(echo $google_servcies_xml | sed "s/@google_app_id/$google_app_id/" )

troca2=$(echo $troca1 | sed "s/@gcm_defaultSenderId/$gcm_defaultSenderId/" )

troca3=$(echo $troca2 | sed "s/@default_web_client_id/$default_web_client_id/" )

troca4=$(echo $troca3 | sed "s/@firebase_database_url/$firebase_database_url/" )

troca5=$(echo $troca4 | sed "s/@google_api_key/$google_api_key/" )

troca6=$(echo $troca5 | sed "s/@google_crash_reporting_api_key/$google_crash_reporting_api_key/" )

troca7=$(echo $troca6 | sed "s/@project_id/$project_id/" )



> Notification/value_services_tmp.txt
> Notification/res/values/notification_value.xml

echo $troca7 >> Notification/value_services_tmp.txt

tr '$' '\n' < Notification/value_services_tmp.txt > Notification/res/values/notification_value.xml


rm -rf Notification/value_services_tmp.txt

echo "FIREBASE XML"
#aapt2 compile Notification/res/values/notification_value.xml -o  My_Build/compiled_resources_plugins/
echo ""
#FIREBASE GOOGLE_SERVICES.JSON XML GENERATE






#Outros Plugins Godot
rm -rf  ../My_Build/compiled_resources/*

echo ""
if [ ! -e "ANDROID_PATH.txt" ]; then
#Pegar o android path para usar android.jar
echo ""
echo "Give me your path to Android Platform "
echo "Ex: /usr/lib/android-sdk/platforms/android-NN"
echo "without / at the end"
echo " "
read androidpath

>ANDROID_PATH.txt
echo $androidpath >> ANDROID_PATH.txt

else
androidpath=$(cat ANDROID_PATH.txt)
echo " "
echo "ANDROID_PATH:"
echo $androidpath
#FIM android path pegar
fi
echo ""

#70+
if [ -d "plugins_config/" ]; then
rm -rf plugins_config/
rm -rf My_Build/compiled_resources_plugins
fi

mkdir plugins_config/
cd plugins_config/
>ParteManifestPlugins.txt
cd ..

rm -rf My_Build/gen_plugin/*

cd Admob_Android_Dependency


#FIREBASE DEPENDENCI NOTIFICATION
#primeiro 67, 68 e 689
ManifestMessaging=$(cat -E ../Notification/AndroidManifest.txt)

parte_ManifestMessaging=$(echo $ManifestMessaging | sed "s/\${applicationId}/$package/" | sed "s/\${package}/$package/" | sed "s/\${notificationicon}/$nomenotificon/" )
#FIREBASE DEPENDENCI



#Plugins Admob_Dependency 70
mkdir ../My_Build/compiled_resources_plugins
numero=70

echo ""
echo "Plugins Folder Plugins"
for line in $(cat ../MyPluginsGodot.txt);
do

PluginGodotManifest=$(cat -E $numero/AndroidManifest.xml)


#Gerar o gen para plugins que tem res/

aapt2 compile $numero/res/**/* -o  ../My_Build/compiled_resources_plugins/
aapt2 link --proto-format -o temporaryplugin.apk -I $androidpath/android.jar --manifest $numero/AndroidManifest.xml -R  ../My_Build/compiled_resources_plugins/*.flat --auto-add-overlay --java  ../My_Build/gen_plugin



plugin_godot=$(echo $PluginGodotManifest | sed "s/.*<application>//; s/<\/application>.*//")

parte_godot=$(echo $plugin_godot | sed "s/\${applicationId}/$package/" )

echo $parte_godot >> ../plugins_config/ParteManifestPlugins.txt

numero=$(($numero+1))

done


echo ""


#rm -rf  ../My_Build/compiled_resources/*
rm -rf temporaryplugin.apk 
cd ..

outros_plugins_manifest=$(cat plugins_config/ParteManifestPlugins.txt)
#FIM OUTROS PLUGINS




#>>START ADMOB

if [ $admob == "y" ];
then

#use AndroidManifest.xml

#Admob ads lite activity and provider
ads_Admob=$(echo $AdmobAdsManifest | sed "s/.*<application>//; s/<\/application>.*//")
#use AndroidManifest.xml 
parte_Ads_Admob=$(echo $ads_Admob | sed "s/\${applicationId}/$package/" )


#Admob common meta com.google.android.gms.version
parte_Common_Admob=$(echo $AdmobCommonManifest | sed "s/.*<application>//; s/<\/application>.*//")
#google_play_services_version integer value
value_integer=$(echo $valueCommonManifest | sed "s/.*<integer name=\"google_play_services_version\">//; s/<\/integer>.*//")
#Adicionar o value integer no local indicado
#@integer/google_play_services_version
total_common_admob=$(echo $parte_Common_Admob | sed "s/@integer\/google_play_services_version/$value_integer/" )



#Parte final do Admob e godot
Add_Admob_Manifest=$(echo -e "\n <!-- MY APPLICATION_ID --> \n $my_application_id  \n \n <!--Plugin AdMob for Godot -->  $parte_Ads_Admob \n $total_common_admob \n")

else
echo "OK! No AdMob"
fi

#>> END ADMOB






#Inicio do AndroidManifest.xml
my_inicio_manifest=$(cat AndroidManifest/Part_Manifest/my_start_manifest.txt)
#Modificar package
modify_package=$(echo $my_inicio_manifest | sed "s/com.godot.game/$package/" )
#Modifica_version_code
version_code=$(echo $modify_package | sed "s/android:versionCode=\"1\"/android:versionCode=\"$versionCode\"/")
#Modifica version_name
version_name=$(echo $version_code | sed "s/ android:versionName=\"1.0\"/ android:versionName=\"$versionName\"/")

#Parte inicial AndroidManifest.xml
#echo $version_name



echo "..."
echo ""






#Parte do uses-sdk AndroidManifest.xml
#<uses-sdk android:minSdkVersion="18" android:targetSdkVersion="30" android:maxSdkVersion="30"/>

echo "OK! Now I need the minSdkVersion: Ex.: 18"
read minSdkVersion

echo ""
echo "OK! Now I need the targetSdkVersion: Ex.: 30"
read targetSdkVersion


echo ""

#Modificar a parte de usesSDK
my_uses_sdk=$(cat AndroidManifest/Part_Manifest/my_uses-sdk.txt)

modify_minSdk=$(echo $my_uses_sdk | sed "s/android:minSdkVersion=\"18\"/android:minSdkVersion=\"$minSdkVersion\"/")

modify_targetSdk=$(echo $modify_minSdk | sed "s/android:targetSdkVersion=\"30\"/android:targetSdkVersion=\"$targetSdkVersion\"/")




#Parte uses-sdk AndroidManifest.xml
#echo $modify_targetSdk









#Parte do supports-screens AndroidManifest.xml
#Modify manualy >> Part_Manifest/supports-screens.txt
supports_screens=$(cat AndroidManifest/Part_Manifest/supports-screens.txt)

#Parte supports-screens AndroidManifest.xml
#echo $supports_screens





echo "..."


 #Parte uses_feature AndroidManifest.xml
 #echo $modify_uses_feature
  
  
  
  
  
  
#parte uses-permission AndroidManifest.xml
uses_permission=$(cat AndroidManifest/Part_Manifest/uses-permission.txt)
#Parte uses-permission AndroidManifest.xml  
#echo $uses_permission  
  
  
  
 echo "..."
 #Parte Application do AndroidManifest.xml
 #Modificar esta parte aquisó por referencia
my_application_app=$(cat AndroidManifest/Part_Manifest/application_start.txt) 
modify_application_app=$(echo $my_application_app | sed "s/godot_project_name_string/godot_project_name/" | sed "s/android:icon=\"@mipmap\/icon\"/android:icon=\"@mipmap\/$nomeicon\" android:roundIcon=\"@mipmap\/$nomeicon\_round\"/" )
 
 #Aqui precisa definir a orientation
 echo ""
 echo "Tell me what will android:screenOrientation be?"
 echo "portrait or landscape or sensor" 
 read orientation
#portrait ou landscape 
orientation_application=$(echo $modify_application_app | sed "s/android:screenOrientation=\"landscape\"/android:screenOrientation=\"$orientation\"/2" | sed "s/PluginPackage/$package/")  
  
 
#Parte Application AndroidManifest.xml
#echo $orientation_application
 

 
 
 
 
 
#FIM ANDROIDMANIFEST.XML
end_androidmanifest=$(cat AndroidManifest/Part_Manifest/my_end_manifest.txt)    






echo ""





#Montar AndroidMnaifest.xml
mkdir AndroidManifest/AndroidManifest
> AndroidManifest/AndroidManifest/AndroidManifest_tmp.xml
> ../$FolderProject/build/AndroidManifest.xml

start=$(echo -e "$version_name \n $modify_targetSdk  $supports_screens \n $uses_permission \n")
quite=$(echo -e "$orientation_application ")
end=$(echo -e "$Add_Admob_Manifest \n $outros_plugins_manifest \n $parte_ManifestMessaging \n $end_androidmanifest")


echo -e "$start \n $quite \n $end" >> AndroidManifest/AndroidManifest/AndroidManifest_tmp.xml


tr '$' '\n' < AndroidManifest/AndroidManifest/AndroidManifest_tmp.xml > ../$FolderProject/build/AndroidManifest.xml


rm AndroidManifest/AndroidManifest/AndroidManifest_tmp.xml



#--min-api compative d8
> AndroidManifest/min_api.txt

echo $minSdkVersion >> AndroidManifest/min_api.txt


#Salvar versionCode e versionName Atuias
> ../$FolderProject/build/ProjectVersion.txt

echo -e "VERSION_CODE =  $versionCode \n VERSION_NAME =  $versionName" >> ../$FolderProject/build/ProjectVersion.txt




#Dar um jeitinho em BuildConfig/BuildConfig.java
#BuildConfig_example.txt

BuildConfig=$(cat -E BuildConfig/BuildConfig_example.txt)
> BuildConfig/BuildConfig.txt
> BuildConfig/BuildConfig_tmp.txt

Modify_BuildConfig=$(echo $BuildConfig | sed "s/com.godot.game/$package/g" | sed "s/{versioncode}/$versionCode/" | sed "s/{versionname}/\"$versionName\"/")

echo $Modify_BuildConfig >> BuildConfig/BuildConfig_tmp.txt

tr '$' '\n' < BuildConfig/BuildConfig_tmp.txt > BuildConfig/BuildConfig.txt

rm BuildConfig/BuildConfig_tmp.txt







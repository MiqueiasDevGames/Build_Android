#!/bin/bash

#base.zip removido
rm -rf *.zip

echo ""
NameProject=$(cat AndroidManifest/NameProject/NameProject.txt)
echo $NameProject
echo ""

#Começar o trabalho duro
echo ""
echo "Remember to run CreateAndroidManifest.sh first"
echo "run it every time you change your project version"

echo ""
echo "Is this a debug or relase version?"
echo "write: debug or release"
read DebugorRelea

debugORrelase=""
if [ $DebugorRelea == "debug" ]; then
debugORrelase="--debug"
parseBoolean="Boolean.parseBoolean(\"true\")"
my_build_config="debug"
else
if [ $DebugorRelea == "release" ]; then
debugORrelase="--release"
parseBoolean="Boolean.parseBoolean(\"false\")"
my_build_config="release"
else
echo ""
echo "Error!!! you should write: debug or release"
echo ""
return
fi
fi
echo " "
echo $debugORrelase
echo " "
#BuildConfig debug or release
BuildConfig=$(cat -E BuildConfig/BuildConfig.txt)
> BuildConfig/BuildConfig.java
> BuildConfig/BuildConfig_tmp.txt

Modify_BuildConfig=$(echo $BuildConfig | sed "s/\"debug\"/\"$my_build_config\"/" | sed "s/Boolean.parseBoolean(\"true\")/$parseBoolean/")

echo $Modify_BuildConfig >> BuildConfig/BuildConfig_tmp.txt
tr '$' '\n' < BuildConfig/BuildConfig_tmp.txt > BuildConfig/BuildConfig.java

rm BuildConfig/BuildConfig_tmp.txt



#Fazer limpa em  My_Build/gen,  My_Build/build,  My_Build/src e  My_Build/assets
rm -rf  My_Build/gen/*

#Limpa rm -rf  My_Build/compiled_resources
rm -rf  My_Build/compiled_resources/*
#FIM Limpa rm -rf  My_Build/compiled_resources



echo ""



if [ -d "folderApkGodot/" ]; then
rm -rf staging/assets/*
rm -rf staging/manifest/*
rm -rf staging/res/*
rm -rf staging/resources.pb
rm -rf folderApkGodot
fi

mkdir folderApkGodot


#Aqui poderia criar o assets em folderApkGodot

cp -rf folderApkGodot/assets/. staging/assets/

echo ""
echo "This staging/assets error is because it's the first time"
echo "that you run this script, don't worry"
echo ""
#Fim pasta assets GodotEngine
#Fim pasta assets GodotEngine

echo " "


#Deseja compilar tudo novamente
echo "If you have already run this script before you can choose"
echo "for not compiling everything again."
echo "If the only change you made to the project was"
echo "by Godot, so there's no need to compile it all over again."
echo "I will only need the apk generated in Godot."
echo ""
echo "Do you want to compile everything again? y or n"
echo ""
echo "RECOMPILE y or n"
read recompile
if [ $recompile == "y" ]; then
rm -rf  My_Build/build/*

#Deseja compilar tudo novamente

#Remover apks temorary and zips
rm -rf *.apk



#Outros Plugins Godot GEN R CLASS
if [ -d "My_Build/gen_plugin/" ]; then
cp -rf My_Build/gen_plugin/* My_Build/gen/
cp -rf My_Build/compiled_resources_plugins/* My_Build/compiled_resources/
fi
#FIM PLUGINS GODOT


#Criar staging
rm -rf staging
echo "creating staging/"
mkdir staging

echo "creating staging/assets/"
mkdir staging/assets

echo "creating staging/dex/"
mkdir staging/dex

echo "creating staging/lib/"
mkdir staging/lib

echo "creating staging/manifest/"
mkdir staging/manifest
#FIM criar staging

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

echo " "




#lib em staging para um projeto godot
echo "..."

#FIM Projeto godot lib staging

echo "..."
#Necessario copiar de novo o assets do projeto caso seja sim para recompile
#cp -rf folderApkGodot/assets/. staging/assets/

echo " "

echo "Notification Firebase"
#NOTIFICATION
#Google-services.json
aapt2 compile Notification/res/values/notification_value.xml -o  My_Build/compiled_resources/
#CloudMessaging firebase
aapt2 compile Admob_Android_Dependency/67/res/**/* -o  My_Build/compiled_resources/

aapt2 link --proto-format -o temporaryplugin.apk -I $androidpath/android.jar --manifest Admob_Android_Dependency/67/AndroidManifest.xml -R  My_Build/compiled_resources/*.flat --auto-add-overlay --java  My_Build/gen
#NOTIFICATION
echo "Notification Firebase final"

echo ""

#Vou precisar do path do projeto
projectpath=../$NameProject/build
#Necessário compilar platform-godot res antes do projeto principal
echo "Compile and Link Godot/res and Project/res"
echo "..."

#Tinha dado um problema com o nome duplicado de values
#por iso necessario mudar nome de values.xml
#Androidx/core 41 compiled res gerar R.java em  My_Build/gen/
cp -rf Android_Dependency/41/res/values/values.xml  Android_Dependency/41/res/values/projectG_values.xml  
rm -rf Android_Dependency/41/res/values/values.xml 
aapt2 compile Android_Dependency/41/res/**/* -o  My_Build/compiled_resources
cp -rf  Android_Dependency/41/res/values/projectG_values.xml  Android_Dependency/41/res/values/values.xml 
rm -rf Android_Dependency/41/res/values/projectG_values.xml 
#Androidx/core 41 compiled res gerar R.java em  My_Build/gen/



echo "Google Play core"
#Tinha dado um problema com o nome duplicado de values
cp -rf Admob_Android_Dependency/70/res/values/values.xml  Admob_Android_Dependency/70/res/values/projectC_values.xml  
rm -rf Admob_Android_Dependency/70/res/values/values.xml 
aapt2 compile Admob_Android_Dependency/70/res/**/* -o  My_Build/compiled_resources
cp -rf  Admob_Android_Dependency/70/res/values/projectC_values.xml  Admob_Android_Dependency/70/res/values/values.xml 
rm -rf Admob_Android_Dependency/70/res/values/projectC_values.xml 
echo ""
echo ""



#Testando tema para corrigir splash screen
#@style/Theme.AppCompat.Translucent
#rm -rf ../$NameProject/build/res/values/themes.xml
#cp -rf Theme/themes.xml  ../$NameProject/build/res/values/themes.xml
#cp -rf Theme/colors.xml  ../$NameProject/build/res/values/colors.xml
#Testando tema para corrigir splash screen



#Project
aapt2 compile $projectpath/res/**/* -o  My_Build/compiled_resources/


#Splash Screen
cp -rf Android_Dependency/45/res/values/values.xml  Android_Dependency/45/res/values/projectS_values.xml  
rm -rf Android_Dependency/45/res/values/values.xml 
aapt2 compile Android_Dependency/45/res/**/* -o  My_Build/compiled_resources
cp -rf  Android_Dependency/45/res/values/projectS_values.xml  Android_Dependency/45/res/values/values.xml 
rm -rf Android_Dependency/45/res/values/projectS_values.xml 
#Splash Screen




echo "Project"
#Aqui para gerar o  My_Build/gen do projeto
aapt2 link --proto-format -o temporary.apk -I $androidpath/android.jar --manifest $projectpath/AndroidManifest.xml -R  My_Build/compiled_resources/*.flat --auto-add-overlay --java  My_Build/gen


echo ""


echo "..."
echo "compile and Link dependencys"
echo "..."
#Aqui vamos compilar o res de alguns libs dependencias R.java
#para gerar o R.java delas necessários


#Splash Screen
aapt2 compile Android_Dependency/45/res/**/* -o  My_Build/compiled_resources_dependency
aapt2 link --proto-format -o notusage.apk -I $androidpath/android.jar --manifest Android_Dependency/45/AndroidManifest.xml -R  My_Build/compiled_resources_dependency/*.flat --auto-add-overlay --java  My_Build/gen
#Splash Screen
#Limpa  My_Build/compiled_resources_dependency
rm -rf  My_Build/compiled_resources_dependency/*

#Androidx/core 41 compiled res gerar R.java em  My_Build/gen/
aapt2 compile Android_Dependency/41/res/**/* -o  My_Build/compiled_resources_dependency
aapt2 link --proto-format -o notusage.apk -I $androidpath/android.jar --manifest Android_Dependency/41/AndroidManifest.xml -R  My_Build/compiled_resources_dependency/*.flat --auto-add-overlay --java  My_Build/gen
#Fim Androidx/core 
#Limpa  My_Build/compiled_resources_dependency
rm -rf  My_Build/compiled_resources_dependency/*


#Androidx/appcompat resources 8 compiled res gerar R.java em  My_Build/gen/
aapt2 compile Android_Dependency/8/res/**/* -o  My_Build/compiled_resources_dependency
aapt2 link --proto-format -o notusage.apk -I $androidpath/android.jar --manifest Android_Dependency/8/AndroidManifest.xml -R  My_Build/compiled_resources_dependency/*.flat --auto-add-overlay --java  My_Build/gen
#Fim Androidx/appcompat resources
#Limpa  My_Build/compiled_resources_dependency
rm -rf  My_Build/compiled_resources_dependency/*


#Androidx/Fragment 40 compiled res gerar R.java  My_Build/gen/
aapt2 compile Android_Dependency/40/res/**/* -o  My_Build/compiled_resources_dependency
aapt2 link --proto-format -o notusage.apk -I $androidpath/android.jar --manifest Android_Dependency/40/AndroidManifest.xml -R  My_Build/compiled_resources_dependency/*.flat --auto-add-overlay --java  My_Build/gen
#Fim Androidx/Fragment
#Limpa  My_Build/compiled_resources_dependency
rm -rf  My_Build/compiled_resources_dependency/*


#Androidx/lifecycle-runtime 37 compiled res R.java  My_Build/gen/
aapt2 compile Android_Dependency/37/res/**/* -o  My_Build/compiled_resources_dependency
aapt2 link --proto-format -o notusage.apk -I $androidpath/android.jar --manifest Android_Dependency/37/AndroidManifest.xml -R  My_Build/compiled_resources_dependency/*.flat --auto-add-overlay --java  My_Build/gen
#Fim Androidx/lifecycle-runtime
#Limpa  My_Build/compiled_resources_dependency
rm -rf  My_Build/compiled_resources_dependency/*


#Androidx/lifecycle-viewmodel 36 compiled res R.java  My_Build/gen/
aapt2 compile Android_Dependency/36/res/**/* -o  My_Build/compiled_resources_dependency
aapt2 link --proto-format -o notusage.apk -I $androidpath/android.jar --manifest Android_Dependency/36/AndroidManifest.xml -R  My_Build/compiled_resources_dependency/*.flat --auto-add-overlay --java  My_Build/gen
#Fim Androidx/lifecycle-viewmodel
#Limpa  My_Build/compiled_resources_dependency
rm -rf  My_Build/compiled_resources_dependency/*


#Androidx/savedstate 31 compiled res R.java  My_Build/gen/
aapt2 compile Android_Dependency/31/res/**/* -o  My_Build/compiled_resources_dependency
aapt2 link --proto-format -o notusage.apk -I $androidpath/android.jar --manifest Android_Dependency/31/AndroidManifest.xml -R  My_Build/compiled_resources_dependency/*.flat --auto-add-overlay --java  My_Build/gen
#Fim Androidx/savedstate
#Limpa  My_Build/compiled_resources_dependency
rm -rf  My_Build/compiled_resources_dependency/*



#Google Play Core APP Rating
aapt2 compile Admob_Android_Dependency/70/res/**/* -o  My_Build/compiled_resources_dependency
aapt2 link --proto-format -o notusage.apk -I $androidpath/android.jar --manifest Admob_Android_Dependency/70/AndroidManifest.xml -R  My_Build/compiled_resources_dependency/*.flat --auto-add-overlay --java  My_Build/gen
#Fim 53 Play-services-base
#Limpa  My_Build/compiled_resources_dependency
rm -rf  My_Build/compiled_resources_dependency/*
#Google Play Core APP Rating

#Precisa tanto pro Android_dependency
#como para Admob_dependency
classesjar='classes.jar'

#ADMOB ADMOB ADMOB

#Limpa, caso não for usado também garante que existe 
#fora do if abaixo
javac_classpath_Admob=""
d8_sourcepath_Admob=""





echo ""
#echo "You should run AddAdmobPlugin.sh first, do you already run it? y"
#echo "just once ok"
#read addAdmobSh

echo ""
echo "..."
echo "..."
aapt2 compile Admob_Android_Dependency/45/res/**/* -o  My_Build/compiled_resources_dependency
aapt2 link --proto-format -o notusage.apk -I $androidpath/android.jar --manifest Admob_Android_Dependency/45/AndroidManifest.xml -R  My_Build/compiled_resources_dependency/*.flat --auto-add-overlay --java  My_Build/gen
#Fim 53 Play-services-base
#Limpa  My_Build/compiled_resources_dependency
rm -rf  My_Build/compiled_resources_dependency/*

aapt2 compile Admob_Android_Dependency/47/res/**/* -o  My_Build/compiled_resources_dependency
aapt2 link --proto-format -o notusage.apk -I $androidpath/android.jar --manifest Admob_Android_Dependency/47/AndroidManifest.xml -R  My_Build/compiled_resources_dependency/*.flat --auto-add-overlay --java  My_Build/gen
#Fim 53 Play-services-base
#Limpa  My_Build/compiled_resources_dependency
rm -rf  My_Build/compiled_resources_dependency/*

aapt2 compile Admob_Android_Dependency/53/res/**/* -o  My_Build/compiled_resources_dependency
aapt2 link --proto-format -o notusage.apk -I $androidpath/android.jar --manifest Admob_Android_Dependency/53/AndroidManifest.xml -R  My_Build/compiled_resources_dependency/*.flat --auto-add-overlay --java  My_Build/gen
#Fim 53 Play-services-base
#Limpa  My_Build/compiled_resources_dependency
rm -rf  My_Build/compiled_resources_dependency/*



#AndroidManifest ADMOB funcionando

#FIM ADMOB ADMOB ADMOB



#Compile ADSAdmob_Android_Dependency
#d8
cd Admob_Android_Dependency
d8_sourcepath_Admob=''
for file in *; 
do
Admobclasspath=Admob_Android_Dependency/$file/$classesjar
#Usar javac
javac_classpath_Admob+=':'$Admobclasspath
#Usar no d8
d8_sourcepath_Admob+=' '$Admobclasspath
done
cd ..
#Admob_Android_Dependency
#convert Admob Class em dex

echo "..."
#Agora vamos usar javac para gerar os .class
#Usando dependency aqui para pegar todas as pastas
#que estão em denpendency
#Isso permite que possa adicionar dependeny sem precisar
#Mecher neste código

#Recupera a lista de pastas de Android_Dependency
#Para montar o classpath javac e source path d8
cd Android_Dependency

echo ""
#Necessario fazer uma limpa nas varias que recebem +=
javac_classpath=''
d8_sourcepath=''
#inicio FOR
#Montar javac_classpath and d8_sourcepath
#Com as dependencias
#Tudo que ta em Android_Dependency entra aqui
#Por isso que AddDependency.sh funciona
echo "Unzip .jar to class"
#Javac
for file in *; 
do

classpath=Android_Dependency/$file/$classesjar

#Usar no javac
javac_classpath+=':'$classpath

d8_sourcepath+=' '$classpath

done


#Fim FOR
cd ..
#Fim Android_dependency
#Fim montar o classpath javac e source path d8



echo "..."




echo "..."


#Converter .java em .class usando javac
#Para o Godot Engine Project
echo "..."
echo "Compiling .java into .class"
echo "..."

#Recupera a lista de R.java no  My_Build/gen
Rjava=$(find  My_Build/gen -name "*.java")
#FIM R.java path


#Recupera ao GodotApp.java
Sjava=$(find  ../$NameProject/build/src -name "*.java")
#FIM recupera path java



javac -d  My_Build/build -cp $androidpath/android.jar:$javac_classpath:$javac_classpath_Admob $Rjava $Sjava BuildConfig/*.java

echo "..."
echo "..."
#FIM Converter .java em .class usando javac


echo "..."
#Converter .class em classes.dex
realAndroidpath=$(echo ${androidpath%/platforms*})

#Qual versão do Build Tools vai usar
#NEcessário ser acima de 30
echo ""
echo "What version of Android Sdk build tools?"
echo "It should be in ANDROID_HOME/build-tools/"
echo "Ex.: 30.0.3"
read versionBuildTools
echo " "
echo " "


echo "Convert .class to .dex"
echo "This may take a while."
echo "Some warnings may appear, nothing that prevents your game from working."
echo "..."





mkdir  My_Build/build/intermediate
mkdir  My_Build/build/intermediate/dex
#Preciso compilar tudo .class que está em  My_Build/build gerado pelo javac
#Pegar caminhos do arquivos.class de  My_Build/build que javac populou
#MyClass=$( find  My_Build/build/androidx/ -name "*.class" )
echo "..."
MyClass=$( find  My_Build/build/ -name "*.class" )
#FIM .class usa d8 $MyClass,
echo "..."
#min-api d8 min_api.txt
minAPI=$(cat AndroidManifest/min_api.txt)

$realAndroidpath/build-tools/$versionBuildTools/d8 --min-api $minAPI $debugORrelase --lib $androidpath/android.jar $d8_sourcepath $d8_sourcepath_Admob $MyClass --intermediate --file-per-class --output  My_Build/build/intermediate/dex
echo "..."

echo "generate classes.txt"
echo "..."

#Unzip Android_Dependency

cd Android_Dependency
for file in *; 
do

unzip -n -q $file/$classesjar -d ../My_Build/build

done
cd ..

#AdMob classes para a classes.dex principal
unzip -n -q Admob_Android_Dependency/45/$classesjar -d My_Build/build
unzip -n -q Admob_Android_Dependency/47/$classesjar -d My_Build/build
unzip -n -q Admob_Android_Dependency/53/$classesjar -d My_Build/build
#AdMob classes para a classes.dex principal


#Fim unzip Android_Dependency and godot

echo "..."
echo "Generate classes.txt, OK!"
echo "..."
#Gerar classes.txt
#Para ser usado no d8 --main-dex-list
#pega a lista de classes em seus diretorios
MyIntermediateClass=$( find  My_Build/build/ -name "*.class" )

>  My_Build/build/tmpclasses.txt
>  My_Build/build/tmp2classes.txt

#salva o texto em tmpclasses.txt
echo $MyIntermediateClass >>  My_Build/build/tmpclasses.txt

#troca espaços por linha
tr ' ' '\n' <  My_Build/build/tmpclasses.txt >  My_Build/build/tmp2classes.txt

#Tira a referencia a pasta  My_Build/build/
sed "s/My_Build\/build\///g"  My_Build/build/tmp2classes.txt >  My_Build/build/classes.txt

#remove os temporarios usados
rm  My_Build/build/tmpclasses.txt
rm  My_Build/build/tmp2classes.txt
#FIM gera classe.txt
#Tudo certo ate aqui<<<<<<



echo ""
#Pega os .dex gerados anteriormente
#e passa pro d8, mas com o main-dex-list definindo as classes
#que vão para o dex principal classes.dex
MyClass=$( find  My_Build/build/intermediate/dex/ -name "*.dex" )
echo "Generate classes.dex and classes2.dex and classes*.dex"
echo "..."
$realAndroidpath/build-tools/$versionBuildTools/d8 $MyClass $debugORrelase --main-dex-list  My_Build/build/classes.txt --output staging/dex
echo "..."
#FIM Converter .class em classes.dex




fi
#Não recompila
#Agora vamos ajeitar tudo em staging 
#limpa  My_Build/AAB e  My_Build/APKs
rm -rf  My_Build/AAB/*
rm -rf  My_Build/APKs/*
#Para em seguida gerar o base.zip
#Depois o  My_Build/AAB
#Depois o  My_Build/APKs
#que será unzip em universal.apk para testes
echo "..."
echo "Build AAB"
echo "..."
echo ""
unzip temporary.apk -d staging


cd staging

mv AndroidManifest.xml manifest
#Agora gerar base.zip
zip -r ../base.zip *

#Gerar aab
cd ..
java -jar *.jar build-bundle --modules=base.zip --output=My_Build/AAB/bundle.aab


#Gerar  My_Build/APKs
def_signature=""
echo "..."
echo "Build apk"
echo "..."
echo ""
echo "Want to sign your APK with a release signature? y or n"
read signature
if [ $signature == "y" ]; then
echo ""
echo "Tell me the location of name.keystore"
echo "Ex.: /home/username/.android/name.keystore"
read keystore
echo ""
echo "Now I need your alias"
read my_alias
echo ""

def_signature="--ks=$keystore --ks-key-alias=$my_alias"

fi
echo ""
Myaapt2=$(which aapt2)
java -jar *.jar build-apks --bundle=My_Build/AAB/bundle.aab --output=My_Build/APKs/bundle.apks --aapt2 $Myaapt2 --mode=universal $def_signature

#unzip bundle.apks
cd  My_Build/APKs
unzip bundle.apks
cd ..
cd ..

echo ""
echo "We sign your APK, AAB and at your own expense"
echo ""
echo "Remember to sign your  My_Build/AAB/bundle.aab before uploading to google play"
echo ""
echo "Here's a summary of the required signing:"
echo "App Bundle (.aab)"
echo "Signing needed (with jarsigner) before uploading to the Play Store."
echo "No signing needed during development or testing."
echo "EX.:"
echo ""
echo "jarsigner  -keystore  /home/username/.android/name.keystore  My_Build/AAB/bundle.aab  alias"
echo ""


echo "EXIT"



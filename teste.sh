
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
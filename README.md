# Build_Android

Install Android easily on a 64bit system, but if your system is 32bit follow this tutorial from my other project:
[tutorial](https://github.com/MiqueiasDevGames/export-godot-to-android-without-gradle-32bits-and-64bits)


##Android default design:

Now you need this project in a folder like: Projects-Android/
and inside this folder you also put other folders of your projects, like this: Projects-Android/helloworld/build/


Here, inside build, you can start with the basics for an android project which is:

A folder res/
A src/ folder
And your AndroidManifest.xml  ->  Remember to put in your manifest all the activities that your project uses.


Inside the res/ folder you create the values/ folder
where you will put your xmls of colors, strings and etc


In the src/ folder you put your .java files

Still in values you will also need the layout/ folder where you will put your activity_main.xml


##Generating apk and aab

With your android project ready you first run:
mkdirFolders.sh


To enable firebase notifications in your project you should throw google-services.json into build as you normally would.
Also in AndroidManifest/Part_Manifest you can edit parts of android manifest used to assemble your final android manifest
Here you will need to provide the name of the folder where your android project is and also the actual name of your project.
Then, to create the android manifest:
CreateAndroidManifest.sh


Here remember to manually add in your manifest all the activities present in your project
And finally: Build_aab.sh


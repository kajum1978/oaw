#!/bin/bash

#directorio base de la instalación
baseDir="/usr/local/share/oaw"

if [ -z "$1" ] || [ $# -ne 1 ] || [ "$1" != "es" -a "$1" != "en" ]; then
	echo "Use: $0 (languaje)"
	echo "$0 es"
	echo "or"
	echo "$0 en"
	exit -1
fi

#si no están las variables de entorno las establecemos
if [ $(echo $PATH | grep -i -c apache-maven-3.6.3) -eq 0 ]; then
		export PATH=$baseDir/apache-maven-3.6.3/bin:$PATH
fi

if [ $(echo $PATH | grep -i -c jdk1.8.0_202) -eq 0 ]; then
	export JAVA_HOME=$baseDir/jdk1.8.0_202
	export PATH=$PATH:$JAVA_HOME/bin
fi

#sólo puede ser "en" or "es"
lang="$1"

if [ "$lang" == "es" ]; then
	echo "El siguiente script compila la aplicación y copia el fichero 'oaw.war' generado al directorio webapps del tomcat"
	echo "Si existe el fichero 'owa.war' en este direcorio será borrado."
	echo -n "¿Quiere continuar [y/n]? "
elif [ "$lang" == "en" ]; then
	echo "The next script compile the application and copy the file 'owa.war' generated into the tomcat's webapps directory."
	echo "If the file 'owa.war' exists in this directory, it will be deleted."
	echo -n "Do you want to continue [y/n]? "

fi
read continuar
while [ "$continuar" != "y" ] && [ "$continuar" != "n" ]; do 
	if [ "$lang" == "es" ]; then
		echo -n "¿Quiere continuar [y/n]? "
	elif [ "$lang" == "en" ]; then
		echo -n "Do you want to continue [y/n]? "
	fi
	read continuar
done

#si no queremos continuar nos salimos
if [ "$continuar" == "n" ]; then
	exit 0
fi 

if [ "$lang" == "es" ]; then
	echo "Compilando aplicación..."
elif [ "$lang" == "en" ]; then
	echo "Build application...."
fi

#Si no existe el fichero es que es la primera ejecución y nos creamos una copia
if [ ! -e "${baseDir}/oaw/oaw/pom.xml_backup" ]; then
	mv "${baseDir}/oaw/oaw/pom.xml" "${baseDir}/oaw/oaw/pom.xml_backup"
fi

#sobreescribimos el fichero de compilación de maven
#uno de ellos
cp "$baseDir/xmlMofidicados/pom.xml" "${baseDir}/oaw/oaw"


#Nos hacemos una copia si es la primera ejecución
#este fichero tiene unos comentarios que afectan a la compilación y da un error
#se quitan solo los comentarios
#jacin comprobar que esto es cierto
if [ ! -e "${baseDir}/oaw/portal/tiles/tiles-defs.xml_backup" ]; then
	mv "${baseDir}/oaw/portal/tiles/tiles-defs.xml" "${baseDir}/oaw/portal/tiles/tiles-defs.xml_backup"
fi
cp "${baseDir}/xmlMofidicados/tiles-defs.xml" "${baseDir}/oaw/portal/tiles/tiles-defs.xml"



#fichero en el que el deply.path no funciona
if [ ! -e "$baseDir/oaw/portal/src/main/resources/tiles-defs.xml_backup" ]; then
	cp "$baseDir/oaw//portal/src/main/resources/tiles-defs.xml" "$baseDir/oaw/portal/src/main/resources/tiles-defs.xml_backup"
fi
#sobreescribo el fichero
sed -e s#\$\{deploy.path\}#/$baseDir/apache-tomcat-7.0.107/webapps/oaw#g "$baseDir/oaw//portal/src/main/resources/tiles-defs.xml_backup" > "$baseDir/oaw//portal/src/main/resources/tiles-defs.xml"

#creamos /sobreescribimos en cada ejecución el profile customMaven dentro del proyecto
#todo lo que tengamos en ${baseDir}customMaven será lo usado para compilar con maven
rm -r -f "${baseDir}/oaw/portal/profiles/customMaven" >/dev/null
cp -R "${baseDir}/customMaven" "${baseDir}/oaw/portal/profiles"

#nos movemos a la ruta adecuada para compilar el pom
cd "${baseDir}/oaw/oaw"
mvn clean install -P customMaven -DskipTests #-e -rf :portal
if [ $? -ne 0 ]; then
	echo "Maven error"
	exit -1
fi 

#Copiamos el war al tomcat
rm -r -f "${baseDir}/apache-tomcat-7.0.107/webapps/oaw" >/dev/null
rm -r -f "${baseDir}/apache-tomcat-7.0.107/webapps/oaw.war" >/dev/null

cp "${baseDir}/oaw/portal/target/oaw.war" "${baseDir}/apache-tomcat-7.0.107/webapps"

if [ "$lang" == "es" ]; then
	echo "Hecho"
elif [ "$lang" == "en" ]; then
	echo "Done"
fi

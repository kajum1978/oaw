#!/bin/bash

#Versiones:
#1.0: 
#	  -Coge los fuentes de github
#	  -Crea las imágenes de docker desde unos ficheros .tar

#1.1: 
#     -Se tiene una imagen estática de los ficheros fuentes, en este repositorio.
#	  -Las imágenes de docker se crean directamente con docker-compose

#imprime una pantalla de ayuda, al ejecutar incorrectamente el comando
function ayuda(){
	echo "Use: $0 (languaje) [ [resume (step number)] | [execute (step number)] ]"
	echo "examples:"
	echo "$0 es"
	echo "$0 es resume 3"
	echo "$0 es execute 3"
	echo "or"
	echo "$0 en"
	echo "$0 en resume 3"
	echo "$0 en execute 3"
	exit -1
}


#Definición de los mensajes en su correspondiente idioma
function setLanguaje(){
	if [ "$lang" == "es" ]; then
		msgError0_1="Error paso 0 1/2: Directorio de instalación ya existe $base_dir"
		msgError0_2="Error paso 0 2/2: No puedo crear el directorio $baseDir. Se necesitan permisos de superusuario"
		msgError1_1="Error paso 1: Distribución linux no soportada. Solo debian o redhat."
		msgError2_1="Error paso 2: Fallo al instalar el paquete alien."
		msgError3_1="Error paso 3 1/2: Fallo al instalar librería libdevmapper1.02.1"
		msgError3_2="Error paso 3 2/2: Fallo al crear enlace simbólico a librería libdevmapper1.02.1"
		msgError4_1="Error paso 4: No se puede copiar los fuentes oaw al directorio de instalación ${baseDir}."
		msgError5_1="Error paso 5 1/3: Fallo al instalar paquete docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm"
		msgError5_2="Error paso 5 2/3: Fallo al instalar paquete docker-ce-17.03.2.ce-1.el7.centos.x86_64.rpm."
		msgError5_3="Error paso 5 3/3: Fallo al arrancar docker o habilitar el servicio docker para su ejecución al inicio."
		msgError6_1="Error paso 6: Versión de docker incorrecta. Debe ser 17.03.2-ce."
		msgError7_1="Error paso 7: Fallo al instalar docker-compose."
		msgError8_1="Error paso 8: Versión de docker-compose incorrecta. Debe ser 1.23.2."
		msgError10_1="Error paso 10: Fallo al modificar el fichero ${baseDir}/oaw/motor-js/nginx/reverse.conf"
		msgError11_1="Error paso 11: Fallo al ejecutar el comando: docker-compose up -d"
		msgError12_1="Error paso 12: Fallo al instalar mariadb-server"
		msgError13_1="Error paso 13: Error al crear el usuario administrador en mariadb-server"
		msgError14_1="Error paso 14: Error al crear la estructura de la base de datos en la bd OAW."
		msgError15_1="Error paso 15: Fallo al establecer usuario administrador aplicación OAW."
		msgError16_1="Error paso 16 1/2: Fallo al descomprimir jdk-8u202-linux-x64.tar.gz a $baseDir"
		msgError16_2="Error paso 16 2/2: Fallo al establecer variables de entorno de Java."
		msgError17_1="Error paso 17 1/4: Fallo al descomprimir apache-tomcat-7.0.107.tar.gz a $baseDir"
		msgError17_2="Error paso 17 2/4: Fallo al establecer variables de entorno de Apache Tomcat"
		msgError17_3="Error paso 17 3/4: Fallo al establecer el profile oaw.xml de Apache Tomcat en $baseDir/apache-tomcat-7.0.107/conf/Catalina/localhost"
		msgError17_4="Error paso 17 4/4: Fallo al copiar librería necesaria mysql-connector-java-8.0.23.jar"
		msgError18_1="Error paso 18 1/2: Fallo al descomprimir apache-maven-3.6.3-bin.tar.gz a $baseDir"
		msgError18_2="Error paso 18 2/2: Fallo al establecer variables de entorno de maven."
		msgError19_1="Error paso 19 1/6: Fallo al copiar el profile de maven a $baseDir"
		msgError19_2="Error paso 19 2/6: Fallo al instalar el fichero build_oaw.sh en $binaryDir"
		msgError19_3="Error paso 19 3/6: Fallo al copiar los fichero xml modificados a $baseDir/xmlMofidicados"
		msgError19_4="Error paso 19 4/6: Fallo al cambiar el fichero context.xml del perfil de maven $baseDir/customMaven"
		msgError19_5="Error paso 19 5/6: Fallo al instalar el fichero start_oaw.sh en $binaryDir"
		msgError19_6="Error paso 19 6/6: Fallo al instalar el fichero stop_oaw.sh en $binaryDir"


		msgInfo0_1="Paso 0: Creación del directorio de instalación $baseDir"
		msgInfo1_1="Paso 1: Gestor de paquetes detectado: " 
		msgInfo2_1="Paso 2: Instalando paquete alien." 
		msgInfo3_1="Paso 3: Instalando librería libdevmapper1.02.1"
		msgInfo4_1="Paso 4: Copiando ficheros fuentes de oaw al directorio de instalación."
		msgInfo5_1="Paso 5 1/3: Instalando docker. Parte 1"
		msgInfo5_2="Paso 5 2/3: Instalando docker. Parte 2"
		msgInfo5_3="Paso 5 3/3: Activando servicio docker."
		msgInfo6_1="Paso 6: Comprobando versión de docker."
		msgInfo7_1="Paso 7: Instalando fichero docker-compose."
		msgInfo8_1="Paso 8: Comprobando versión de docker-compose."
		msgInfo9_1="Paso 9: Congelando paquetes de docker."
		msgInfo10_1="Paso 10: En el fichero ${baseDir}/oaw/motor-js/nginx/reverse.conf se establecerá la siguiente ip como dns exterior:"
		msgInfo11_1="Paso 11: Ejecutando: docker-compose up -d"
		msgInfo12_1="Paso 12: Instalando mariadb-server equivalente a mysql:"
		msgInfo13_1="Paso 13: Creación de usuario administrador mariadb-server:"
		msgInfo14_1="Paso 14: Creando la estructura en la base de datos OAW."
		msgInfo15_1="Paso 15: Creación de usuario administrador aplicación OAW."
		msgInfo15_2="Usuario administrador: "
		msgInfo15_3="Password administrador: "
		msgInfo15_4="Nombre: "
		msgInfo15_5="Apellidos: "
		msgInfo15_6="Departamento: "
		msgInfo15_7="Email: "
		msgInfo15_8="Actualizando la bd con el nuevo administrador de la aplicación"
		msgInfo16_1="Paso 16 1/2: Instalación de java 1.8.202"
		msgInfo16_2="Paso 16 2/2: Estableciendo variables de entorno de Java en $envFile"
		msgInfo17_1="Paso 17 1/4: Instalación de apache tomcat 1.7.0.107"
		msgInfo17_2="Paso 17 2/4: Estableciendo variables de entorno de Apache Tomcat en $envFile"
		msgInfo17_3="Paso 17 3/4: Estableciendo profile oaw.xml de Apache Tomcat en $baseDir/apache-tomcat-7.0.107/conf/Catalina/localhost"
		msgInfo17_4="Paso 17 4/4: Instalando librería necesaria para Apache Tomcat mysql-connector-java-8.0.23.jar"
		msgInfo18_1="Paso 18 1/2: Instalando apache-maven 3.6.3"
		msgInfo18_2="Paso 18 2/2: Estableciendo variables de entorno de maven en $envFile"
		msgInfo19_1="Paso 19: Preparando estructura para compilar el proyecto oaw y instalar ejecutables necesarios."
		
		msgInfoFin_1="Fin de la instalación. Pasos siguientes:"
		msgInfoFin_2="1. Revisar el directorio $baseDir/customMaven. Modificar a conveniencia según la documentación."
		msgInfoFin_3="2. Ejecutar: sudo build_oaw.sh es"
		msgInfoFin_4="   -Se creara el fichero oaw.war y se establecera en su correspondiente directorio del tomcat."
		msgInfoFin_5="   -Se puede ejecutar cuantas veces se necesite build_oaw.sh"
		msgInfoFin_6="3. IMPORTANTE: Tomcat no arranca por defecto. Arrancar con: sudo start_oaw.sh"
		msgInfoFin_7="            Para parar Tomcat: sudo stop_oaw.sh"
		msgInfoFin_8="4. Finalmente lanzar la aplicación en el navegador con http://localhost:8080/oaw"

		msgInfo_askForUserPasswordDb_1="Se debe utilizar otro nombre de usuario distinto de root."

		msgQuestion1="¿ip Dns exterior?, si no sabes establece una de google 8.8.8.8: "
		msgQuestion2="Son los datos correctos [y/n]: "
		msgQuestion3="¿nombre de administrador para mariadb-server? "
		msgQuestion4="¿password administrador para mariadb-server? "
		msgQuestion5="¿quieres instalar la estructura de la base de datos de la aplicación en español o en inglés [es/en]? "
		
	elif [ "$lang" == "en" ]; then
		msgError0_1="Error step 0 1/2: Installation directory already exists $base_dir"
		msgError0_2="Error step 0 2/2: I can't create the directory $baseDir. Superuser permissions are required."
		msgError1_1="Error step 1: Linux distribution not supported. Only debian or redhat."
		msgError2_1="Error step 2: Failed to install alien package."
		msgError3_1="Error step 3 1/2: Failed to install libdevmapper1.02.1 library."
		msgError3_2="Error step 3 2/2: Failed to create symbolic link to libdevmapper1.02.1 library."
		msgError4_1="Error step 4: Unable to copy oaw sources to installation directory ${baseDir}."
		msgError5_1="Error step 5 1/3: Failed to install package docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm"
		msgError5_2="Error step 5 2/3: Failed to install package docker-ce-17.03.2.ce-1.el7.centos.x86_64.rpm."
		msgError5_3="Error step 5 3/3: Failure to start docker or enable docker service to run at startup."
		msgError6_1="Error step 6: Wrong docker version. Must be 17.03.2-ce."
		msgError7_1="Error step 7: Failed to install docker-compose."
		msgError8_1="Error step 8: Wrong docker-compose version. Must be 1.23.2."
		msgError10_1="Error step 10: Failed to modify the file ${baseDir}/oaw/motor-js/nginx/reverse.conf"
		msgError11_1="Error step 11: Failed to execute command: docker-compose up -d"
		msgError12_1="Error step 12: Failed to install mariadb-server"
		msgError13_1="Error step 13: Error creating administrator user in mariadb-server"
		msgError14_1="Error step 14: Error creating database structure in OAW db."
		msgError15_1="Error step 15: Failed to set OAW application administrator user."
		msgError16_1="Error step 16 1/2: Failed to unzip jdk-8u202-linux-x64.tar.gz to $baseDir"
		msgError16_2="Error step 16 2/2: Failed to set Java environment variables."
		msgError17_1="Error step 17 1/4: Failed to unzip apache-tomcat-7.0.107.tar.gz to $baseDir"
		msgError17_2="Error step 17 2/4: Failed to set Apache Tomcat environment variables"
		msgError17_3="Error step 17 3/4: Failed to set Apache Tomcat profile oaw.xml to $baseDir/apache-tomcat-7.0.107/conf/Catalina/localhost"
		msgError17_4="Error step 17 4/4: Failed to copy required library mysql-connector-java-8.0.23.jar"
		msgError18_1="Error step 18 1/2: Failed to unzip apache-maven-3.6.3-bin.tar.gz to $baseDir"
		msgError18_2="Error step 18 2/2: Failed to set maven environment variables."
		msgError19_1="Error step 19 1/6: Failed to copy profile from maven to $baseDir"
		msgError19_2="Error step 19 2/6: Failed to install build_oaw.sh file in $binaryDir"
		msgError19_3="Error step 19 3/6: Failed to copy modified xml files to $baseDir/xmlMofidicados"
		msgError19_4="Error paso 19 4/6: Failed to change the context.xml file of the maven profile $baseDir/customMaven"
		msgError19_5="Error step 19 5/6: Failed to install start_oaw.sh file in $binaryDir"
		msgError19_6="Error step 19 6/6: Failed to install stop_oaw.sh file in $binaryDir"


		msgInfo0_1="Step 0: Creating the installation directory $baseDir"
		msgInfo1_1="Step 1: Package manager detected: " 
		msgInfo2_1="Step 2: Installing alien package." 
		msgInfo3_1="Step 3: Installing libdevmapper1.02.1 library"
		msgInfo4_1="Step 4: Copying source files from oaw to the installation directory."
		msgInfo5_1="Step 5 1/3: Installing docker. Part 1"
		msgInfo5_2="Step 5 2/3: Installing docker. Part 2"
		msgInfo5_3="Step 5 3/3: Activating docker service."
		msgInfo6_1="Step 6: Checking version of docker."
		msgInfo7_1="Step 7: Installing docker-compose."
		msgInfo8_1="Step 8: Checking version of docker-compose."
		msgInfo9_1="Step 9: Freezing docker packages."
		msgInfo10_1="Step 10: In the file ${baseDir}/oaw/motor-js/nginx/reverse.conf the following ip will be set as external dns:"
		msgInfo11_1="Step 11: Running: docker-compose up -d"
		msgInfo12_1="Step 12: Installing mariadb-server equivalent to mysql:"
		msgInfo13_1="Step 13: Creation of administrator user mariadb-server:"
		msgInfo14_1="Step 14: Creating the structure in the OAW database."
		msgInfo15_1="Step 15: OAW application administrator user creation."
		msgInfo15_2="Administrator user: "
		msgInfo15_3="Administrator password: "
		msgInfo15_4="Name: "
		msgInfo15_5="Surnames: "
		msgInfo15_6="Department: "
		msgInfo15_7="Email: "
		msgInfo15_8="Updating the database with the new application manager (Administrator user/password)"
		msgInfo16_1="Step 16 1/2: Java 1.8.202 installation"
		msgInfo16_2="Step 16 2/2: Setting Java environment variables to $envFile"
		msgInfo17_1="Step 17 1/4: Apache tomcat 1.7.0.107 installation"
		msgInfo17_2="Step 17 2/4: Setting Apache Tomcat environment variables to $envFile"
		msgInfo17_3="Step 17 3/4: Setting Apache Tomcat's profile oaw.xml to $baseDir/apache-tomcat-7.0.107/conf/Catalina/localhost"
		msgInfo17_4="Step 17 4/4: Installing required library for Apache Tomcat mysql-connector-java-8.0.23.jar"
		msgInfo18_1="Step 18 1/2: Installing apache-maven 3.6.3"
		msgInfo18_2="Step 18 2/2: Setting maven environment variables to $envFile"
		msgInfo19_1="Step 19: Preparing structure to compile the oaw project and install necessary executables."
		
		msgInfoFin_1="End of installation. Next steps:"
		msgInfoFin_2="1. Review the directory $baseDir/customMaven. Modify at convenience according to the documentation."
		msgInfoFin_3="2. Run: sudo build_oaw.sh en"
		msgInfoFin_4="   -The oaw.war file will be created and established in its corresponding tomcat directory."
		msgInfoFin_5="   -It can be run as many times as needed build_oaw.sh"
		msgInfoFin_6="3. IMPORTANT: Tomcat does not start by default. Start with: sudo start_oaw.sh"
		msgInfoFin_7="            To stop Tomcat: sudo stop_oaw.sh"
		msgInfoFin_8="4. Finally launch the application in the browser with http://localhost:8080/oaw"

		msgInfo_askForUserPasswordDb_1="A username other than root must be used."

		msgQuestion1="IP Dns exterior ?, if you do not know, set one of google 8.8.8.8: "
		msgQuestion2="Is data correct? [y/n]: "
		msgQuestion3="Administrator user for mariadb-server? "
		msgQuestion4="Administrator user for mariadb-server? "
		msgQuestion5="do you want to install application database structure in Spanish or English [es/en]? "
	fi
}

#Para hacer los mensajes más visibles.
function infoCabecera(){
	echo "*****************************************************************************"
	echo "$1"
	echo "*****************************************************************************"
	echo
}

#sacamos esta parte fuera, porque la vamos a necesitar para ejecutar pasos por fuera
function askForUserPasswordDb(){
	datosCorrectos=""
	while [ "$datosCorrectos" != 'y' ]; do
		newAdminDb=""
		passwordDb=""
		while [ -z "$newAdminDb" ] || [ "$newAdminDb" == "root" ];do 
			echo -n "$msgQuestion3"; read newAdminDb
			#no queremos que se use el usuario root
			if [ "$newAdminDb" == "root" ]; then
				echo "$msgInfo_askForUserPasswordDb_1"
				newAdminDb=""
			fi 
		done
		
		while [ -z "$passwordDb" ];do 
			echo -n "$msgQuestion4"; read passwordDb
		done
		echo
		echo "$newAdminDb"
		echo "$passwordDb"
		datosCorrectos=""
		while [ "$datosCorrectos" != 'n' ] && [ "$datosCorrectos" != 'y' ]; do
			echo -n "$msgQuestion2" ; read datosCorrectos
		done
	done
}

function askForApplicationLanguaje(){
	applicationVersion=""
	while [ "$applicationVersion" != "es" ] && [ "$applicationVersion" != "en" ]; do
		echo -n "$msgQuestion5" ; read applicationVersion
	done
}

function setPathBinMaven(){
	if [ $(echo $PATH | grep -i -c apache-maven-3.6.3) -eq 0 ]; then
		export PATH=$baseDir/apache-maven-3.6.3/bin:$PATH
	fi
}

#creación del directorio de instalacion
function step0(){
	infoCabecera "$msgInfo0_1"
	if [ -e "$baseDir" ]; then
		echo "$msgError0_1"
		exit -1 
	fi 
	mkdir "$baseDir"
	if [ $? -ne 0 ]; then
		echo "$msgError0_2"
		exit -1
	fi
}

#vamos a averiguar que gestor de paquete usamos, lo ejecutamos siempre que nos pidan otro paso
function step1(){
	quiet="$1"
	declare -A osInfo;
	osInfo[/etc/redhat-release]="yum"
	osInfo[/etc/arch-release]="pacman"
	osInfo[/etc/gentoo-release]="emerge"
	osInfo[/etc/SuSE-release]="zypp"
	osInfo[/etc/debian_version]="apt-get"

	gestorPaquetes=""
	for f in ${!osInfo[@]}
	do
		if [[ -f $f ]];then
			gestorPaquetes="${osInfo[$f]}"
		fi
	done


	if [ "$gestorPaquetes" == "apt-get" ] || [ "$gestorPaquetes" == "yum" ]; then
		if [ "$quiet" != "True" ]; then
			infoCabecera "$msgInfo1_1 $gestorPaquetes"
		fi
	else
		echo "$msgError1_1"
		exit -1
	fi 
}

#install of alien
function step2(){
	if [ "$gestorPaquetes" == "apt-get" ]; then
		infoCabecera "$msgInfo2_1"
		$gestorPaquetes install -y alien
		if [ $? -ne 0 ]; then
			echo "$msgError2_1"
			exit -1
		fi
	fi
}

#dependencia para docker
function step3(){
	#instalando libdevmapper necesaria para ejecuar docker
	infoCabecera "$msgInfo3_1"
	$gestorPaquetes install -y libdevmapper1.02.1
	if [ $? -ne 0 ]; then
		echo "$msgError3_1"
		exit -1
	fi

	#la versión de docker es antigua y busca una librería antigua de libdevmapper
	if [ ! -e /usr/lib/x86_64-linux-gnu/libdevmapper.so.1.02 ]; then
		ln -s /usr/lib/x86_64-linux-gnu/libdevmapper.so.1.02.1 /usr/lib/x86_64-linux-gnu/libdevmapper.so.1.02
		if [ $? -ne 0 ]; then
			echo "$msgError3_2"
			exit -1
		fi
	fi
}

#copy files to installation dir, from actual repository
function step4(){
	infoCabecera "$msgInfo4_1"
	cd "$baseDir"
	ret=0
	cp "$iniDir/dependencias/oaw.tar.gz" .
	ret=$?
	tar -xf oaw.tar.gz
	let ret=$ret+$?
	if [ $ret -ne 0 ]; then
		echo "$msgError4_1"
		exit -1
	fi
	rm oaw.tar.gz
}

#docker install, instalamos la versión especificada. Seguramente funcione con la última también
function step5(){
	cd "$baseDir/oaw/motor-js/instalacion"
	if [ "$gestorPaquetes" == "apt-get" ]; then
		infoCabecera "$msgInfo5_1"
		sudo alien -i docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm
		if [ $? -ne 0 ]; then
			echo "$msgError5_1"
			exit -1
		fi
		infoCabecera "$msgInfo5_2"
		sudo alien -i docker-ce-17.03.2.ce-1.el7.centos.x86_64.rpm
		if [ $? -ne 0 ]; then
			echo "$msgError5_2"
			exit -1
		fi
	else
		infoCabecera "$msgInfo5_1"
		rpm -i install docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm
		if [ $? -ne 0 ]; then
			echo "$msgError5_1"
			exit -1
		fi
		
		infoCabecera "$msgInfo5_2"
		rpm -i install docker-ce-17.03.2.ce-1.el7.centos.x86_64.rpm
		if [ $? -ne 0 ]; then
			echo "$msgError5_2"
			exit -1
		fi
	fi
	
	#configurando el servicio para que se ejecute al inicio y arrancando el servicio ahora, para tenerlo disponible
	infoCabecera "$msgInfo5_3"
	ret=0
	systemctl enable docker.service	#habilita docker al arrancar el sistema
	ret=$?
	systemctl start docker #arranca el servicio docker ahora
	let ret=$ret+$?
	if [ $ret -ne 0 ]; then 
		echo "$msgError5_3"
		exit -1
	fi
	
}

function step6(){
	#comprobar la versión de docker
	infoCabecera "$msgInfo6_1"
	if [ $(docker --version | grep -i -c "17.03.2-ce") -ne 1 ]; then
		echo "$msgError6_1"
		docker --version
		exit -1
	fi 
}

function step7(){
	#docker-compose. Repito el cd para tener claro donde está el fichero
	cd "$baseDir/oaw/motor-js/instalacion"
	infoCabecera "$msgInfo7_1"
	cp docker-compose "$binaryDir"
	sudo chmod u+x,g+x "${binaryDir}/docker-compose"
	if [ $? -ne 0 ]; then
		echo "$msgError7_1"
		exit -1
	fi
}

function step8(){
	#comprobamos la versión de docker compose
	infoCabecera "$msgInfo8_1"
	if [ $(docker-compose --version | grep -i -c "1.23.2") -ne 1 ]; then 
		echo "$msgError8_1"
		docker-compose --version
		exit -1
	fi
}





function step9(){
	#congelamos los paquetes de docker
	infoCabecera "$msgInfo9_1"
	if [ "$gestorPaquetes" == "apt-get" ]; then
		apt-mark hold docker-ce-selinux
		apt-mark hold docker-ce
		apt-mark hold libdevmapper1*
	else
		#añadiendo esta linea al fichero de yum, se congela el paquete
		echo "exclude=docker-ce*,libdevmapper1*" >> /etc/yum.conf
	fi
}


#nos vamos a esta ruta y vamos a cambiar el fichero de configuración del proxy nginx para establecer la ip del dns exterior
#no tengo claro que la coja, habría que mirar dentro del contenedor y si no modificarlo dentro del contenedor después de cargarlo
function step10(){
	cd "${baseDir}/oaw/motor-js/nginx"

	datosCorrectos='n'
	while [ "$datosCorrectos" != 'y' ]; do
		echo -n "$msgQuestion1" ; read ipDnsExterior
		if [ ! -z "$ipDnsExterior" ]; then
			infoCabecera "$msgInfo10_1"
			echo "$ipDnsExterior"
			echo -n "$msgQuestion2" ; read datosCorrectos
		fi
	done


	#nos creamos una copia
	if [ ! -e "reverse.conf.back" ]; then
		mv reverse.conf reverse.conf.back
	fi

	#sed -e s/"resolver 10.253.252.21"/"resolver $ipDnsExterior"/g reverse.conf.back > reverse.conf
	sed "/resolver [1-9]\?/c resolver ${ipDnsExterior};" reverse.conf.back > reverse.conf
	if [ $? -ne 0 ]; then
		echo "$msgError10_1"
		exit -1
	fi

	#borramos los certificados obsoletos, que vienen en los fuentes. Nginx recreará la carpeta, por si se quieren añadir
	cd "${baseDir}/oaw/motor-js/nginx/certs"
	rm -r *
}

#ejecución de docker-compose up
function step11(){
	cd "${baseDir}/oaw/motor-js"
	infoCabecera "$msgInfo11_1"
	#Si se ejecuta otra vez se necesita --force-recreate 
	docker-compose up -d --force-recreate
	if [ $? -ne 0 ]; then
		echo "$msgError11_1"
		exit -1
	fi
}

#instalación de mariadb-server
function step12(){
	infoCabecera "$msgInfo12_1"
	$gestorPaquetes install -y mariadb-server
	if [ $? -ne 0 ]; then
		echo "$msgError12_1"
		exit -1
	fi
}

#se puede ejectuar todas las veces que se quiera, simplemente se actualiza o se crea otro usuario
function step13(){
	infoCabecera "$msgInfo13_1"
	askForUserPasswordDb
	mysql --user="root" --execute "GRANT ALL ON *.* TO "$newAdminDb"@'localhost' IDENTIFIED BY "\'$passwordDb\'" WITH GRANT OPTION;FLUSH PRIVILEGES;"
	if [ $? -ne 0 ]; then
		echo "$msgError13_1"
		exit -1
	fi 
}

#creación de la estructura de la bd
#para eliminar lo anterior
#sudo mysql -u root <<< "drop database OAW"

function step14(){
	infoCabecera "$msgInfo14_1"
	cd "$iniDir/dependencias/sqls"
	
	askForApplicationLanguaje
	if [ "$applicationVersion" == "en" ]; then
		cd english
	fi 
	mysql -u root <<< "CREATE DATABASE OAW;"
	ret=$?
	mysql -u root OAW < 01_CREATE_DATABSE_OAW_FIXED.sql
	let ret=$ret+$?
	mysql -u root OAW < 02_INIT_DATABASE_OAW.sql
	let ret=$ret+$?
	mysql -u root OAW < 03_UPDATE_OAW_5.0.4.sql
	let ret=$ret+$?
	if [ $ret -ne 0 ]; then
		echo "$msgError14_1"
		exit -1
	fi 
}

#alta de usuario administrador de la aplicación
function step15(){
	infoCabecera "$msgInfo15_1"
	datosCorrectos=""
	while [ "$datosCorrectos" != "y" ]; do 
		ApliUsuario=""
		ApliPassword=""
		ApliNombre=""
		ApliApellidos=""
		ApliDepartamento=""
		ApliEmail=""
		while [ -z "$ApliUsuario" ]; do
			echo -n "$msgInfo15_2" ;read ApliUsuario
		done
		while [ -z "$ApliPassword" ]; do
			echo -n "$msgInfo15_3" ;read ApliPassword
		done
		while [ -z "$ApliNombre" ]; do
			echo -n "$msgInfo15_4"; read ApliNombre
		done
		while [ -z "$ApliApellidos" ]; do
			echo -n "$msgInfo15_5"; read ApliApellidos
		done
		while [ -z "$ApliDepartamento" ]; do
			echo -n "$msgInfo15_6"; read ApliDepartamento
		done
		while [ -z "$ApliEmail" ]; do
			echo -n "$msgInfo15_7"; read ApliEmail
		done
		datosCorrectos=""
		while [ "$datosCorrectos" != 'n' ] && [ "$datosCorrectos" != 'y' ]; do
			echo -n "$msgQuestion2" ; read datosCorrectos
		done
	done
	#calculamos el hash y me quedo con éste
	ApliPassword=$(echo -n "$ApliPassword" | md5sum | cut -d' ' -f1)

	#actualizamos el administrador de la aplicación
	echo "$msgInfo15_8"
	mysql -u root OAW --execute "update usuario \
	set usuario='$ApliUsuario', \
	password='$ApliPassword', \
	nombre='$ApliNombre', \
	apellidos='$ApliApellidos', \
	departamento='$ApliDepartamento', \
	email='$ApliEmail' \
	where id_usuario=1;"
	if [ $? -ne 0 ]; then
		echo "$msgError15_1"
		exit -1
	fi
}

#instalación java
function step16(){
	infoCabecera "$msgInfo16_1"
	cd "$iniDir/dependencias"
	cp jdk-8u202-linux-x64.tar.gz $baseDir
	cd $baseDir
	tar -xf jdk-8u202-linux-x64.tar.gz
	if [ $? -ne 0 ]; then
		echo "$msgError16_1"
		exit -1
	fi
	rm jdk-8u202-linux-x64.tar.gz
	echo "$msgInfo16_2"
	ret=0
	#para la sesion actual
	export JAVA_HOME=$baseDir/jdk1.8.0_202
	export PATH=$PATH:$JAVA_HOME/bin
	
	#para establecer las variables después de reiniciar
	if [ ! -e "$envFile" ]; then
		touch "$envFile"
		echo "#Environment vars for oaw" >> "$envFile"
	fi
	
	if [ $(grep -i -c "export JAVA_HOME=$baseDir/jdk1.8.0_202" "$envFile" ) -eq 0 ]; then
		echo export JAVA_HOME=$baseDir/jdk1.8.0_202 >> "$envFile"
		ret=$?
	fi
	
	if [ $(grep -i -c 'PATH=$PATH:$JAVA_HOME/bin' "$envFile" ) -eq 0 ]; then
		echo 'export PATH=$PATH:$JAVA_HOME/bin' >> "$envFile"
		let ret=$ret+$?
	fi
	
	if [ $ret -ne 0 ]; then
		echo "$msgError16_2"
		exit -1
	fi
		
}

#instalación apache
function step17(){
	infoCabecera "$msgInfo17_1"
	cd "$iniDir/dependencias"
	cp apache-tomcat-7.0.107.tar.gz $baseDir
	cd $baseDir
	tar -xf apache-tomcat-7.0.107.tar.gz
	if [ $? -ne 0 ]; then
		echo "$msgError17_1"
		exit -1
	fi
	rm apache-tomcat-7.0.107.tar.gz
	echo "$msgInfo17_2"
	#para la sesión actual
	
	export CATALINA_HOME=$baseDir/apache-tomcat-7.0.107
	export CATALINA_BASE=$baseDir/apache-tomcat-7.0.107
	
	#para establecer las variables después de reiniciar
	
	ret=0
	if [ $(grep -i -c "export CATALINA_HOME=$baseDir/apache-tomcat-7.0.107" "$envFile" ) -eq 0 ]; then
		echo "export CATALINA_HOME=$baseDir/apache-tomcat-7.0.107" >> "$envFile"
		ret=$?
	fi
	
	if [ $(grep -i -c "export CATALINA_BASE=$baseDir/apache-tomcat-7.0.107" "$envFile" ) -eq 0 ]; then
		echo "export CATALINA_BASE=$baseDir/apache-tomcat-7.0.107" >> "$envFile"
		let ret=$ret+$?
	fi
	
	if [ $ret -ne 0 ]; then
		echo "$msgError17_2"
		exit -1
	fi

	echo $msgInfo17_3
	
	ret=0
	if [ ! -d $baseDir/apache-tomcat-7.0.107/conf/Catalina/localhost ]; then
		mkdir $baseDir/apache-tomcat-7.0.107/conf/Catalina/
		let ret=$ret+$?
		mkdir $baseDir/apache-tomcat-7.0.107/conf/Catalina/localhost
		let ret=$ret+$?
	fi
	
	cd $baseDir/apache-tomcat-7.0.107/conf/Catalina/localhost
	let ret=$ret+$?
	rm -f oaw.xml 2&1>/dev/null
	if [ -z "$newAdminDb"  ]; then
		askForUserPasswordDb
	fi
	
	cat > oaw.xml <<EOF
<Context path="/oaw" reloadable="true">
    <Resource auth="Container" driverClassName="com.mysql.jdbc.Driver"
    type="javax.sql.DataSource" name="jdbc/oaw" url="jdbc:mysql://localhost:3306/OAW"
    maxActive="100" maxIdle="10"
    maxWait="-1" validationQuery="SELECT 1 as dbcp_connection_test"
    removeAbandoned="true" testOnBorrow="true"
    timeBetweenEvictionRunsMillis="60000" testWhileIdle="true"
    defaultTransactionIsolation="READ_UNCOMMITTED" username="$newAdminDb"
    password="$passwordDb"/>
</Context>
EOF
	let ret=$ret+$?
	if [ $ret -ne 0 ]; then
		echo "$msgError17_3"
		exit -1
		
	fi

	echo "$msgInfo17_4"
	#copiamos la librería de mysql. Se ha descargado la ultima disponible de oracle
	ret=0
	cp "$iniDir/dependencias/mysql-connector-java-8.0.23.jar" "$baseDir/apache-tomcat-7.0.107/lib"
	ret=$?
	chmod u=rw,g=r,o= "$baseDir/apache-tomcat-7.0.107/lib/mysql-connector-java-8.0.23.jar"
	let ret=$ret+$?
	if [ $ret -ne 0 ]; then
		echo "$msgError17_4"
		exit -1
	fi

}

function step18(){
	infoCabecera "$msgInfo18_1"
	cd "$iniDir/dependencias"
	cp "apache-maven-3.6.3-bin.tar.gz" "$baseDir"
	cd $baseDir
	tar -xf apache-maven-3.6.3-bin.tar.gz
	if [ $? -ne 0 ]; then
		echo "$msgError18_1"
		exit -1
	fi
	rm apache-maven-3.6.3-bin.tar.gz
	#para la sesión actual
	#export PATH=$baseDir/apache-maven-3.6.3/bin:$PATH
	setPathBinMaven
	
	echo "$msgInfo18_2"
	if [ $(grep -i -c "export PATH=$baseDir/apache-maven-3.6.3/bin" "$envFile" ) -eq 0 ]; then
		echo export "PATH=$baseDir/apache-maven-3.6.3/bin:\$PATH" >> "$envFile"
	fi
	if [ $? -ne 0 ]; then
		echo $msgError18_2
		exit -1
	fi

}

#preparación para compilar con maven y generar el oaw.war
function step19(){
	infoCabecera "$msgInfo19_1"
	#para tener acceso a los binarios de maven
	setPathBinMaven
	
	cp -r "$iniDir/dependencias/customMaven" "$baseDir"
	if [ $? -ne 0 ]; then
		echo "$msgError19_1"
		exit -1
	fi
	ret=0
	cp "$iniDir/build_oaw.sh" $binaryDir
	ret=$?
	chmod u+x,g+x $binaryDir/build_oaw.sh
	let ret=$ret+$?
	if [ $ret -ne 0 ]; then
		echo "$msgError19_2"
		exit -1
	fi

	#ficheros modificados del proyecto
	ret=0
	if [ ! -d $baseDir/xmlMofidicados ]; then
		mkdir $baseDir/xmlMofidicados
		ret=$?
	fi
	cp "$iniDir/dependencias/pom.xml" $baseDir/xmlMofidicados
	let ret=$ret+$?
	cp "$iniDir/dependencias/tiles-defs.xml" $baseDir/xmlMofidicados
	let ret=$ret+$?
	if [ $ret -ne 0 ]; then
		echo "$msgError19_3"
		exit -1
	fi
	
	#necesitamos el usuario de la base de datos para establecerlo
	if [ -z "$newAdminDb" ]; then
		askForUserPasswordDb
	fi
	ret=0
	if [ ! -e $baseDir/customMaven/context.xml.back ]; then
		mv $baseDir/customMaven/context.xml $baseDir/customMaven/context.xml.back
		ret=$?
	fi
	
	sed -e s"/username=\"\"/username=\"$newAdminDb\"/" 	-e s"/password=\"\"/password=\"$passwordDb\"/" $baseDir/customMaven/context.xml.back > $baseDir/customMaven/context.xml
	let ret=$ret+$?
	if [ $ret -ne 0 ]; then
		echo "$msgError19_4"
		exit -1
	fi

	ret=0
	cp "$iniDir/start_oaw.sh" $binaryDir
	ret=$?
	chmod u+x,g+x $binaryDir/start_oaw.sh
	let ret=$ret+$?
	if [ $ret -ne 0 ]; then
		echo "$msgError19_5"
		exit -1
	fi

	ret=0
	cp "$iniDir/stop_oaw.sh" $binaryDir
	ret=$?
	chmod u+x,g+x $binaryDir/stop_oaw.sh
	let ret=$ret+$?
	if [ $ret -ne 0 ]; then
		echo "$msgError19_6"
		exit -1
	fi
}

function stepFin(){
	echo "$msgInfoFin_1"
	echo "$msgInfoFin_2"
	echo "$msgInfoFin_3"
	echo "$msgInfoFin_4"
	echo "$msgInfoFin_5"
	echo "$msgInfoFin_6"
	echo "$msgInfoFin_7"
	echo "$msgInfoFin_8"
}


#quiero quitar la database anonymous y poner que root solo se pueda conectar desde localhost

function executeSteps(){
	
	if [ "$command" == "resume" ]; then
		if [ $step -gt 1 ]; then
			#este se va a necesitar casi siempre para saber cual es el gestor de paquetes. Se ejecuta en modo silencioso.
			step1 "True"
		fi
		while [ $step -lt $totalSteps ]; do
			${listaFuncionesPasos[$step]}
			let step=$step+1
		done
	
	elif [ "$command" == "execute" ]; then
		if [ $step -gt 1 ]; then
			#este se va a necesitar casi siempre para saber cual es el gestor de paquetes. Se ejecuta en modo silencioso.
			step1 "True"
		fi
		#paso en concreto
		${listaFuncionesPasos[$step]}
	else
		#todos los pasos
		for numStep in "${listaFuncionesPasos[@]}"; do
			$numStep
		done
	fi
}

#****************************************************
# MAIN
#****************************************************

iniDir="$PWD"

baseDir="/usr/local/share/oaw"
binaryDir="/usr/local/bin"

#environment vars
envFile="/etc/profile.d/oaw-env.sh"

#array de funciones para ejecutar los pasos
listaFuncionesPasos=(step0 step1 step2 step3 step4 step5 step6 step7 step8 step9 step10 step11 step12 step13 step14 step15 step16 step17 step18 step19 stepFin)

#total de pasos que tenemos
totalSteps=${#listaFuncionesPasos[@]}

#***************************************************
#Validación de los parámetros de entrada del script
#***************************************************

#sólo puede ser "en" or "es"
if [ -z "$1" ] || [ "$1" != "es" -a "$1" != "en" ]; then
		ayuda
fi 

lang="$1"
step=""
command=""

#$2 puede ser resume o execute y $3 un número (el número de paso desde o a ejecutar)
if [ $# -gt 1 ]; then
	if [ "$2" != "resume" ] && [ "$2" != "execute" ]; then
		ayuda
	fi
	#comienza y termina por numero y hay al menos uno
	re='^[0-9]+$'
	if ! [[ "$3" =~ $re ]] ; then
		ayuda 
	fi
	if [ $# -gt 3 ]; then
		ayuda
	fi 
	
	#el número de paso tiene que estar comprendido entre 0 y $totalSteps
	
	if [ $3 -lt 0 ] || [ $3 -ge $totalSteps ]; then
		#lo modificamos para mostrar correctamente el mensaje de error
		let totalSteps=$totalSteps-1
		echo "Parameter step number incorrect. Must be a number between 0 and $totalSteps."
		ayuda
	fi
	command="$2"
	step="$3"
	
fi

#establecemos el lenguaje de los mensajes, errores, etc
setLanguaje

#ejecutamos el script según nos hayan requerido por la línea de comandos
executeSteps

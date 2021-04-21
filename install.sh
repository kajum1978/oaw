#!/bin/bash

#Versiones:
#1.0: 
#	  -Coge los fuentes de github
#	  -Crea las imágenes de docker desde unos ficheros .tar

#1.1: 
#     -Se tiene una imagen estática de los ficheros fuentes, en este repositorio.
#	  -Las imágenes de docker se crean directamente con docker-compose

#1.2:
#     -Se nombran los pasos por un nombre más significativo y menos genérico
#     -Se cambia el orden de llamada de los pasos. Por si existe un proxy de empresa y da un error docker-compose
#	      Se necesitan tener ciertos pasos hecho antes para cambiar ficheros de configuración al ejecutar: configure_proxy.sh

#imprime una pantalla de ayuda, al ejecutar incorrectamente el comando
function ayuda(){
	echo "Use: $0 (languaje) [ [resume (step number)] | [execute (step number)] ]"
	echo "examples:"
	echo "$0 es"
	echo "$0 es resume"
	echo "$0 es resume 3"
	echo "$0 es execute 3"
	echo "or"
	echo "$0 en"
	echo "$0 en resume"
	echo "$0 en resume 3"
	echo "$0 en execute 3"
	exit -1
}


#Definición de los mensajes en su correspondiente idioma
function setLanguaje(){
	if [ "$lang" == "es" ]; then
		createDirInstall_msgError_1="Error paso ${createDirInstall_stepNum} 1/2: Directorio de instalación ya existe $baseDir"
		createDirInstall_msgError_2="Error paso ${createDirInstall_stepNum} 2/2: No puedo crear el directorio $baseDir. Se necesitan permisos de superusuario"
		detectPackageInstaller_msgError_1="Error paso ${detectPackageInstaller_stepNum}: Distribución linux no soportada. Solo debian o redhat."
		alienInstall_msgError_1="Error paso ${alienInstall_stepNum}: Fallo al instalar el paquete alien."
		dockerDependency_msgError_1="Error paso ${dockerDependency_stepNum} 1/2: Fallo al instalar librería libdevmapper1.02.1"
		dockerDependency_msgError_2="Error paso ${dockerDependency_stepNum} 2/2: Fallo al crear enlace simbólico a librería libdevmapper1.02.1"
		copyOawSourceFiles_msgError_1="Error paso ${copyOawSourceFiles_stepNum}: No se puede copiar los fuentes oaw al directorio de instalación ${baseDir}."
		dockerInstall_msgError_1="Error paso ${dockerInstall_stepNum} 1/3: Fallo al instalar paquete docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm"
		dockerInstall_msgError_2="Error paso ${dockerInstall_stepNum} 2/3: Fallo al instalar paquete docker-ce-17.03.2.ce-1.el7.centos.x86_64.rpm."
		dockerInstall_msgError_3="Error paso ${dockerInstall_stepNum} 3/3: Fallo al arrancar docker o habilitar el servicio docker para su ejecución al inicio."
		checkDockerVersion_msgError_1="Error paso ${checkDockerVersion_stepNum}: Versión de docker incorrecta. Debe ser 17.03.2-ce."
		dockerComposeInstall_msgError_1="Error paso ${dockerComposeInstall_stepNum}: Fallo al instalar docker-compose."
		checkDockerComposeVersion_msgError_1="Error paso ${checkDockerComposeVersion_stepNum}: Versión de docker-compose incorrecta. Debe ser 1.23.2."
		configureIpDns_msgError_1="Error paso ${configureIpDns_stepNum}: Fallo al modificar el fichero ${baseDir}/oaw/motor-js/nginx/reverse.conf"
		executeDockerCompose_msgError_1="Error paso ${executeDockerCompose_stepNum}: Fallo al ejecutar el comando: docker-compose up -d"
		executeDockerCompose_msgError_2="               ¿Tienes al menos tres CPUs disponibles?"
		executeDockerCompose_msgError_3="               ¿Tienes un proxy?"
		executeDockerCompose_msgError_4="               ejecuta: sudo ./configure_proxy.sh es"
		executeDockerCompose_msgError_5="               después: sudo ./install.sh es resume"
		mariadbInstall_msgError_1="Error paso ${mariadbInstall_stepNum}: Fallo al instalar mariadb-server"
		createAdminMariadb_msgError_1="Error paso ${createAdminMariadb_stepNum}: Error al crear el usuario administrador en mariadb-server"
		createStructureDbOaw_msgError_1="Error paso ${createStructureDbOaw_stepNum}: Error al crear la estructura de la base de datos en la bd OAW."
		createUserApplicationOaw_msgError_1="Error paso ${createUserApplicationOaw_stepNum}: Fallo al establecer usuario administrador aplicación OAW."
		javaInstall_msgError_1="Error paso ${javaInstall_stepNum} 1/2: Fallo al descomprimir jdk-8u202-linux-x64.tar.gz a $baseDir"
		javaInstall_msgError_2="Error paso ${javaInstall_stepNum} 2/2: Fallo al establecer variables de entorno de Java."
		apacheTomcatInstall_msgError_1="Error paso ${apacheTomcatInstall_stepNum} 1/4: Fallo al descomprimir apache-tomcat-7.0.107.tar.gz a $baseDir"
		apacheTomcatInstall_msgError_2="Error paso ${apacheTomcatInstall_stepNum} 2/4: Fallo al establecer variables de entorno de Apache Tomcat"
		apacheTomcatInstall_msgError_3="Error paso ${apacheTomcatInstall_stepNum} 3/4: Fallo al establecer el profile oaw.xml de Apache Tomcat en $baseDir/apache-tomcat-7.0.107/conf/Catalina/localhost"
		apacheTomcatInstall_msgError_4="Error paso ${apacheTomcatInstall_stepNum} 4/4: Fallo al copiar librería necesaria mysql-connector-java-8.0.23.jar"
		apacheMavenInstall_msgError_1="Error paso ${apacheMavenInstall_stepNum} 1/2: Fallo al descomprimir apache-maven-3.6.3-bin.tar.gz a $baseDir"
		apacheMavenInstall_msgError_2="Error paso ${apacheMavenInstall_stepNum} 2/2: Fallo al establecer variables de entorno de maven."
		prepareForCompilation_msgError_1="Error paso ${prepareForCompilation_stepNum} 1/6: Fallo al copiar el profile de maven a $baseDir"
		prepareForCompilation_msgError_2="Error paso ${prepareForCompilation_stepNum} 2/6: Fallo al instalar el fichero build_oaw.sh en $binaryDir"
		prepareForCompilation_msgError_3="Error paso ${prepareForCompilation_stepNum} 3/6: Fallo al copiar los fichero xml modificados a $baseDir/xmlMofidicados"
		prepareForCompilation_msgError_4="Error paso ${prepareForCompilation_stepNum} 4/6: Fallo al cambiar el fichero context.xml del perfil de maven $baseDir/customMaven"
		prepareForCompilation_msgError_5="Error paso ${prepareForCompilation_stepNum} 5/6: Fallo al instalar el fichero start_oaw.sh en $binaryDir"
		prepareForCompilation_msgError_6="Error paso ${prepareForCompilation_stepNum} 6/6: Fallo al instalar el fichero stop_oaw.sh en $binaryDir"


		createDirInstall_msgInfo_1="Paso ${createDirInstall_stepNum}: Creación del directorio de instalación $baseDir"
		detectPackageInstaller_msgInfo_1="Paso ${detectPackageInstaller_stepNum}: Gestor de paquetes detectado: " 
		alienInstall_msgInfo_1="Paso ${alienInstall_stepNum}: Instalando paquete alien." 
		dockerDependency_msgInfo_1="Paso ${dockerDependency_stepNum}: Instalando librería libdevmapper1.02.1"
		copyOawSourceFiles_msgInfo_1="Paso ${copyOawSourceFiles_stepNum}: Copiando ficheros fuentes de oaw al directorio de instalación."
		dockerInstall_msgInfo_1="Paso ${dockerInstall_stepNum} 1/3: Instalando docker. Parte 1"
		dockerInstall_msgInfo_2="Paso ${dockerInstall_stepNum} 2/3: Instalando docker. Parte 2"
		dockerInstall_msgInfo_3="Paso ${dockerInstall_stepNum} 3/3: Activando servicio docker."
		checkDockerVersion_msgInfo_1="Paso ${checkDockerVersion_stepNum}: Comprobando versión de docker."
		dockerComposeInstall_msgInfo_1="Paso ${dockerComposeInstall_stepNum}: Instalando fichero docker-compose."
		checkDockerComposeVersion_msgInfo_1="Paso ${checkDockerComposeVersion_stepNum}: Comprobando versión de docker-compose."
		holdPackages_msgInfo_1="Paso ${holdPackages_stepNum}: Congelando paquetes de docker."
		configureIpDns_msgInfo_1="Paso ${configureIpDns_stepNum}: En el fichero ${baseDir}/oaw/motor-js/nginx/reverse.conf se establecerá la siguiente ip como dns exterior:"
		executeDockerCompose_msgInfo_1="Paso ${executeDockerCompose_stepNum}: Ejecutando: docker-compose up -d"
		mariadbInstall_msgInfo_1="Paso ${mariadbInstall_stepNum}: Instalando mariadb-server equivalente a mysql:"
		createAdminMariadb_msgInfo_1="Paso ${createAdminMariadb_stepNum}: Creación de usuario administrador mariadb-server:"
		createStructureDbOaw_msgInfo_1="Paso ${createStructureDbOaw_stepNum}: Creando la estructura en la base de datos OAW."
		createUserApplicationOaw_msgInfo_1="Paso ${createUserApplicationOaw_stepNum}: Creación de usuario administrador aplicación OAW."
		createUserApplicationOaw_msgInfo_2="Usuario administrador: "
		createUserApplicationOaw_msgInfo_3="Password administrador: "
		createUserApplicationOaw_msgInfo_4="Nombre: "
		createUserApplicationOaw_msgInfo_5="Apellidos: "
		createUserApplicationOaw_msgInfo_6="Departamento: "
		createUserApplicationOaw_msgInfo_7="Email: "
		createUserApplicationOaw_msgInfo_8="Actualizando la bd con el nuevo administrador de la aplicación"
		javaInstall_msgInfo_1="Paso ${javaInstall_stepNum} 1/2: Instalación de java 1.8.202"
		javaInstall_msgInfo_2="Paso ${javaInstall_stepNum} 2/2: Estableciendo variables de entorno de Java en $envFile"
		apacheTomcatInstall_msgInfo_1="Paso ${apacheTomcatInstall_stepNum} 1/4: Instalación de apache tomcat 1.7.0.107"
		apacheTomcatInstall_msgInfo_2="Paso ${apacheTomcatInstall_stepNum} 2/4: Estableciendo variables de entorno de Apache Tomcat en $envFile"
		apacheTomcatInstall_msgInfo_3="Paso ${apacheTomcatInstall_stepNum} 3/4: Estableciendo profile oaw.xml de Apache Tomcat en $baseDir/apache-tomcat-7.0.107/conf/Catalina/localhost"
		apacheTomcatInstall_msgInfo_4="Paso ${apacheTomcatInstall_stepNum} 4/4: Instalando librería necesaria para Apache Tomcat mysql-connector-java-8.0.23.jar"
		apacheMavenInstall_msgInfo_1="Paso ${apacheMavenInstall_stepNum} 1/2: Instalando apache-maven 3.6.3"
		apacheMavenInstall_msgInfo_2="Paso ${apacheMavenInstall_stepNum} 2/2: Estableciendo variables de entorno de maven en $envFile"
		prepareForCompilation_msgInfo_1="Paso ${prepareForCompilation_stepNum}: Preparando estructura para compilar el proyecto oaw y instalar ejecutables necesarios."
		
		endInstallation_msgInfo_1="Fin de la instalación. Pasos siguientes:"
		endInstallation_msgInfo_2="1. Revisar el directorio $baseDir/customMaven. Modificar a conveniencia según la documentación."
		endInstallation_msgInfo_3="2. Ejecutar: sudo build_oaw.sh es"
		endInstallation_msgInfo_4="   -Se creara el fichero oaw.war y se establecera en su correspondiente directorio del tomcat."
		endInstallation_msgInfo_5="   -Se puede ejecutar cuantas veces se necesite build_oaw.sh"
		endInstallation_msgInfo_6="3. IMPORTANTE: Tomcat no arranca por defecto. Arrancar con: sudo start_oaw.sh"
		endInstallation_msgInfo_7="            Para parar Tomcat: sudo stop_oaw.sh"
		endInstallation_msgInfo_8="4. Finalmente lanzar la aplicación en el navegador con http://localhost:8080/oaw"

		msgInfo_askForUserPasswordDb_1="Se debe utilizar otro nombre de usuario distinto de root."

		msgQuestion1="¿ip Dns exterior?, si no sabes establece una de google 8.8.8.8: "
		msgQuestion2="Son los datos correctos (y|n): "
		msgQuestion3="¿nombre de administrador para mariadb-server? "
		msgQuestion4="¿password administrador para mariadb-server? "
		msgQuestion5="¿quieres instalar la estructura de la base de datos de la aplicación en español o en inglés (es|en)? "
		
	elif [ "$lang" == "en" ]; then
		createDirInstall_msgError_1="Error step ${createDirInstall_stepNum} 1/2: Installation directory already exists $baseDir"
		createDirInstall_msgError_2="Error step ${createDirInstall_stepNum} 2/2: I can't create the directory $baseDir. Superuser permissions are required."
		detectPackageInstaller_msgError_1="Error step ${detectPackageInstaller_stepNum}: Linux distribution not supported. Only debian or redhat."
		alienInstall_msgError_1="Error step ${alienInstall_stepNum}: Failed to install alien package."
		dockerDependency_msgError_1="Error step ${dockerDependency_stepNum} 1/2: Failed to install libdevmapper1.02.1 library."
		dockerDependency_msgError_2="Error step ${dockerDependency_stepNum} 2/2: Failed to create symbolic link to libdevmapper1.02.1 library."
		copyOawSourceFiles_msgError_1="Error step ${copyOawSourceFiles_stepNum}: Unable to copy oaw sources to installation directory ${baseDir}."
		dockerInstall_msgError_1="Error step ${dockerInstall_stepNum} 1/3: Failed to install package docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm"
		dockerInstall_msgError_2="Error step ${dockerInstall_stepNum} 2/3: Failed to install package docker-ce-17.03.2.ce-1.el7.centos.x86_64.rpm."
		dockerInstall_msgError_3="Error step ${dockerInstall_stepNum} 3/3: Failure to start docker or enable docker service to run at startup."
		checkDockerVersion_msgError_1="Error step ${checkDockerVersion_stepNum}: Wrong docker version. Must be 17.03.2-ce."
		dockerComposeInstall_msgError_1="Error step ${dockerComposeInstall_stepNum}: Failed to install docker-compose."
		checkDockerComposeVersion_msgError_1="Error step ${checkDockerComposeVersion_stepNum}: Wrong docker-compose version. Must be 1.23.2."
		configureIpDns_msgError_1="Error step ${configureIpDns_stepNum}: Failed to modify the file ${baseDir}/oaw/motor-js/nginx/reverse.conf"
		executeDockerCompose_msgError_1="Error step ${executeDockerCompose_stepNum}: Failed to execute command: docker-compose up -d"
		executeDockerCompose_msgError_2="               Do you have at least 3 CPUs available?"
		executeDockerCompose_msgError_3="               Do you have a proxy?"
		executeDockerCompose_msgError_4="               execute: sudo ./configure_proxy.sh en"
		executeDockerCompose_msgError_5="               next: sudo ./install.sh en resume"
		mariadbInstall_msgError_1="Error step ${mariadbInstall_stepNum}: Failed to install mariadb-server"
		createAdminMariadb_msgError_1="Error step ${createAdminMariadb_stepNum}: Error creating administrator user in mariadb-server"
		createStructureDbOaw_msgError_1="Error step ${createStructureDbOaw_stepNum}: Error creating database structure in OAW db."
		createUserApplicationOaw_msgError_1="Error step ${createUserApplicationOaw_stepNum}: Failed to set OAW application administrator user."
		javaInstall_msgError_1="Error step ${javaInstall_stepNum} 1/2: Failed to unzip jdk-8u202-linux-x64.tar.gz to $baseDir"
		javaInstall_msgError_2="Error step ${javaInstall_stepNum} 2/2: Failed to set Java environment variables."
		apacheTomcatInstall_msgError_1="Error step ${apacheTomcatInstall_stepNum} 1/4: Failed to unzip apache-tomcat-7.0.107.tar.gz to $baseDir"
		apacheTomcatInstall_msgError_2="Error step ${apacheTomcatInstall_stepNum} 2/4: Failed to set Apache Tomcat environment variables"
		apacheTomcatInstall_msgError_3="Error step ${apacheTomcatInstall_stepNum} 3/4: Failed to set Apache Tomcat profile oaw.xml to $baseDir/apache-tomcat-7.0.107/conf/Catalina/localhost"
		apacheTomcatInstall_msgError_4="Error step ${apacheTomcatInstall_stepNum} 4/4: Failed to copy required library mysql-connector-java-8.0.23.jar"
		apacheMavenInstall_msgError_1="Error step ${apacheMavenInstall_stepNum} 1/2: Failed to unzip apache-maven-3.6.3-bin.tar.gz to $baseDir"
		apacheMavenInstall_msgError_2="Error step ${apacheMavenInstall_stepNum} 2/2: Failed to set maven environment variables."
		prepareForCompilation_msgError_1="Error step ${prepareForCompilation_stepNum} 1/6: Failed to copy profile from maven to $baseDir"
		prepareForCompilation_msgError_2="Error step ${prepareForCompilation_stepNum} 2/6: Failed to install build_oaw.sh file in $binaryDir"
		prepareForCompilation_msgError_3="Error step ${prepareForCompilation_stepNum} 3/6: Failed to copy modified xml files to $baseDir/xmlMofidicados"
		prepareForCompilation_msgError_4="Error paso ${prepareForCompilation_stepNum} 4/6: Failed to change the context.xml file of the maven profile $baseDir/customMaven"
		prepareForCompilation_msgError_5="Error step ${prepareForCompilation_stepNum} 5/6: Failed to install start_oaw.sh file in $binaryDir"
		prepareForCompilation_msgError_6="Error step ${prepareForCompilation_stepNum} 6/6: Failed to install stop_oaw.sh file in $binaryDir"


		createDirInstall_msgInfo_1="Step ${createDirInstall_stepNum}: Creating the installation directory $baseDir"
		detectPackageInstaller_msgInfo_1="Step ${detectPackageInstaller_stepNum}: Package manager detected: " 
		alienInstall_msgInfo_1="Step ${alienInstall_stepNum}: Installing alien package." 
		dockerDependency_msgInfo_1="Step ${dockerDependency_stepNum}: Installing libdevmapper1.02.1 library"
		copyOawSourceFiles_msgInfo_1="Step ${copyOawSourceFiles_stepNum}: Copying source files from oaw to the installation directory."
		dockerInstall_msgInfo_1="Step ${dockerInstall_stepNum} 1/3: Installing docker. Part 1"
		dockerInstall_msgInfo_2="Step ${dockerInstall_stepNum} 2/3: Installing docker. Part 2"
		dockerInstall_msgInfo_3="Step ${dockerInstall_stepNum} 3/3: Activating docker service."
		checkDockerVersion_msgInfo_1="Step ${checkDockerVersion_stepNum}: Checking version of docker."
		dockerComposeInstall_msgInfo_1="Step ${dockerComposeInstall_stepNum}: Installing docker-compose."
		checkDockerComposeVersion_msgInfo_1="Step ${checkDockerComposeVersion_stepNum}: Checking version of docker-compose."
		holdPackages_msgInfo_1="Step ${holdPackages_stepNum}: Freezing docker packages."
		configureIpDns_msgInfo_1="Step ${configureIpDns_stepNum}: In the file ${baseDir}/oaw/motor-js/nginx/reverse.conf the following ip will be set as external dns:"
		executeDockerCompose_msgInfo_1="Step ${executeDockerCompose_stepNum}: Running: docker-compose up -d"
		mariadbInstall_msgInfo_1="Step ${mariadbInstall_stepNum}: Installing mariadb-server equivalent to mysql:"
		createAdminMariadb_msgInfo_1="Step ${createAdminMariadb_stepNum}: Creation of administrator user mariadb-server:"
		createStructureDbOaw_msgInfo_1="Step ${createStructureDbOaw_stepNum}: Creating the structure in the OAW database."
		createUserApplicationOaw_msgInfo_1="Step ${createUserApplicationOaw_stepNum}: OAW application administrator user creation."
		createUserApplicationOaw_msgInfo_2="Administrator user: "
		createUserApplicationOaw_msgInfo_3="Administrator password: "
		createUserApplicationOaw_msgInfo_4="Name: "
		createUserApplicationOaw_msgInfo_5="Surnames: "
		createUserApplicationOaw_msgInfo_6="Department: "
		createUserApplicationOaw_msgInfo_7="Email: "
		createUserApplicationOaw_msgInfo_8="Updating the database with the new application manager (Administrator user/password)"
		javaInstall_msgInfo_1="Step ${javaInstall_stepNum} 1/2: Java 1.8.202 installation"
		javaInstall_msgInfo_2="Step ${javaInstall_stepNum} 2/2: Setting Java environment variables to $envFile"
		apacheTomcatInstall_msgInfo_1="Step ${apacheTomcatInstall_stepNum} 1/4: Apache tomcat 1.7.0.107 installation"
		apacheTomcatInstall_msgInfo_2="Step ${apacheTomcatInstall_stepNum} 2/4: Setting Apache Tomcat environment variables to $envFile"
		apacheTomcatInstall_msgInfo_3="Step ${apacheTomcatInstall_stepNum} 3/4: Setting Apache Tomcat's profile oaw.xml to $baseDir/apache-tomcat-7.0.107/conf/Catalina/localhost"
		apacheTomcatInstall_msgInfo_4="Step ${apacheTomcatInstall_stepNum} 4/4: Installing required library for Apache Tomcat mysql-connector-java-8.0.23.jar"
		apacheMavenInstall_msgInfo_1="Step ${apacheMavenInstall_stepNum} 1/2: Installing apache-maven 3.6.3"
		apacheMavenInstall_msgInfo_2="Step ${apacheMavenInstall_stepNum} 2/2: Setting maven environment variables to $envFile"
		prepareForCompilation_msgInfo_1="Step ${prepareForCompilation_stepNum}: Preparing structure to compile the oaw project and install necessary executables."
		
		endInstallation_msgInfo_1="End of installation. Next steps:"
		endInstallation_msgInfo_2="1. Review the directory $baseDir/customMaven. Modify at convenience according to the documentation."
		endInstallation_msgInfo_3="2. Run: sudo build_oaw.sh en"
		endInstallation_msgInfo_4="   -The oaw.war file will be created and established in its corresponding tomcat directory."
		endInstallation_msgInfo_5="   -It can be run as many times as needed build_oaw.sh"
		endInstallation_msgInfo_6="3. IMPORTANT: Tomcat does not start by default. Start with: sudo start_oaw.sh"
		endInstallation_msgInfo_7="            To stop Tomcat: sudo stop_oaw.sh"
		endInstallation_msgInfo_8="4. Finally launch the application in the browser with http://localhost:8080/oaw"

		msgInfo_askForUserPasswordDb_1="A username other than root must be used."

		msgQuestion1="IP Dns exterior ?, if you do not know, set one of google 8.8.8.8: "
		msgQuestion2="Is data correct? (y|n): "
		msgQuestion3="Administrator user for mariadb-server? "
		msgQuestion4="Administrator user for mariadb-server? "
		msgQuestion5="do you want to install application database structure in Spanish or English (es|en)? "
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
function createDirInstall(){
	infoCabecera "$createDirInstall_msgInfo_1"
	if [ -e "$baseDir" ]; then
		echo "$createDirInstall_msgError_1"
		exit -1 
	fi 
	mkdir "$baseDir"
	if [ $? -ne 0 ]; then
		echo "$createDirInstall_msgError_2"
		exit -1
	fi
}

#vamos a averiguar que gestor de paquete usamos, lo ejecutamos siempre que nos pidan otro paso
function detectPackageInstaller(){
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
			infoCabecera "$detectPackageInstaller_msgInfo_1 $gestorPaquetes"
		fi
	else
		echo "$detectPackageInstaller_msgError_1"
		exit -1
	fi 
}

#install of alien
function alienInstall(){
	if [ "$gestorPaquetes" == "apt-get" ]; then
		infoCabecera "$alienInstall_msgInfo_1"
		$gestorPaquetes install -y alien
		if [ $? -ne 0 ]; then
			echo "$alienInstall_msgError_1"
			exit -1
		fi
	fi
}

#dependencia para docker
function dockerDependency(){
	#instalando libdevmapper necesaria para ejecuar docker
	infoCabecera "$dockerDependency_msgInfo_1"
	$gestorPaquetes install -y libdevmapper1.02.1
	if [ $? -ne 0 ]; then
		echo "$dockerDependency_msgError_1"
		exit -1
	fi

	#la versión de docker es antigua y busca una librería antigua de libdevmapper
	if [ ! -e /usr/lib/x86_64-linux-gnu/libdevmapper.so.1.02 ]; then
		ln -s /usr/lib/x86_64-linux-gnu/libdevmapper.so.1.02.1 /usr/lib/x86_64-linux-gnu/libdevmapper.so.1.02
		if [ $? -ne 0 ]; then
			echo "$dockerDependency_msgError_2"
			exit -1
		fi
	fi
}

#copy files to installation dir, from actual repository
function copyOawSourceFiles(){
	infoCabecera "$copyOawSourceFiles_msgInfo_1"
	cd "$baseDir"
	ret=0
	cp "$iniDir/dependencias/oaw.tar.gz" .
	ret=$?
	tar -xf oaw.tar.gz
	let ret=$ret+$?
	if [ $ret -ne 0 ]; then
		echo "$copyOawSourceFiles_msgError_1"
		exit -1
	fi
	rm oaw.tar.gz
}

#docker install, instalamos la versión especificada. Seguramente funcione con la última también
function dockerInstall(){
	cd "$baseDir/oaw/motor-js/instalacion"
	if [ "$gestorPaquetes" == "apt-get" ]; then
		infoCabecera "$dockerInstall_msgInfo_1"
		sudo alien -i docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm
		if [ $? -ne 0 ]; then
			echo "$dockerInstall_msgError_1"
			exit -1
		fi
		infoCabecera "$dockerInstall_msgInfo_2"
		sudo alien -i docker-ce-17.03.2.ce-1.el7.centos.x86_64.rpm
		if [ $? -ne 0 ]; then
			echo "$dockerInstall_msgError_2"
			exit -1
		fi
	else
		infoCabecera "$dockerInstall_msgInfo_1"
		rpm -i install docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm
		if [ $? -ne 0 ]; then
			echo "$dockerInstall_msgError_1"
			exit -1
		fi
		
		infoCabecera "$dockerInstall_msgInfo_2"
		rpm -i install docker-ce-17.03.2.ce-1.el7.centos.x86_64.rpm
		if [ $? -ne 0 ]; then
			echo "$dockerInstall_msgError_2"
			exit -1
		fi
	fi
	
	#configurando el servicio para que se ejecute al inicio y arrancando el servicio ahora, para tenerlo disponible
	infoCabecera "$dockerInstall_msgInfo_3"
	ret=0
	systemctl enable docker.service	#habilita docker al arrancar el sistema
	ret=$?
	systemctl start docker #arranca el servicio docker ahora
	let ret=$ret+$?
	if [ $ret -ne 0 ]; then 
		echo "$dockerInstall_msgError_3"
		exit -1
	fi
	
}

function checkDockerVersion(){
	#comprobar la versión de docker
	infoCabecera "$checkDockerVersion_msgInfo_1"
	if [ $(docker --version | grep -i -c "17.03.2-ce") -ne 1 ]; then
		echo "$checkDockerVersion_msgError_1"
		docker --version
		exit -1
	fi 
}

function dockerComposeInstall(){
	#docker-compose. Repito el cd para tener claro donde está el fichero
	cd "$baseDir/oaw/motor-js/instalacion"
	infoCabecera "$dockerComposeInstall_msgInfo_1"
	cp docker-compose "$binaryDir"
	sudo chmod u+x,g+x "${binaryDir}/docker-compose"
	if [ $? -ne 0 ]; then
		echo "$dockerComposeInstall_msgError_1"
		exit -1
	fi
}

function checkDockerComposeVersion(){
	#comprobamos la versión de docker compose
	infoCabecera "$checkDockerComposeVersion_msgInfo_1"
	if [ $(docker-compose --version | grep -i -c "1.23.2") -ne 1 ]; then 
		echo "$checkDockerComposeVersion_msgError_1"
		docker-compose --version
		exit -1
	fi
}

function holdPackages(){
	#congelamos los paquetes de docker
	infoCabecera "$holdPackages_msgInfo_1"
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
function configureIpDns(){
	cd "${baseDir}/oaw/motor-js/nginx"

	datosCorrectos='n'
	while [ "$datosCorrectos" != 'y' ]; do
		echo -n "$msgQuestion1" ; read ipDnsExterior
		if [ ! -z "$ipDnsExterior" ]; then
			infoCabecera "$configureIpDns_msgInfo_1"
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
		echo "$configureIpDns_msgError_1"
		exit -1
	fi

	#borramos los certificados obsoletos, que vienen en los fuentes. Nginx recreará la carpeta, por si se quieren añadir
	cd "${baseDir}/oaw/motor-js/nginx/certs"
	rm -r *
}

#ejecución de docker-compose up
function executeDockerCompose(){
	cd "${baseDir}/oaw/motor-js"
	infoCabecera "$executeDockerCompose_msgInfo_1"
	#Si se ejecuta otra vez se necesita --force-recreate 
	docker-compose up -d --force-recreate
	if [ $? -ne 0 ]; then
		echo "$executeDockerCompose_msgError_1"
		echo "$executeDockerCompose_msgError_2"
		echo "$executeDockerCompose_msgError_3"
		echo "$executeDockerCompose_msgError_4"
		echo "$executeDockerCompose_msgError_5"
		exit -1
	fi
}

#instalación de mariadb-server
function mariadbInstall(){
	infoCabecera "$mariadbInstall_msgInfo_1"
	$gestorPaquetes install -y mariadb-server
	if [ $? -ne 0 ]; then
		echo "$mariadbInstall_msgError_1"
		exit -1
	fi
}

#se puede ejectuar todas las veces que se quiera, simplemente se actualiza o se crea otro usuario
function createAdminMariadb(){
	infoCabecera "$createAdminMariadb_msgInfo_1"
	askForUserPasswordDb
	mysql --user="root" --execute "GRANT ALL ON *.* TO "$newAdminDb"@'localhost' IDENTIFIED BY "\'$passwordDb\'" WITH GRANT OPTION;FLUSH PRIVILEGES;"
	if [ $? -ne 0 ]; then
		echo "$createAdminMariadb_msgError_1"
		exit -1
	fi 
}

#creación de la estructura de la bd
#para eliminar lo anterior
#sudo mysql -u root <<< "drop database OAW"

function createStructureDbOaw(){
	infoCabecera "$createStructureDbOaw_msgInfo_1"
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
		echo "$createStructureDbOaw_msgError_1"
		exit -1
	fi 
}

#alta de usuario administrador de la aplicación
function createUserApplicationOaw(){
	infoCabecera "$createUserApplicationOaw_msgInfo_1"
	datosCorrectos=""
	while [ "$datosCorrectos" != "y" ]; do 
		ApliUsuario=""
		ApliPassword=""
		ApliNombre=""
		ApliApellidos=""
		ApliDepartamento=""
		ApliEmail=""
		while [ -z "$ApliUsuario" ]; do
			echo -n "$createUserApplicationOaw_msgInfo_2" ;read ApliUsuario
		done
		while [ -z "$ApliPassword" ]; do
			echo -n "$createUserApplicationOaw_msgInfo_3" ;read ApliPassword
		done
		while [ -z "$ApliNombre" ]; do
			echo -n "$createUserApplicationOaw_msgInfo_4"; read ApliNombre
		done
		while [ -z "$ApliApellidos" ]; do
			echo -n "$createUserApplicationOaw_msgInfo_5"; read ApliApellidos
		done
		while [ -z "$ApliDepartamento" ]; do
			echo -n "$createUserApplicationOaw_msgInfo_6"; read ApliDepartamento
		done
		while [ -z "$ApliEmail" ]; do
			echo -n "$createUserApplicationOaw_msgInfo_7"; read ApliEmail
		done
		datosCorrectos=""
		while [ "$datosCorrectos" != 'n' ] && [ "$datosCorrectos" != 'y' ]; do
			echo -n "$msgQuestion2" ; read datosCorrectos
		done
	done
	#calculamos el hash y me quedo con éste
	ApliPassword=$(echo -n "$ApliPassword" | md5sum | cut -d' ' -f1)

	#actualizamos el administrador de la aplicación
	echo "$createUserApplicationOaw_msgInfo_8"
	mysql -u root OAW --execute "update usuario \
	set usuario='$ApliUsuario', \
	password='$ApliPassword', \
	nombre='$ApliNombre', \
	apellidos='$ApliApellidos', \
	departamento='$ApliDepartamento', \
	email='$ApliEmail' \
	where id_usuario=1;"
	if [ $? -ne 0 ]; then
		echo "$createUserApplicationOaw_msgError_1"
		exit -1
	fi
}

#instalación java
function javaInstall(){
	infoCabecera "$javaInstall_msgInfo_1"
	cd "$iniDir/dependencias"
	cp jdk-8u202-linux-x64.tar.gz $baseDir
	cd $baseDir
	tar -xf jdk-8u202-linux-x64.tar.gz
	if [ $? -ne 0 ]; then
		echo "$javaInstall_msgError_1"
		exit -1
	fi
	rm jdk-8u202-linux-x64.tar.gz
	echo "$javaInstall_msgInfo_2"
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
		echo "$javaInstall_msgError_2"
		exit -1
	fi
		
}

#instalación apache
function apacheTomcatInstall(){
	infoCabecera "$apacheTomcatInstall_msgInfo_1"
	cd "$iniDir/dependencias"
	cp apache-tomcat-7.0.107.tar.gz $baseDir
	cd $baseDir
	tar -xf apache-tomcat-7.0.107.tar.gz
	if [ $? -ne 0 ]; then
		echo "$apacheTomcatInstall_msgError_1"
		exit -1
	fi
	rm apache-tomcat-7.0.107.tar.gz
	echo "$apacheTomcatInstall_msgInfo_2"
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
		echo "$apacheTomcatInstall_msgError_2"
		exit -1
	fi

	echo $apacheTomcatInstall_msgInfo_3
	
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
		echo "$apacheTomcatInstall_msgError_3"
		exit -1
		
	fi

	echo "$apacheTomcatInstall_msgInfo_4"
	#copiamos la librería de mysql. Se ha descargado la ultima disponible de oracle
	ret=0
	cp "$iniDir/dependencias/mysql-connector-java-8.0.23.jar" "$baseDir/apache-tomcat-7.0.107/lib"
	ret=$?
	chmod u=rw,g=r,o= "$baseDir/apache-tomcat-7.0.107/lib/mysql-connector-java-8.0.23.jar"
	let ret=$ret+$?
	if [ $ret -ne 0 ]; then
		echo "$apacheTomcatInstall_msgError_4"
		exit -1
	fi

}

function apacheMavenInstall(){
	infoCabecera "$apacheMavenInstall_msgInfo_1"
	cd "$iniDir/dependencias"
	cp "apache-maven-3.6.3-bin.tar.gz" "$baseDir"
	cd $baseDir
	tar -xf apache-maven-3.6.3-bin.tar.gz
	if [ $? -ne 0 ]; then
		echo "$apacheMavenInstall_msgError_1"
		exit -1
	fi
	rm apache-maven-3.6.3-bin.tar.gz
	#para la sesión actual
	#export PATH=$baseDir/apache-maven-3.6.3/bin:$PATH
	setPathBinMaven
	
	echo "$apacheMavenInstall_msgInfo_2"
	if [ $(grep -i -c "export PATH=$baseDir/apache-maven-3.6.3/bin" "$envFile" ) -eq 0 ]; then
		echo export "PATH=$baseDir/apache-maven-3.6.3/bin:\$PATH" >> "$envFile"
	fi
	if [ $? -ne 0 ]; then
		echo $apacheMavenInstall_msgError_2
		exit -1
	fi

}

#preparación para compilar con maven y generar el oaw.war
function prepareForCompilation(){
	infoCabecera "$prepareForCompilation_msgInfo_1"
	#para tener acceso a los binarios de maven
	setPathBinMaven
	
	cp -r "$iniDir/dependencias/customMaven" "$baseDir"
	if [ $? -ne 0 ]; then
		echo "$prepareForCompilation_msgError_1"
		exit -1
	fi
	ret=0
	cp "$iniDir/build_oaw.sh" $binaryDir
	ret=$?
	chmod u+x,g+x $binaryDir/build_oaw.sh
	let ret=$ret+$?
	if [ $ret -ne 0 ]; then
		echo "$prepareForCompilation_msgError_2"
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
		echo "$prepareForCompilation_msgError_3"
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
		echo "$prepareForCompilation_msgError_4"
		exit -1
	fi

	ret=0
	cp "$iniDir/start_oaw.sh" $binaryDir
	ret=$?
	chmod u+x,g+x $binaryDir/start_oaw.sh
	let ret=$ret+$?
	if [ $ret -ne 0 ]; then
		echo "$prepareForCompilation_msgError_5"
		exit -1
	fi

	ret=0
	cp "$iniDir/stop_oaw.sh" $binaryDir
	ret=$?
	chmod u+x,g+x $binaryDir/stop_oaw.sh
	let ret=$ret+$?
	if [ $ret -ne 0 ]; then
		echo "$prepareForCompilation_msgError_6"
		exit -1
	fi
}

function endInstallation(){
	infoCabecera "$endInstallation_msgInfo_1"
	echo "$endInstallation_msgInfo_2"
	echo "$endInstallation_msgInfo_3"
	echo "$endInstallation_msgInfo_4"
	echo "$endInstallation_msgInfo_5"
	echo "$endInstallation_msgInfo_6"
	echo "$endInstallation_msgInfo_7"
	echo "$endInstallation_msgInfo_8"
}

#Ejecución de los pasos
function executeSteps(){

	#si es un execute, ejecutaremos sólo ese paso y saldremos
	if [ "$command" == "execute" ]; then
		if [ $step -gt 1 ]; then
			#este se va a necesitar casi siempre para saber cual es el gestor de paquetes. Se ejecuta en modo silencioso.
			detectPackageInstaller "True"
		fi
		#paso en concreto
		${listaFuncionesPasos[$step]}
	else
		#si es un resume, la variable $step estará informada, sino la variable $step tendrá 0 y se ejecutaran todos los pasos
		if [ "$command" == "resume" ]; then
			if [ $step -gt 1 ]; then
				#este se va a necesitar casi siempre para saber cual es el gestor de paquetes. Se ejecuta en modo silencioso.
				detectPackageInstaller "True"
			fi
		fi
		while [ $step -lt $totalSteps ]; do
			#nos apuntamos el paso que estamos haciendo
			echo "$step" > "$lastErrorFile"
			#ejecutamos el paso
			${listaFuncionesPasos[$step]}
			let step=$step+1
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

lastErrorFile="${iniDir}/.lastErrorInstall"

#array de funciones para ejecutar los pasos
#orden de los pasos a ejecutar
listaFuncionesPasos=(
createDirInstall
detectPackageInstaller
copyOawSourceFiles
mariadbInstall
createAdminMariadb
createStructureDbOaw
createUserApplicationOaw
javaInstall
apacheTomcatInstall
apacheMavenInstall
alienInstall
dockerDependency
dockerInstall
checkDockerVersion
dockerComposeInstall
checkDockerComposeVersion
holdPackages
configureIpDns
executeDockerCompose
prepareForCompilation
endInstallation
)

#número de paso. Debe concordar con lo anterior
#se hace así para no tener que estar llamando a setLanguaje continuamente cuando ejecuto el paso
createDirInstall_stepNum=0					#debe ser el 0
detectPackageInstaller_stepNum=1			#debe ser el 1

#Source files
copyOawSourceFiles_stepNum=2

#db
mariadbInstall_stepNum=3
createAdminMariadb_stepNum=4
createStructureDbOaw_stepNum=5
createUserApplicationOaw_stepNum=6

#java, tomcat, maven
javaInstall_stepNum=7
apacheTomcatInstall_stepNum=8
apacheMavenInstall_stepNum=9


#docker
alienInstall_stepNum=10
dockerDependency_stepNum=11
dockerInstall_stepNum=12
checkDockerVersion_stepNum=13
dockerComposeInstall_stepNum=14
checkDockerComposeVersion_stepNum=15
holdPackages_stepNum=16
configureIpDns_stepNum=17
executeDockerCompose_stepNum=18

#fin
prepareForCompilation_stepNum=19

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
step=0
command=""

#$2 puede ser resume o execute y $3 un número (el número de paso desde o a ejecutar)
if [ $# -gt 1 ]; then
	if [ "$2" != "resume" ] && [ "$2" != "execute" ]; then
		ayuda
	fi

	#resume desde donde dió el error
	#install.sh es resume
	if [ $# -eq 2 ] && [ "$2" == "resume" ]; then
		if [ -e "$lastErrorFile" ]; then
			step=$(cat "$lastErrorFile")
		else
			step=0
		fi
		
	else
		#comienza y termina por numero y hay al menos uno
		#resume o execute con paso
		re='^[0-9]+$'
		if ! [[ "$3" =~ $re ]] ; then
			ayuda 
		fi
		if [ $# -gt 3 ]; then
			ayuda
		fi 
		
		#el número de paso tiene que estar comprendido entre 0 y $totalSteps-1
		if [ $3 -lt 0 ] || [ $3 -ge $totalSteps ]; then
			#lo modificamos para mostrar correctamente el mensaje de error
			let totalSteps=$totalSteps-1
			echo "Parameter step number incorrect. Must be a number between 0 and $totalSteps."
			ayuda
		fi
		step="$3"
	fi
	command="$2"
else
	#nos han ejecutado normal ./install.sh es, pero ha habido una ejecución anterior fallida. ¿Preguntamos si quiere ejecutar desde el fallo?
	if [ -e "$lastErrorFile" ]; then
		
		if [ $lang == "es" ]; then
			preguntaResumir="Hay una ejecución anterior. ¿Quieres ejecutar desde donde falló? (y|n): "
		else 
			preguntaResumir="There is a previous execution. Do you want to run from where it failed? (y|n): "
		fi

		quieresResumir=""
		while [ "$quieresResumir" != 'n' ] && [ "$quieresResumir" != 'y' ]; do
			echo -n "$preguntaResumir" ; read quieresResumir
		done

		if [ "$quieresResumir" == 'y' ]; then
			#cargamos el paso
			step=$(cat "$lastErrorFile")
			command="resume" #para que lo coja la función executeSteps, y ejecute desde el paso
		fi
	fi
fi

#establecemos el lenguaje de los mensajes, errores, etc
setLanguaje

#ejecutamos el script según nos hayan requerido por la línea de comandos
executeSteps

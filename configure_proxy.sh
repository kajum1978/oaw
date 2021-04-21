#!/bin/bash

function ayuda(){
	echo "Use: $0 (languaje)"
	echo "examples:"
	echo "$0 es"
	echo "or"
	echo "$0 en"
	exit -1
}

function setLanguaje(){
	if [ "$lang" == "es" ]; then
        msgInfo1="Configuración del proxy para instalar oaw."
        msgInfo2="Proxy para conexiones http:"
        msgInfo3="Proxy para conexiones https:"
        msgInfo4="Puerto:"
        msgInfo4_1="Host:"
        msgInfo5="Creando el fichero /etc/systemd/system/docker.service.d/http-proxy.conf"
        msgInfo6="Creando el fichero /root/.docker/config.json"
        msgInfo7="Modificando el fichero /usr/local/share/oaw/apache-maven-3.6.3/conf/settings.xml"


        msgError1="Error al crear el fichero /etc/systemd/system/docker.service.d/http-proxy.conf"
        msgError2="Error al crear el fichero /root/.docker/config.json"
        msgError3="Error al modificar el fichero /usr/local/share/oaw/apache-maven-3.6.3/conf/settings.xml"

        msgQuestion1="¿Proxy para peticiones http:? ejemplo: http://10.1.0.222:8080/    : " 
        msgQuestion2="¿Proxy para peticiones https:? ejemplo: http://10.1.0.222:8080/   : "
        msgQuestion3="¿Son los datos correctos? (y|n): "

    elif [ "$lang" == "en" ]; then
       msgInfo1="Configuración del proxy para instalar oaw."
        msgInfo2="Proxy para conexiones http:"
        msgInfo3="Proxy para conexiones https:"
        msgInfo4="Puerto:"
        msgInfo4_1="Host:"
        msgInfo5="Creando el fichero /etc/systemd/system/docker.service.d/http-proxy.conf"
        msgInfo6="Creando el fichero /root/.docker/config.json"
        msgInfo7="Modificando el fichero /usr/local/share/oaw/apache-maven-3.6.3/conf/settings.xml"


        msgError1="Error al crear el fichero /etc/systemd/system/docker.service.d/http-proxy.conf"
        msgError2="Error al crear el fichero /root/.docker/config.json"
        msgError3="Error al modificar el fichero /usr/local/share/oaw/apache-maven-3.6.3/conf/settings.xml"

        msgQuestion1="¿Proxy para peticiones http:? ejemplo: http://10.1.0.222:8080/    : " 
        msgQuestion2="¿Proxy para peticiones https:? ejemplo: http://10.1.0.222:8080/   : "
        msgQuestion3="¿Son los datos correctos? (y|n): "
    fi
}


#sólo puede ser "en" or "es"
if [ -z "$1" ] || [ "$1" != "es" -a "$1" != "en" ]; then
		ayuda
fi 

lang="$1"
setLanguaje
datosCorrectos='n'
while [ "$datosCorrectos" != 'y' ]; do
    proxyHttp=""
    proxyHttps=""
    while [ -z "$proxyHttp" ];do
        echo -n "$msgQuestion1" ; read proxyHttp
    done
    while [ -z "$proxyHttps" ];do
        echo -n "$msgQuestion2" ; read proxyHttps
    done

    #extraemos el puerto
    proxyPort=$(echo "$proxyHttp" | rev | cut -d: -f1 | rev) #revese cut and reverse. Para el último campo con cut
    proxyPort=${proxyPort//[!0-9]/} #sólo me quedo con los número

    #extraemos el host
    proxyHost=$(echo $proxyHttp | cut -d'/' -f3 | cut -d':' -f1)

    echo "$msgInfo2 $proxyHttp"
    echo "$msgInfo3 $proxyHttps"
    echo "$msgInfo4 $proxyPort"
    echo "$msgInfo4_1 $proxyHost"
    
    echo -n "$msgQuestion3" ; read datosCorrectos
done

#For docker
echo "$msgInfo5"
ret=0
mkdir -p /etc/systemd/system/docker.service.d/
let ret=$ret+$?
cat >  /etc/systemd/system/docker.service.d/http-proxy.conf <<EOF
[Service]
Environment="HTTP_PROXY=$proxyHttp"
Environment="HTTPS_PROXY=$proxyHttps"
EOF
let ret=$ret+$?
if [ $ret -ne 0 ]; then
    echo "$msgError1"
    exit -1
fi

echo "$msgInfo6"
ret=0
mkdir -p /root/.docker
let ret=$ret+$?
cat > /root/.docker/config.json <<EOF
{
  "proxies": {
    "default": {
      "httpProxy": "http://10.1.0.222:8080/",
      "httpsProxy":  "http://10.1.0.222:8080/"
    }
  }
}
EOF
let ret=$ret+$?
if [ $ret -eq 0 ]; then
    systemctl daemon-reload
    systemctl restart docker
else
    echo "$msgError2"
    exit -1
fi


#For maven
echo "$msgInfo7"
ret=0
if [ ! -e "/usr/local/share/oaw/apache-maven-3.6.3/conf/settings.xml.back" ]; then
    mv "/usr/local/share/oaw/apache-maven-3.6.3/conf/settings.xml" "/usr/local/share/oaw/apache-maven-3.6.3/conf/settings.xml.back" 
    let ret=$ret+$?
fi
if [ $ret -eq 0 ]; then
    cadenaInsertar="\ \ \ \ <proxy>\n      <id>oaw</id>\n      <active>true</active>\n      <protocol>http</protocol>\n      <host>$proxyHost</host>\n      <port>$proxyPort</port>\n    </proxy>\n"
    sed "/^  <proxies>/a $cadenaInsertar" /usr/local/share/oaw/apache-maven-3.6.3/conf/settings.xml.back > /usr/local/share/oaw/apache-maven-3.6.3/conf/settings.xml
    let ret=$ret+$?
fi

if [ $ret -ne 0 ]; then
    echo "$msgError3"
fi


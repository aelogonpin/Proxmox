read -p "Escriba el nombre del usuario: " user1
read -p "Escriba algun comentario o dejalo en blanco: " comentario
#Generación de la contraseña
while true; do
    read -s -p "Ingresa una contraseña (minimo 8 caracteres): " pass
    echo
    if [ ${#pass} -ge 8 ]; then
        break
    else
        echo "La contraseña debe tener al menos 8 caracteres."
    fi
done

usuario="$user1"
aleatorio="$RANDOM"

# Concatena las dos cadenas de texto y almacena la cadena resultante en la variable "cadena3"
sentencia=$usuario-$aleatorio

echo "El usuario sera $user1 "

# Para crear usuario se realiza de esta manera
pveum useradd $user1@pve -comment "$comentario"  --password "$pass"

# Asigna una contraseña al usuario "user1"
#pveum passwd $user1@pve 

# Crea un nuevo pool de recursos llamado "pool1"
pveum pool add $sentencia --comment "$user1 pool"


# Asigna el pool "pool1" al usuario "user1"
pvesh set /access/acl  -path /pool/$sentencia -roles PVEVMAdmin -users "$user1@pve"

#Crear contenedor para usuario:
#pct create $aleatorio ubuntu /var/lib/vz/template/iso/ubuntu-20.04.1-standard_20.04.1-1_amd64.tar.gz

#Añadir almacenamiento al pool
pvesh set /pools/$sentencia --storage local-lvm

#Para clonar un contenedor

pct clone 113 --newid --name $aleatorio

#Añadir maquinas al pool
pvesh set /pools/$sentencia --vms $aleatorio

if [ $? -eq 0 ]
then 
echo "$User1. Ya esta creado y listo para su uso"
else
echo  "Algo esta mal"
fi

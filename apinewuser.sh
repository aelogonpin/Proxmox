#Generación de la contraseña


usuario="$1"
aleatorio="$RANDOM"

# Concatena las dos cadenas de texto y almacena la cadena resultante en la variable "cadena3"
sentencia=$usuario-$aleatorio

echo "<h3> El usuario será $1. </h3>"

# Para crear usuario se realiza de esta manera
pveum useradd $1@pve -comment "$3"  --password "$2"
#echo "<h3> Su contraseña sera $2 </h3>"

# Crea un nuevo pool de recursos llamado "pool1"
pveum pool add $sentencia --comment "$1 pool"

# Asigna el pool "pool1" al usuario "user1"
pvesh set /access/acl  -path /pool/$sentencia -roles PVEVMAdmin -users "$1@pve"


#Añadir almacenamiento al pool
pvesh set /pools/$sentencia --storage local-lvm

#Para clonar un contenedor

pct clone 113 --newid --name $aleatorio

#Añadir maquinas al pool
pvesh set /pools/$sentencia --vms $aleatorio

if [ $? -eq 0 ]
then 
echo "<h4>$1 ya esta creado y listo para su uso. </h4>"
else
echo  "Algo esta mal"
fi

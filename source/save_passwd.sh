function save_passwd(){
     # Notas del fichero
        # VARS: username (${1})
        # VARS: password (${2})

    destination="/root/user_credentials/${username}"

    if [ ! -f ${destination} ]; then
        touch ${destination}
    fi

    echo ${1} >> ${destination}
}
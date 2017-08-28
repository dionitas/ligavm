#!/bin/bash
#Script para ligar o ambiente para o curso JBOSS 4Linux

infra(){

    echo "INFRA"
    #infra 4Linux Jboss
    echo "Iniciando Firewall Dexter"
    /usr/bin/vboxmanage startvm 7c5f784e-0fc6-4b32-bfdb-14ea5d58d9f8 --type headless >> /dev/null
    sleep 5
    echo "Iniciando Gateway VLAN"
    /usr/bin/vboxmanage startvm c0c5d428-b619-4166-9dfc-066577aadc41 --type headless >> /dev/null
    sleep 3
    echo "Iniciando Monitoring Server"
    /usr/bin/vboxmanage startvm a6cf9ce6-4690-4640-87e6-e7b48438ce2d --type headless >> /dev/null
}

desligaAmbiente(){

   #Verifica as vm's que estão em execução e desliga todas.
   vboxmanage list runningvms | awk -v FS="({|})" '{print $2}' | xargs -L1 -I {} vboxmanage controlvm {} poweroff
}

devOps1(){

    echo "DevOps1"
    #balancer 1
    vboxmanage startvm f58b7cb2-7717-4767-9703-199842c0d7eb --type headless >> /dev/null
    #Jboss1
    vboxmanage startvm dedfc78c-563b-4a3c-b670-468d3c2d6173 --type headless >> /dev/null
    #Jboss2
    vboxmanage startvm f75eb771-1e68-4ee6-8ba7-15018b238f92 --type headless >> /dev/null
    #DB 1
    vboxmanage startvm 166f1b49-1e9b-47ac-9e07-09855f306f8e --type headless >> /dev/null
}


devOps2(){

    echo "DevOps2"
    #DB 2
    vboxmanage startvm 69b590cc-b620-4efa-8e76-756aeeaddedf --type headless

}

devOps3(){

    echo "devOps3"
    #balancer2
    vboxmanage startvm 1bf9d2c1-bdc4-44c1-b141-07af5c5e9c22 --type headless
    #Jboss 3
    vboxmanage startvm e4a8b5cc-bcc8-400c-9070-e53caf07176b --type headless
    #Jboss 4
    vboxmanage startvm e787476b-bbf3-4b8a-b4c3-7126832716ad --type headless
    #DB3
    vboxmanage startvm 91d0423e-e69b-46b5-aaf4-062f9afe0758 --type headless
}


ligaAmbiente(){

    infra

    if [ $PARM2 -eq 3 ]; then
        devOps1
    elif [ $PARM2 -eq 4 ]; then
        devOps2
    elif [ $PARM2 -eq 5 ]; then
        devOps3
    fi

}

main(){

    if [ $PARM1 -eq 1 ]; then
        ligaAmbiente
    else
        desligaAmbiente
    fi

}
if [ $# -ge 3 ] || [ $# -eq 0 ]; then
    clear
    echo "Informe 1 ou 2 parâmetros! "
    echo ""
    echo "1) para ligar Infra JBOSS"
    echo "3) para iniciar ambiente ambiente DevOps1"
    echo "4) para iniciar ambiente ambiente DevOps2"
    echo "5) para iniciar ambiente ambiente DevOps3"
    echo "9) para desligar TODO ambiente JBOSS"
else
    PARM1=$1
    if [ -z $2 ]; then
        PARM2=0
        echo "dentro fi"
    else
        PARM2=$2
        echo "dentro else"
    fi
    main
fi

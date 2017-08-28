 #!/bin/bash

#Script para verificar se as VM estão rodando corretamente devido a falha física no HD ele fica desmontando.

vms=$(vboxmanage list vms | awk -v FS="({|})" '{print $2}')
TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
LOG=/var/log/vm_running.log

echo "" >> ${LOG}
echo $TIMESTAMP >> ${LOG}
echo "" >> ${LOG}

vm_running(){
    for vm in $vms; do
        state=$(vboxmanage showvminfo $vm | grep State | awk '{print $2}')
        vm_name=$(vboxmanage showvminfo $vm | head -n 1 | awk '{print $2}')

        if [ $state == "paused" ]; then
            vboxmanage controlvm $vm resume >> ${LOG}
            echo "Alterado vm" $vm_name "de" $state "para running" >> ${LOG}
        elif [ $state == "aborted" ]; then
            vboxmanage startvm $vm --type headless >> ${LOG}
            echo "Alterado vm" $vm_name "de" $state "para running" >> ${LOG}
        fi
    done
}

montagem(){
    #Lista a quantidade de vms com status 'aborted' e chama a função liga-las.
    state=$(vboxmanage list vms -l | grep aborted | wc -l)
    if [ $state -ne 0 ]; then
        sudo mount -a >> ${LOG}
    fi
}

vm_running
montagem


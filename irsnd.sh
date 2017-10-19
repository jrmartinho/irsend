 
#!/usr/bin/sh
#
# irsnd.sh
#

if [ $# -eq 0 ]; then  # roda interativamente

  V_REMOTE=""
  V_COMANDO=""
  V_OPT="100"
  V_REM=(TV TVIR MXT9800L AQUARIO VCR VCR_LG)
  let "V_REM_TAMANHO=${#V_REM[@]}+1"

  while [ $((V_OPT)) = 100 ]; do
    until [ $V_OPT -lt $V_REM_TAMANHO  ]
      do  
        echo "============================="
        echo "    Escolha o dispositivo:"
        echo "============================="
        echo ""
        count=0
        for N in ${V_REM[@]} ; do
          count=$((count+1))
          echo "[$count] - $N"
        done
        echo ""
        echo "[222] - Desligar Computador"
        echo ""
        echo "[0] - Sair"
        echo "============================="
        read V_OPT
        echo ""
        if [ $((V_OPT)) = 0 ] ; then
          exit 0
        elif [ $((V_OPT)) = 222 ] ; then
          echo ""
          echo " DESEJA REALMENTE DESLIGAR O COMPUTADOR?"
          echo " yes/no "
          read V_YN
          if [ $V_YN = "yes" ] ; then
#             shutdown -h now
             echo "comando shutdown"
             exit 0
          fi
        fi 
      done # Escolheu REMOTE se V_OPT < qtd cadastrada 

      V_REMOTE=${V_REM[$((V_OPT-1))]} 
      echo "Escolhido foi $V_OPT - ${V_REMOTE}"
      echo ""
#      echo "FIM REMOTE"
      # Carrega array do REMOTE e retorna tamanho do Array

      case $V_OPT in
# TV
        1) V_COM=(1 2 3 4 5 6 7 8 9 0 INPUT CH+ CH- VOL- VOL+ MUTE MENU EXIT PIP SWAP SLEEP ENTER REC REW PLAY FF RECBLUE STOP PAUSE ON/OFF) ;;
# TVIR
        2) V_COM=(KEY_1 KEY_2 KEY_3 KEY_4 KEY_5 KEY_6 KEY_7 KEY_8 KEY_9 KEY_0 KEY_POWER KEY_TV KEY_SUBTITLE KEY_TEXT KEY_CYCLEWINDOWS DEMO SCENEA KEY_YELLOW AD KEY_HOME KEY_INFO KEY_OPTION KEY_UP KEY_LEFT KEY_OK KEY_RIGHT KEY_DOWN KEY_BACK KEY_INFO KEY_REWIND KEY_PLAY KEY_FORWARD KEY_STOP KEY_RECORD KEY_VOLUMEUP KEY_VOLUMEDOWN KEY_MUTE FORMAT KEY_CHANNELUP KEY_CHANNELDOWN SOUND PICTURE) ;;
# MXT9800L
        3) V_COM=(1 2 3 4 5 6 7 8 9 0 MUTE ON/OFF CH+ CH- VOL- VOL+ LOCK STORE BW SKEW MENU POLAR TIMER AFT/HOUR) ;;
# AQUARIO
        4) V_COM=(1 2 3 4 5 6 7 8 9 0 STANDBY TV/RADIO MUTE FAVOURITE GOTO EXIT RECALL INFO MENU OK VOL+ VOL- CH+ CH- EPG V-FORMAT AUDIO CC REV FWD PREV NEXT REPEAT STOP PAUSE PLAY BLUE YELLOW GREEN RED) ;;
# VCR
        5) V_COM=(1 2 3 4 5 6 7 8 9 0 ON/OFF CH+ CH- MENU EXIT REC REW PLAY FF RECBLUE STOP PAUSE ENTER PIP INPUT AUDIO) ;;
# VCR_LG
        6) V_COM=(KEY_1 KEY_2 KEY_3 KEY_4 KEY_5 KEY_6 KEY_7 KEY_8 KEY_9 KEY_0 KEY_POWER KEY_EJECTCD KEY_MENU KEY_CLEAR CmSkip KEY_OK KEY_CHANNELUP KEY_CHANNELDOWN KEY_VOLUMEDOWN KEY_VOLUMEUP LP KEY_STOP KEY_PAUSE KEY_RECORD Reverse KEY_PLAY KEY_FORWARD EzPoweroff EzRepeat) ;;

      esac
      
      V_OPT=1000
      let "V_COM_TAMANHO=${#V_COM[@]}+1"

      while [ $((V_OPT)) = 1000 ]; do
        until [ $((V_OPT)) -lt $((V_COM_TAMANHO)) ]
          do  
            echo "======================================="
            echo "    Escolha o comando:"
            echo "======================================="
            echo ""
            count=0
            for N in ${V_COM[@]} ; do
              count=$((count+1))
              echo "[$count] - $N"
            done
            echo ""
            echo "[0] - Escolher outro Controle Remoto" 
            echo "======================================"
	    read V_OPT
            echo ""
#	    echo "=== $V_OPT === ${#V_OPT} ===$((${#V_OPT})) ==="
            if [ ${#V_OPT} = 0 ] ; then
              V_OPT=$V_OPT_ANTERIOR
#              echo "=== $V_OPT === ${#V_OPT} ==="
            fi
            V_OPT_ANTERIOR=$V_OPT
          done # Sai se for menor do que a qtde do array
          if [ $((V_OPT)) = 0 ] ; then # Escolheu novo Controle
            V_OPT="100"
          else                         # Escolheu comando 
            V_COMANDO=${V_COM[$((V_OPT-1))]} 
            echo ""
#            echo "Comando escolhido foi $V_OPT - ${V_COMANDO}"
            echo "Comando: [irsend SEND_ONCE $V_REMOTE $V_COMANDO]"
            irsend SEND_ONCE $V_REMOTE $V_COMANDO
            echo ""
#            read V_OPT
	    V_OPT=1000
          fi
      done      # Novo Comando se 1000 
  done      # se V_OPT=100 volta a escolha do REMOTE

else
  echo
fi
#while getopts "he" OPTION; do
#        case $OPTION in
#
#                e)
#                        ECHO="true"
#                        ;;
#
#                h)
#                        echo "Usage:"
#                        echo "args.sh -h "
#                        echo "args.sh -e "
#                        echo ""
#                        echo "   -e     to execute echo \"hello world\""
#                        echo "   -h     help (this output)"
#                        exit 0
#                        ;;
#
#        esac
#done

#if [ $ECHO = "true" ]
#then
#        echo "Hello world";
#fi

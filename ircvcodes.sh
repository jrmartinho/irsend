#!/bin/bash
#
# Uso:   Converte Controles remotos e comandos do arquivo de
#        configuracao do LIRC lircd.conf para serem
#        utilizados no programa irsnd.sh bastando substituir
#        as linhas geradas no script.
#
#        Este script le o arquivo de configuracao em
#        /etc/lirc/lircd.conf e gera o arquivo irsnd.txt no
#        diretorio corrente
#
# Exemplo: ircvcodes.sh
#        
# Autor:  Joao Martinho
#
# Versao: 20160919
#---------------------------------------------------------
#
#
#
#Input file
_if="/etc/lirc/lircd.conf"
#_if=lircd.conf

#Output file
_of="irsnd.txt"

_bremote=0
_bcode=0
_brawcode=0
_remote=""
_vrem=""
_numremote=0
_comando=""
_numcomando=0

# If file exists 
if [[ -f "$_if" ]]
then
    printf '#================================================\n#  Gerado com o script [ircvcodes.sh]\n#================================================\n\n' > $_of
    printf '#================================================\n#  Gerado com o script [ircvcodes.sh]\n#================================================\n\n'
    # read it
    while IFS=' ' read -r f1 f2 f3 f4 f5 f6 f7
    do
#
# Atribui _bremote, _bcode e _brawcode
#
# Inicio begin remote  
        if [[ $f1 == "begin" && $f2 == "remote" ]]
        then
           if [[ $_bremote = 0 ]]
             then
               _bremote=1
             else
               echo "Erro: -bremote > 1"
           fi
         fi
# Inicio end remote  
        if [[ $f1 = "end" && $f2 = "remote" ]]
        then
           if [[ $_bremote = 1 ]]
             then
               _bremote=0
               _remote=""
             else
               echo "Erro: -bremote > 0"
           fi
         fi
# Inicio begin codes  
        if [[ $f1 = "begin" && $f2 = "codes" ]]
        then
           if [[ $_bremote = 1 && $_bcode = 0 ]]
             then
               _bcode=1
             else
               echo "Erro: -bcode > 1"
           fi
         fi
# Inicio end codes  
        if [[ $f1 = "end" && $f2 = "codes" ]]
        then
           if [[ $_bremote = 1 && $_bcode = 1 ]]
             then
               _comando="$_comando) ;;"
        printf '# %s\n' "$_remote"
        printf '%s\n' "$_comando"
        printf '# %s\n' "$_remote" >> $_of
        printf '%s\n' "$_comando" >> $_of
               _bcode=0
               _numcomando=0
               _comando=""
             else
               echo "Erro: -bcode > 0"
           fi
         fi
# Inicio begin raw_codes  
        if [[ $f1 = "begin" && $f2 = "raw_codes" ]]
        then
           if [[ $_bremote = 1 && $_brawcode = 0 ]]
             then
               _brawcode=1
             else
               echo "Erro: -brawcode > 1"
           fi
         fi
# Inicio end raw_codes  
        if [[ $f1 = "end" && $f2 = "raw_codes" ]]
        then
           if [[ $_bremote = 1 && $_brawcode = 1 ]]
             then
               _comando="$_comando) ;;"
        printf '# %s\n' "$_remote"
        printf '%s\n' "$_comando"
        printf '# %s\n' "$_remote" >> $_of
        printf '%s\n' "$_comando" >> $_of
               _brawcode=0
               _numcomando=0
               _comando=""
             else
               echo "Erro: -brawcode > 0"
           fi
         fi
#
# Pega nome dos remotes
#
        if [[ $f1 = "name" && $_bremote = 1 && "x$_remote" = "x" ]] ####&& $_remote = "" ]]
        then
          if [[ "x$f2" != "x" ]]
            then
               _numremote=$(($_numremote+1))
               _remote=$f2
            if [[ $_numremote = 1 ]]
            then
              _vrem="  V_REM=($_remote"
            else
              _vrem="$_vrem $_remote"
            fi
          fi
        fi
#
# Pega nome dos comandos normais
#
        if [[ "$f1" != "name" && "x$f1" != "x" && $_bremote = 1 && $_bcode = 1 ]]
        then
          if [[ "$f2" != "codes" && "x$f2" != "x" ]]
          then
            _numcomando=$(($_numcomando+1))
            if [[ $_numcomando = 1 ]]
            then
              _comando="        $_numremote) V_COM=($f1 "
            else
              _comando="$_comando $f1"
            fi
          fi
        fi
#
# Pega nome dos comandos raw
#
        if [[ "$f1" = "name" && $_bremote = 1 && $_brawcode = 1 ]]
        then
          if [[ "x$f2" != "x" ]]
          then
            _numcomando=$(($_numcomando+1))
            if [[ $_numcomando = 1 ]]
            then
              _comando="        $_numremote) V_COM=($f2 "
            else
              _comando="$_comando $f2"
            fi
          fi
        fi
    done <"$_if"
#
# fecha e grava a linha com os remotes    
#
    if [[ $_numremote > 0 ]]
    then
      _vrem="$_vrem)"
    printf '\n#================================================\n'
    printf '%s\n' "$_vrem"
    printf '#================================================\n\n'
    printf '\n%s\n\n' "$_vrem" >> $_of
    printf '#================================================\n' >> $_of
     fi
else
    echo "Arquivo de entrada $_if nao encontrado..."
fi 

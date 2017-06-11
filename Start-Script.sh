#green Message
function greenMessage {
    echo -e "\\033[32;1m${@}\033[0m"
}
#red Message
function redMessage {
    echo -e "\\033[31;1m${@}\033[0m"
}

#okAndSleep
function okAndSleep {
    greenMessage $1
    sleep 1
}

#errorAndContinue
function errorAndContinue {
    redMessage "Invalid option."
    continue
}

#CheckInstall
function checkInstall {
    if [ "`dpkg-query -s $1 2>/dev/null`" == "" ]; then
        okAndSleep "Installing package $1"
        #apt-get install -y $1
        INSTALLED=false
    else
        INSTALLED=true
   fi
}

#Root Passwort
greenMessage "Soll ein neues Root Passwort gesetzt werden oder der Root Account aktiviert werden?"
OPTIONS=("Ja" "Nein")
select ROOT in "${OPTIONS[@]}"; do
                case "$REPLY" in
                1|2 ) break;;
                *) errorAndContinue;;
                esac
done

if [ "$ROOT" == "Ja" ]; then
        greenMessage "Bitte setzten sie ein neues Passwort für den Root Account."
        passwd root
fi

#Update durchführen
greenMessage "Sollen Linux Updates Installiert werden?"
OPTIONS=("Ja" "Nein")
select UPDATE in "${OPTIONS[@]}"; do
                case "$REPLY" in
                1|2 ) break;;
                *) errorAndContinue;;
                esac
done

if [ "$UPDATE" == "Ja" ]; then
        greenMessage "Updates werden Installiert"
        apt -y update 
        apt -y upgrade
fi

#FTP-Server installation
greenMessage "Soll ein FTP-Server installiert werden?"
OPTIONS=("Ja" "Nein")
select FTP in "${OPTIONS[@]}"; do
                case "$REPLY" in
                1|2 ) break;;
                *) errorAndContinue;;
                esac
done

if [ "$FTP" == "Ja" ]; then
        checkInstall vsftpd
        if [ "$INSTALLED" == false ]; then
        INSTALLED=true
        greenMessage "Der FTP-Server wird installiert."
        sleep 2
        apt-get install --yes vsftpd
        fi
fi

#SSH-Server installieren
greenMessage "Soll ein SSH-Server installiert werden?"

OPTIONS=("Ja" "Nein")
select SSH in "${OPTIONS[@]}"; do
                case "$REPLY" in
                1|2 ) break;;
                *) errorAndContinue;;
                esac
done

if [ "$SSH" == "Ja" ]; then
    checkInstall openssh-server
        if [ "$INSTALLED" == false ]; then
            INSTALLED=true
            greenMessage "Der SSH-Server wird installiert."
            sleep 2
            apt-get install --yes openssh-server
        fi
fi

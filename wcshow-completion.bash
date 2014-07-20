_wcshow_complete(){

    USER_LOGIN=$USER
    HAS_WCNAME=0
    HAS_PROJECT=0
    HAS_USER=0

    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}" #получаем текущий вводимый аргумент
    PROJECTS="images2 images3 video2 video3 web3 images_touch_phone video_touch_phone"

    # Проверяем уже имеющиеся параметры
    for index in ${!COMP_WORDS[*]}
    do
        param=${COMP_WORDS[$index]}

        if [[ $param != $cur ]]
        then
            if [[ $param != "-s" && $param != "--status" ]]
            then
                if [ -d /home/$param/ ]
                then
                    USER_LOGIN=$param
                    HAS_USER=1
                else
                    if [ -d /home/$USER_LOGIN/$param ]
                    then
                        HAS_WCNAME=1
                    else
                        for proj in ${PROJECTS}
                        do
                            [[ $proj == $param ]] && HAS_PROJECT=1
                        done
                    fi
                fi
            fi
        fi
    done;

    # Выбираем все каталоги в домашней директории пользователя
    DIRECTORIES=`ls -d /home/${USER_LOGIN}/*/`
    DIRECTORIES=${DIRECTORIES//\/home\/$USER_LOGIN\//}
    DIRECTORIES=${DIRECTORIES//\//}
    # Получаем список пользователей
    USERS=`ls -d /home/*/`
    USERS=${USERS//\/home\//}
    USERS=${USERS//\//}

    subcommands=""

    # Подмешиваем пользователей в подсказки
    [[ $HAS_USER == 0 && $HAS_WCNAME == 0 ]] && subcommands="${subcommands} ${USERS}"

    # Подмешиваем каталоги пользователя в подсказки
    [[ $HAS_WCNAME == 0 ]] && subcommands="${subcommands} ${DIRECTORIES}"

    # Подмешиваем названия проектов в подсказки
    [[ $HAS_PROJECT == 0 ]] && subcommands="${subcommands} ${PROJECTS}"

    COMPREPLY=( $(compgen -W "${subcommands}" -- ${cur}) ) #some magic

    return 0
}

complete -F _wcshow_complete wcshow

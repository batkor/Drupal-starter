#!/bin/bash

#<----------START FUNCTIONS BLOCK------------>
# Function check project directory and if need create directory.
check_folder(){
    
    if [ ! -d "$1" ]; then
        echo -n "Каталог не существует, хотите добавить?(Y/n)"
        read is_create
        case "$is_create" in
            y|Y|"") 
                echo -e "Создание каталога для проекта..."
                mkdir -p $1 
                if [ $? -eq 0 ]; then
                    $SETCOLOR_SUCCESS
                    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[OK]"
                    $SETCOLOR_NORMAL
                    echo
                else
                    $SETCOLOR_FAILURE
                    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[fail]"
                    $SETCOLOR_NORMAL
                    echo
                    exit 1
                fi
                ;;
            n|N|*) 
                echo "Каталог указан не верно. Выход"
                exit 1
                ;;
        esac
    fi
}

# Function return path to project.
get_path_project(){
    read  -e -p "Введите путь до нового проекта или оставьте пустым:`echo $'\n> '`" folder
    case "$folder" in
        "") folder=${PWD} ;;
    esac
    
    folder=$(eval readlink -f "$folder")
    
    echo $folder
}

# Function return name project. Or current directory name or inputted text.
get_project_name(){
    read -p "Введите имя проекта или оставьте пустым:`echo $'\n> '`" project_name
    case "$project_name" in
        "") project_name=${PWD##*/} ;;
    esac
    echo $project_name
}

# Parh for get last realese version.
d4d_last_version(){
 curl https://github.com/wodby/docker4drupal/releases/latest | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+"
}

#<----------END FUNCTIONS BLOCK------------>


# Set path project for install.
folder=$(get_path_project)
check_folder $folder
# Set project name. Used name in docker.
project_name=$(get_project_name)
# Set latest vesion for Docker4Drupal
d4d_version=$(d4d_last_version)

# Warning message.
echo "Путь до проекта: "$folder"; (Проект будет установлен в данную деректорию)"
echo "Имя проекта: "$project_name"; (Данное имя будет указано в .env файле Docker4Drupal)"

cd $folder
rm -rf {.,}*

#Download docker4Drupal.
wget -N -P $folder https://github.com/wodby/docker4drupal/releases/download/$d4d_version/docker4drupal.tar.gz
tar -xvf docker4drupal.tar.gz

# Correct project directory.
rm -rf docker4drupal.tar.gz
rm -rf docker-sync.yml

# Set project name in .env file
sed -i "s/my_drupal8_project/"$project_name"/" $folder/.env
sed -i "s/drupal.docker/"$project_name"/" $folder/.env

# Change port. 
read -p "Введите номер порта или остаьте пустым:`echo $'\n> '`" port_name
case "$port_name" in
    "") echo "Порт: 8000" ;;
    *) 
        if [[ "$port_name" =~ ^[0-9]+$ ]]; then
            sed -i "s/8000/"$port_name"/" $folder/docker-compose.yml
            echo "Порт: "$port_name
        else
            echo "Не корректный номер порта: "$port_name
        fi
    ;;
esac

# Get docker-compose override file.
wget -O docker-compose.override.yml 'https://gitlab.com/batkor/ease/raw/master/docker-compose.override.yml'

# Get default files.
wget 'https://gitlab.com/batkor/ease/raw/master/composer.json'
wget 'https://gitlab.com/batkor/ease/raw/master/.gitconfig'
wget 'https://gitlab.com/batkor/ease/raw/master/.gitignore'

# Result message.
echo 'Installed in: '$folder
echo 'Project name: '$project_name
echo 'Docker4Drupal version: '$d4d_version

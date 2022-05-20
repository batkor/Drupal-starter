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
        "") project_name=$(basename $1) ;;
    esac
    echo $project_name
}

#<----------END FUNCTIONS BLOCK------------>

# Set path project for install.
folder=$(get_path_project)
check_folder $folder
# Set project name. Used name in docker.
project_name=$(get_project_name "$folder")
# Warning message.
echo "Путь до проекта: $folder; (Проект будет установлен в данную деректорию)"
echo "Имя проекта: $project_name; (Данное имя будет указано в .env файле Docker4Drupal)"

cd $folder || exit
find . -mindepth 1 -delete

#Download docker4Drupal.
curl -OJL https://github.com/wodby/docker4drupal/releases/latest/download/docker4drupal.tar.gz
tar -xvf docker4drupal.tar.gz

# Correct project directory.
rm -rf docker4drupal.tar.gz
rm -rf docker-sync.yml

# Set project name in .env file
sed -i "s/my_drupal9_project/$project_name/" $folder/.env
sed -i "s/drupal.docker/$project_name/" $folder/.env

# Get docker-compose override file.
curl -OJ https://raw.githubusercontent.com/batkor/Drupal-starter/main/docker-compose.override.yml

# Change port.
echo "Введите номер порта или оставьте пустым:"
read -r port_name
case "$port_name" in
    ""  ) echo "Порт: 8000" ;;
    *   )
        if [[ "$port_name" =~ ^[0-9]+$ ]]; then
            sed -i "s/8000/$port_name/" $folder/docker-compose.override.yml
            echo "Порт: $port_name"
        else
            echo "Не корректный номер порта: $port_name"
        fi
    ;;
esac

# Create default files and folder.
mkdir ./code && cd ./code || exit
curl -OJ 'https://raw.githubusercontent.com/batkor/Drupal-starter/main/composer.json'
curl -OJ 'https://raw.githubusercontent.com/batkor/Drupal-starter/main/.gitignore'
curl -OJ 'https://raw.githubusercontent.com/batkor/Drupal-starter/main/phpcs.xml'
curl -OJ 'https://raw.githubusercontent.com/batkor/Drupal-starter/main/phpunit.xml'

# Result message.
# Get Docker4Drupal version.
d4d_version=$(curl -I https://github.com/wodby/docker4drupal/releases/latest | grep location: | sed 's#.*/##')
echo "Installed in: $folder"
echo "Project name: $project_name"
echo "Docker4Drupal version: $d4d_version"

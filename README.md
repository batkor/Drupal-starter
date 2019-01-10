# Быстрое развертывание DrupalProject в d4d
1. Создание папки ```mkdir drupal8```
2. Переходим в созданную папку ```cd drupal8```
3. Разворачивачивает последнюю версию Docker4Drupal, скачиваем Drupal-project, запускаем docker compose и устанавливаем composer пакеты. DockerCompose должен быть установлен.
###### Если есть алиас composer
```wget -qO- https://gitlab.com/batkor/ease/raw/master/d8_builder.sh | bash && docker-compose up -d && composer install```
###### Если нет алиаса
```wget -qO- https://gitlab.com/batkor/ease/raw/master/d8_builder.sh | bash && docker-compose up -d && docker-compose exec php composer install```

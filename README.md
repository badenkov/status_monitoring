# Тестовое задание

Для настройки рабочего окружения используется инструмент [devenv](https://devenv.sh/getting-started/)
и [direnv](https://direnv.net/).

* `devenv` - Помогает в декларативной форме описывать рабочее окружение - устанавливать все необходимые зависимости, сервисы и т.п.
* `direnv` - Позволяет автоматически загружать рабочее окружение при переходе в директорию с проектом. Без него бы приходилось вызывать команду `devenv shell` в ручную.

То есть для установки всех необходимых зависимостей необходимо клонировать репозиторий

```
git clone git@github.com:badenkov/status_monitoring.git
cd status_monitoring
direnv allow
```

Затем необходимо установить зависимости

```
bundle install
bin/rails db:setup
```

и можно запустить проект.

```
bin/dev
```

и открыть проект в браузере `http://localhost:3000`




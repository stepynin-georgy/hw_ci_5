# Домашнее задание к занятию 12 «GitLab»

## Подготовка к выполнению


1. Или подготовьте к работе Managed GitLab от yandex cloud [по инструкции](https://cloud.yandex.ru/docs/managed-gitlab/operations/instance/instance-create) .
Или создайте виртуальную машину из публичного образа [по инструкции](https://cloud.yandex.ru/marketplace/products/yc/gitlab ) .

Создал инстанс gitlab по первой инструкции:

![изображение](https://github.com/stepynin-georgy/hw_ci_5/blob/main/img/Screenshot_70.png)

![изображение](https://github.com/stepynin-georgy/hw_ci_5/blob/main/img/Screenshot_71.png)

3. Создайте виртуальную машину и установите на нее gitlab runner, подключите к вашему серверу gitlab  [по инструкции](https://docs.gitlab.com/runner/install/linux-repository.html) .

<details><summary>Установка gitlab-runner</summary>

```
root@gitlab-runner:/home/user# curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash

  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  6885  100  6885    0     0  17793      0 --:--:-- --:--:-- --:--:-- 17836
Detected operating system as Ubuntu/noble.
Checking for curl...
Detected curl...
Checking for gpg...
Detected gpg...
Running apt-get update... done.
Installing apt-transport-https... done.
Installing /etc/apt/sources.list.d/runner_gitlab-runner.list...done.
Importing packagecloud gpg key... done.
Running apt-get update... done.

The repository is setup! You can now install packages.
root@gitlab-runner:/home/user# sudo apt-get install gitlab-runner
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Suggested packages:
  docker-engine
The following NEW packages will be installed:
  gitlab-runner
0 upgraded, 1 newly installed, 0 to remove and 24 not upgraded.
Need to get 500 MB of archives.
After this operation, 568 MB of additional disk space will be used.
Get:1 https://packages.gitlab.com/runner/gitlab-runner/ubuntu noble/main amd64 gitlab-runner amd64 17.4.0-1 [500 MB]
Fetched 500 MB in 7s (68.1 MB/s)
Selecting previously unselected package gitlab-runner.
(Reading database ... 121540 files and directories currently installed.)
Preparing to unpack .../gitlab-runner_17.4.0-1_amd64.deb ...
Unpacking gitlab-runner (17.4.0-1) ...
Setting up gitlab-runner (17.4.0-1) ...
GitLab Runner: creating gitlab-runner...
Home directory skeleton not used
Runtime platform                                    arch=amd64 os=linux pid=3110 revision=b92ee590 version=17.4.0
gitlab-runner: the service is not installed
Runtime platform                                    arch=amd64 os=linux pid=3124 revision=b92ee590 version=17.4.0
gitlab-ci-multi-runner: the service is not installed
Runtime platform                                    arch=amd64 os=linux pid=3143 revision=b92ee590 version=17.4.0
Runtime platform                                    arch=amd64 os=linux pid=3241 revision=b92ee590 version=17.4.0
INFO: Docker installation not found, skipping clear-docker-cache
Scanning processes...
Scanning linux images...

Running kernel seems to be up-to-date.

No services need to be restarted.

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.
root@gitlab-runner:/home/user#
```
</details>

<details><summary>Регистрация gitlab-runner</summary>

```
root@gitlab-runner:/home/user# gitlab-runner register  --url https://hw-netology-ci.gitlab.yandexcloud.net  --token ########################
Runtime platform                                    arch=amd64 os=linux pid=9380 revision=b92ee590 version=17.4.0
Running in system-mode.

Enter the GitLab instance URL (for example, https://gitlab.com/):
[https://hw-netology-ci.gitlab.yandexcloud.net]:
Verifying runner... is valid                        runner=ywiyHUhNJ
Enter a name for the runner. This is stored only in the local config.toml file:
[gitlab-runner]: hw_ci
Enter an executor: kubernetes, docker-autoscaler, custom, ssh, virtualbox, docker, docker-windows, shell, parallels, docker+machine, instance:
shell
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!

Configuration (with the authentication token) was saved in "/etc/gitlab-runner/config.toml"

```
</details>

3. (* Необязательное задание повышенной сложности. )  Если вы уже знакомы с k8s попробуйте выполнить задание, запустив gitlab server и gitlab runner в k8s  [по инструкции](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/gitlab-containers). 

4. Создайте свой новый проект.
5. Создайте новый репозиторий в GitLab, наполните его [файлами](./repository).

![изображение](https://github.com/stepynin-georgy/hw_ci_5/blob/main/img/Screenshot_73.png)

6. Проект должен быть публичным, остальные настройки по желанию.

## Основная часть

### DevOps

В репозитории содержится код проекта на Python. Проект — RESTful API сервис. Ваша задача — автоматизировать сборку образа с выполнением python-скрипта:

1. Образ собирается на основе [centos:7](https://hub.docker.com/_/centos?tab=tags&page=1&ordering=last_updated).
2. Python версии не ниже 3.7.
3. Установлены зависимости: `flask` `flask-jsonpify` `flask-restful`.
4. Создана директория `/python_api`.
5. Скрипт из репозитория размещён в /python_api.
6. Точка вызова: запуск скрипта.
7. При комите в любую ветку должен собираться docker image с форматом имени hello:gitlab-$CI_COMMIT_SHORT_SHA . Образ должен быть выложен в Gitlab registry или yandex registry.

[Dockerfile]() 

### Product Owner

Вашему проекту нужна бизнесовая доработка: нужно поменять JSON ответа на вызов метода GET `/rest/api/get_info`, необходимо создать Issue в котором указать:

1. Какой метод необходимо исправить.
2. Текст с `{ "message": "Already started" }` на `{ "message": "Running"}`.
3. Issue поставить label: feature.

### Developer

Пришёл новый Issue на доработку, вам нужно:

1. Создать отдельную ветку, связанную с этим Issue.
2. Внести изменения по тексту из задания.
3. Подготовить Merge Request, влить необходимые изменения в `master`, проверить, что сборка прошла успешно.


### Tester

Разработчики выполнили новый Issue, необходимо проверить валидность изменений:

1. Поднять докер-контейнер с образом `python-api:latest` и проверить возврат метода на корректность.
2. Закрыть Issue с комментарием об успешности прохождения, указав желаемый результат и фактически достигнутый.

## Итог

В качестве ответа пришлите подробные скриншоты по каждому пункту задания:

- файл gitlab-ci.yml;
- Dockerfile; 
- лог успешного выполнения пайплайна;
- решённый Issue.

### Важно 
После выполнения задания выключите и удалите все задействованные ресурсы в Yandex Cloud.


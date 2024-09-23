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

[Dockerfile](https://github.com/stepynin-georgy/hw_ci_5/blob/main/Dockerfile) 

[.gitlab-ci.yml](https://github.com/stepynin-georgy/hw_ci_5/blob/main/gitlab-ci.yml)

<details><summary>Проверка работы пайплайна</summary>
  
```
  Running with gitlab-runner 17.4.0 (b92ee590)
  on hw_ci t2of8sMeQ, system ID: s_fac309dfd8c4
Preparing the "shell" executor
00:00
Using Shell (bash) executor...
Preparing environment
00:00
Running on gitlab-runner...
Getting source from Git repository
00:02
Fetching changes with git depth set to 20...
Reinitialized existing Git repository in /home/gitlab-runner/builds/t2of8sMeQ/0/stepynin.georgy/hw_ci/.git/
Checking out c3ca462c as detached HEAD (ref is main)...
Skipping Git submodules setup
Executing "step_script" stage of the job script
02:35
$ docker build -t $DOCKER_IMAGE .
#0 building with "default" instance using docker driver
#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 853B done
#1 DONE 0.2s
#2 [internal] load metadata for docker.io/library/centos:7
#2 DONE 1.2s
#3 [internal] load .dockerignore
#3 transferring context: 2B done
#3 DONE 0.0s
#4 [1/6] FROM docker.io/library/centos:7@sha256:be65f488b7764ad3638f236b7b515b3678369a5124c47b8d32916d6487418ea4
#4 DONE 0.0s
#5 [internal] load build context
#5 transferring context: 7.97kB 0.9s done
#5 DONE 1.0s
#6 [2/6] COPY ./repository-check.sh .
#6 CACHED
#7 [3/6] RUN chmod +x repository-check.sh  && ./repository-check.sh
#7 CACHED
#8 [4/6] WORKDIR /python_api
#8 CACHED
#9 [5/6] RUN yum -y install wget make gcc openssl-devel bzip2-devel libffi-devel &&     cd /tmp/ &&     wget https://www.python.org/ftp/python/3.7.9/Python-3.7.9.tgz &&     tar xzf Python-3.7.9.tgz &&     cd Python-3.7.9 &&     ./configure --enable-optimizations &&     make altinstall &&     ln -sfn /usr/local/bin/python3.7 /usr/bin/python3.7 &&     ln -sfn /usr/local/bin/pip3.7 /usr/bin/pip3.7 &&     python3.7 -m pip install --upgrade pip
#9 CACHED
#10 [6/6] COPY . /python_api
#10 DONE 1.8s
#11 exporting to image
#11 exporting layers 0.1s done
#11 writing image sha256:fccd644746dc37c514d62a7f80417fd013ba702379f34e017d8ae23c95ea2c4c 0.0s done
#11 naming to docker.io/library/hello:gitlab-c3ca462c
#11 naming to docker.io/library/hello:gitlab-c3ca462c 0.0s done
#11 DONE 0.1s
$ docker tag $DOCKER_IMAGE $CI_REGISTRY_IMAGE/$DOCKER_IMAGE
$ docker push $CI_REGISTRY_IMAGE/$DOCKER_IMAGE
The push refers to repository [hw-netology-ci.gitlab.yandexcloud.net:5050/stepynin.georgy/hw_ci/hello]
547fbe38076b: Preparing
ef0f2cb968a0: Preparing
0090d39f8267: Preparing
da77fd07cf44: Preparing
34dc701c44c1: Preparing
174f56854903: Preparing
174f56854903: Waiting
0090d39f8267: Pushed
34dc701c44c1: Pushed
547fbe38076b: Pushed
da77fd07cf44: Pushed
174f56854903: Pushed
ef0f2cb968a0: Pushed
gitlab-c3ca462c: digest: sha256:0bc07f4d62b920b6d4b4cac8beb0aa35e6f4e149f18cece68797fe1e035ed438 size: 1579
Cleaning up project directory and file based variables
00:00
Job succeeded
```
</details>

![изображение](https://github.com/stepynin-georgy/hw_ci_5/blob/main/img/Screenshot_76.png)

![изображение](https://github.com/stepynin-georgy/hw_ci_5/blob/main/img/Screenshot_77.png)

### Product Owner

Вашему проекту нужна бизнесовая доработка: нужно поменять JSON ответа на вызов метода GET `/rest/api/get_info`, необходимо создать Issue в котором указать:

1. Какой метод необходимо исправить.
2. Текст с `{ "message": "Already started" }` на `{ "message": "Running"}`.
3. Issue поставить label: feature.

![изображение](https://github.com/stepynin-georgy/hw_ci_5/blob/main/img/Screenshot_78.png)

![изображение](https://github.com/stepynin-georgy/hw_ci_5/blob/main/img/Screenshot_79.png)

### Developer

Пришёл новый Issue на доработку, вам нужно:

1. Создать отдельную ветку, связанную с этим Issue.
2. Внести изменения по тексту из задания.

Создал отдельную ветку developer и внес изменения в соответствии с issue

3. Подготовить Merge Request, влить необходимые изменения в `master`, проверить, что сборка прошла успешно.

![изображение](https://github.com/stepynin-georgy/hw_ci_5/blob/main/img/Screenshot_81.png)

### Tester

Разработчики выполнили новый Issue, необходимо проверить валидность изменений:

1. Поднять докер-контейнер с образом `python-api:latest` и проверить возврат метода на корректность.

```
gitlab-runner@gitlab-runner:/home/user$ docker run -d --rm --name issue-1 -p 5290:5290 hello:gitlab-a14f401d
b65f144d272f378dbf354dee1a818e63390917e50e208ee50fcd6281b7e4e121
gitlab-runner@gitlab-runner:/home/user$ docker ps
CONTAINER ID   IMAGE                   COMMAND                  CREATED         STATUS         PORTS                                       NAMES
b65f144d272f   hello:gitlab-a14f401d   "python3.7 /python-a…"   4 seconds ago   Up 3 seconds   0.0.0.0:5290->5290/tcp, :::5290->5290/tcp   issue-1
gitlab-runner@gitlab-runner:/home/user$ docker exec -ti issue-1 bash
[root@b65f144d272f python-api]# curl localhost:5290/get_info
{"version": 3, "method": "GET", "message": "Running"}
[root@b65f144d272f python-api]#
```

2. Закрыть Issue с комментарием об успешности прохождения, указав желаемый результат и фактически достигнутый.

![изображение](https://github.com/stepynin-georgy/hw_ci_5/blob/main/img/Screenshot_82.png)

## Итог

В качестве ответа пришлите подробные скриншоты по каждому пункту задания:

- файл gitlab-ci.yml;
- Dockerfile; 
- лог успешного выполнения пайплайна;
- решённый Issue.

### Важно 
После выполнения задания выключите и удалите все задействованные ресурсы в Yandex Cloud.


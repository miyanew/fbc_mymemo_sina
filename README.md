# mymemo

mymemo.rbは、Sinatraで作られたWebブラウザ上で動作するメモアプリです。ローカルなネットワーク環境で動作します。

対象環境はWSL2（debian）です。

## インストールと起動

1. [Debian に Docker エンジンをインストールする](https://docs.docker.com/engine/install/debian/#install-using-the-convenience-script)を参照し、Dockerをインストールしてください。

```
$ curl -fsSL https://get.docker.com -o get-docker.sh
$ sudo sh get-docker.sh
```

2. 非 root ユーザーとして Docker を管理したい場合は[こちら](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user)の手順を実行し、ログアウトして再度ログインしてください。

```
$ sudo usermod -aG docker $USER
$ sudo service docker start
```

3. PCの任意の作業ディレクトリにて git clone してください。
```
$ git clone https://github.com/miyanew/fbc_mymemo_sina.git
```

4. プロジェクトのルートディレクトリに移動したら、`.env`ファイルに環境変数を入力してコンテナを起動してください。
```
$ vi .env

POSTGRES_DB=
POSTGRES_USER=postgres
POSTGRES_PASSWORD=password

$ docker compose up -d
```

5. ブラウザに `http://localhost:4567` を入力するとアプリを実行できます。

6. アプリケーションを終了します。
```
$ docker compose down
```
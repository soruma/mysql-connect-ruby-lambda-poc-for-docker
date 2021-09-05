## Start up

```
docker-compose build
docker-compose up
```

## Test

```
curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"payload":"hello world!"}'
```

## Deploy

```
aws ecr create-repository \
    --repository-name mysql-connect \
    --image-scanning-configuration scanOnPush=true \
    --region us-east-1
```

```
image_uri=$(aws ecr describe-repositories | jq -r '.repositories[] | select( .repositoryName == "mysql-connect" ) | .repositoryUri')
docker login -u AWS -p $(aws ecr get-login-password) ${image_uri}

sam build
sam deploy
```

## Memo

ImgUri 取得
```
aws ecr describe-repositories | jq -r '.repositories[] | select( .repositoryName == "mysql-connect" ) | .repositoryUri'
```

[Amazon VPC に接続されている Lambda 関数にインターネットアクセスを許可するにはどうすればよいですか?](https://aws.amazon.com/jp/premiumsupport/knowledge-center/internet-access-lambda-function/)

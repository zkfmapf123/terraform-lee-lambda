# Lambda Module

## Description

- Lambda 함수를 Docker 기반으로 구성 / 배포 하는 테라폼 모듈

## Interface

```yaml
## examples 참조
lambda:
  iam:
    name:           ## iam 이름
    policy:         ## iam 구성에 필요한 정책
  computing:
    name:           ## 람다 함수 이름
    image_url:      ## ecr 이름 (없으면 자동생성)
    timeout:
    memory:
    architecture:   ## x86_64 | arm64
    environments:   ## 환경변수
    tags:           ## 태그
```

## Issue

### Docker Pull 이슈

```sh
ERROR: failed to solve: public.ecr.aws/lambda/python:3.8: pulling from host public.ecr.aws failed with status code: 403 Forbidden
```

- AWS Public 이미지는 따로 로그인을 실행해야 함

```sh
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws
```

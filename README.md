<!-- BEGIN_TF_DOCS -->
## Requirements

- CLI를 활용하여 배포가 가능하도록 수정하였습니다.
- <b>ECR을 미리 생성하고 var.ecr_attr에 ecr registry를 입력해야 함</b>

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [null_resource.build](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.lambda_default_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_deploy"></a> [auto\_deploy](#input\_auto\_deploy) | 배포 옵션입니다. | `map` | <pre>{<br>  "is_enable": false,<br>  "revision": "1.0.0"<br>}</pre> | no |
| <a name="input_common_attr"></a> [common\_attr](#input\_common\_attr) | 공통 옵션입니다. | `map` | <pre>{<br>  "name": ""<br>}</pre> | no |
| <a name="input_compute_attr"></a> [compute\_attr](#input\_compute\_attr) | lambda computing 옵션입니다. | `map` | <pre>{<br>  "architecture": "arm64",<br>  "environments": {<br>    "System": "lambda"<br>  },<br>  "logging_format": "JSON",<br>  "memory": 128,<br>  "timeout": 10<br>}</pre> | no |
| <a name="input_ecr_attr"></a> [ecr\_attr](#input\_ecr\_attr) | ecr 옵션입니다. | `map` | <pre>{<br>  "exists_ecr_registry": ""<br>}</pre> | no |
| <a name="input_iam_attr"></a> [iam\_attr](#input\_iam\_attr) | iam 옵션입니다. | `map` | <pre>{<br>  "policy": {}<br>}</pre> | no |
| <a name="input_network_attr"></a> [network\_attr](#input\_network\_attr) | lambda computing에 network 옵션입니다. | `map` | <pre>{<br>  "sg_ids": [],<br>  "subnet_ids": [],<br>  "vpc_id": null<br>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Docker Image Examples

### Javascript

```Dockerfile
FROM public.ecr.aws/lambda/nodejs:20
COPY index.js ${LAMBDA_TASK_ROOT}
CMD [ "index.handler" ]
```

```javascript
exports.handler = async (event) => {
  const response = {
    statusCode: 200,
    body: JSON.stringify("Hello from Lambda!"),
  };
  return response;
};
```

### Golang

```Dockerfile
FROM golang:1.23 as build
WORKDIR /app

COPY go.mod go.sum ./

COPY main.go .
RUN go build -tags lambda.norpc -o main main.go

FROM public.ecr.aws/lambda/provided:al2023
COPY --from=build /app/main ./main
ENTRYPOINT [ "./main" ]
```

```golang
package main

import (
        "context"
        "encoding/json"
        "fmt"

        "github.com/aws/aws-lambda-go/lambda"
)


func HandleRequest(ctx context.Context, e json.RawMessage) (string, error) {

        fmt.Println("Event : ", string(e))
        return "hello world-1", nil
}

func main() {
        lambda.Start(HandleRequest)
}
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
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

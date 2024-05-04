output "arn" {
  value = aws_lambda_function.test_lambda.arn
}

output "name" {
  value = aws_lambda_function.test_lambda.function_name
}

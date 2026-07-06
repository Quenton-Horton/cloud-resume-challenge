data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "cloud-resume-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

# Scoped: only UpdateItem on the one table
data "aws_iam_policy_document" "lambda_dynamo" {
  statement {
    actions   = ["dynamodb:UpdateItem"]
    resources = [aws_dynamodb_table.visitors.arn]
  }
}

resource "aws_iam_role_policy" "lambda_dynamo" {
  name   = "cloud-resume-lambda-dynamo"
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.lambda_dynamo.json
}

# Basic execution (CloudWatch Logs)
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda/counter.py"
  output_path = "${path.module}/../lambda/counter.zip"
}

resource "aws_lambda_function" "counter" {
  function_name    = "cloud-resume-counter"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  handler          = "counter.handler"
  runtime          = "python3.12"
  role             = aws_iam_role.lambda.arn

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.visitors.name
    }
  }
}

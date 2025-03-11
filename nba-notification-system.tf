terraform {
 required_providers {
   aws={
     source = "hashicorp/aws"
 }
}
}

provider "aws"{
    region = var.region
}
resource "aws_sns_topic" "nba_game_notification" {
  name = "nba-game-notification"
}

#defining lambda iam role 
resource "aws_iam_role" "lambda_role" {
    name ="lambda_role"
    assume_role_policy =  jsonencode(
    {
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  }
  )
}
#IAM policies that are going to be attached to the iam role
resource "aws_iam_policy" "publish_sns_topic" {
  policy = jsonencode(
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow"
        "Action": "sns:Publish"
        "Resource": "${aws_sns_topic.nba_game_notification.arn}"
        }]
    }
    )
}
#attach the sns publish policy to the 
resource "aws_iam_role_policy_attachment" "attach_lambda_SNSpublish" {
    policy_arn = aws_iam_policy.publish_sns_topic.arn
    role = aws_iam_role.lambda_role.name
  
}
data "aws_caller_identity" "acc_info" {
}

#iam policy to read from ssm
resource "aws_iam_policy" "ssm_policy" {
    name = "ssm_policy"
    policy = jsonencode(
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow"
        "Action": "ssm:GetParametre"
        "Resource": "arn:aws:ssm:${var.region}:${data.aws_caller_identity.acc_info.account_id}:parameter/nba-api-key"
        }]
    }
    )
}

resource "aws_iam_role_policy_attachment" "ssm_attached_policy" {
  policy_arn = aws_iam_policy.ssm_policy.arn
  role =  aws_iam_role.lambda_role.name
}

resource "aws_lambda_function" "lambda_function" {
  function_name = "Game_day_notification"
  role = aws_iam_role.lambda_role.arn
  filename = "lambda_funtion.zip"
  handler = "lambda_function.lambda_handler"
  runtime = "python3.8"
  environment {
    variables = {
      SNS_TOPIC_ARN=aws_sns_topic.nba_game_notification.arn
    }
  }

}

#lambda CloudWatch logging policy 
resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging_policy"
  description = "Allow Lambda to write logs"
  policy = jsonencode(
    {
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:${var.region}:${data.aws_caller_identity.acc_info.account_id}:*"
      }
    ]
  } 
  )
}


resource "aws_iam_role_policy_attachment" "lambda_logs" {
  policy_arn = aws_iam_policy.lambda_logging.arn
  role = aws_iam_role.lambda_role.name
}

resource "aws_cloudwatch_event_rule" "nba_schedule" {
  name    = "nba_game_notifications_schedule"
  schedule_expression = "rate(1 day)" 
}

# EventBridge Target was formerly known as CloudWatch Events
resource "aws_cloudwatch_event_target" "nba_target" {
  rule = aws_cloudwatch_event_rule.nba_schedule.name
  target_id = "lambda_function"
  arn = aws_lambda_function.lambda_function.arn
}

# Grant EventBridge Permission to trriger Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.nba_schedule.arn
}

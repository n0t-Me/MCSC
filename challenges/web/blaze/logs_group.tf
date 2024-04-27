resource "aws_cloudwatch_log_group" "blaze_blaze_logs" {
  name = "/ecs/blaze/blaze"
}

resource "aws_cloudwatch_log_group" "blaze_graphql_logs" {
  name = "/ecs/blaze/graphql"
}

resource "aws_cloudwatch_log_group" "blaze_bot_logs" {
  name = "/ecs/blaze/bot"
}

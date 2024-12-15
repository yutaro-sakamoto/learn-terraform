provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_iam_user" "example" {
  count = 3
  name  = "user-${count.index}"
}

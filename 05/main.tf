provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_iam_user" "example" {
  count = 3
  name  = "user-${count.index}"
}

variable "user_names" {
  type    = list(string)
  default = ["neo", "trinity", "morpeus"]
}

resource "aws_iam_user" "example2" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}

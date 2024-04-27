terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.29.0"
    }
  }
}

provider "cloudflare" {}

data "aws_lb" "lb" {
  arn = var.lb_arn
}

data "aws_lb" "ctfd" {
  arn = var.lb_ctfd_arn
}


resource "cloudflare_record" "ctfd" {
  zone_id         = var.cloudflare_zone_id
  name            = "ctfd"
  type            = "CNAME"
  value           = data.aws_lb.ctfd.dns_name
  allow_overwrite = true
  proxied         = true
}

resource "cloudflare_record" "blaze" {
  zone_id         = var.cloudflare_zone_id
  name            = "blaze"
  type            = "CNAME"
  value           = data.aws_lb.lb.dns_name
  allow_overwrite = true
  proxied         = true
}

resource "cloudflare_record" "ez" {
  zone_id         = var.cloudflare_zone_id
  name            = "ez"
  type            = "CNAME"
  value           = data.aws_lb.lb.dns_name
  allow_overwrite = true
  proxied         = true
}

resource "cloudflare_record" "warmup" {
  zone_id         = var.cloudflare_zone_id
  name            = "warmup"
  type            = "CNAME"
  value           = data.aws_lb.lb.dns_name
  allow_overwrite = true
  proxied         = true
}

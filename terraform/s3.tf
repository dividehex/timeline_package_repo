resource "aws_s3_bucket" "s3_bucket" {
  bucket = "tlpr.relops.mozops.net"
  acl    = "public-read"

  versioning {
    enabled = true
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name = "tlpr.relops.mozops.net"
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = "${aws_s3_bucket.s3_bucket.id}"

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[{
	"Sid":"PublicReadGetObject",
        "Effect":"Allow",
	  "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::tlpr.relops.mozops.net/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_object" "bootstrap_object" {
  bucket = aws_s3_bucket.s3_bucket.id
  key    = "scripts/bootstrap.py"
  source = "files/bootstrap.py"
  etag   = md5(file("files/bootstrap.py"))
}

resource "aws_s3_bucket_object" "manifest_object" {
  bucket = aws_s3_bucket.s3_bucket.id
  key    = "manifest.yml"
  source = "files/manifest.yml"
  etag   = md5(file("files/manifest.yml"))
}


resource "aws_route53_record" "tlpr" {
  zone_id = data.aws_route53_zone.relops_mozops_net.zone_id
  name    = "tlpr.relops.mozops.net"
  type    = "A"

  alias {
    name                   = aws_s3_bucket.s3_bucket.website_domain
    zone_id                = aws_s3_bucket.s3_bucket.hosted_zone_id
    evaluate_target_health = false
  }
}


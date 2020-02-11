resource "aws_s3_bucket" "s3_bucket" {
  bucket = "relops-tlpr"
  acl = "public-read"
  versioning {
		enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }

  tags {
  	Name = "relops-tlpr"
  }
}

resource "aws_s3_bucket_object" "bootstrap_object" {
  bucket = "${aws_s3_bucket.s3_bucket.id}"
  key    = "scripts/bootstrap.py"
  source = "${"files/bootstrap.py"}"
  etag   = "${md5(file("files/bootstrap.py"))}"
}

resource "aws_s3_bucket_object" "manifest_object" {
  bucket = "${aws_s3_bucket.s3_bucket.id}"
  key    = "manifest.yml"
  source = "files/manifest.yml"
  etag   = "${md5(file("files/manifest.yml"))}"
}


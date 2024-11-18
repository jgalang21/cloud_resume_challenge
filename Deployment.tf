#create the s3 bucket

resource "aws_s3_bucket" "myResumeBucket" {
  bucket = var.myResume
}


#set who has ownership controls of the bucket
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.myResumeBucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


#set the policies
resource "aws_s3_bucket_public_access_block" "pubAccess" {
  bucket = aws_s3_bucket.myResumeBucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#alllow public read access
resource "aws_s3_bucket_acl" "bucketAcls" {
  depends_on = [
    aws_s3_bucket_ownership_controls.ownership,
    aws_s3_bucket_public_access_block.pubAccess,
  ]
  bucket = aws_s3_bucket.myResumeBucket.id
  acl    = "public-read"
}


#add the object index/error html files
resource "aws_s3_object" "index" {
    bucket = aws_s3_bucket.myResumeBucket.id
    key = "index.html"
    source  = "index.html"
    acl = "public-read"
    content_type = "text/html"

}


resource "aws_s3_object" "error" {
    bucket = aws_s3_bucket.myResumeBucket.id
    key = "error.html"
    source  = "error.html"
    acl = "public-read"
    content_type = "text/html"

}

data "local_file" "assets" {
  for_each = fileset("${path.module}/assets", "**/*")
  filename = "${path.module}/assets/${each.value}"
}

data "local_file" "images" {
  for_each = fileset("${path.module}/images", "**/*")
  filename = "${path.module}/images/${each.value}"
}


resource "aws_s3_bucket_object" "assets_files" {
  for_each    = data.local_file.assets
  bucket      = aws_s3_bucket.myResumeBucket.id
  key         = "assets/${basename(each.value.filename)}"
  source      = each.value.filename
  content_type = lookup(
    {
      "css"  = "text/css",
      "js"   = "application/javascript",
      "png"  = "image/png",
      "jpg"  = "image/jpeg",
      "jpeg" = "image/jpeg"
    },
    element(split(".", basename(each.value.filename)), length(split(".", basename(each.value.filename))) - 1),
    "application/octet-stream"
  )
  acl         = "public-read"
}

resource "aws_s3_bucket_object" "images_files" {
  for_each    = data.local_file.images
  bucket      = aws_s3_bucket.myResumeBucket.id
  key         = "images/${basename(each.value.filename)}"
  source      = each.value.filename
  content_type = lookup(
    {
      "png"  = "image/png",
      "jpg"  = "image/jpeg",
      "jpeg" = "image/jpeg"
    },
    element(split(".", basename(each.value.filename)), length(split(".", basename(each.value.filename))) - 1),
    "application/octet-stream"
  )
  acl         = "public-read"
}



resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.myResumeBucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [aws_s3_bucket_acl.bucketAcls]


}
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits = 2048
}

resource "tls_self_signed_cert" "cert" {
  key_algorithm = "RSA"
  private_key_pem = tls_private_key.key.private_key_pem

  validity_period_hours = 12

  early_renewal_hours = 3

  set_subject_key_id = true

  allowed_uses = [
      "key_encipherment",
      "digital_signature",
      "server_auth",
  ]

  subject {
      common_name = "*.mydomain.com"
      organization = "DevOps"
  }
}

resource "aws_acm_certificate" "cert" {
  private_key      = tls_private_key.key.private_key_pem
  certificate_body = tls_self_signed_cert.cert.cert_pem
}

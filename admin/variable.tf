
##provision access_key when running the script
variable "access_key" {
  default = ""
  # checkov:skip=CKV_SECRET_2: ADD REASON

}

#provision secret_key when running the script
variable "secret_key" {
  default = ""

}


variable "vault_addr" {
  default = "http://127.0.0.1:8200"

}

variable "vault_token" {
  default = "hvs.8otTCepynRvTvRUtCUQt8Yso"

}

variable "name_prefix" {
  type = string
}

variable "recovery_window_in_days" {
  description = "Days a deleted secret can be restored. 0 deletes immediately, so destroy + re-apply works (practice accounts)."
  type        = number
  default     = 30
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "roles" {
  type = map(object({
    connection_limit = optional(number)
    databases_ro     = list(string)
    databases_rw     = list(string)
  }))
}
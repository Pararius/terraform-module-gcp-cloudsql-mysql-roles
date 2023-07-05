resource "random_password" "role" {
  for_each = var.roles

  length      = 48
  min_lower   = 0
  min_numeric = 0
  min_special = 0
  min_upper   = 0

  lower   = true
  numeric = true
  special = false
  upper   = true

  lifecycle {
    ignore_changes = [lower, numeric, special, upper]
  }
}

resource "mysql_role" "role_ro" {
  name = "role_ro"
}

resource "mysql_role" "role_rw" {
  name = "role_rw"
}

resource "mysql_grant" "role_ro" {
  for_each = local.databases

  role       = "role_ro"
  database   = each.value
  privileges = local.privileges_ro
  table      = "*"
}

resource "mysql_grant" "role_rw" {
  for_each = local.databases

  role       = "role_rw"
  database   = each.value
  privileges = local.privileges_rw
  table      = "*"
}

resource "mysql_user" "users" {
  for_each = var.roles

  user               = each.key
  host               = "%"
  plaintext_password = random_password.role[each.key].result
}

resource "mysql_grant" "users_ro" {
  for_each = {
    for databases_readers in local.databases_readers : "${databases_readers.database}.${databases_readers.role}" => databases_readers
  }

  user     = each.value.role
  host     = "%"
  database = each.value.database
  roles    = ["role_ro"]
  table    = "*"
}

resource "mysql_grant" "users_rw" {
  for_each = {
    for database_writer in local.databases_writers : "${database_writer.database}.${database_writer.role}" => database_writer
  }

  user     = each.value.role
  host     = "%"
  database = each.value.database
  roles    = ["role_rw"]
  table    = "*"
}

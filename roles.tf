resource "random_password" "role" {
  for_each = local.roles_built_in

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

resource "mysql_user" "users" {
  for_each = {
    for username, user in local.roles_built_in : username => user
  }

  user               = each.key
  host               = "%"
  plaintext_password = random_password.role[each.key].result
}

resource "mysql_grant" "users_ro" {
  for_each = {
    for databases_readers in local.databases_readers : "${databases_readers.database}.${databases_readers.role}" => databases_readers
  }

  user       = each.value.is_iam ? split("@", each.value.role)[0] : each.value.role
  host       = each.value.type == "CLOUD_IAM_GROUP" ? split("@", each.value.role)[1] : "%"
  database   = each.value.database
  privileges = local.privileges_ro
  table      = "*"
}

resource "mysql_grant" "users_rw" {
  for_each = {
    for database_writer in local.databases_writers : "${database_writer.database}.${database_writer.role}" => database_writer
  }

  user       = each.value.is_iam ? split("@", each.value.role)[0] : each.value.role
  host       = each.value.type == "CLOUD_IAM_GROUP" ? split("@", each.value.role)[1] : "%"
  database   = each.value.database
  privileges = local.privileges_rw
  table      = "*"
}

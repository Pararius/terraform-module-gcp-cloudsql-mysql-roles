locals {
  databases = toset(distinct(flatten([
    for role in var.roles : [role.databases_ro, role.databases_rw]
  ])))

  databases_readers = flatten([
    for role, role_ in var.roles : [
      for database in role_.databases_ro : {
        role     = role
        database = database
      }
    ]
  ])
  databases_writers = flatten([
    for role, role_ in var.roles : [
      for database in role_.databases_rw : {
        role     = role
        database = database
      }
    ]
  ])

  privileges_ro = [
    "SELECT",
  ]
  privileges_rw = [
    "ALL PRIVILEGES",
    # "ALTER",
    # "ALTER ROUTINE",
    # "CREATE",
    # "CREATE ROUTINE",
    # "CREATE TEMPORARY TABLES",
    # "CREATE VIEW",
    # "DELETE",
    # "DROP",
    # "EVENT",
    # "EXECUTE",
    # "INDEX",
    # "INSERT",
    # "LOCK TABLES",
    # "REFERENCES",
    # "SELECT",
    # "SHOW VIEW",
    # "TRIGGER",
    # "UPDATE",
  ]
}

printjson(db.createUser(
  {
    user: "tier_3_admin",
    pwd: "tier_3_admin",
    roles: ["root", "userAdminAnyDatabase", "readWriteAnyDatabase"]
  }
));
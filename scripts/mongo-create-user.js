printjson(db.createUser(
  {
    user: "tier_3_user",
    pwd: "tier_3_user",
    roles: [
      { role: "readWrite", db: "MyDatabase" }
    ]
  }
));
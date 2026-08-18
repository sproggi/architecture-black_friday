#!/bin/bash

echo '========================================='
echo '=== CLUSTER SETUP ==='
echo '========================================='

echo ''
echo '=== 1. Add Shards ==='
mongosh mongos_router:27020 --eval 'sh.addShard("shard1/shard1:27018"); sh.addShard("shard2/shard2:27019")'

echo ''
echo '=== 2. Enable Sharding ==='
mongosh mongos_router:27020 --eval 'sh.enableSharding("somedb")'

echo ''
echo '=== 3. Shard Collection ==='
mongosh mongos_router:27020 --eval '
  sh.shardCollection("somedb.helloDoc", { "age": "hashed" })
'

echo ''
echo '=== 4. Insert 1000 Documents ==='
mongosh mongos_router:27020 --eval '
  db = db.getSiblingDB("somedb");
  for(var i = 0; i < 1000; i++) {
    db.helloDoc.insertOne({
      age: i,
      name: "ly" + i,
      createdAt: new Date()
    });
  }
  var total = db.helloDoc.count();
  print("Inserted documents: " + total);
'

echo ''
echo '=== 5. Verify ==='
mongosh mongos_router:27020 --eval '
  var db = db.getSiblingDB("somedb");
  var total = db.helloDoc.count();
  print("Total documents: " + total);
'

echo ''
echo '========================================='
echo '=== CLUSTER READY ==='
echo '========================================='

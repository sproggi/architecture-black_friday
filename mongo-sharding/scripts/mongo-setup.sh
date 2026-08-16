#!/bin/bash

echo '========================================='
echo '=== НАСТРОЙКА КЛАСТЕРА ==='
echo '========================================='

echo ''
echo '=== 1. Добавление шардов ==='
mongosh mongos_router:27020 --eval 'sh.addShard("shard1/shard1:27018"); sh.addShard("shard2/shard2:27019")'

echo ''
echo '=== 2. Включение шардирования ==='
mongosh mongos_router:27020 --eval 'sh.enableSharding("somedb")'

echo ''
echo '=== 3. Создание индекса ==='
mongosh mongos_router:27020 --eval '
  db = db.getSiblingDB("somedb");
  db.helloDoc.createIndex({ "age": "hashed" });
  print("✅ Индекс создан");
'

echo ''
echo '=== 4. Вставка 1000 записей ==='
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
  print("✅ Вставлено записей: " + total);
'

echo ''
echo '=== 5. Шардирование коллекции ==='
mongosh mongos_router:27020 --eval '
  sh.shardCollection("somedb.helloDoc", { "age": "hashed" })
'

echo ''
echo '=== 6. Проверка ==='
mongosh mongos_router:27020 --eval '
  var db = db.getSiblingDB("somedb");
  var total = db.helloDoc.count();
  print("Всего записей: " + total);
'

echo ''
echo '========================================='
echo '=== ✅ КЛАСТЕР ГОТОВ ==='
echo '========================================='
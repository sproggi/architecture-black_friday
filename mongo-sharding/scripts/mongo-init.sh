#!/bin/bash

echo '========================================='
echo '=== ИНИЦИАЛИЗАЦИЯ REPLICA SETS ==='
echo '========================================='

echo ''
echo '=== 1. Config Server ==='
mongosh configSrv:27017 --eval 'rs.initiate({ _id: "config_server", configsvr: true, members: [{ _id: 0, host: "configSrv:27017" }] })'

sleep 10

echo ''
echo '=== 2. Shard 1 ==='
mongosh shard1:27018 --eval 'rs.initiate({ _id: "shard1", members: [{ _id: 0, host: "shard1:27018" }] })'

sleep 5

echo ''
echo '=== 3. Shard 2 ==='
mongosh shard2:27019 --eval 'rs.initiate({ _id: "shard2", members: [{ _id: 0, host: "shard2:27019" }] })'

sleep 10

echo ''
echo '=== ✅ ИНИЦИАЛИЗАЦИЯ ЗАВЕРШЕНА ==='
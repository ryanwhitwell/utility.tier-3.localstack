#!/bin/bash
echo "  __  __                           ____  ____  " &&
echo " |  \/  | ___  _ __   __ _  ___   |  _ \| __ ) " &&
echo " | |\/| |/ _ \| '_ \ / _\` |/ _ \  | | | |  _ \ " &&
echo " | |  | | (_) | | | | (_| | (_) | | |_| | |_) |" &&
echo " |_|  |_|\___/|_| |_|\__, |\___/  |____/|____/ " &&
echo "                     |___/                     " &&
# Start mongod config replicaset
mongod --config /scripts/mongod-config.conf &&
# Wait until mongo logs that it's ready (or timeout after 60s)
COUNTER=0
grep -q 'waiting for connections on port' /var/log/mongod-config.log
while [[ $? -ne 0 && $COUNTER -lt 60 ]] ; do
    sleep 2
    let COUNTER+=2
    echo "Waiting for mongod config to initialize... ($COUNTER seconds so far)"
    grep -q 'waiting for connections on port' /var/log/mongod-config.log
done
# Inititzlie repliacset
mongo localhost:27018 /scripts/mongo-replSet-init-config.js &&
# Start mongod shard replicaset
mongod --config /scripts/mongod-shard.conf &&
# Wait until mongo logs that it's ready (or timeout after 60s)
COUNTER=0
grep -q 'waiting for connections on port' /var/log/mongod-shard.log
while [[ $? -ne 0 && $COUNTER -lt 60 ]] ; do
    sleep 2
    let COUNTER+=2
    echo "Waiting for mongod shard to initialize... ($COUNTER seconds so far)"
    grep -q 'waiting for connections on port' /var/log/mongod-shard.log
done
# Inititzlie repliacset
mongo localhost:27019 /scripts/mongo-replSet-init-shard.js &&
# Start mongos
mongos --config /scripts/mongos.conf &&
# Wait until mongo logs that it's ready (or timeout after 60s)
COUNTER=0
grep -q 'waiting for connections on port' /var/log/mongos.log
while [[ $? -ne 0 && $COUNTER -lt 60 ]] ; do
    sleep 2
    let COUNTER+=2
    echo "Waiting for mongos to initialize... ($COUNTER seconds so far)"
    grep -q 'waiting for connections on port' /var/log/mongos.log
done
# Add Shard
mongo localhost:27017 /scripts/mongo-add-shard.js &&
# Create admin user
mongo localhost:27017/admin /scripts/mongo-create-admin.js &&
# Create Tier 3 user
mongo localhost:27017/MyDatabase --authenticationDatabase "admin" -u "tier_3_admin" -p "tier_3_admin" /scripts/mongo-create-user.js &&
# User the Tier 3 user to print out the MOnogoDB Version info
mongo localhost:27017/MyDatabase -u "tier_3_user" -p "tier_3_user" /scripts/mongo-version.js &&
echo " ____       _     _     _ _     __  __  ___  " &&
echo "|  _ \ __ _| |__ | |__ (_) |_  |  \/  |/ _ \ " &&
echo "| |_) / _\` | '_ \| '_ \| | __| | |\/| | | | |" &&
echo "|  _ < (_| | |_) | |_) | | |_  | |  | | |_| |" &&
echo "|_| \_\__,_|_.__/|_.__/|_|\__| |_|  |_|\__\_\\" &&
echo "                                             " &&
service rabbitmq-server start &&
service rabbitmq-server status &&
rabbitmqctl add_user tier_3_admin tier_3_admin &&
rabbitmqctl set_user_tags tier_3_admin administrator &&
rabbitmqctl set_permissions -p / tier_3_admin ".*" ".*" ".*" &&
rabbitmqctl add_user tier_3_user tier_3_user &&
rabbitmqctl set_user_tags tier_3_user administrator &&
rabbitmqctl set_permissions -p / tier_3_user ".*" ".*" ".*" &&
rabbitmq-plugins enable rabbitmq_management &&
service rabbitmq-server restart &&
echo " ____          _ _     " &&
echo "|  _ \ ___  __| (_)___ " &&
echo "| |_) / _ \/ _\` | / __|" &&
echo "|  _ <  __/ (_| | \__ \\" &&
echo "|_| \_\___|\__,_|_|___/" &&
cp /scripts/redis.conf /etc/redis/redis.conf &&
service redis-server start &&
redis-server -v &&
service redis-server status &&
echo " _____ _           _   _                              _     " &&
echo "| ____| | __ _ ___| |_(_) ___ ___  ___  __ _ _ __ ___| |__  " &&
echo "|  _| | |/ _\` / __| __| |/ __/ __|/ _ \/ _\` | '__/ __| '_ \\ " &&
echo "| |___| | (_| \__ \ |_| | (__\__ \  __/ (_| | | | (__| | | |" &&
echo "|_____|_|\__,_|___/\__|_|\___|___/\___|\__,_|_|  \___|_| |_|" &&
echo "                                                            " &&
cp /scripts/elasticsearch.yml /elasticsearch-2.3.4/config/elasticsearch.yml &&
elasticsearch-2.3.4/bin/elasticsearch -d -Des.insecure.allow.root=true
/elasticsearch-2.3.4/bin/elasticsearch --version
echo " " &&
echo "Tier 3 is up and running! Press [Ctrl + C] to quit." &&
tail -f /dev/null
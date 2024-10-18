
## MongoBD Cluster steps##
1. Export Data from the Existing MongoDB Instance

```
# For Linux
sudo apt-get install -y mongodb-database-tools

# For MacOS (using Homebrew)
brew tap mongodb/brew
brew install mongodb-database-tools

#Run the following command to dump the data from your existing MongoDB instance
mongodump --uri="mongodb+srv://username:password@cluster.mongodb.net/dbname" --out=/path/to/backup

```

2. Setting Up MongoDB on Kubernetes

* Create a StatefulSet for MongoDB Replica Set
* Add Service (clusterIP) for MongoDB
* Deploy the StatefulSet

3. Initialize the MongoDB Replica Set

```
kubectl exec -it mongo-0 -- mongosh --host mongo-0.mongo-service --port 27017 -u dionamite -p Dionamite1! --authenticationDatabase admin

>rs.initiate({
  _id: "rs0",
  members: [
    { _id: 0, host: "mongo-0.mongo-service:27017" },
    { _id: 1, host: "mongo-1.mongo-service:27017" },
    { _id: 2, host: "mongo-2.mongo-service:27017" }
  ]
});
>exit
```

4. Import Data into the Kubernetes MongoDB Cluster

```
kubectl cp /path/to/backup mongo-0:/data/backup
kubectl exec -it mongo-0 -- mongorestore /data/backup
```
5. Add dionamite user to db 

``` 
kubectl exec -it mongo-0 -- mongosh --host mongo-0.mongo-service --port 27017 -u dionamite -p Dionamite1! --authenticationDatabase admin

>use flor
>db.createUser({
  user: "dionamite",
  pwd: "Dionamite1!",
  roles: [{ role: "readWrite", db: "flor" }]
})
```
6. Update Application to Use the MongoDB Replica Set

```
const MONGO_URI = process.env.MONGODB_URI || 
  "mongodb://dionamite:Dionamite1!@mongo-0.mongo-service:27017,mongo-1.mongo-service:27017,mongo-2.mongo-service:27017/flor?replicaSet=rs0";
```

7. Update .env and env variables in backend and frontend deployments

```
#frontend
VITE_SERVER_URL= "http://backend-service:6001"

#backend
MONGODB_URI="mongodb://dionamite:Dionamite1%21@mongo-0.mongo-service:27017,mongo-1 mongo-service:27017,mongo-2.mongo-service:27017/flor?replicaSet=rs0"
```
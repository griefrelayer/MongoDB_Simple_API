from os import getenv
from pymongo import MongoClient
from bson import json_util
from bson.objectid import ObjectId
from flask import Flask, request
from flask_restful import Resource, Api


app = Flask(__name__)
application = app
api = Api(app)

client = MongoClient(getenv('MONGO_DB_IP', "172.17.0.2"), 27017, connectTimeoutMS=30000, socketTimeoutMS=None, connect=False, maxPoolsize=1)
db = client.api_db
data = db.api_data

# API managing classes


class SimpleGet(Resource):
    def get(self, mongo_id):
        return json_util.dumps(data.find_one({'_id': ObjectId(mongo_id)}))


class SimplePost(Resource):
    def post(self):
        inserted_id = data.insert_one({'document1': request.json['data']}).inserted_id
        return str(inserted_id)


# URLs management
api.add_resource(SimpleGet, '/get_data/<string:mongo_id>')
api.add_resource(SimplePost, '/post_data')

if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=True, port=80)

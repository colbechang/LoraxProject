from flask import Blueprint, request, jsonify, make_response
import json
from src import db


dictatorship = Blueprint('dictatorship', __name__)

# Get all people
@dictatorship.route('/people', methods=['GET'])
def get_people():
    cursor = db.get_db().cursor()
    cursor.execute('''select * from people order by annual_emissions''')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get persion by id
@dictatorship.route('/people/<id>', methods=['GET'])
def get_person(id):
    cursor = db.get_db().cursor()
    cursor.execute('''select * from people where peopleID = {} order by annual_emissions'''.format(id))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Terminate persion by id
@dictatorship.route('/people/rip/<id>', methods=['DELETE'])
def terminate_person(id):
    cursor = db.get_db().cursor()
    cursor.execute('''delete from people where peopleID = {}'''.format(id))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Reward persion by id
@dictatorship.route('/people/nice/<id>/<amt>', methods=['PUT'])
def reward_person(id, amt):
    cursor = db.get_db().cursor()
    cursor.execute('''update people set income = income + {} where peopleID = {}'''.format(amt, id))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Fine persion by id
@dictatorship.route('/people/naughty/<id>/<amt>', methods=['PUT'])
def fine_person(id, amt):
    cursor = db.get_db().cursor()
    cursor.execute('''update people set income = income - {} where peopleID = {}'''.format(amt, id))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response
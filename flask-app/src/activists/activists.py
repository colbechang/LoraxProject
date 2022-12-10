from flask import Blueprint, request, jsonify, make_response
import json
from src import db


activists = Blueprint('activists', __name__)

# Get all industry data
@activists.route('/industries', methods=['GET'])
def get_industries():
    cursor = db.get_db().cursor()
    country_name = '(select name from countries c where c.countryID = i.countryID) as country'
    cursor.execute('''select name, annual_emmissions, annual revenue, {}
                      from industry i order by population limit 20'''.format(country_name))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get all industry names
@activists.route('/industries/names', methods=['GET'])
def get_industry_names(userID):
    cursor = db.get_db().cursor()
    cursor.execute('select distinct name as value, industryID as label from industry order by name')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get an industry row
@activists.route('/industries/<industryID>', methods=['GET'])
def get_industry(industryID):
    cursor = db.get_db().cursor()
    country_name = '(select name from countries c where c.countryID = i.countryID) as country'
    cursor.execute('select name, annual emmissions, annual_revenue, {1} from industry i where id = {0} orderby country'.format(industryID, country_name))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response
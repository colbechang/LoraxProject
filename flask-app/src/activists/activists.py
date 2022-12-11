from flask import Blueprint, request, jsonify, make_response
import json
from src import db


activists = Blueprint('activists', __name__)

# Get all industry data
@activists.route('/industries', methods=['GET'])
def get_industries():
    cursor = db.get_db().cursor()
    country_name = '(select country from countries c where c.countryID = i.countryID) as country'
    cursor.execute('''select industry, annual_emissions_in_millions, annual_revenue_in_millions, {}
                      from industry i order by annual_emissions_in_millions'''.format(country_name))
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
def get_industry_names():
    cursor = db.get_db().cursor()
    cursor.execute('select distinct industry as label, industryID as value from industry order by industry')
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
    country_name = '(select country from countries c where c.countryID = i.countryID) as country'
    cursor.execute('select industry, annual_emissions_in_millions, annual_revenue_in_millions, {1} from industry i where industryID = {0} order by country'.format(industryID, country_name))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get all city data
@activists.route('/cities', methods=['GET'])
def get_cities():
    cursor = db.get_db().cursor()
    cursor.execute('''select city, GDP_in_billions, population_in_millions, sea_level, trend_year
                      from cities order by city''')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get all continent names
@activists.route('/continents', methods=['GET'])
def get_continents():
    cursor = db.get_db().cursor()
    cursor.execute('select distinct continent as label, continent as value from continents order by continent')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get all countries in a continent
@activists.route('/countries/<continent>', methods=['GET'])
def get_continent_countries(continent):
    cursor = db.get_db().cursor()
    continentIDS = '(select continentid from continents where continent = "{}")'.format(continent)
    cursor.execute('select distinct country as label, country as value from countries where continentID in {}'.format(continentIDS))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get all cities in a country
@activists.route('/cities/<country>', methods=['GET'])
def get_country_cities(country):
    cursor = db.get_db().cursor()
    countryIDS = '(select countryID from countries where country = "{}")'.format(country)
    cursor.execute('select distinct city as label, city as value from cities where countryID in {} order by city'.format(countryIDS))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# get a specific city data
@activists.route('/<cityName>', methods=['GET'])
def get_city(cityName):
    cursor = db.get_db().cursor()
    cursor.execute('''select city, GDP_in_billions, population_in_millions, sea_level, trend_year
                    from cities where city = "{}"'''.format(cityName))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response
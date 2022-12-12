from flask import Blueprint, current_app, request, jsonify, make_response
import json
from src import db


researchers = Blueprint('researchers', __name__)

"""
GET methods
"""

# Get max mitigation id
@researchers.route('/mitigation_techniques/id', methods=['GET'])
def get_mitigation_id():
    cursor = db.get_db().cursor()
    cursor.execute('select max(mitigationID) from mitigation_techniques')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get max adaptation id
@researchers.route('/adaptation_techniques/id', methods=['GET'])
def get_adaptation_id():
    cursor = db.get_db().cursor()
    cursor.execute('select max(adaptationid) from adaptation_techniques')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get max radiative forcing city id
@researchers.route('/radiative_forcing/id', methods=['GET'])
def get_rf_cityID():
    cursor = db.get_db().cursor()
    cursor.execute('select max(rf_cityID) from radiative_forcing')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get max id
@researchers.route('/<table>/<id>', methods=['GET'])
def get_maxID(id, table):
    cursor = db.get_db().cursor()
    cursor.execute('select max({}) from {}'.format(id, table))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

"""
POST methods
"""

# insert new climate change trends data
@researchers.route('/climate_change_trends/insert', methods=['POST'])
def insert_cct():

    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    trend_year = request.form['trend_year']
    temperature = request.form['temperature']
    air_quality = request.form['air_quality']
    sea_level = request.form['sea_level']

    query = f'insert into climate_change_trends (temperature, trend_year, air_quality, sea_level) values (\"{temperature}\", \"{trend_year}\", \"{air_quality}\", \"{sea_level}\")'
    cursor.execute(query)
    db.get_db().commit()
    return 'Success!'

# insert new radiative forcing data
@researchers.route('/radiative_forcing/insert', methods=['POST'])
def insert_rf():

    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    rf_cityID = request.form['rf_cityID']
    co2 = request.form['co2']
    other_GHG = request.form['other_GHG']
    ozone = request.form['ozone']
    ARI = request.form['ARI']
    surface_albedo = request.form['surface_albedo']
    contrails = request.form['contrails']
    SWCH4 = request.form['SWCH4']
    solar_irradiance = request.form['solar_irradiance']
    trend_year = request.form['trend_year']

    query = f'insert into radiative_forcing (rf_cityID, co2, other_GHG, ozone, ARI, surface_albedo,contrails,SWCH4,solar_irradiance) values (\"{rf_cityID}\", \"{co2}\", \"{other_GHG}\", \"{ozone}\", \"{ARI}\", \"{surface_albedo}\", \"{contrails}\", \"{SWCH4}\", \"{solar_irradiance}\", \"{trend_year}\")'
    cursor.execute(query)
    db.get_db().commit()
    return 'Success!'

# insert new adaptation techniques data
@researchers.route('/adaptation_techniques/insert', methods=['POST'])
def insert_adap_tech():
    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    adaptationid = request.form['adaptationid']
    adaptation_technique = request.form['adaptation_technique']
    est_lives_saved_per_dollar = request.form['est_lives_saved_per_dollar']
    est_dollars_saved_per_dollar = request.form['est_dollars_saved_per_dollar']
    query = f'insert into adaptation_techniques (adaptationid, adaptation_technique, est_lives_saved_per_dollar, est_dollars_saved_per_dollar) values (\"{adaptationid}\", \"{adaptation_technique}\", \"{est_lives_saved_per_dollar}\", \"{est_dollars_saved_per_dollar}\")'
    cursor.execute(query)
    db.get_db().commit()
    return 'Success!'

# insert new mitigation techniques data
@researchers.route('/mitigation_techniques/insert', methods=['POST'])
def insert_mitig_tech():

    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    mitigationID = request.form['mitigationID']
    mitigation_type = request.form['mitigation_type']
    WPM_RFMPD = request.form['WPM_RFMPD']
    
    query = f'insert into mitigation_techniques(mitigationID, mitigation_type, WPM_RFMPD) values (\"{mitigationID}\", \"{mitigation_type}\", \"{WPM_RFMPD}\")'
    cursor.execute(query)
    db.get_db().commit()
    return 'Success!'
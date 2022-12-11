from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

governments = Blueprint('governments', __name__)


@governments.route('/countries' , methods=['GET'])
def get_countries():
    cursor = db.get_db().cursor()
    query = 'select distinct country as value, country as label from countries'
    cursor.execute(query)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@governments.route('/country_data' , methods=['GET'])
def country_data():
    cursor = db.get_db().cursor()
    query = 'select * from countries'
    cursor.execute(query)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@governments.route('/people/<countryName>', methods=['GET'])
def get_country_data(countryName):
    cursor = db.get_db().cursor()
    countryName=str(countryName)
    cursor.execute('select p.* from people p join countries c on p.countryID = c.countryID where c.country="{}"'.format(countryName))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


@governments.route('/industry/<countryName>' , methods=['GET'])
def get_industries(countryName):
    cursor = db.get_db().cursor()
    query = 'select i.* from industry i join countries c on i.countryID = c.countryID where c.country="{}"'.format(countryName)
    cursor.execute(query)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@governments.route('/max_pid', methods=['GET'])
def get_max_pid():
    cursor = db.get_db().cursor()
    cursor.execute('select max(peopleID) from people')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


@governments.route('/person', methods=['POST'])
def add_person():
    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    fname = request.form['fname']
    lname = request.form['lname']
    pid = request.form['pid']
    email = request.form['email']
    age = request.form['age']
    gender = request.form['gender']
    pnumber = request.form['pnumber']
    ann_em = request.form['ann_em']
    race = request.form['race']
    cityid = request.form['cityid']
    countryid = request.form['countryid']
    industryid = request.form['industryid']
    str_address = request.form['str_address']
    pos_code = request.form['pos_code']
    income = request.form['income']
    query = f'insert into people(first_name, last_name, peopleID, age, income, gender, race, annual_emissions, email, phone, street, postal_code, industryID, cityID, countryID) values(\"{fname}\", \"{lname}\", {pid}, {age}, {income}, \"{gender}\", \"{race}\", {ann_em}, \"{email}\", \"{pnumber}\", \"{str_address}\", \"{pos_code}\", {industryid}, {cityid}, {countryid})'
    cursor.execute(query)
    db.get_db().commit()
    return 'Success!'

@governments.route('/all_people' , methods=['GET'])
def get_people():
    cursor = db.get_db().cursor()
    query = 'select * from people order by first_name'
    cursor.execute(query)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@governments.route('/add_industry', methods=['POST'])
def add_industry():
    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    industryid = request.form['industryid']
    industry = request.form['industry']
    ann_em = request.form['ann_em']
    ann_rev = request.form['ann_rev']
    countryid = request.form['countryid']
    query = f'insert into industry(industryID, industry, annual_emissions_in_millions, annual_revenue_in_millions, countryID) values({industryid}, "{industry}", {ann_em}, {ann_rev}, {countryid})'
    cursor.execute(query)
    db.get_db().commit()
    return "Success!"

@governments.route('/max_industryid', methods=['GET'])
def get_max_industryid():
    cursor = db.get_db().cursor()
    cursor.execute('select max(industryID) from industry')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response
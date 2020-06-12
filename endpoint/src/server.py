from flask import Flask
from flask import request
from flask.json import jsonify
import simplejson as json
from datetime import datetime
import mysql.connector

cnx = mysql.connector.connect(user='root', password='xBarry!019',
                            host = '127.0.0.1', database='mydb',
                            auth_plugin='mysql_native_password')
cursor = cnx.cursor()

app = Flask(__name__)

def get_table(table):
    query = (f"SELECT * from {table}")
    cursor.execute(query)
    query_result = list()
    for item in cursor:
        query_result.append(item)
    return json.dumps(query_result)

def add_new_row(table, request):
    body_json = request.get_json()
    id = None
    keys = ""
    values = ""
    print(body_json)
    for key in body_json:
        if key == "id":
            id = body_json[key]
        else:
            if body_json[key] != None:
                keys += f"{key}, "
                values += f"'{body_json[key]}', "

    keys = keys[:-2]
    values = values[:-2]
    insert_statement = (f"INSERT INTO {table} "
                        f"({keys}) "
                        f"VALUES ({values});")
    print(insert_statement)
    cursor.execute(insert_statement)
    try: 
        cnx.commit()
    except mysql.connector.Error as error:
        cnx.rollback()
        return jsonify({'error': 'There has been an error and row data hasn\'t been insterted'})
    finally: 
        return jsonify({'message': 'Table updated correctly'})

def update_row_values(table, request):
    body_json = request.get_json()
    id = None
    parameters_update_set = ""
    for key in body_json:
        if key == "id":
            id = body_json[key]
        else:
            if body_json[key] != None:
                parameters_update_set += f"{key} = {body_json[key]}, "

    if not id:
        return jsonify({'error': 'row cannot be updated, id has not been provided'})

    parameters_update_set = parameters_update_set[:-2]
    update_statement = (f"UPDATE {table} "
                        f"SET {parameters_update_set} "
                        f"WHERE id = {id};")
    
    cursor.execute(update_statement)
    try: 
        cnx.commit()
    except mysql.connector.Error as error:
        cnx.rollback()
        return jsonify({'error': 'There has been an error and data hasn\'t been updated'})
    finally: 
        return jsonify({'message': 'Table updated correctly'})

def delete_rows(table, request):
    body_json = request.get_json()
    try: 
        for id in body_json:
            delete_statement = f"DELETE FROM `{table}` WHERE id = {id};"
            print(delete_statement)
            cursor.execute(delete_statement)
            cnx.commit()
    except mysql.connector.Error as error:
        cnx.rollback()
        return jsonify({'error': 'There has been an error and data hasn\'t been deleted'})
    finally: 
        return jsonify({'message': 'Rows deleted correctly'})
    

@app.route('/api/table/<string:table>', methods=['GET', 'POST', 'PUT', 'DELETE'])
def table_request(table):
    if request.method == 'GET':
        return get_table(table)
    elif request.method == 'POST':
        return add_new_row(table, request)
    elif request.method == 'PUT':
        return update_row_values(table, request)
    elif request.method == 'DELETE':
        return delete_rows(table, request)

def get_vehicle_statistics():
    return jsonify({'message': 'jest w pyte'})

@app.route('/api/statistics', methods=['POST'])
def get_filtered_data():
    body_json = request.get_json()
    parking_lots = body_json['parkingLots']
    date_from = body_json['dateFrom']
    date_to = body_json['dateTo']
    license_plate = body_json['licensePlate']
    payment_status = body_json['paymentStatus']
    query_base = (f"SELECT parkinglots.name, count(eparkingtickets.id) "
                f"FROM eparkingtickets "
                f"INNER JOIN parkinglots ON parkinglots.id=eparkingtickets.parking_lot_id "
                f"INNER JOIN vehicles ON vehicles.id=eparkingtickets.vehicle_id "
                f"INNER JOIN payments ON payments.bill_id=eparkingtickets.bill_id OR payments.fine_id=eparkingtickets.fine_id ")
    if parking_lots is None:
        return get_vehicle_statistics()
    else:
        statistics = list()
        for p_lot in parking_lots:
            conditions = list()
            conditions.append(f"parkinglots.id = {p_lot} ")
            if not (date_from is None or date_to is None):
                print(f"datefrom: {type(date_from)} dateto: {type(date_to)}")
                datetime_from = datetime.fromtimestamp(date_from/1000)
                datetime_to = datetime.fromtimestamp(date_to/1000)
                conditions.append(f"((eparkingtickets.start_date BETWEEN '{datetime_from}' AND '{datetime_to}') "
                                f"AND "
                                f"(eparkingtickets.end_date BETWEEN '{datetime_from}' AND '{datetime_to}')) ")

            if license_plate is not None:
                conditions.append(f"vehicles.license_plate = '{license_plate}' ")

            if payment_status is not None:
                conditions.append(f"payments.status = '{payment_status}' ")

            condition_statement = "WHERE "
            for condition in conditions:
                condition_statement += condition
                if condition == conditions[-1]:
                    condition_statement += ";"
                else:
                    condition_statement += "AND "
            
            query = f"{query_base}\n{condition_statement}"
            print(query)
            cursor.execute(query)
            query_result = list(cursor)[0]
            print(query_result)
            statistics.append({"name": query_result[0], "value": query_result[1]})    
        return jsonify(statistics)

def select_column(table):
    table = table.lower()
    if table == "addresses":
        return "street"
    elif table == "bills":
        return "total_cost"
    elif table == "cameras":
        return "is_active"
    elif table == "controllers":
        return "surname"
    elif table == "eparkingtickets":
        return "status"
    elif table == "fines":
        return "total_cost"
    elif table == "parkinglots":
        return "name"
    elif table == "parkingmeters":
        return "nfc_tag_id"
    elif table == "payments":
        return "payment_reference"
    elif table == "users":
        return "login"
    elif table == "vehicles":
        return "model_name"
    elif table == "zones":
        return "cost_per_hour"

@app.route('/api/foreign-keys', methods=['POST'])
def get_foreign_keys():
    body_json = request.get_json()
    result_dict = dict()
    for table in body_json:
        query = (f"SELECT id, {select_column(table)} from {table}")
        cursor.execute(query)
        rows = list()
        for item in cursor:
            to_extract = list(item)
            rows.append({'id': to_extract[0], select_column(table): to_extract[1]})
        result_dict[table] = rows
    return jsonify(json.dumps(result_dict))
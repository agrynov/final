from flask import Flask, request, jsonify
import csv
import os

app = Flask(__name__)

CSV_FILE = 'students.csv'


# Helper Functions
def read_csv():
    if not os.path.exists(CSV_FILE):
        with open(CSV_FILE, mode='w', newline='') as file:
            writer = csv.writer(file)
            writer.writerow(['id', 'first_name', 'last_name', 'age'])
    with open(CSV_FILE, mode='r') as file:
        return list(csv.DictReader(file))


def write_csv(data):
    with open(CSV_FILE, mode='w', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=['id', 'first_name', 'last_name', 'age'])
        writer.writeheader()
        writer.writerows(data)


# API Endpoints
@app.route('/students', methods=['GET'])
def get_students():
    students = read_csv()
    last_name = request.args.get('last_name')
    if last_name:
        filtered_students = [s for s in students if s['last_name'].lower() == last_name.lower()]
        if filtered_students:
            return jsonify(filtered_students), 200
        return jsonify({"error": "No students found with the provided last name"}), 404
    return jsonify(students), 200


@app.route('/students/<int:id>', methods=['GET'])
def get_student_by_id(id):
    students = read_csv()
    student = next((s for s in students if int(s['id']) == id), None)
    if student:
        return jsonify(student), 200
    return jsonify({"error": "Student not found"}), 404


@app.route('/students', methods=['POST'])
def add_student():
    data = request.json
    if not data or any(key not in ['first_name', 'last_name', 'age'] for key in data.keys()):
        return jsonify({"error": "Invalid fields in request body"}), 400

    if not all(field in data for field in ['first_name', 'last_name', 'age']):
        return jsonify({"error": "Missing required fields"}), 400

    students = read_csv()
    new_id = 1 if not students else int(students[-1]['id']) + 1
    new_student = {
        'id': new_id,
        'first_name': data['first_name'],
        'last_name': data['last_name'],
        'age': data['age']
    }
    students.append(new_student)
    write_csv(students)
    return jsonify(new_student), 201


@app.route('/students/<int:id>', methods=['PUT'])
def update_student(id):
    data = request.json
    if not data or any(key not in ['first_name', 'last_name', 'age'] for key in data.keys()):
        return jsonify({"error": "Invalid fields in request body"}), 400

    students = read_csv()
    student = next((s for s in students if int(s['id']) == id), None)
    if not student:
        return jsonify({"error": "Student not found"}), 404

    for field in ['first_name', 'last_name', 'age']:
        student[field] = data.get(field, student[field])
    write_csv(students)
    return jsonify(student), 200


@app.route('/students/<int:id>', methods=['PATCH'])
def update_student_age(id):
    data = request.json
    if not data or 'age' not in data:
        return jsonify({"error": "Invalid or missing fields in request body"}), 400

    students = read_csv()
    student = next((s for s in students if int(s['id']) == id), None)
    if not student:
        return jsonify({"error": "Student not found"}), 404

    student['age'] = data['age']
    write_csv(students)
    return jsonify(student), 200


@app.route('/students/<int:id>', methods=['DELETE'])
def delete_student(id):
    students = read_csv()
    student = next((s for s in students if int(s['id']) == id), None)
    if not student:
        return jsonify({"error": "Student not found"}), 404

    students = [s for s in students if int(s['id']) != id]
    write_csv(students)
    return jsonify({"message": "Student deleted successfully"}), 200


if __name__ == '__main__':
    app.run(debug=True)
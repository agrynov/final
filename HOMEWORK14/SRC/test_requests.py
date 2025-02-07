import requests

BASE_URL = "http://127.0.0.1:5001"
RESULTS_FILE = "results.txt"


def log_result(message):
    print(message)
    with open(RESULTS_FILE, "a") as file:
        file.write(message + "\n")


def main():
    # Clear results file
    open(RESULTS_FILE, "w").close()

    # GET all students
    response = requests.get(f"{BASE_URL}/students")
    log_result(f"GET /students:\n{response.json()}\n")

    # POST three students
    students = [
        {"first_name": "Kyrill", "last_name": "Ivanov", "age": "20"},
        {"first_name": "Iryna", "last_name": "Shevchenko", "age": "22"},
        {"first_name": "Vladislav", "last_name": "Vladchenko", "age": "19"},
        {"first_name": "Andriy", "last_name": "Andreev", "age": "19"},
        {"first_name": "Oleksandr", "last_name": "Oleksandrov", "age": "21"},
    ]
    for student in students:
        response = requests.post(f"{BASE_URL}/students", json=student)
        log_result(f"POST /students:\n{response.json()}\n")

    # GET all students
    response = requests.get(f"{BASE_URL}/students")
    log_result(f"GET /students:\n{response.json()}\n")

    # PATCH second student's age
    response = requests.patch(f"{BASE_URL}/students/2", json={"age": "23"})
    log_result(f"PATCH /students/2:\n{response.json()}\n")

    # GET second student
    response = requests.get(f"{BASE_URL}/students/2")
    log_result(f"GET /students/2:\n{response.json()}\n")

    # PUT update third student
    response = requests.put(f"{BASE_URL}/students/3", json={"first_name": "Vladislav", "last_name": "Vladchenko", "age": "20"})
    log_result(f"PUT /students/3:\n{response.json()}\n")

    # GET third student
    response = requests.get(f"{BASE_URL}/students/3")
    log_result(f"GET /students/3:\n{response.json()}\n")

    # GET all students
    response = requests.get(f"{BASE_URL}/students")
    log_result(f"GET /students:\n{response.json()}\n")

    # DELETE first student
    response = requests.delete(f"{BASE_URL}/students/1")
    log_result(f"DELETE /students/1:\n{response.json()}\n")

    # GET all students
    response = requests.get(f"{BASE_URL}/students")
    log_result(f"GET /students:\n{response.json()}\n")


if __name__ == "__main__":
    main()
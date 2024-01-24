import csv
import os


def main():
    file = "liste-login-pass.csv"
    counter = 0

    with open(file, newline='') as list:
        student_list = csv.reader(list, delimiter=";")

        for line in student_list:

            student_id = line[3]
            password = line[4]

            print(os.popen(f"htpasswd -b -B /var/www/admin.passwd {student_id} {password}").read())

            if counter == 3:
                break
            else:
                counter += 1


if __name__ == '__main__':
    main()

from datetime import date
import time

def main():
    f = open("scriptlog.txt", "a")
    today = date.today()
    t = time.localtime()
    current_time = time.strftime("%H:%M:%S", t)

    # Month abbreviation, day and year
    current_date = today.strftime("%b-%d-%Y")

    f.write(f"{current_date} {current_time} : Sudo detected \n")
    f.close()


if __name__ == '__main__':
    main()

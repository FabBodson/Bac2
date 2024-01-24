import os
from settings import *

# Total ram free Constant
__OID = ".1.3.6.1.4.1.2021.4.11.0"
__FILE = "/var/log/total_ram_free.log"
__COMMAND = f"snmpget -v2c -O v -c public {IP_HOST} {__OID} >> {__FILE}".split()


def main():
    print(__COMMAND)
    open(__FILE, 'a').close()
    # Time in second
    start = time.time()
    while time.time() < start + DURATION:
        os.popen(__COMMAND).read()


if __name__ == '__main__':
    main()


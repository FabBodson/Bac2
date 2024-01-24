import os
import sys
import zipfile


def main():

    directory = str(sys.argv[1])
    dir_to_zip = (directory + "-backup.zip").split("/")[-1]
    zip_file = zipfile.ZipFile(dir_to_zip, 'w', zipfile.ZIP_DEFLATED)

    for root, directories, files in os.walk(directory):
        for file in files:
            zip_file.write(os.path.join(root, file))
    zip_file.close()

    print(os.popen(f'lftp backup:root@192.168.131.2 -e "put /root/Documents/11_FTP/{dir_to_zip}; exit;"').read())


if __name__ == '__main__':
    main()
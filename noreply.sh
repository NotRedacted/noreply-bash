#!/bin/bash
rm /tmp/body;
rm /tmp/message;
userTable=(/home/vmail/REDACTED/*/);
userTable=("${userTable[@]%/}");
userTable=("${userTable[@]##*/}");
arrayLength=${#userTable[@]};

for (( i=0; i<${arrayLength}; i++ ));
do
  echo "${userTable[$i]}"
  sleep 0.05;
done

echo "Loaded ${arrayLength} users."
echo "Email all? (Y/N)"
read emailAll;
echo "Subject:";
read subject;
rm /tmp/message;
echo "Type the body and save the file, You can use HTML5 tags.";
sleep 1;
nano /tmp/body;
sleep 0.25;
body=$(cat /tmp/body);

if [ ${emailAll} == "n" ]; then
  #We're emailing one user.
  echo "Recipient Address:";
  read recipient;
  echo -e "From: noreply@REDACTED";
  echo -e "To: ${recipient}" >> message;
  echo -e "Subject: ${subject}" >> message;
  echo -e "Mime-Version: 1.0">> message;
  echo -e "Content-Type: text/html" >> message;
  echo -e "${body}" >> message;
  sendmail -f noreply@REDACTED $recipient < message;
fi

if [ ${emailAll} == "y" ]; then
  #We're emailing all users for the domain.
  for (( i=0; i<${arrayLength}; i++ ));
    do
      echo -e "From: noreply@REDACTED">> message;
      echo -e "To: ${userTable[$i]}@REDACTED" >> message;
      echo -e "Subject: ${subject}" >> message;
      echo -e "Mime-Version: 1.0">> message;
      echo -e "Content-Type: text/html" >> message;
      echo -e "${body}" >> message;
      sendmail -f noreply@REDACTED "${userTable[$i]}@REDACTED" < message;
      echo "Sent message to ${userTable[$i]}@REDACTED";
      sleep 0.25;
      rm /tmp/message;
    done
fi
rm /tmp/message;
rm /tmp/body;

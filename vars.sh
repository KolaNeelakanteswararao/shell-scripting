#! /bin/bash

student_name="Raju"
echo student_name=$student_name
echo student_name=${student_name}

Date=11-12-2022
echo Good Morning Today date is $Date

DATE=$(date +%f)
echo Good Morning Today date is $DATE

expr=$((2+3-4*5/7*8))
echo expr output=$expr
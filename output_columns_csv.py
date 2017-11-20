import os
import csv
import pandas as pd 
import glob

"""
Maansi Desai & Alia Shafi, November 2017 
Project: Speech Arrest 

This script reads in all csv files (one per patient) which contains data on stimulation time (onset and offset), error time (onset and off set), 
error type, and columns which record the presence of stimulation (denoted at Y). 
This script then performs a series of basic computations:
1) extracts the total number of each error type across ALL files 
2) identifies the times across all patients for which stimulation onset occurs "x amount" of milliseconds/seconds post trial and generated an error
3) 

"""

directoryPath = ('/Users/maansi/Desktop/Arrest_data/final_csvs/*.csv') 		#change path for where csv files live

files = glob.glob(directoryPath) 		#glob module merges all file types into one variable 

#initialize variables for counting output 
all_motor = 0
all_word = 0
all_syllable = 0
all_number = 0
all_stim = 0
stim_error_pt = 0

#read into all files and define columns to extract data from 
for read in files:
	
	reader = pd.read_csv(read, encoding = "ISO-8859-1")
	n = []

	error_col = reader["error"] 			#these strings in [] correspond to the header of each column of each csv file 
	stim_col = reader["stim"]
	stim_on = reader["stim_onset"]		#onset of stimulation error time (in seconds)
	error_onset = reader["s_onset"]			# onset of error time from patient (in seconds)
	stim_off = reader["stim_offset"]		
	
	stim_all = [reader["s_onset"],reader["stim_onset"], reader["error"]]		#read three columns and store into one variable 
	
	#convert columns of csvs to floating points
	df_error = pd.DataFrame(error_onset)
	df_stim = pd.DataFrame(stim_on)

	

	count_motor = 0
	count_word = 0
	count_syllable = 0
	count_number = 0
	count_stim = 0
	stim_compare = 0 			#initialize to identify trials in which stim_onset (sec) occurred in the middle of patient making error = error_on_s (sec) 
	

	for row1 in df_error:		# NOT OUTPUTTING CORRECTLY: attempting to compare int values in stim_on column with int values in error_onset column
		for row2 in df_stim:
			if row1 > row2:
				stim_compare += 1
				print (row1[0] + "<" + row2[0])
			else:
				continue 


	for row in stim_col: 
		if row == "Y":
			count_stim += 1

	for row in error_col:
		if row == 'motor':
			count_motor += 1
		if row == 'word':
			count_word += 1
		if row == 'syllable':
			count_syllable += 1
		if row == 'number':
			count_number += 1
	
	for row in reader:
		if "motor" in row:
			stim_motor += stim_on

	all_motor += count_motor
	all_word += count_word
	all_syllable += count_syllable
	all_number += count_number
	all_stim += count_stim
	stim_error_pt += stim_compare



print('Number of motor errors = ', all_motor)
print('Number of word errors = ', all_word) 
print('Number of syllable errors = ', all_syllable)
print('Number of number errors = ', all_number)
print('Number of stimulation trials with Y = ', all_stim)	  
print(stim_error_pt)



"""
TO DO ~ What we want in our script:
1) Extract trials where stim happens in middle of pt's response
2) extract stim duration and error type (?)
3) For trials where stim happens in middle of response, where is the break in the pt's speech?
"""
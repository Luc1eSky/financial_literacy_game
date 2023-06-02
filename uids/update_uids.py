import os
import csv
import firebase_admin
from firebase_admin import credentials, firestore, initialize_app
import keyboard


# connect to firebase via service account
cred = credentials.Certificate('firebase_admin.json')
app = initialize_app(cred)
db = firestore.client()



# find all csv files in current directory
for file in os.listdir(os.getcwd()):
	if file.endswith(".csv"):
		# get file name without extension
		fileName = os.path.splitext(file)[0]

		# open csv file
		with open(file) as csv_file:
			csv_reader = csv.reader(csv_file, delimiter=',')
			csv_list = list(csv_reader)
			# check if headers are in correct order
			header = csv_list[0]
			if 'uid' not in header[0]:
				print('"uid" not found in first column of header')
				quit()
			if 'firstName' not in header[1]:
				print('"firstName" not found in second column of header')
				quit()
			if 'lastName' not in header[2]:
				print('"lastName" not found in third column of header')
				quit()
			uid_listCSV = csv_list[1:]


			uidListsCollection = db.collection(u'uidLists')

			# TODO: WHAT IF NAME IS NOT FOUND?!
			locationDoc = uidListsCollection.document(fileName).get()
			# create document if it does not exist yet
			if not locationDoc.exists:
				uidListsCollection.document(fileName).set({
					'uids': []
					})
				locationDoc = uidListsCollection.document(fileName).get()

			uidListFirestore = locationDoc.to_dict().get("uids")

			sameUIDs = 0
			newUIDs = 0

			# create uid only list from firestore list
			uidsOnlyFirestore = []
			for entryFirestore in uidListFirestore:
				uidsOnlyFirestore.append(entryFirestore['uid'])

			# create uid only list from csv list
			uidsOnlyCSV = []
			for entryCSV in uid_listCSV:
				uidsOnlyCSV.append(entryCSV[0])

			# check for uids that are not present anymore in new csv
			missingUIDs = []
			for uidFirestore in uidsOnlyFirestore:
				if uidFirestore not in uidsOnlyCSV:
					missingUIDs.append(uidFirestore)

			# check for new uids that are not present in firestore
			newUIDs = []
			for uidCSV in uidsOnlyCSV:
				if uidCSV not in uidsOnlyFirestore:
					newUIDs.append(uidCSV)
			print('---------------')
			print('Updating', fileName)
			print('')
			print(len(missingUIDs), 'missing UIDs:')
			for missingUID in missingUIDs:
				print(missingUID)
			print('')
			print(len(newUIDs), 'new UIDs:')
			for newUID in newUIDs:
				print(newUID)
			print('')

			print('CONTINUE? y/n')

			while True:
				print(keyboard.read_key())
				if keyboard.read_key() == "y":
					break
				if keyboard.read_key() == "n":
					quit()

			print('UPDATING DATA...')

			newFirestoreList = []
			for entryCSV in uid_listCSV:
				mapEntry = {
					'uid': entryCSV[0],
					'firstName': entryCSV[1],
					'lastName' : entryCSV[2],
				}
				newFirestoreList.append(mapEntry)

			uidListsCollection.document(fileName).update({
				'uids' : newFirestoreList
				})





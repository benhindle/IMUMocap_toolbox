
# Pythono3 code to delete highg files and rename multiple  
# files in a directory or folder 
  
# importing os module 
import os
import glob  
path = "/Users/<insert_username>/<folder_name>"


# Delete all highg files ** ONLY USE IF DESIRED
fileList_low = glob.glob(path + '*lowg.csv')
fileList_mag = glob.glob(path + '*_mag.csv')
for filePath in fileList_low:
    try:
        os.remove(filePath)
    except:
        print("Error while deleting file : ", filePath)

for filePath in fileList_mag:
    try:
        os.remove(filePath)
    except:
        print("Error while deleting file : ", filePath)


# Delete lowg component of magnetic calibration
fileListLow = glob.glob(path + 'MC*highg.csv')
for filePathLow in fileListLow:
    try:
        os.remove(filePathLow)
    except:
        print("Error while deleting file : ", filePathLow)

# Rename files 
for filename in os.listdir(path): 
    if "_TS-" in filename:
      nameVect = filename.split("_TS-")
      nameVect2 = nameVect[1].split("_")
      newFileName = nameVect[0] + "_" + nameVect2[0] + "__" + nameVect2[-1]
      
      src = path + filename 
      newFileName = path + newFileName

      os.rename(src, newFileName) 

import os
import numpy as np
from skimage import io
import skimage as skim
import tensorflow as tf
print('TensorFlow Version: '+ tf.__version__)



def ObtainVectorizedImages(curdd):
	curr_dir_files = os.listdir(curdd)
	Image_data_dir = curdd+'/'+curr_dir_files[0]
	#Subdirectory with train data folders
	ImFiles = os.listdir(Image_data_dir)
	#Number of files in subdirectory
	numFl = len(ImFiles)
	TheCellData = list()
	class_labels=list()
	for i in range(numFl):
		Image_dir = Image_data_dir+'/'+ImFiles[i]
		Cell_image_dir = os.listdir(Image_dir)
		if(ImFiles[i][-1]=='1'):
			class_labels.append(1)
		else:
			class_labels.append(0)
		Singlecell=list()
		for j in range(len(Cell_image_dir)):
			CellImage = Image_dir+'/'+Cell_image_dir[j]
			Singlecell.append(np.array(skim.img_as_float(io.imread(CellImage))))
		TheCellData.append(np.array(Singlecell))
	TheCellData = np.array(TheCellData)	
	class_labels = np.array(class_labels)
	#print(class_labels)
	#print('\n'+str(TheCellData.shape)+str(TheCellData.dtype))
	#print('\n'+str(class_labels.shape)+str(class_labels.dtype))
	return [TheCellData,class_labels]

def vectorizeall(all_cell_data):
	VecDat=list()
	res=list()
	for i in range(all_cell_data.size):
		for j in range(all_cell_data[i].size):
			cellim=np.reshape(all_cell_data[i][j],(all_cell_data[i][j].size,1))
			zeropadd=np.zeros((441-all_cell_data[i][j].size,1))
			vectim=np.concatenate((cellim,zeropadd),axis=0)
			VecDat.append(vectim)
			#fix to 21x21 image patches. 
			#Test if any image patch has more than 21x21 pixels
			#if(all_cell_data[i][j].size>=441):
			#	c+=1
			#	print(i,j)
		res.append(np.array(VecDat))		
	return res


if __name__=="__main__":
	print('\nCurrent Directory is: ')
	curr_dir = str(os.getcwd());
	print(curr_dir+'\n')
	
	#Train Data ready
	All_Cell_Data = ObtainVectorizedImages(curr_dir)
	data = vectorizeall(All_Cell_Data[0])	

	print(data)

	print("\nFUN IS HERE")
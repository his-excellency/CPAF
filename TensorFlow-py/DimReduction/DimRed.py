import numpy as np
import tensorflow as tf
print('TensorFlow Version: '+ tf.__version__)
#tf.GraphKeys.VARIABLES = tf.GraphKeys.GLOBAL_VARIABLES

#Later - will create a function for obtaining data
#points from the data file
num_input_data_points = 434
num_hidl1 = num_input_data_points/2

Tdat = tf.placeholder('float',shape=(1,num_input_data_points))


def TheNetworkModel(inp):
	Hidden_Layer = {
	"weights": tf.Variable(tf.random_normal([num_input_data_points,num_hidl1])),
	"Bias": tf.Variable(tf.random_normal([1, num_hidl1]))
	}

	Output_layer = {
	"weights": tf.Variable(tf.random_normal([num_hidl1,num_input_data_points])),
	"Bias": tf.Variable(tf.random_normal([1, num_input_data_points]))
	}

	hid_layer1 = tf.add(tf.matmul(inp, Hidden_Layer["weights"]),Hidden_Layer["Bias"])
	hid_layer1 = tf.nn.relu(hid_layer1)

	output = tf.add(tf.matmul(hid_layer1, Output_layer["weights"]),Output_layer["Bias"])

	return output

def Train_Neural_Net(Tdat):
	result = TheNetworkModel(Tdat)
	cost = tf.reduce_sum(tf.nn.l2_loss(tf.sub(Tdat,result)))
	optimizer = tf.train.AdamOptimizer().minimize(cost)

	epochs = 1000
	with tf.Session() as sess:
		sess.run(tf.initialize_all_variables())
		epoch_loss = 0;
		inp_data = np.random.rand(1, num_input_data_points)
		for itr in range(epochs):
			res,_,c = sess.run([result, optimizer, cost], feed_dict={Tdat: inp_data})
			fin_acc = np.sum(np.sqrt(np.power(np.subtract(res,inp_data),2)))/num_input_data_points
			#print 'Epoch '+str(itr+1)+' out of '+str(epochs)+'| Error: '+str(fin_acc)
			#Need to process multiple examples in batches
		#fin_acc = (tf.sqrt(tf.reduce_sum(tf.squared_difference(Tdat,result)))/num_input_data_points)
		sess.close()

	return [fin_acc,res]
	
				
if __name__ == "__main__":
	#inp_data = tf.placeholder(tf.float32, shape=(1,num_input_data_points))
	inp_data = tf.random_normal([1, num_input_data_points])
	#out_data = tf.placeholder(tf.float32, shape=(None,num_input_data_points))
	out = Train_Neural_Net(inp_data)
	#print out
	print 'FINAL ACCURACY: ' + str(100-out[0])
	

	
	
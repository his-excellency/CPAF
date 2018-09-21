import numpy as np
import tensorflow as tf

x = tf.constant(512313)
print(x)
sess = tf.Session()
print(sess.run(x))
sess.close()
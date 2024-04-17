import numpy as np
import sys

# Set print options for numpy arrays
np.set_printoptions(threshold=sys.maxsize, edgeitems=30, linewidth=100000, 
    formatter=dict(float=lambda x: "%.3g" % x))

def test(g = "11101101101110001000001100100000", parallization = 8):
    g_size = len(g)
    g_matrix = np.fromiter(g, dtype=np.uint).reshape(1,g_size)
    print(g_matrix)
    big_i_matrix = np.identity(g_size-1)
    
    small_i_matrix = np.identity(parallization-1)
    
    big_i_matrix=np.c_[np.zeros(g_size-1), big_i_matrix, np.zeros((g_size-1,parallization))]
    big_i_matrix=np.r_[ big_i_matrix, np.c_[g_matrix,np.zeros((1,parallization))]]
    big_i_matrix=np.r_[ big_i_matrix, np.c_[np.zeros((1,g_size+parallization-1)),np.ones((1,1))]]
    big_i_matrix=np.r_[ big_i_matrix, np.c_[np.zeros((parallization-1,g_size)),np.eye((parallization-1)),np.zeros((parallization-1,1))]]

    
    print(big_i_matrix)
    

# Example usage:

test()
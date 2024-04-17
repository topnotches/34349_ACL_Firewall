import numpy as np
import sys

# Set print options for numpy arrays
np.set_printoptions(threshold=sys.maxsize, edgeitems=30, linewidth=100000, 
    formatter=dict(float=lambda x: "%.3g" % x))


class acl_hash():
    def __init__(self, lof_g_funcs =["11101101101110001000001100100000"], crc_length = 32, parallelization = 8):
        self.lof_g_funcs = lof_g_funcs
        self.crc_length = crc_length
        self.parallelization = parallelization
        self.design_matrix = self.gen_design_matrix()
        self.lof_poly = [7,15]
        self.lof_poly_tables = []
        for i in range(len(self.lof_poly)):
            self.lof_poly_tables.append(self.crcTableGen(self.lof_poly[i]))
            
    def set_lof_g_funcs(self,lof_g_funcs):
        self.lof_g_funcs = lof_g_funcs
    def set_crc_length(self,crc_length):
        self.crc_length = crc_length
        
    def get_lof_g_funcs(self,lof_g_funcs):
        return lof_g_funcs
    def get_crc_length(self,crc_length):
        return crc_length
    def gen_design_matrix(self, g = "11101101101110001000001100100000", parallization = 8):
        g_size = len(g)
        g_matrix = np.fromiter(g, dtype=np.uint).reshape(1,g_size)
        #print(g_matrix)
        big_i_matrix = np.identity(g_size-1)
        
        small_i_matrix = np.identity(parallization-1)
        
        big_i_matrix=np.c_[np.zeros(g_size-1), big_i_matrix, np.zeros((g_size-1,parallization))]
        big_i_matrix=np.r_[ big_i_matrix, np.c_[g_matrix,np.zeros((1,parallization))]]
        big_i_matrix=np.r_[ big_i_matrix, np.c_[np.ones((1,1)),np.zeros((1,g_size+parallization-2)),np.ones((1,1))]]
        big_i_matrix=np.r_[ big_i_matrix, np.c_[np.zeros((parallization-1,g_size)),np.eye((parallization-1)),np.zeros((parallization-1,1))]]

        
        return big_i_matrix
    
    def print_rtl(self):
        
        # Define a list of strings representing signal names
        my_strings = []
        for i in range(self.crc_length):
            my_strings.append("fcs_parallel_r(" + str(i) +")")
        for i in range(self.parallelization):
            my_strings.append("data_in(" + str(self.parallelization-1-i)+")")

        # Define the transition matrix representing the state transition logic
        my_matrix = self.design_matrix
        # Raise the transition matrix to the power of 8 to represent 8 time steps
        my_new_matrix = np.linalg.matrix_power(my_matrix, self.parallelization)

        # Initialize an empty list to store VHDL expressions for each signal transition
        my_vhdl_expressions = []

        # Iterate over each signal and its corresponding state transition
        for col, string in enumerate(my_strings):
            # Initialize a VHDL expression for the next state of the current signal
            my_vhdl_expression = string + "_next <="
            
            # Iterate over each possible next state for the current signal
            for row in range(len(my_new_matrix)):
                # Check if there is a transition from the current state to the next state
                if my_new_matrix[row, col] == 1:
                    # Append the next state signal to the VHDL expression with XOR operator
                    my_vhdl_expression += " " + my_strings[row] + " xor "
            
            # Remove the last " xor " and append ";" to complete the VHDL expression
            my_vhdl_expression += ";"
            
            # Append the completed VHDL expression to the list
            my_vhdl_expressions.append(my_vhdl_expression)

        # Print header for VHDL code
        print()
        print("Copy paste the following into architecture body:")
        print()

        # Print each VHDL expression with correct syntax
        for string in my_vhdl_expressions:
            print(string[:-6] + ";")

    def calculateByteInCRCTable(self, byteValue, poly):
        for i in range(8):
            byteValue = byteValue << 1
            if (byteValue//256) == 1:
                byteValue = byteValue - 256
                byteValue = byteValue ^ poly
        return byteValue
    
    def crcTableGen(self, poly):
        crcTable = []
        for i in range(256):
            crcTable += [self.calculateByteInCRCTable(i, poly)]
        return crcTable        

    def hash(self, index, seq):
        crc = 0
        for byte in seq:
            crcByte = byte^crc
            crc = self.lof_poly_tables[index][crcByte]
        print(crc)

my_hash = acl_hash()
sequence = [5563786548586, 26, 106, 10, 8, 3, 3, 3, 114]
my_hash.hash(0,sequence)

#my_hash.print_rtl()

        
        
        
        
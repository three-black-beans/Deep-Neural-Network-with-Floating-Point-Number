import csv
from fractions import Fraction


# Make real number to binary
def conv2bin(s):
	x = Fraction(s)
	x1 = x//1
	x2 = x - x1
	digits = []
	tail = ""
	for _ in range(30):
		if x2 == 0:
			tail = ""
			break
		x2 = x2 * 2
		if x2 < 1:
			digits.append("0")
		else:
			digits.append("1")
			x2 -= 1
	return bin(x1)[2:] + "." + "".join(digits) + tail


def main():
    f = open('example1.csv', 'r',  encoding='utf-16')
    rdr = csv.reader(f, delimiter="\t")
    fw = open("new_file.csv", 'w')
    
    data = [] # data to write into new file 
    w_line = [] # line to write into new file
    temp = 0 # Value that checks target number

    for line in rdr:
        for real_num in line:
            real_num = float(real_num)
            
            # target number(4th value) normalization % -> divide 100
            temp += 1 
            if temp == 4:
                real_num = real_num/100
                
            bin_a = conv2bin(real_num)
            comma = bin_a.find(".")
            new_a = bin_a.replace('.', '', 1)
            
            # set exponent
            exponent = 127 + comma - 1
            exp_bin = bin(exponent)
            exp_str = exp_bin[2:]
            
            # set sign
            sign = '0'
            
            # set fragnant
            frag_str = new_a[1:]
            frag_str_len = len(frag_str)
            if frag_str_len < 23:
                frag_str = frag_str + "0" * (23 - frag_str_len)
            
            # set result
            result = sign + exp_str 
            result = result + str(frag_str)
            result = result[0:32]
            if len(result) > 32:
                raise ValueError("error")
            
            w_line.append(result)
            
        temp = 0
        data.append(w_line)
        w_line = []

    writer = csv.writer(fw) 
    writer.writerows(data) 

    fw.close()
    f.close()


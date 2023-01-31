import csv
from fractions import Fraction
import bitstring


f = open('example.txt', 'r',  encoding='utf8')
rdr = csv.reader(f, delimiter="\t")
fw = open("new_file.csv", 'w')

data = [] # data to write into new file 
w_line = [] # line to write into new file
for line in rdr:
    for real_num in line:
        real_num = float(real_num)
        floating_point_num = bitstring.BitArray(float = real_num, length = 32)
        w_line.append(floating_point_num.bin)
    data.append(w_line)
    w_line = []
writer = csv.writer(fw) 
writer.writerows(data) 
fw.close()
f.close()


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
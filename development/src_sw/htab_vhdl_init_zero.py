

for i in range(256):
    upper_nibble = i // 16
    lower_nibble = i % 16
    print("x\"00000000\"" + ", -- "+str(i) + ", " + hex(upper_nibble)+ hex(lower_nibble)[2:])
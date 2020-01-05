#!/usr/bin/python3

arr=[1, 2, 3, 4]

del arr[2]

print( "length: {}".format(len(arr)) )

for i in range(len(arr)):
    print( "index {} value {}".format( i, arr[i] ) )

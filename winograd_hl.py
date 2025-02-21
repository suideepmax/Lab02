
# Given Inputs
d = [0, 0, 1, 2]
g = [10, 20, 30]

# Calculating outputs
m1 = (d[0] - d[2]) * g[0]
m2 = (d[1] + d[2]) * (g[0] + g[1] + g[2]) // 2
m3 = (d[2] - d[1]) * (g[0] - g[1] + g[2]) // 2
m4 = (d[1] - d[3]) * g[2]

# Printing results
print("m1 =", m1)
print("m2 =", m2)
print("m3 =", m3)
print("m4 =", m4)
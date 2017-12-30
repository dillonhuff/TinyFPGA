def is_input(port):
    return (port[1] % 2) == 0

def is_output(port):
    return (port[1] % 2) == 1

num_sides = 4
num_ins = 2

sides = []
# Print all sides
for i in range(0, num_sides):
    ports = []
    for j in range(0, 2*num_ins):
        #sides.append('side_' + str(i) + '_conn_' + str(j))
        ports.append((i, j))

    sides.append(ports)

print '# of sides = ', len(sides)
for side in sides:
    print '--- Side'
    for port in side:
        print port, 'is input = ', is_input(port)

connections = []
for i in range(0, num_sides):

    for port in sides[i]:

        if (is_input(port)):

            for j in range(0, num_sides):

                if (i != j):

                    for out_port in sides[j]:
                        if (is_output(out_port)):
                            connections.append((port, out_port))
                            break;

print '# of connections = ', len(connections)
for conn in connections:
    print conn[0], ' ---> ', conn[1]
    assert(is_input(conn[0]))
    assert(is_output(conn[1]))

outputs_to_inputs = {}
for conn in connections:
    if conn[1] in outputs_to_inputs:
        outputs_to_inputs[conn[1]].append(conn[0])
    else:
        outputs_to_inputs[conn[1]] = []
        outputs_to_inputs[conn[1]].append(conn[0])

    print 'Added ', conn[1], ' as key'
    assert(conn[1] in outputs_to_inputs)

print 'Connections receiver by each output'
for out in outputs_to_inputs:
    print out, ' <--- ', outputs_to_inputs[out]
#assert(len(connections) == (num_sides - 1)*12)
                
#assert(len(sides) == num_sides*num_ins*2)

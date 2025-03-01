import random

LENGTH = 3


def generate_matrix():
    return [
        [random.randint(1, 10) for _ in range(LENGTH)] for _ in range(LENGTH)
    ]


def print_matrix_as_c_array(matrix, name):
    print(f"    int {name}[LENGTH][LENGTH] = \'{{")
    for row in matrix:
        print("        \'{" + ", ".join(map(str, row)) + "},")
    print("    };\n")


# Generate matrices
MatrixA = generate_matrix()
MatrixB = generate_matrix()

# Print matrices in C format
print_matrix_as_c_array(MatrixA, "MatrixA")
print_matrix_as_c_array(MatrixB, "MatrixB")

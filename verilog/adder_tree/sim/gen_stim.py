#rows value should be a factor of NB_IN
import random

def generate_random_table(rows, min_value, max_value):
    table = []
    for _ in range(rows):
        table.append(random.randint(min_value, max_value))
    return table

def save_table_to_file(table, filename):
    with open(filename, 'w') as file:
        for value in table:
            file.write(str(value) + '\n')

# Example usage:
random_table = generate_random_table(4*100, 0, 100)
for value in random_table:
    print(value)
save_table_to_file(random_table, 'stim_in.txt')
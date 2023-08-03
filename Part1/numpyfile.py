import pandas as pd

# Given dictionary
dct = [{'2022-03-31': {'A': 12323, 'B': 123123}}, {'2021-03-31': {'A': 12, 'B': 123}}]

# Initialize empty lists for DataFrame columns
dates = []
A_values = []
B_values = []

# Extract data from the dictionary and populate the lists
for item in dct:
    for date, values in item.items():
        dates.append(date)
        A_values.append(values['A'])
        B_values.append(values['B'])

# Create the DataFrame
data = {'Date': dates, 'A': A_values, 'B': B_values}
df = pd.DataFrame(data)

print(df)

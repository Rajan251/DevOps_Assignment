# Given list
lst = [10, -20, 30, 40, -50, 60, 12, -12, 11, 1, 90, -20, -10, -5, -4]

# Initialize variables to store the sum of positive and negative numbers
sum_positive = 0
sum_negative = 0

# Loop through the list and calculate the sum of positive and negative numbers below 40
for num in lst:
    if num < 40:
        if num > 0:
            sum_positive += num
        elif num < 0:
            sum_negative += num

# Print the results
print("The sum of positive elements in the list below 40:", sum_positive)
print("The sum of negative elements in the list below 40:", sum_negative)

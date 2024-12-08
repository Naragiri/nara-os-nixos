import re
import sys
import os
import json

def extract_user_prefs(input_file):
  pattern = re.compile(r'^\s*user_pref\("([^"]+)",\s*([^;]+)\);\s*$')

  with open(input_file, 'r') as file:
    lines = file.readlines()

  user_prefs = {}
  for line in lines:
    match = pattern.match(line)
    if match:
      key = match[1]  # Extract the first capture group for key
      value = match[2]  # Extract the second capture group for value
      user_prefs[key] = value.strip()  # Add key-value pair to the dictionary

  # Print the user_prefs as a JSON object
  print(json.dumps(user_prefs, indent=2))  # Pretty print with indentation


  # user_prefs = []
  # for line in lines:
  #   match = pattern.match(line)
  #   if match:
  #     user_prefs.append(line.strip())

  # if user_prefs:
  #   print('\n'.join(user_prefs))

if __name__ == '__main__':
  if len(sys.argv) != 2:
    print("Usage: python extractor.py <file>")
    sys.exit(1)

  input_file = sys.argv[1]

  if not os.path.isfile(input_file):
    print(f"Error: Input file '{input_file}' does not exist.")
    sys.exit(1)

  extract_user_prefs(input_file)

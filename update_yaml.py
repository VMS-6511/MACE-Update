import sys
import ast
from ruamel.yaml import YAML
from ruamel.yaml.scalarstring import SingleQuotedScalarString

def update_yaml(yaml_file, updates):
    yaml = YAML()
    yaml.preserve_quotes = True

    # Load the YAML file
    with open(yaml_file, 'r') as file:
        data = yaml.load(file)

    # Apply updates to the YAML file
    for key, value in updates.items():
        # Split key into nested keys if necessary
        keys = key.split('.')
        d = data
        for k in keys[:-1]:
            d = d.setdefault(k, {})
        if key == 'MACE.mapping_concept':
            # Process the value to handle lists and ensure correct quoting
            try:
                # Safely evaluate the value to handle lists and other literals
                parsed_value = ast.literal_eval(value)
                if isinstance(parsed_value, list):
                    # Ensure each string in the list is wrapped in single quotes
                    parsed_value = [
                        SingleQuotedScalarString(item)
                        if isinstance(item, str) and not (item.startswith("'") and item.endswith("'"))
                        else item
                        for item in parsed_value
                    ]
                value = parsed_value
            except (ValueError, SyntaxError):
                # If the value is not a literal, treat it as a string
                value = SingleQuotedScalarString(value)
        elif key == 'MACE.multi_concept':
            # Process the value to handle nested lists and ensure correct quoting
            try:
                # Safely evaluate the value to handle lists and other literals
                parsed_value = ast.literal_eval(value)
                if isinstance(parsed_value, list):
                    # Recursively process nested lists
                    parsed_value = process_list(parsed_value)
                value = parsed_value
            except (ValueError, SyntaxError):
                # If the value is not a literal, treat it as a string
                value = SingleQuotedScalarString(value)
        
        else:
            try:
                parsed_value = ast.literal_eval(value)
                value = parsed_value
            except (ValueError, SyntaxError):
                pass


        d[keys[-1]] = value

    # Write the updated YAML back to the file
    with open(yaml_file, 'w') as file:
        yaml.dump(data, file)

    print(f"Updated {yaml_file} with fields: {updates}")

def process_list(lst):
    """
    Recursively process a list to ensure strings are correctly single-quoted.
    """
    processed_list = []
    for item in lst:
        if isinstance(item, list):
            processed_list.append(process_list(item))  # Recursively process nested lists
        elif isinstance(item, str):
            processed_list.append(SingleQuotedScalarString(item))
        else:
            processed_list.append(item)
    return processed_list

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python update_yaml.py <yaml_file> <key1=value1> [<key2=value2> ...]")
        sys.exit(1)

    yaml_file = sys.argv[1]
    updates = {}

    for arg in sys.argv[2:]:
        key, value = arg.split('=', 1)
        updates[key] = value

    update_yaml(yaml_file, updates)

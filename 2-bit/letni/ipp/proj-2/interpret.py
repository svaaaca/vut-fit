# @file interpret.py
# @author David Kvacek (xkvace00)
# @brief Implementation of the second task in the IPP 2022/23.
# @version 1.0
# @date 2023-04-19

import os
import re
import sys
import argparse
import xml.etree.ElementTree as et

OK = 0
FAIL_PARAMS = 10
FAIL_INPUT_FILE = 11
FAIL_OUTPUT_FILE = 12
FAIL_XML_FORMAT = 31
FAIL_XML_STRUCTURE = 32
FAIL_SEMANTIC = 52
FAIL_OPERAND = 53
FAIL_VAR_NOT_EXIST = 54
FAIL_FRAME_NOT_EXIST = 55
FAIL_VALUE_NOT_EXIST = 56
FAIL_OPERAND_VALUE = 57
FAIL_STRING = 58
INTERNAL_ERROR = 99

SOURCE_FILE = None
INPUT_FILE = None

def check_xml(xml):
    tree = et.parse(xml)
    root = tree.getroot()
    if root.tag != "program" or "language" not in root.attrib or root.attrib["language"] != "IPPcode23":
        print("interpret.py: xml file is not well-formed")
        sys.exit(FAIL_XML_FORMAT)

    for child in root:
        if child.tag != "instruction" or "order" not in child.attrib or "opcode" not in child.attrib or child.attrib["order"].isdigit() == False or int(child.attrib["order"]) < 1 or child.attrib["opcode"].upper() not in ["MOVE", "CREATEFRAME", "PUSHFRAME", "POPFRAME", "DEFVAR", "CALL", "RETURN", "PUSHS", "POPS", "ADD", "SUB", "MUL", "IDIV", "LT", "GT", "EQ", "AND", "OR", "NOT", "INT2CHAR", "STRI2INT", "READ", "WRITE", "CONCAT", "STRLEN", "GETCHAR", "SETCHAR", "TYPE", "LABEL", "JUMP", "JUMPIFEQ", "JUMPIFNEQ", "EXIT", "DPRINT", "BREAK"]:
            print("interpret.py: unexpected xml structure")
            sys.exit(FAIL_XML_STRUCTURE)

    orders = set()
    instructions = root.findall('instruction')
    instructions.sort(key = lambda k: int(k.get('order')))

    for instruction in instructions:
        order = int(instruction.get('order'))
        if order in orders:
            print("interpret.py: unexpected xml structure [duplicate order]")
            sys.exit(FAIL_XML_STRUCTURE)

        orders.add(order)
        opcode = instruction.attrib["opcode"].upper()

        arg1 = instruction.find('arg1')
        arg2 = instruction.find('arg2')
        arg3 = instruction.find('arg3')

        type1 = arg1.attrib["type"] if arg1 is not None else None
        type2 = arg2.attrib["type"] if arg2 is not None else None
        type3 = arg3.attrib["type"] if arg3 is not None else None

        value1 = arg1.text if arg1 is not None else None
        value2 = arg2.text if arg2 is not None else None
        value3 = arg3.text if arg3 is not None else None

        var = ["var"]
        symb = ["var", "int", "bool", "string", "nil"]
        label = ["label"]
        type = ["int", "string", "bool"]

        var_pattern = '^(LF|TF|GF)@[a-zA-Z_\-$&%*!?][a-zA-Z0-9_\-$&%*!?]*$'
        int_pattern = '^int@[+\-]?([1-9][0-9]*(_[0-9]+)*|0[xX][0-9a-fA-F]+(_[0-9a-fA-F]+)*|0[oO]?[0-7]+(_[0-7]+)*|0[bB][01]+(_[01]+)*)+$'
        bool_pattern = '^bool@(true|false)$'
        string_pattern = '^string@(([^\s\#\\\\]|\\\\[0-9]{3})*)$'
        nil_pattern = '^nil@nil$'
        label_pattern = '^[a-zA-Z_\-$&%*!?][a-zA-Z0-9_\-$&%*!?]*$'

        match opcode:
            case "MOVE":
                if arg1 is None or arg2 is None or arg3 is not None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in var or type2 not in symb:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "CREATEFRAME":
                if arg1 is not None or arg2 is not None or arg3 is not None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)
                    
            case "PUSHFRAME":
                if arg1 is not None or arg2 is not None or arg3 is not None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)
                    
            case "POPFRAME":
                if arg1 is not None or arg2 is not None or arg3 is not None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

            case "DEFVAR":
                if arg1 is None or arg2 is not None or arg3 is not None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in var:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "CALL":
                if arg1 is None or arg2 is not None or arg3 is not None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in label:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "RETURN":
                if arg1 is not None or arg2 is not None or arg3 is not None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

            case "PUSHS":
                if arg1 is None or arg2 is not None or arg3 is not None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in symb:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "POPS":
                if arg1 is None or arg2 is not None or arg3 is not None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in var:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "ADD":
                if arg1 is None or arg2 is None or arg3 is None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in var or type2 not in symb or type3 not in symb:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "SUB":
                if arg1 is None or arg2 is None or arg3 is None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in var or type2 not in symb or type3 not in symb:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "MUL":
                if arg1 is None or arg2 is None or arg3 is None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in var or type2 not in symb or type3 not in symb:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "IDIV":
                if arg1 is None or arg2 is None or arg3 is None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in var or type2 not in symb or type3 not in symb:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "LT":
                if arg1 is None or arg2 is None or arg3 is None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in var or type2 not in symb or type3 not in symb:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "GT":
                if arg1 is None or arg2 is None or arg3 is None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in var or type2 not in symb or type3 not in symb:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "EQ":
                if arg1 is None or arg2 is None or arg3 is None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in var or type2 not in symb or type3 not in symb:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "AND":
                if arg1 is None or arg2 is None or arg3 is None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in var or type2 not in symb or type3 not in symb:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "OR":
                if arg1 is None or arg2 is None or arg3 is None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in var or type2 not in symb or type3 not in symb:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "NOT":
                if arg1 is None or arg2 is None or arg3 is not None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in var or type2 not in symb:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "INT2CHAR":
                if arg1 is None or arg2 is None or arg3 is not None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in var or type2 not in symb:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "STRI2INT":
                if arg1 is None or arg2 is None or arg3 is None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in var or type2 not in symb or type3 not in symb:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "READ":
                if arg1 is None or arg2 is None or arg3 is not None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in var or type2 not in type:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "WRITE":
                if arg1 is None or arg2 is not None or arg3 is not None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in symb:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "CONCAT":
                if arg1 is None or arg2 is None or arg3 is None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in var or type2 not in symb or type3 not in symb:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "STRLEN":
                if arg1 is None or arg2 is None or arg3 is not None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in var or type2 not in symb:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "GETCHAR":
                if arg1 is None or arg2 is None or arg3 is None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in var or type2 not in symb or type3 not in symb:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "SETCHAR":
                if arg1 is None or arg2 is None or arg3 is None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in var or type2 not in symb or type3 not in symb:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "TYPE":
                if arg1 is None or arg2 is None or arg3 is not None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in var or type2 not in symb:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "LABEL":
                if arg1 is None or arg2 is not None or arg3 is not None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in label:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

                if value1 in labels:
                    print("interpret.py: semantic analysis error [duplicate label]")
                    sys.exit(FAIL_SEMANTIC)
                labels[value1] = value1

            case "JUMP":
                if arg1 is None or arg2 is not None or arg3 is not None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in label:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "JUMPIFEQ":
                if arg1 is None or arg2 is None or arg3 is None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in label or type2 not in symb or type3 not in symb:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "JUMPIFNEQ":
                if arg1 is None or arg2 is None or arg3 is None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in label or type2 not in symb or type3 not in symb:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "EXIT":
                if arg1 is None or arg2 is not None or arg3 is not None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in symb:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

                if type1 != "int" or (int(value1.split('@')[1]) < 0 or int(value1.split('@')[1]) > 49):
                    print(f"interpret.py: wrong operand value [{opcode}]")
                    sys.exit(FAIL_OPERAND_VALUE)

            case "DPRINT":
                if arg1 is None or arg2 is not None or arg3 is not None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

                if type1 not in symb:
                    print(f"interpret.py: wrong operand type [{opcode}]")
                    sys.exit(FAIL_OPERAND)

            case "BREAK":
                if arg1 is not None or arg2 is not None or arg3 is not None:
                    print(f"interpret.py: unexpected xml structure [{opcode}]")
                    sys.exit(FAIL_XML_STRUCTURE)

            case _:
                print("interpret.py: unexpected xml structure")
                sys.exit(FAIL_XML_STRUCTURE)
            
        if type1 == "var" and re.match(var_pattern, value1) is None:
            print(f"interpret.py: wrong variable name [{opcode}]")
            sys.exit(FAIL_OPERAND_VALUE)

        elif type1 == "int" and re.match(int_pattern, value1) is None:
            print(f"interpret.py: wrong integer value [{opcode}]")
            sys.exit(FAIL_OPERAND_VALUE)

        elif type1 == "bool" and re.match(bool_pattern, value1) is None:
            print(f"interpret.py: wrong boolean value [{opcode}]")
            sys.exit(FAIL_OPERAND_VALUE)

        elif type1 == "string" and re.match(string_pattern, value1) is None:
            print(f"interpret.py: wrong string literal [{opcode}]")
            sys.exit(FAIL_OPERAND_VALUE)

        elif type1 == "nil" and re.match(nil_pattern, value1) is None:
            print(f"interpret.py: wrong nil value [{opcode}]")
            sys.exit(FAIL_OPERAND_VALUE)

        elif type1 == "label" and re.match(label_pattern, value1) is None:
            print(f"interpret.py: wrong label name [{opcode}]")
            sys.exit(FAIL_OPERAND_VALUE)


        if type2 == "var" and re.match(var_pattern, value2) is None:
            print(f"interpret.py: wrong variable name [{opcode}]")
            sys.exit(FAIL_OPERAND_VALUE)

        elif type2 == "int" and re.match(int_pattern, value2) is None:
            print(f"interpret.py: wrong integer value [{opcode}]")
            sys.exit(FAIL_OPERAND_VALUE)

        elif type2 == "bool" and re.match(bool_pattern, value2) is None:
            print(f"interpret.py: wrong boolean value [{opcode}]")
            sys.exit(FAIL_OPERAND_VALUE)

        elif type2 == "string" and re.match(string_pattern, value2) is None:
            print(f"interpret.py: wrong string literal [{opcode}]")
            sys.exit(FAIL_OPERAND_VALUE)

        elif type2 == "nil" and re.match(nil_pattern, value2) is None:
            print(f"interpret.py: wrong nil value [{opcode}]")
            sys.exit(FAIL_OPERAND_VALUE)

        elif type2 == "label" and re.match(label_pattern, value2) is None:
            print(f"interpret.py: wrong label name [{opcode}]")
            sys.exit(FAIL_OPERAND_VALUE)


        if type3 == "var" and re.match(var_pattern, value3) is None:
            print(f"interpret.py: wrong variable name [{opcode}]")
            sys.exit(FAIL_OPERAND_VALUE)

        elif type3 == "int" and re.match(int_pattern, value3) is None:
            print(f"interpret.py: wrong integer value [{opcode}]")
            sys.exit(FAIL_OPERAND_VALUE)

        elif type3 == "bool" and re.match(bool_pattern, value3) is None:
            print(f"interpret.py: wrong boolean value [{opcode}]")
            sys.exit(FAIL_OPERAND_VALUE)

        elif type3 == "string" and re.match(string_pattern, value3) is None:
            print(f"interpret.py: wrong string literal [{opcode}]")
            sys.exit(FAIL_OPERAND_VALUE)

        elif type3 == "nil" and re.match(nil_pattern, value3) is None:
            print(f"interpret.py: wrong nil value [{opcode}]")
            sys.exit(FAIL_OPERAND_VALUE)

        elif type3 == "label" and re.match(label_pattern, value3) is None:
            print(f"interpret.py: wrong label name [{opcode}]")
            sys.exit(FAIL_OPERAND_VALUE)

def main(source, input):
    tree = et.parse(source)
    root = tree.getroot()
    instructions = root.findall('instruction')
    instructions.sort(key = lambda k: int(k.get('order')))

    for instruction in instructions:
        arg1 = instruction.find('arg1')
        arg2 = instruction.find('arg2')
        arg3 = instruction.find('arg3')

        type1 = arg1.attrib["type"] if arg1 is not None else None
        type2 = arg2.attrib["type"] if arg2 is not None else None
        type3 = arg3.attrib["type"] if arg3 is not None else None

        value1 = arg1.text if arg1 is not None else None
        value2 = arg2.text if arg2 is not None else None
        value3 = arg3.text if arg3 is not None else None

        opcode = instruction.attrib["opcode"].upper()
        match opcode:
            case "CALL":
                if value1 not in labels:
                    print("interpret.py: semantic analysis error [label not defined]")
                    sys.exit(FAIL_SEMANTIC)

            case "JUMP":
                if value1 not in labels:
                    print("interpret.py: semantic analysis error [label not defined]")
                    sys.exit(FAIL_SEMANTIC)

            case "JUMPIFEQ":
                if value1 not in labels:
                    print("interpret.py: semantic analysis error [label not defined]")
                    sys.exit(FAIL_SEMANTIC)

            case "JUMPIFNEQ":
                if value1 not in labels:
                    print("interpret.py: semantic analysis error [label not defined]")
                    sys.exit(FAIL_SEMANTIC)

labels = {}
parser = argparse.ArgumentParser()
parser.add_argument('--source', help = 'source file in xml format')
parser.add_argument('--input', help = 'input file with data for the program')
arguments = parser.parse_args()

if arguments.source and arguments.input:
    if not os.path.exists(arguments.source):
        print(f"interpret.py: source file {arguments.source} does not exist")
        sys.exit(FAIL_INPUT_FILE)
    elif not os.path.isfile(arguments.source):
        print(f"interpret.py: source file {arguments.source} is not a file")
        sys.exit(FAIL_INPUT_FILE)
    elif not os.access(arguments.source, os.R_OK):
        print(f"interpret.py: source file {arguments.source} is not readable")
        sys.exit(FAIL_INPUT_FILE)
    elif not os.path.exists(arguments.input):
        print(f"interpret.py: input file {arguments.input} does not exist")
        sys.exit(FAIL_INPUT_FILE)
    elif not os.path.isfile(arguments.input):
        print(f"interpret.py: input file {arguments.input} is not a file")
        sys.exit(FAIL_INPUT_FILE)
    elif not os.access(arguments.input, os.R_OK):
        print(f"interpret.py: input file {arguments.input} is not readable")
        sys.exit(FAIL_INPUT_FILE)
    else:
        SOURCE_FILE = arguments.source
        INPUT_FILE = arguments.input
        check_xml(SOURCE_FILE)
        main(SOURCE_FILE, INPUT_FILE)
        sys.exit(OK)

elif arguments.source:
    if not os.path.exists(arguments.source):
        print(f"interpret.py: source file {arguments.source} does not exist")
        sys.exit(FAIL_INPUT_FILE)
    elif not os.path.isfile(arguments.source):
        print(f"interpret.py: source file {arguments.source} is not a file")
        sys.exit(FAIL_INPUT_FILE)
    elif not os.access(arguments.source, os.R_OK):
        print(f"interpret.py: source file {arguments.source} is not readable")
        sys.exit(FAIL_INPUT_FILE)
    else:
        SOURCE_FILE = arguments.source
        INPUT_FILE = sys.stdin.read()
        check_xml(SOURCE_FILE)
        main(SOURCE_FILE, INPUT_FILE)

elif arguments.input:
    if not os.path.exists(arguments.input):
        print(f"interpret.py: input file {arguments.input} does not exist")
        sys.exit(FAIL_INPUT_FILE)
    elif not os.path.isfile(arguments.input):
        print(f"interpret.py: input file {arguments.input} is not a file")
        sys.exit(FAIL_INPUT_FILE)
    elif not os.access(arguments.input, os.R_OK):
        print(f"interpret.py: input file {arguments.input} is not readable")
        sys.exit(FAIL_INPUT_FILE)
    else:
        SOURCE_FILE = sys.stdin.read()
        INPUT_FILE = arguments.input
        check_xml(SOURCE_FILE)
        main(SOURCE_FILE, INPUT_FILE)

else:
    print("interpret.py: provide source or input file for the interpreter\n\t      use -h or --help option for more information")
    sys.exit(FAIL_PARAMS)

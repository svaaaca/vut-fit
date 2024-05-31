"""
@file parse.py
@author David Kvaček (xkvace00@stud.fit.vutbr.cz)
@brief Implementation of the code analyzer in IPPcode24 (parser).
@date 2024-03-04
"""

import argparse
import re
import sys
import xml.dom.minidom as minidom
import xml.etree.ElementTree as ET

class ParameterError(Exception):
    "Exception for missing script parameter (if needed) or use of forbidden parameter combination."

    def __init__(self, message: str = "\033[31m\033[1m" + "ParameterError: " + "\033[0m" + "Missing script parameter (if needed) or use of forbidden parameter combination.", code: int = 10):
        self.message = message
        self.code = code

class OutputFileError(Exception):
    "Exception for error when opening output files for writing (e.g. insufficient permissions, writing error)."

    def __init__(self, message: str = "\033[31m\033[1m" + "OutputFileError: " + "\033[0m" + "Error when opening output files for writing (e.g. insufficient permissions, writing error).", code: int = 12):
        self.message = message
        self.code = code

class HeaderError(Exception):
    "Exception for incorrect or missing header in the source code written in IPPcode24."

    def __init__(self, message: str = "\033[31m\033[1m" + "HeaderError: " + "\033[0m" + "Incorrect or missing header in the source code written in IPPcode24.", code: int = 21):
        self.message = message
        self.code = code

class OpcodeError(Exception):
    "Exception for unknown or incorrect opcode in the source code written in IPPcode24."

    def __init__(self, message: str = "\033[31m\033[1m" + "OpcodeError: " + "\033[0m" + "Unknown or incorrect opcode in the source code written in IPPcode24.", code: int = 22):
        self.message = message
        self.code = code

class LexicalSyntaxError(Exception):
    "Exception for other lexical or syntax error in the source code written in IPPcode24."

    def __init__(self, message: str = "\033[31m\033[1m" + "LexicalSyntaxError: " + "\033[0m" + "Other lexical or syntax error in the source code written in IPPcode24.", code: int = 23):
        self.message = message
        self.code = code

class InternalError(Exception):
    "Exception for internal error (not affected by integration, input files or command line parameters)."

    def __init__(self, message: str = "\033[31m\033[1m" + "InternalError: " + "\033[0m" + "Internal error (not affected by integration, input files or command line parameters).", code: int = 99):
        self.message = message
        self.code = code

def args_check(args: list) -> None:
    "Check the script parameters."

    if len(args) == 2:
        if args[1] not in ("-h", "--help") and not args[1].startswith("--stats"):
            raise ParameterError()

    if len(args) > 2:
        if ("--help" in args) or ("-h" in args):
            raise ParameterError()
        if not args[1].startswith("--stats"):
            raise ParameterError()

    if "--stats" in args:
        raise ParameterError()

    stats = []
    for arg in args:
        if arg.startswith("--stats="):
            if arg.split("=")[1] not in stats:
                stats.append(arg.split("=")[1])
            else:
                raise OutputFileError()

def comment_remove(line: str) -> str:
    "Remove comments from the line."

    return re.sub(r"#.*", "", line)

def whitespace_remove(line: str) -> str:
    "Remove whitespaces from the line."

    return re.sub(r"\s+", " ", line).strip()

def variable_check(variable: str) -> None:
    "Check the variable format."

    if not re.match(r"^(GF|LF|TF)@[a-zA-Z_\-$&%*!?][a-zA-Z0-9_\-$&%*!?]*$", variable):
        raise LexicalSyntaxError()

def symbol_check(symbol: str) -> None:
    "Check the symbol format."

    if not re.match(r"^(GF|LF|TF)@[a-zA-Z_\-$&%*!?][a-zA-Z0-9_\-$&%*!?]*$|^int@[-+]?[0-9]+$|^int@[-+]?0[oO][0-7]+$|^int@[-+]?0[xX][0-9a-fA-F]+$|^bool@(true|false)$|^string@([^\s#\\]|(\\[0-9]{3}))*$|^nil@nil$", symbol):
        raise LexicalSyntaxError()

def label_check(label: str) -> None:
    "Check the label format."

    if not re.match(r"^[a-zA-Z_\-$&%*!?][a-zA-Z0-9_\-$&%*!?]*$", label):
        raise LexicalSyntaxError()

def type_check(type: str) -> None:
    "Check the type format."

    if not re.match(r"^(int|bool|string)$", type):
        raise LexicalSyntaxError()

def header_check(source_code: list) -> None:
    "Check the header format."

    if len(source_code) < 1 or source_code[0].upper() != ".IPPCODE24":
        raise HeaderError()

def opcode_check(source_code: list) -> None:
    "Check the opcode format."

    for i in range(1, len(source_code)):
        opcode = source_code[i].split(" ")[0].upper()
        if not re.match(r"^[A-Z0-9]+$", opcode):
            raise LexicalSyntaxError()

        if not re.match(r"^(MOVE|CREATEFRAME|PUSHFRAME|POPFRAME|DEFVAR|CALL|RETURN|PUSHS|POPS|ADD|SUB|MUL|IDIV|LT|GT|EQ|AND|OR|NOT|INT2CHAR|STRI2INT|READ|WRITE|CONCAT|STRLEN|GETCHAR|SETCHAR|TYPE|LABEL|JUMP|JUMPIFEQ|JUMPIFNEQ|EXIT|DPRINT|BREAK)$", opcode):
            raise OpcodeError()

def operand_check(source_code: list) -> None:
    "Check the operand format."

    for i in range(1, len(source_code)):
        opcode = source_code[i].split(" ")[0].upper()
        operand = source_code[i].split(" ")[1:]
        if opcode in ("CREATEFRAME", "PUSHFRAME", "POPFRAME", "RETURN", "BREAK"):
            if len(operand) != 0:
                raise LexicalSyntaxError()

        elif opcode in ("DEFVAR", "POPS"):
            if len(operand) != 1:
                raise LexicalSyntaxError()

            variable_check(operand[0])

        elif opcode in ("CALL", "LABEL", "JUMP"):
            if len(operand) != 1:
                raise LexicalSyntaxError()

            label_check(operand[0])

        elif opcode in ("PUSHS", "WRITE", "EXIT", "DPRINT"):
            if len(operand) != 1:
                raise LexicalSyntaxError()

            symbol_check(operand[0])

        elif opcode in ("MOVE", "NOT", "INT2CHAR", "STRLEN", "TYPE"):
            if len(operand) != 2:
                raise LexicalSyntaxError()

            variable_check(operand[0])
            symbol_check(operand[1])

        elif opcode in ("READ"):
            if len(operand) != 2:
                raise LexicalSyntaxError()

            variable_check(operand[0])
            type_check(operand[1])

        elif opcode in ("ADD", "SUB", "MUL", "IDIV", "LT", "GT", "EQ", "AND", "OR", "STRI2INT", "CONCAT", "GETCHAR", "SETCHAR"):
            if len(operand) != 3:
                raise LexicalSyntaxError()

            variable_check(operand[0])
            symbol_check(operand[1])
            symbol_check(operand[2])

        elif opcode in ("JUMPIFEQ", "JUMPIFNEQ"):
            if len(operand) != 3:
                raise LexicalSyntaxError()

            label_check(operand[0])
            symbol_check(operand[1])
            symbol_check(operand[2])

        else:
            raise InternalError()

def get_type(element: str, opcode: str) -> str:
    "Get the type of the element."

    if re.match(r"^int@[-+]?[0-9]+$|^int@[-+]?0[oO][0-7]+$|^int@[-+]?0[xX][0-9a-fA-F]+$", element):
        return "int"

    elif re.match(r"^bool@(true|false)$", element):
        return "bool"

    elif re.match(r"^string@([^\s#\\]|(\\[0-9]{3}))*$", element):
        return "string"

    elif re.match(r"^nil@nil$", element):
        return "nil"

    elif re.match(r"^[a-zA-Z_\-$&%*!?][a-zA-Z0-9_\-$&%*!?]*$", element):
        if re.match(r"^(int|bool|string)$", element):
            if opcode in ("READ"):
                return "type"

        return "label"

    elif re.match(r"^(GF|LF|TF)@[a-zA-Z_\-$&%*!?][a-zA-Z0-9_\-$&%*!?]*$", element):
        return "var"

    else:
        raise InternalError()

def get_value(element: str) -> str:
    "Get the value of the element."

    if re.match(r"^int@[-+]?[0-9]+$|^int@[-+]?0[oO][0-7]+$|^int@[-+]?0[xX][0-9a-fA-F]+$|^bool@(true|false)$|^string@([^\s#\\]|(\\[0-9]{3}))*$|^nil@nil$", element):
        return element.split("@", 1)[1]

    elif re.match(r"^[a-zA-Z_\-$&%*!?][a-zA-Z0-9_\-$&%*!?]*$|^(int|bool|string)$|^(GF|LF|TF)@[a-zA-Z_\-$&%*!?][a-zA-Z0-9_\-$&%*!?]*$", element):
        return element

    else:
        raise InternalError()

def clean_code(source_code: list) -> list:
    "Clean the source code."

    code = []
    for line in source_code:
        line = whitespace_remove(line)
        line = comment_remove(line).strip()
        if line:
            code.append(line)

    return code

def generate_xml(source_code: list) -> None:
    "Generate the XML representation of the source code."

    root = ET.Element("program", language = "IPPcode24")
    order = 1
    for line in source_code:
        instruction = ET.SubElement(root, "instruction", order = str(order), opcode = line.split()[0].upper())
        for i in range(1, len(line.split())):
            element = ET.SubElement(instruction, "arg" + str(i), type = get_type(line.split()[i], line.split()[0].upper()))
            element.text = get_value(line.split()[i])
        order += 1

    xml = ET.tostring(root, encoding = "UTF-8", method = "xml", xml_declaration = True).decode("utf-8")
    xml = minidom.parseString(xml).toprettyxml(indent = "    ", encoding = "UTF-8").decode("utf-8")
    print(xml)

def get_loc(source_code: list) -> int:
    "Get the number of lines with instructions."

    return len(clean_code(source_code)) - 1

def get_comments(source_code: list) -> int:
    "Get the number of lines on which the comment occurs."

    comments = 0
    for line in source_code:
        if re.match(r".*#.*", line):
            comments += 1

    return comments

def get_labels(source_code: list) -> int:
    "Get the number of defined labels."

    labels = []
    for line in clean_code(source_code):
        if line.split(" ")[0].upper() == "LABEL":
            if line.split(" ")[1] not in labels:
                labels.append(line.split(" ")[1])

    return len(labels)

def get_jumps(source_code: list) -> int:
    "Get the number of all call return instructions and jump instructions."

    jumps = 0
    for line in clean_code(source_code):
        if line.split(" ")[0].upper() in ("CALL", "RETURN", "JUMP", "JUMPIFEQ", "JUMPIFNEQ"):
            jumps += 1

    return jumps

def get_fwjumps(source_code: list) -> int:
    "Get the number of forward jumps."

    fwjumps = 0
    label = ""
    i = 0
    for line in clean_code(source_code):
        if line.split(" ")[0].upper() in ("CALL", "JUMP", "JUMPIFEQ", "JUMPIFNEQ"):
            label = line.split(" ")[1]
            j = 0
            for line in clean_code(source_code):
                if line.split(" ")[0].upper() == "LABEL" and line.split(" ")[1] == label:
                    if j > i:
                        fwjumps += 1
                        break

                j += 1

        i += 1

    return fwjumps

def get_backjumps(source_code: list) -> int:
    "Get the number of back jumps."

    backjumps = 0
    label = ""
    i = 0
    for line in clean_code(source_code):
        if line.split(" ")[0].upper() in ("CALL", "JUMP", "JUMPIFEQ", "JUMPIFNEQ"):
            label = line.split(" ")[1]
            j = 0
            for line in clean_code(source_code):
                if line.split(" ")[0].upper() == "LABEL" and line.split(" ")[1] == label:
                    if j < i:
                        backjumps += 1
                        break

                j += 1

        i += 1

    return backjumps

def get_badjumps(source_code: list) -> int:
    "Get the number of jumps on a non-existent label."

    badjumps = 0
    label = ""
    labels = []
    for line in clean_code(source_code):
        if line.split(" ")[0].upper() == "LABEL":
            labels.append(line.split(" ")[1])

    for line in clean_code(source_code):
        if line.split(" ")[0].upper() in ("CALL", "JUMP", "JUMPIFEQ", "JUMPIFNEQ"):
            label = line.split(" ")[1]
            if label not in labels:
                badjumps += 1

    return badjumps

def get_frequent(source_code: list) -> str:
    "Get the names of opcodes that are most frequent in the source code according to the number of static occurrences."

    opcodes = {}
    for line in clean_code(source_code)[1:]:
        opcode = line.split(" ")[0].upper()
        if opcode not in opcodes:
            opcodes[opcode] = 1

        else:
            opcodes[opcode] += 1

    return ",".join(sorted(key for key, value in opcodes.items() if value == max(opcodes.values())))

def generate_stats(args: list, source_code: list) -> None:
    "Generate the stats in the parameters."

    for i in range(1, len(args)):
        if args[i].startswith("--stats="):
            with open(args[i].split("=")[1], "w") as file:
                file.write("")

            for j in range(i + 1, len(args)):
                if args[j].startswith("--stats="):
                    break

                with open(args[i].split("=")[1], "a") as file:
                    if args[j] == "--loc":
                        file.write(str(get_loc(source_code)) + "\n")

                    elif args[j] == "--comments":
                        file.write(str(get_comments(source_code)) + "\n")

                    elif args[j] == "--labels":
                        file.write(str(get_labels(source_code)) + "\n")

                    elif args[j] == "--jumps":
                        file.write(str(get_jumps(source_code)) + "\n")

                    elif args[j] == "--fwjumps":
                        file.write(str(get_fwjumps(source_code)) + "\n")

                    elif args[j] == "--backjumps":
                        file.write(str(get_backjumps(source_code)) + "\n")

                    elif args[j] == "--badjumps":
                        file.write(str(get_badjumps(source_code)) + "\n")

                    elif args[j] == "--frequent":
                        file.write(get_frequent(source_code) + "\n")

                    elif args[j].startswith("--print="):
                        file.write(args[j].split("=")[1] + "\n")

                    elif args[j] == "--eol":
                        file.write("\n")

if __name__ == "__main__":
    try:
        args_check(sys.argv)

        parser = argparse.ArgumentParser(usage = "python3.10 parse.py [-h, --help] [--stats=file] [--loc] [--comments] [--labels] [--jumps] [--fwjumps] [--backjumps] [--badjumps] [--frequent] [--print=string] [--eol]", description = "Code analyzer in IPPcode24 (parser).")

        parser.add_argument("--stats", metavar = "file", type = str, help = "specifying the 'file' where the stats in the parameters will be printed")
        parser.add_argument("--loc", action = "store_true", help = "number of lines with instructions (not counting blank lines or lines containing only a comment or an opening line)")
        parser.add_argument("--comments", action = "store_true", help = "number of lines on which the comment occurs")
        parser.add_argument("--labels", action = "store_true", help = "number of defined labels (i.e. unique possible jump targets)")
        parser.add_argument("--jumps", action = "store_true", help = "number of all call return instructions and jump instructions (collectively conditional/unconditional jumps and calls)")
        parser.add_argument("--fwjumps", action = "store_true", help = "number of forward jumps")
        parser.add_argument("--backjumps", action = "store_true", help = "number of back jumps")
        parser.add_argument("--badjumps", action = "store_true", help = "number of jumps on a non-existent label")
        parser.add_argument("--frequent", action = "store_true", help = "names of opcodes that are most frequent in the source code according to the number of static occurrences")
        parser.add_argument("--print", metavar = "string", type = str, help = "print 'string' to stats")
        parser.add_argument("--eol", action = "store_true", help = "print end of line to stats")

        args = parser.parse_args()
        source_code = sys.stdin.readlines()

        header_check(clean_code(source_code))
        opcode_check(clean_code(source_code))
        operand_check(clean_code(source_code))

        generate_xml(clean_code(source_code)[1:])

    except ParameterError:
        print(ParameterError().message, file = sys.stderr)
        sys.exit(ParameterError().code)

    except OutputFileError:
        print(OutputFileError().message, file = sys.stderr)
        sys.exit(OutputFileError().code)

    except HeaderError:
        print(HeaderError().message, file = sys.stderr)
        sys.exit(HeaderError().code)

    except OpcodeError:
        print(OpcodeError().message, file = sys.stderr)
        sys.exit(OpcodeError().code)

    except LexicalSyntaxError:
        print(LexicalSyntaxError().message, file = sys.stderr)
        sys.exit(LexicalSyntaxError().code)

    except Exception:
        print(InternalError().message, file = sys.stderr)
        sys.exit(InternalError().code)

    try:
        generate_stats(sys.argv, source_code)

    except:
        pass
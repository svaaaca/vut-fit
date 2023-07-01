<?php
/**
 * Implementace 1. ulohy do IPP 2022/23
 * Jmeno a prijmeni: David Kvacek
 * Login: xkvace00
 * Datum: 2023-03-14
 */

ini_set('display_errors', 'stderr');

const OK = 0;
const FAIL_PARAMS = 10;
const FAIL_HEADER = 21;
const FAIL_OPCODE = 22;
const FAIL_SOURCE = 23;

/**
 * Cast programu, ktera cte ze standardniho vstupu radek po radku.
 * Zavadi se zde take povinna hlavicka vystupniho souboru XML.
 * Probiha kontrola, zda-li vstupni soubor obsahuje hlavicku ve
 * spravnem formatu a nasledne se podle poctu argumentu na aktualnim
 * radku volaji odpovidajici funkce, ktere dane instrukce nasledne
 * zpracuji.
 */
if($argc == 1) {
    $xml_output = new DOMDocument('1.0', 'UTF-8');
    $xml_output->formatOutput = true;
    $xml_program = $xml_output->createElement('program');
    $xml_program->setAttribute('language', 'IPPcode23');
    $xml_output->appendChild($xml_program);

    $header = false;
    $order = 1;

    while($input = fgets(STDIN)) {
        $input = explode('#', $input);
        $input = trim($input[0]);

        if($header == false) {
            if($input == '') {
                continue;
            }
            else {
                if(strtoupper($input) != '.IPPCODE23') {
                    fwrite(STDERR, "Incorrect or missing header!\n");
                    exit(FAIL_HEADER);
                }
                else {
                    $header = true;
                    continue;
                }
            }
        }

        if($input != '') {
            $input = preg_replace('~\s+~', ' ', $input);
            $line = explode(' ', $input);
            switch(count($line)) {
                case 1:
                    zero_params($line, $order);
                    $order++;
                    break;
                case 2:
                    one_param($line, $order);
                    $order++;
                    break;
                case 3:
                    two_params($line, $order);
                    $order++;
                    break;
                case 4:
                    three_params($line, $order);
                    $order++;
                    break;
                default:
                    fwrite(STDERR, "Another lexical or syntax error!\n");
                    exit(FAIL_SOURCE);
            }
        }
        else {
            continue;
        }
    }
    echo($xml_output->saveXML());
}
else if($argc == 2) {
    if($argv[1] == '--help'){
        echo("Usage: php8.1 parse.php [--help] <input >output\n");
        exit(OK);
    }
    else {
        fwrite(STDERR, "Using a forbidden combination of parameters!\n");
        exit(FAIL_PARAMS);
    }
}
else if($argc > 2) {
    fwrite(STDERR, "Using a forbidden combination of parameters!\n");
    exit(FAIL_PARAMS);
}

/**
 * Funkce, ktera provadi nasledne zpracovani instrukci, jejichz
 * pocet argumentu se rovna nule. Pouze vypise odpovidajici
 * operacni kod, pokud je platny.
 */
function zero_params($line, $order) {
    global $xml_output, $xml_program;
    $instruction = strtoupper($line[0]);
    if(($instruction == 'CREATEFRAME') || ($instruction == 'PUSHFRAME') || ($instruction == 'POPFRAME') || ($instruction == 'RETURN') || ($instruction == 'BREAK')) {
        $xml_instruction = $xml_output->createElement('instruction');
        $xml_instruction->setAttribute('order', $order);
        $xml_instruction->setAttribute('opcode', $instruction);
        $xml_program->appendChild($xml_instruction);
    }
    else {
        fwrite(STDERR, "Unknown or incorrect operating code!\n");
        exit(FAIL_OPCODE);
    }
}

/**
 * Funkce, ktera provadi nasledne zpracovani instrukci, jejichz
 * pocet argumentu se rovna jedne. Nejdrive probiha kontrola
 * zadaneho argumentu. Pokud vse probehne bez chyb, vypise se
 * odpovidajici operacni kod s argumentem.
 */
function one_param($line, $order) {
    global $xml_output, $xml_program;
    $instruction = strtoupper($line[0]);
    $argument = $line[1];

    if(($instruction == 'DEFVAR') || ($instruction == 'POPS')) {
        if(preg_match('~^(LF|TF|GF)@[a-zA-Z_\-$&%*!?][a-zA-Z0-9_\-$&%*!?]*$~', $argument)) {
            $xml_instruction = $xml_output->createElement('instruction');
            $xml_instruction->setAttribute('order', $order);
            $xml_instruction->setAttribute('opcode', $instruction);
            $xml_argument = $xml_output->createElement('arg1', $argument);
            $xml_argument->setAttribute('type', 'var');
            $xml_instruction->appendChild($xml_argument);
            $xml_program->appendChild($xml_instruction);
        }
        else {
            fwrite(STDERR, "Another lexical or syntax error!\n");
            exit(FAIL_SOURCE);
        }
    }
    elseif(($instruction == 'CALL') || ($instruction == 'LABEL') || ($instruction == 'JUMP')) {
        if(preg_match('~^[a-zA-Z_\-$&%*!?][a-zA-Z0-9_\-$&%*!?]*$~', $argument)) {
            $xml_instruction = $xml_output->createElement('instruction');
            $xml_instruction->setAttribute('order', $order);
            $xml_instruction->setAttribute('opcode', $instruction);
            $xml_argument = $xml_output->createElement('arg1', $argument);
            $xml_argument->setAttribute('type', 'label');
            $xml_instruction->appendChild($xml_argument);
            $xml_program->appendChild($xml_instruction);
        }
        else {
            fwrite(STDERR, "Another lexical or syntax error!\n");
            exit(FAIL_SOURCE);
        }
    }
    elseif(($instruction == 'PUSHS') || ($instruction == 'WRITE') || ($instruction == 'EXIT') || ($instruction == 'DPRINT')) {
        if(preg_match('~^(LF|TF|GF)@[a-zA-Z_\-$&%*!?][a-zA-Z0-9_\-$&%*!?]*$~', $argument)) {
            $xml_instruction = $xml_output->createElement('instruction');
            $xml_instruction->setAttribute('order', $order);
            $xml_instruction->setAttribute('opcode', $instruction);
            $xml_argument = $xml_output->createElement('arg1', $argument);
            $xml_argument->setAttribute('type', 'var');
            $xml_instruction->appendChild($xml_argument);
            $xml_program->appendChild($xml_instruction);
        }
        elseif(preg_match('~^nil@nil$~', $argument)) {
            $xml_instruction = $xml_output->createElement('instruction');
            $xml_instruction->setAttribute('order', $order);
            $xml_instruction->setAttribute('opcode', $instruction);
            $xml_argument = $xml_output->createElement('arg1', 'nil');
            $xml_argument->setAttribute('type', 'nil');
            $xml_instruction->appendChild($xml_argument);
            $xml_program->appendChild($xml_instruction);
        }
        elseif(preg_match('~^bool@true$~', $argument)) {
            $xml_instruction = $xml_output->createElement('instruction');
            $xml_instruction->setAttribute('order', $order);
            $xml_instruction->setAttribute('opcode', $instruction);
            $xml_argument = $xml_output->createElement('arg1', 'true');
            $xml_argument->setAttribute('type', 'bool');
            $xml_instruction->appendChild($xml_argument);
            $xml_program->appendChild($xml_instruction);
        }
        elseif(preg_match('~^bool@false$~', $argument)) {
            $xml_instruction = $xml_output->createElement('instruction');
            $xml_instruction->setAttribute('order', $order);
            $xml_instruction->setAttribute('opcode', $instruction);
            $xml_argument = $xml_output->createElement('arg1', 'false');
            $xml_argument->setAttribute('type', 'bool');
            $xml_instruction->appendChild($xml_argument);
            $xml_program->appendChild($xml_instruction);
        }
        elseif(preg_match('~^int@[+\-]?([1-9][0-9]*(_[0-9]+)*|0[xX][0-9a-fA-F]+(_[0-9a-fA-F]+)*|0[oO]?[0-7]+(_[0-7]+)*|0[bB][01]+(_[01]+)*)+$~', $argument)) {
            $xml_instruction = $xml_output->createElement('instruction');
            $xml_instruction->setAttribute('order', $order);
            $xml_instruction->setAttribute('opcode', $instruction);
            $xml_argument = $xml_output->createElement('arg1', explode('@', $argument)[1]);
            $xml_argument->setAttribute('type', 'int');
            $xml_instruction->appendChild($xml_argument);
            $xml_program->appendChild($xml_instruction);
        }
        elseif(preg_match('~^string@(([^\s\#\\\\]|\\\\[0-9]{3})*)$~', $argument)) {
            $xml_instruction = $xml_output->createElement('instruction');
            $xml_instruction->setAttribute('order', $order);
            $xml_instruction->setAttribute('opcode', $instruction);
            $xml_argument = $xml_output->createElement('arg1', explode('@', $argument, 2)[1]);
            $xml_argument->setAttribute('type', 'string');
            $xml_instruction->appendChild($xml_argument);
            $xml_program->appendChild($xml_instruction);
        }
        else {
            fwrite(STDERR, "Another lexical or syntax error!\n");
            exit(FAIL_SOURCE);
        }
    }
    else {
        fwrite(STDERR, "Unknown or incorrect operating code!\n");
        exit(FAIL_OPCODE);
    }
}

/**
 * Funkce, ktera provadi nasledne zpracovani instrukci, jejichz
 * pocet argumentu se rovna dvema. Nejdrive probiha kontrola
 * zadanych argumentu. Pokud vse probehne bez chyb, vypise se
 * odpovidajici operacni kod s argumenty.
 */
function two_params($line, $order) {
    global $xml_output, $xml_program;
    $instruction = strtoupper($line[0]);
    $first_argument = $line[1];
    $second_argument = $line[2];

    if(($instruction == 'MOVE') || ($instruction == 'INT2CHAR') || ($instruction == 'STRLEN') || ($instruction == 'TYPE')) {
        if(preg_match('~^(LF|TF|GF)@[a-zA-Z_\-$&%*!?][a-zA-Z0-9_\-$&%*!?]*$~', $first_argument)) {
            $xml_instruction = $xml_output->createElement('instruction');
            $xml_instruction->setAttribute('order', $order);
            $xml_instruction->setAttribute('opcode', $instruction);
            $xml_first_argument = $xml_output->createElement('arg1', $first_argument);
            $xml_first_argument->setAttribute('type', 'var');
            $xml_instruction->appendChild($xml_first_argument);
            $xml_program->appendChild($xml_instruction);

            if(preg_match('~^(LF|TF|GF)@[a-zA-Z_\-$&%*!?][a-zA-Z0-9_\-$&%*!?]*$~', $second_argument)) {
                $xml_second_argument = $xml_output->createElement('arg2', $second_argument);
                $xml_second_argument->setAttribute('type', 'var');
                $xml_instruction->appendChild($xml_second_argument);
                $xml_program->appendChild($xml_instruction);
            }
            elseif(preg_match('~^nil@nil$~', $second_argument)) {
                $xml_second_argument = $xml_output->createElement('arg2', 'nil');
                $xml_second_argument->setAttribute('type', 'nil');
                $xml_instruction->appendChild($xml_second_argument);
                $xml_program->appendChild($xml_instruction);
            }
            elseif(preg_match('~^bool@true$~', $second_argument)) {
                $xml_second_argument = $xml_output->createElement('arg2', 'true');
                $xml_second_argument->setAttribute('type', 'bool');
                $xml_instruction->appendChild($xml_second_argument);
                $xml_program->appendChild($xml_instruction);
            }
            elseif(preg_match('~^bool@false$~', $second_argument)) {
                $xml_second_argument = $xml_output->createElement('arg2', 'false');
                $xml_second_argument->setAttribute('type', 'bool');
                $xml_instruction->appendChild($xml_second_argument);
                $xml_program->appendChild($xml_instruction);
            }
            elseif(preg_match('~^int@[+\-]?([1-9][0-9]*(_[0-9]+)*|0[xX][0-9a-fA-F]+(_[0-9a-fA-F]+)*|0[oO]?[0-7]+(_[0-7]+)*|0[bB][01]+(_[01]+)*)+$~', $second_argument)) {
                $xml_second_argument = $xml_output->createElement('arg2', explode('@', $second_argument)[1]);
                $xml_second_argument->setAttribute('type', 'int');
                $xml_instruction->appendChild($xml_second_argument);
                $xml_program->appendChild($xml_instruction);
            }
            elseif(preg_match('~^string@(([^\s\#\\\\]|\\\\[0-9]{3})*)$~', $second_argument)) {
                $xml_second_argument = $xml_output->createElement('arg2', explode('@', $second_argument, 2)[1]);
                $xml_second_argument->setAttribute('type', 'string');
                $xml_instruction->appendChild($xml_second_argument);
                $xml_program->appendChild($xml_instruction);
            }
            else {
                fwrite(STDERR, "Another lexical or syntax error!\n");
                exit(FAIL_SOURCE);
            }
        }
        else {
            fwrite(STDERR, "Another lexical or syntax error!\n");
            exit(FAIL_SOURCE);
        }
    }
    elseif($instruction == 'READ') {
        if(preg_match('~^(LF|TF|GF)@[a-zA-Z_\-$&%*!?][a-zA-Z0-9_\-$&%*!?]*$~', $first_argument)) {
            $xml_instruction = $xml_output->createElement('instruction');
            $xml_instruction->setAttribute('order', $order);
            $xml_instruction->setAttribute('opcode', $instruction);
            $xml_first_argument = $xml_output->createElement('arg1', $first_argument);
            $xml_first_argument->setAttribute('type', 'var');
            $xml_instruction->appendChild($xml_first_argument);
            $xml_program->appendChild($xml_instruction);

            if(preg_match('~^int@[+\-]?([1-9][0-9]*(_[0-9]+)*|0[xX][0-9a-fA-F]+(_[0-9a-fA-F]+)*|0[oO]?[0-7]+(_[0-7]+)*|0[bB][01]+(_[01]+)*)+$~', $second_argument)) {
                $xml_second_argument = $xml_output->createElement('arg2', explode('@', $second_argument)[1]);
                $xml_second_argument->setAttribute('type', 'int');
                $xml_instruction->appendChild($xml_second_argument);
                $xml_program->appendChild($xml_instruction);
            }
            elseif(preg_match('~^string@(([^\s\#\\\\]|\\\\[0-9]{3})*)$~', $second_argument)) {
                $xml_second_argument = $xml_output->createElement('arg2', explode('@', $second_argument, 2)[1]);
                $xml_second_argument->setAttribute('type', 'string');
                $xml_instruction->appendChild($xml_second_argument);
                $xml_program->appendChild($xml_instruction);
            }
            elseif(preg_match('~^bool@true$~', $second_argument)) {
                $xml_second_argument = $xml_output->createElement('arg2', 'true');
                $xml_second_argument->setAttribute('type', 'bool');
                $xml_instruction->appendChild($xml_second_argument);
                $xml_program->appendChild($xml_instruction);
            }
            elseif(preg_match('~^bool@false$~', $second_argument)) {
                $xml_second_argument = $xml_output->createElement('arg2', 'false');
                $xml_second_argument->setAttribute('type', 'bool');
                $xml_instruction->appendChild($xml_second_argument);
                $xml_program->appendChild($xml_instruction);
            }
            else {
                fwrite(STDERR, "Another lexical or syntax error!\n");
                exit(FAIL_SOURCE);
            }
        }
        else {
            fwrite(STDERR, "Another lexical or syntax error!\n");
            exit(FAIL_SOURCE);
        }
    }
    elseif($instruction == 'NOT') {
        if(preg_match('~^(LF|TF|GF)@[a-zA-Z_\-$&%*!?][a-zA-Z0-9_\-$&%*!?]*$~', $first_argument)) {
            $xml_instruction = $xml_output->createElement('instruction');
            $xml_instruction->setAttribute('order', $order);
            $xml_instruction->setAttribute('opcode', $instruction);
            $xml_first_argument = $xml_output->createElement('arg1', $first_argument);
            $xml_first_argument->setAttribute('type', 'var');
            $xml_instruction->appendChild($xml_first_argument);
            $xml_program->appendChild($xml_instruction);

            if(preg_match('~^bool@(true|false)$~', $second_argument)) {
                $xml_second_argument = $xml_output->createElement('arg2', explode('@', $second_argument)[1]);
                $xml_second_argument->setAttribute('type', 'bool');
                $xml_instruction->appendChild($xml_second_argument);
                $xml_program->appendChild($xml_instruction);
            }
            else {
                fwrite(STDERR, "Another lexical or syntax error!\n");
                exit(FAIL_SOURCE);
            }
        }
        else {
            fwrite(STDERR, "Another lexical or syntax error!\n");
            exit(FAIL_SOURCE);
        }
    }
    else {
        fwrite(STDERR, "Unknown or incorrect operating code!\n");
        exit(FAIL_OPCODE);
    }
}

/**
 * Funkce, ktera provadi nasledne zpracovani instrukci, jejichz
 * pocet argumentu se rovna trem. Nejdrive probiha kontrola
 * zadanych argumentu. Pokud vse probehne bez chyb, vypise se
 * odpovidajici operacni kod s argumenty.
 */
function three_params($line, $order) {
    global $xml_output, $xml_program;
    $instruction = strtoupper($line[0]);
    $first_argument = $line[1];
    $second_argument = $line[2];
    $third_argument = $line[3];

    if(($instruction == 'ADD') || ($instruction == 'SUB') || ($instruction == 'MUL') || ($instruction == 'IDIV')) {
        if(preg_match('~^(LF|TF|GF)@[a-zA-Z_\-$&%*!?][a-zA-Z0-9_\-$&%*!?]*$~', $first_argument)) {
            $xml_instruction = $xml_output->createElement('instruction');
            $xml_instruction->setAttribute('order', $order);
            $xml_instruction->setAttribute('opcode', $instruction);
            $xml_first_argument = $xml_output->createElement('arg1', $first_argument);
            $xml_first_argument->setAttribute('type', 'var');
            $xml_instruction->appendChild($xml_first_argument);
            $xml_program->appendChild($xml_instruction);

            if(preg_match('~^int@[+\-]?([1-9][0-9]*(_[0-9]+)*|0[xX][0-9a-fA-F]+(_[0-9a-fA-F]+)*|0[oO]?[0-7]+(_[0-7]+)*|0[bB][01]+(_[01]+)*)+$~', $second_argument)) {
                $xml_second_argument = $xml_output->createElement('arg2', explode('@', $second_argument)[1]);
                $xml_second_argument->setAttribute('type', 'int');
                $xml_instruction->appendChild($xml_second_argument);
                $xml_program->appendChild($xml_instruction);

                if(preg_match('~^int@[+\-]?([1-9][0-9]*(_[0-9]+)*|0[xX][0-9a-fA-F]+(_[0-9a-fA-F]+)*|0[oO]?[0-7]+(_[0-7]+)*|0[bB][01]+(_[01]+)*)+$~', $third_argument)) {
                    $xml_third_argument = $xml_output->createElement('arg3', explode('@', $third_argument)[1]);
                    $xml_third_argument->setAttribute('type', 'int');
                    $xml_instruction->appendChild($xml_third_argument);
                    $xml_program->appendChild($xml_instruction);
                }
                else {
                    fwrite(STDERR, "Another lexical or syntax error!\n");
                    exit(FAIL_SOURCE);
                }
            }
            else {
                fwrite(STDERR, "Another lexical or syntax error!\n");
                exit(FAIL_SOURCE);
            }
        }
        else {
            fwrite(STDERR, "Another lexical or syntax error!\n");
            exit(FAIL_SOURCE);
        }
    }
    elseif(($instruction == 'LT') || ($instruction == 'GT') || ($instruction == 'EQ')) {
        if(preg_match('~^(LF|TF|GF)@[a-zA-Z_\-$&%*!?][a-zA-Z0-9_\-$&%*!?]*$~', $first_argument)) {
            $xml_instruction = $xml_output->createElement('instruction');
            $xml_instruction->setAttribute('order', $order);
            $xml_instruction->setAttribute('opcode', $instruction);
            $xml_first_argument = $xml_output->createElement('arg1', $first_argument);
            $xml_first_argument->setAttribute('type', 'var');
            $xml_instruction->appendChild($xml_first_argument);
            $xml_program->appendChild($xml_instruction);

            if(preg_match('~^int@[+\-]?([1-9][0-9]*(_[0-9]+)*|0[xX][0-9a-fA-F]+(_[0-9a-fA-F]+)*|0[oO]?[0-7]+(_[0-7]+)*|0[bB][01]+(_[01]+)*)+$~', $second_argument)) {
                $xml_second_argument = $xml_output->createElement('arg2', explode('@', $second_argument)[1]);
                $xml_second_argument->setAttribute('type', 'int');
                $xml_instruction->appendChild($xml_second_argument);
                $xml_program->appendChild($xml_instruction);

                if(preg_match('~^int@[+\-]?([1-9][0-9]*(_[0-9]+)*|0[xX][0-9a-fA-F]+(_[0-9a-fA-F]+)*|0[oO]?[0-7]+(_[0-7]+)*|0[bB][01]+(_[01]+)*)+$~', $third_argument)) {
                    $xml_third_argument = $xml_output->createElement('arg3', explode('@', $third_argument)[1]);
                    $xml_third_argument->setAttribute('type', 'int');
                    $xml_instruction->appendChild($xml_third_argument);
                    $xml_program->appendChild($xml_instruction);
                }
                else {
                    fwrite(STDERR, "Another lexical or syntax error!\n");
                    exit(FAIL_SOURCE);
                }
            }
            elseif(preg_match('~^bool@(true|false)$~', $second_argument)) {
                $xml_second_argument = $xml_output->createElement('arg2', explode('@', $second_argument)[1]);
                $xml_second_argument->setAttribute('type', 'bool');
                $xml_instruction->appendChild($xml_second_argument);
                $xml_program->appendChild($xml_instruction);

                if(preg_match('~^bool@(true|false)$~', $third_argument)) {
                    $xml_third_argument = $xml_output->createElement('arg3', explode('@', $third_argument)[1]);
                    $xml_third_argument->setAttribute('type', 'bool');
                    $xml_instruction->appendChild($xml_third_argument);
                    $xml_program->appendChild($xml_instruction);
                }
                else {
                    fwrite(STDERR, "Another lexical or syntax error!\n");
                    exit(FAIL_SOURCE);
                }
            }
            elseif(preg_match('~^string@(([^\s\#\\\\]|\\\\[0-9]{3})*)$~', $second_argument)) {
                $xml_second_argument = $xml_output->createElement('arg2', explode('@', $second_argument, 2)[1]);
                $xml_second_argument->setAttribute('type', 'string');
                $xml_instruction->appendChild($xml_second_argument);
                $xml_program->appendChild($xml_instruction);

                if(preg_match('~^string@(([^\s\#\\\\]|\\\\[0-9]{3})*)$~', $third_argument)) {
                    $xml_third_argument = $xml_output->createElement('arg3', explode('@', $third_argument, 2)[1]);
                    $xml_third_argument->setAttribute('type', 'string');
                    $xml_instruction->appendChild($xml_third_argument);
                    $xml_program->appendChild($xml_instruction);
                }
                else {
                    fwrite(STDERR, "Another lexical or syntax error!\n");
                    exit(FAIL_SOURCE);
                }
            }
            else {
                fwrite(STDERR, "Another lexical or syntax error!\n");
                exit(FAIL_SOURCE);
            }
        }
        else {
            fwrite(STDERR, "Another lexical or syntax error!\n");
            exit(FAIL_SOURCE);
        }
    }
    elseif(($instruction == 'AND') || ($instruction == 'OR')) {
        if(preg_match('~^(LF|TF|GF)@[a-zA-Z_\-$&%*!?][a-zA-Z0-9_\-$&%*!?]*$~', $first_argument)) {
            $xml_instruction = $xml_output->createElement('instruction');
            $xml_instruction->setAttribute('order', $order);
            $xml_instruction->setAttribute('opcode', $instruction);
            $xml_first_argument = $xml_output->createElement('arg1', $first_argument);
            $xml_first_argument->setAttribute('type', 'var');
            $xml_instruction->appendChild($xml_first_argument);
            $xml_program->appendChild($xml_instruction);

            if(preg_match('~^bool@(true|false)$~', $second_argument)) {
                $xml_second_argument = $xml_output->createElement('arg2', explode('@', $second_argument)[1]);
                $xml_second_argument->setAttribute('type', 'bool');
                $xml_instruction->appendChild($xml_second_argument);
                $xml_program->appendChild($xml_instruction);

                if(preg_match('~^bool@(true|false)$~', $third_argument)) {
                    $xml_third_argument = $xml_output->createElement('arg3', explode('@', $third_argument)[1]);
                    $xml_third_argument->setAttribute('type', 'bool');
                    $xml_instruction->appendChild($xml_third_argument);
                    $xml_program->appendChild($xml_instruction);
                }
                else {
                    fwrite(STDERR, "Another lexical or syntax error!\n");
                    exit(FAIL_SOURCE);
                }
            }
            else {
                fwrite(STDERR, "Another lexical or syntax error!\n");
                exit(FAIL_SOURCE);
            }
        }
        else {
            fwrite(STDERR, "Another lexical or syntax error!\n");
            exit(FAIL_SOURCE);
        }
    }
    elseif(($instruction == 'STRI2INT') || ($instruction == 'GETCHAR')) {
        if(preg_match('~^(LF|TF|GF)@[a-zA-Z_\-$&%*!?][a-zA-Z0-9_\-$&%*!?]*$~', $first_argument)) {
            $xml_instruction = $xml_output->createElement('instruction');
            $xml_instruction->setAttribute('order', $order);
            $xml_instruction->setAttribute('opcode', $instruction);
            $xml_first_argument = $xml_output->createElement('arg1', $first_argument);
            $xml_first_argument->setAttribute('type', 'var');
            $xml_instruction->appendChild($xml_first_argument);
            $xml_program->appendChild($xml_instruction);

            if(preg_match('~^string@(([^\s\#\\\\]|\\\\[0-9]{3})*)$~', $second_argument)) {
                $xml_second_argument = $xml_output->createElement('arg2', explode('@', $second_argument, 2)[1]);
                $xml_second_argument->setAttribute('type', 'string');
                $xml_instruction->appendChild($xml_second_argument);
                $xml_program->appendChild($xml_instruction);

                if(preg_match('~^int@[+\-]?([1-9][0-9]*(_[0-9]+)*|0[xX][0-9a-fA-F]+(_[0-9a-fA-F]+)*|0[oO]?[0-7]+(_[0-7]+)*|0[bB][01]+(_[01]+)*)+$~', $third_argument)) {
                    $xml_third_argument = $xml_output->createElement('arg3', explode('@', $third_argument)[1]);
                    $xml_third_argument->setAttribute('type', 'int');
                    $xml_instruction->appendChild($xml_third_argument);
                    $xml_program->appendChild($xml_instruction);
                }
                else {
                    fwrite(STDERR, "Another lexical or syntax error!\n");
                    exit(FAIL_SOURCE);
                }
            }
            else {
                fwrite(STDERR, "Another lexical or syntax error!\n");
                exit(FAIL_SOURCE);
            }
        }
        else {
            fwrite(STDERR, "Another lexical or syntax error!\n");
            exit(FAIL_SOURCE);
        }
    }
    elseif($instruction == 'CONCAT') {
        if(preg_match('~^(LF|TF|GF)@[a-zA-Z_\-$&%*!?][a-zA-Z0-9_\-$&%*!?]*$~', $first_argument)) {
            $xml_instruction = $xml_output->createElement('instruction');
            $xml_instruction->setAttribute('order', $order);
            $xml_instruction->setAttribute('opcode', $instruction);
            $xml_first_argument = $xml_output->createElement('arg1', $first_argument);
            $xml_first_argument->setAttribute('type', 'var');
            $xml_instruction->appendChild($xml_first_argument);
            $xml_program->appendChild($xml_instruction);

            if(preg_match('~^string@(([^\s\#\\\\]|\\\\[0-9]{3})*)$~', $second_argument)) {
                $xml_second_argument = $xml_output->createElement('arg2', explode('@', $second_argument, 2)[1]);
                $xml_second_argument->setAttribute('type', 'string');
                $xml_instruction->appendChild($xml_second_argument);
                $xml_program->appendChild($xml_instruction);

                if(preg_match('~^string@(([^\s\#\\\\]|\\\\[0-9]{3})*)$~', $third_argument)) {
                    $xml_third_argument = $xml_output->createElement('arg3', explode('@', $third_argument, 2)[1]);
                    $xml_third_argument->setAttribute('type', 'string');
                    $xml_instruction->appendChild($xml_third_argument);
                    $xml_program->appendChild($xml_instruction);
                }
                else {
                    fwrite(STDERR, "Another lexical or syntax error!\n");
                    exit(FAIL_SOURCE);
                }
            }
            else {
                fwrite(STDERR, "Another lexical or syntax error!\n");
                exit(FAIL_SOURCE);
            }
        }
        else {
            fwrite(STDERR, "Another lexical or syntax error!\n");
            exit(FAIL_SOURCE);
        }
    }
    elseif($instruction == 'SETCHAR') {
        if(preg_match('~^(LF|TF|GF)@[a-zA-Z_\-$&%*!?][a-zA-Z0-9_\-$&%*!?]*$~', $first_argument)) {
            $xml_instruction = $xml_output->createElement('instruction');
            $xml_instruction->setAttribute('order', $order);
            $xml_instruction->setAttribute('opcode', $instruction);
            $xml_first_argument = $xml_output->createElement('arg1', $first_argument);
            $xml_first_argument->setAttribute('type', 'var');
            $xml_instruction->appendChild($xml_first_argument);
            $xml_program->appendChild($xml_instruction);

            if(preg_match('~^int@[+\-]?([1-9][0-9]*(_[0-9]+)*|0[xX][0-9a-fA-F]+(_[0-9a-fA-F]+)*|0[oO]?[0-7]+(_[0-7]+)*|0[bB][01]+(_[01]+)*)+$~', $second_argument)) {
                $xml_second_argument = $xml_output->createElement('arg2', explode('@', $second_argument)[1]);
                $xml_second_argument->setAttribute('type', 'int');
                $xml_instruction->appendChild($xml_second_argument);
                $xml_program->appendChild($xml_instruction);

                if(preg_match('~^string@(([^\s\#\\\\]|\\\\[0-9]{3})*)$~', $third_argument)) {
                    $xml_third_argument = $xml_output->createElement('arg3', explode('@', $third_argument, 2)[1]);
                    $xml_third_argument->setAttribute('type', 'string');
                    $xml_instruction->appendChild($xml_third_argument);
                    $xml_program->appendChild($xml_instruction);
                }
                else {
                    fwrite(STDERR, "Another lexical or syntax error!\n");
                    exit(FAIL_SOURCE);
                }
            }
            else {
                fwrite(STDERR, "Another lexical or syntax error!\n");
                exit(FAIL_SOURCE);
            }
        }
        else {
            fwrite(STDERR, "Another lexical or syntax error!\n");
            exit(FAIL_SOURCE);
        }
    }
    elseif(($instruction == 'JUMPIFEQ') || ($instruction == 'JUMPIFNEQ')) {
        if(preg_match('~^[a-zA-Z_\-$&%*!?][a-zA-Z0-9_\-$&%*!?]*$~', $first_argument)) {
            $xml_instruction = $xml_output->createElement('instruction');
            $xml_instruction->setAttribute('order', $order);
            $xml_instruction->setAttribute('opcode', $instruction);
            $xml_first_argument = $xml_output->createElement('arg1', $first_argument);
            $xml_first_argument->setAttribute('type', 'label');
            $xml_instruction->appendChild($xml_first_argument);
            $xml_program->appendChild($xml_instruction);

            if(preg_match('~^int@[+\-]?([1-9][0-9]*(_[0-9]+)*|0[xX][0-9a-fA-F]+(_[0-9a-fA-F]+)*|0[oO]?[0-7]+(_[0-7]+)*|0[bB][01]+(_[01]+)*)+$~', $second_argument)) {
                $xml_second_argument = $xml_output->createElement('arg2', explode('@', $second_argument)[1]);
                $xml_second_argument->setAttribute('type', 'int');
                $xml_instruction->appendChild($xml_second_argument);
                $xml_program->appendChild($xml_instruction);

                if(preg_match('~^int@[+\-]?([1-9][0-9]*(_[0-9]+)*|0[xX][0-9a-fA-F]+(_[0-9a-fA-F]+)*|0[oO]?[0-7]+(_[0-7]+)*|0[bB][01]+(_[01]+)*)+$~', $third_argument)) {
                    $xml_third_argument = $xml_output->createElement('arg3', explode('@', $third_argument)[1]);
                    $xml_third_argument->setAttribute('type', 'int');
                    $xml_instruction->appendChild($xml_third_argument);
                    $xml_program->appendChild($xml_instruction);
                }
                else {
                    fwrite(STDERR, "Another lexical or syntax error!\n");
                    exit(FAIL_SOURCE);
                }
            }
            elseif(preg_match('~^bool@(true|false)$~', $second_argument)) {
                $xml_second_argument = $xml_output->createElement('arg2', explode('@', $second_argument)[1]);
                $xml_second_argument->setAttribute('type', 'bool');
                $xml_instruction->appendChild($xml_second_argument);
                $xml_program->appendChild($xml_instruction);

                if(preg_match('~^bool@(true|false)$~', $third_argument)) {
                    $xml_third_argument = $xml_output->createElement('arg3', explode('@', $third_argument)[1]);
                    $xml_third_argument->setAttribute('type', 'bool');
                    $xml_instruction->appendChild($xml_third_argument);
                    $xml_program->appendChild($xml_instruction);
                }
                else {
                    fwrite(STDERR, "Another lexical or syntax error!\n");
                    exit(FAIL_SOURCE);
                }
            }
            elseif(preg_match('~^string@(([^\s\#\\\\]|\\\\[0-9]{3})*)$~', $second_argument)) {
                $xml_second_argument = $xml_output->createElement('arg2', explode('@', $second_argument, 2)[1]);
                $xml_second_argument->setAttribute('type', 'string');
                $xml_instruction->appendChild($xml_second_argument);
                $xml_program->appendChild($xml_instruction);

                if(preg_match('~^string@(([^\s\#\\\\]|\\\\[0-9]{3})*)$~', $third_argument)) {
                    $xml_third_argument = $xml_output->createElement('arg3', explode('@', $third_argument, 2)[1]);
                    $xml_third_argument->setAttribute('type', 'string');
                    $xml_instruction->appendChild($xml_third_argument);
                    $xml_program->appendChild($xml_instruction);
                }
                else {
                    fwrite(STDERR, "Another lexical or syntax error!\n");
                    exit(FAIL_SOURCE);
                }
            }
            else {
                fwrite(STDERR, "Another lexical or syntax error!\n");
                exit(FAIL_SOURCE);
            }
        }
        else {
            fwrite(STDERR, "Another lexical or syntax error!\n");
            exit(FAIL_SOURCE);
        }
    }
    else {
        fwrite(STDERR, "Unknown or incorrect operating code!\n");
        exit(FAIL_OPCODE);
    }
}

?>

#!/bin/sh

#/**
# * Operating Systems
# * =================
# * 
# * 1st Project
# * Author: David Kvacek
# * Login: xkvace00; FIT
# * Date: 2022-04-01
# */

export POSIXLY_CORRECT=yes
export LC_NUMERIC=en_US.UTF-8

help() {
    echo "Usage: corona [-h] [FILTERS] [COMMAND] [LOG [LOG2 [...]]"
    echo ""
    echo " COMMAND can be one of:"
    echo "  infected        counts the number of infected"
    echo ""
    echo "  merge           merges several log files into one,"
    echo "                  preserving the original order"
    echo "                  (the header will be output only once)"
    echo ""
    echo "  gender          lists the number of infected for each sex"
    echo ""
    echo "  age             lists statistics on the number"
    echo "                  of infected people by age"
    echo ""
    echo "  daily           lists statistics on infected people"
    echo "                  for each day"
    echo ""
    echo "  monthly         lists statistics of infected persons"
    echo "                  for individual months"
    echo ""
    echo "  yearly          lists statistics on infected persons"
    echo "                  for each year"
    echo ""
    echo "  countries       lists statistics of infected persons"
    echo "                  for individual countries of the disease"
    echo "                  (excluding the Czech Republic, ie the CZ code)"
    echo ""
    echo "  districts       lists statistics on infected persons"
    echo "                  for individual districts"
    echo ""
    echo "  regions         lists statistics of infected persons"
    echo "                  for individual regions"
    echo ""
    echo ""
    echo " FILTERS can be a combination of the following (each at most once):"
    echo "  -a DATETIME     after: only AFTER records of this date"
    echo "                  are considered (including this date)"
    echo "                  DATETIME is in the format YYYY-MM-DD"
    echo ""
    echo "  -b DATETIME     before: only records BEFORE this date"
    echo "                  (including this date) are considered"
    echo "                  DATETIME is in the format YYYY-MM-DD"
    echo ""
    echo "  -g GENDER       only records of infected persons"
    echo "                  of a given sex are considered"
    echo "                  GENDER can be M (men) or Z (women)"
    echo ""
    echo "  -s [WIDTH]      for the commands gender, age, daily, monthly,"
    echo "                  yearly, countries, districts and regions"
    echo "                  it displays the data not numerically,"
    echo "                  but graphically in the form of histograms"
    echo "                  the optional parameter WIDTH sets the width"
    echo "                  of the histograms, ie the length of the longest"
    echo "                  line, to WIDTH, thus, WIDTH must be"
    echo "                  a positive integer, if the WIDTH parameter"
    echo "                  is not specified, the line widths"
    echo "                  follow the prescribed requirements"
    echo ""
    echo "  -h              prints help with a short description"
    echo "                  of each command and switch"
    echo ""
    echo ""
    echo "A shell script that analyzes the records of people"
    echo "with a proven coronavirus infection causing COVID-19"
    echo "in the Czech Republic, the script will filter records"
    echo "and provide basic statistics as specified by the user"
}

FILTER=""
DATETIME=""
GENDER=""
WIDTH=0
COMMAND="merge"
READ_INPUT=""

while true; do
    case "$1" in
        -a)
            FILTER="$1"
            DATETIME="$2"
            shift
            shift
            ;;
        -b)
            FILTER="$1"
            DATETIME="$2"
            shift
            shift
            ;;
        -g)
            FILTER="$1"
            GENDER="$2"
            shift
            shift
            ;;
        -s)
            FILTER="$1"
            case "$2" in
                ''|*[!0-9]*)
                    WIDTH=0
                    ;;
                *) 
                    WIDTH="$2"
                    ;;
            esac
            shift
            shift
            ;;
        -h)
            help
            exit 0
            ;;
        *)
            break
            shift
            ;;
    esac
done

while true; do
    case "$1" in
        infected)
            COMMAND="$1"
            shift
            break
            ;;
        merge)
            COMMAND="$1"
            shift
            break
            ;;
        gender)
            COMMAND="$1"
            shift
            break
            ;;
        age)
            COMMAND="$1"
            shift
            break
            ;;
        daily)
            COMMAND="$1"
            shift
            break
            ;;
        monthly)
            COMMAND="$1"
            shift
            break
            ;;
        yearly)
            COMMAND="$1"
            shift
            break
            ;;
        countries)
            COMMAND="$1"
            shift
            break
            ;;
        districts)
            COMMAND="$1"
            shift
            break
            ;;
        regions)
            COMMAND="$1"
            shift
            break
            ;;
        *)
            break
            ;;
    esac
done

if [ "$#" -gt 0 ]; then
    N=0
    while [ "$#" -gt 0 ]; do
        N=$((N + 1))
        if [ "${1##*.}" = "csv" ]; then
            if [ "$N" -gt 1 ]; then
                READ_INPUT="${READ_INPUT}$(< "$1" tail -n +2)"
            else
                READ_INPUT="${READ_INPUT}$(cat "$1")"
            fi
            shift

        elif [ "${1##*.}" = "gz" ]; then
            if [ "$N" -gt 1 ]; then
                READ_INPUT="${READ_INPUT}$(gzip -d -c "$1" | cat | tail -n +2)"
            else
                READ_INPUT="${READ_INPUT}$(gzip -d -c "$1" | cat)"
            fi
            shift

        elif [ "${1##*.}" = "bz2" ]; then
            if [ "$N" -gt 1 ]; then
                READ_INPUT="${READ_INPUT}$(bzip2 -d -c "$1" | cat | tail -n +2)"
            else
                READ_INPUT="${READ_INPUT}$(bzip2 -d -c "$1" | cat)"
            fi
            shift
        fi
    done
else
    READ_INPUT="$(cat)"
fi

if [ "${READ_INPUT}" = "" ]; then
    printf "id,datum,vek,pohlavi,kraj_nuts_kod,okres_lau_kod,nakaza_v_zahranici,nakaza_zeme_csu_kod,reportovano_khs\n"
    exit 0
fi

if [ "${COMMAND}" = "infected" ]; then
    if [ "${FILTER}" = "" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{A[$4]+=1} END{print A["M"] + A["Z"]}'

    elif [ "${FILTER}" = "-a" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{A["-a"]+=1} END{print A["-a"]}'

    elif [ "${FILTER}" = "-b" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{A["-b"]+=1} END{print A["-b"]}'

    elif [ "${FILTER}" = "-g" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{A["-g"]+=1} END{print A["-g"]}'
    fi

elif [ "${COMMAND}" = "merge" ]; then
    if [ "${FILTER}" = "" ]; then
        printf "%s\n" "${READ_INPUT}"

    elif [ "${FILTER}" = "-a" ]; then
        printf "%s\n" "${READ_INPUT}" | awk -v var="${DATETIME}" -F, '$2 >= var'

    elif [ "${FILTER}" = "-b" ]; then
        printf "%s\n" "${READ_INPUT}" | awk -v var="${DATETIME}" -F, '$2 <= var'

    elif [ "${FILTER}" = "-g" ]; then
        printf "%s\n" "${READ_INPUT}" | awk -v var="${GENDER}" -F, '$4 == var'

    fi

elif [ "${COMMAND}" = "gender" ]; then
    if [ "${WIDTH}" = 0 ]; then
        WIDTH=100000
    fi

    if [ "${FILTER}" = "" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{A[$4]+=1} END{print "M: " A["M"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{A[$4]+=1} END{print "Z: " A["Z"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{if($4 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None: " A["None"];}'

    elif [ "${FILTER}" = "-a" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{A[$4]+=1} END{print "M: " A["M"] "\nZ: " A["Z"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{if($4 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None: " A["None"];}'
    
    elif [ "${FILTER}" = "-b" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{A[$4]+=1} END{print "M: " A["M"] "\nZ: " A["Z"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{if($4 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None: " A["None"];}'
    
    elif [ "${FILTER}" = "-g" ]; then
        printf "%s: " "${GENDER}"
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{A["-g"]+=1} END{print A["-g"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{if($4 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None: " A["None"];}'
    
    elif [ "${FILTER}" = "-s" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${WIDTH}" -F, '{A[$4]+=1} END{printf "M: "; for(i = 0; i < (int(A["M"]/var)); i++) printf "#"; print ""}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${WIDTH}" -F, '{A[$4]+=1} END{printf "Z: "; for(i = 0; i < (int(A["Z"]/var)); i++) printf "#"; print ""}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${WIDTH}" -F, '{if($4 == "") A["None"]+=1;} END{if(A["None"] > 0) printf "None: "; for(i = 0; i < (int(A["None"]/var)); i++) printf "#"; if(A["None"] > 0) print "";}'

    fi

elif [ "${COMMAND}" = "age" ]; then
    if [ "${WIDTH}" = 0 ]; then
        WIDTH=10000
    fi

    if [ "${FILTER}" = "" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{if($3 <= 5) A[$3]+=1;} END{print "0-5   : " A["0"] + A["1"] + A["2"] + A["3"] + A["4"] + A["5"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{if($3 > 5 && $3 <= 15) A[$3]+=1;} END{print "6-15  : " A["6"] + A["7"] + A["8"] + A["9"] + A["10"] + A["11"] + A["12"] + A["13"] + A["14"] + A["15"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{if($3 > 15 && $3 <= 25) A[$3]+=1;} END{print "16-25 : " A["16"] + A["17"] + A["18"] + A["19"] + A["20"] + A["21"] + A["22"] + A["23"] + A["24"] + A["25"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{if($3 > 25 && $3 <= 35) A[$3]+=1;} END{print "26-35 : " A["26"] + A["27"] + A["28"] + A["29"] + A["30"] + A["31"] + A["32"] + A["33"] + A["34"] + A["35"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{if($3 > 35 && $3 <= 45) A[$3]+=1;} END{print "36-45 : " A["36"] + A["37"] + A["38"] + A["39"] + A["40"] + A["41"] + A["42"] + A["43"] + A["44"] + A["45"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{if($3 > 45 && $3 <= 55) A[$3]+=1;} END{print "46-55 : " A["46"] + A["47"] + A["48"] + A["49"] + A["50"] + A["51"] + A["52"] + A["53"] + A["54"] + A["55"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{if($3 > 55 && $3 <= 65) A[$3]+=1;} END{print "56-65 : " A["56"] + A["57"] + A["58"] + A["59"] + A["60"] + A["61"] + A["62"] + A["63"] + A["64"] + A["65"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{if($3 > 65 && $3 <= 75) A[$3]+=1;} END{print "66-75 : " A["66"] + A["67"] + A["68"] + A["69"] + A["70"] + A["71"] + A["72"] + A["73"] + A["74"] + A["75"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{if($3 > 75 && $3 <= 85) A[$3]+=1;} END{print "76-85 : " A["76"] + A["77"] + A["78"] + A["79"] + A["80"] + A["81"] + A["82"] + A["83"] + A["84"] + A["85"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{if($3 > 85 && $3 <= 95) A[$3]+=1;} END{print "86-95 : " A["86"] + A["87"] + A["88"] + A["89"] + A["90"] + A["91"] + A["92"] + A["93"] + A["94"] + A["95"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{if($3 > 95 && $3 <= 105) A[$3]+=1;} END{print "96-105: " A["96"] + A["97"] + A["98"] + A["99"] + A["100"] + A["101"] + A["102"] + A["103"] + A["104"] + A["105"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{if($3 > 105) A[$3]+=1;} END{print ">105  : " A["106"] + A["107"] + A["108"] + A["109"] + A["110"] + A["111"] + A["112"] + A["113"] + A["114"] + A["115"] + A["116"] + A["117"] + A["118"] + A["119"] + A["120"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{if($3 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None  : " A["None"];}'
    
    elif [ "${FILTER}" = "-a" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{if($3 <= 5) A[$3]+=1;} END{print "0-5   : " A["0"] + A["1"] + A["2"] + A["3"] + A["4"] + A["5"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{if($3 > 5 && $3 <= 15) A[$3]+=1;} END{print "6-15  : " A["6"] + A["7"] + A["8"] + A["9"] + A["10"] + A["11"] + A["12"] + A["13"] + A["14"] + A["15"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{if($3 > 15 && $3 <= 25) A[$3]+=1;} END{print "16-25 : " A["16"] + A["17"] + A["18"] + A["19"] + A["20"] + A["21"] + A["22"] + A["23"] + A["24"] + A["25"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{if($3 > 25 && $3 <= 35) A[$3]+=1;} END{print "26-35 : " A["26"] + A["27"] + A["28"] + A["29"] + A["30"] + A["31"] + A["32"] + A["33"] + A["34"] + A["35"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{if($3 > 35 && $3 <= 45) A[$3]+=1;} END{print "36-45 : " A["36"] + A["37"] + A["38"] + A["39"] + A["40"] + A["41"] + A["42"] + A["43"] + A["44"] + A["45"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{if($3 > 45 && $3 <= 55) A[$3]+=1;} END{print "46-55 : " A["46"] + A["47"] + A["48"] + A["49"] + A["50"] + A["51"] + A["52"] + A["53"] + A["54"] + A["55"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{if($3 > 55 && $3 <= 65) A[$3]+=1;} END{print "56-65 : " A["56"] + A["57"] + A["58"] + A["59"] + A["60"] + A["61"] + A["62"] + A["63"] + A["64"] + A["65"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{if($3 > 65 && $3 <= 75) A[$3]+=1;} END{print "66-75 : " A["66"] + A["67"] + A["68"] + A["69"] + A["70"] + A["71"] + A["72"] + A["73"] + A["74"] + A["75"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{if($3 > 75 && $3 <= 85) A[$3]+=1;} END{print "76-85 : " A["76"] + A["77"] + A["78"] + A["79"] + A["80"] + A["81"] + A["82"] + A["83"] + A["84"] + A["85"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{if($3 > 85 && $3 <= 95) A[$3]+=1;} END{print "86-95 : " A["86"] + A["87"] + A["88"] + A["89"] + A["90"] + A["91"] + A["92"] + A["93"] + A["94"] + A["95"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{if($3 > 95 && $3 <= 105) A[$3]+=1;} END{print "96-105: " A["96"] + A["97"] + A["98"] + A["99"] + A["100"] + A["101"] + A["102"] + A["103"] + A["104"] + A["105"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{if($3 > 105) A[$3]+=1;} END{print ">105  : " A["106"] + A["107"] + A["108"] + A["109"] + A["110"] + A["111"] + A["112"] + A["113"] + A["114"] + A["115"] + A["116"] + A["117"] + A["118"] + A["119"] + A["120"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{if($3 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None  : " A["None"];}'
    
    elif [ "${FILTER}" = "-b" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{if($3 <= 5) A[$3]+=1;} END{print "0-5   : " A["0"] + A["1"] + A["2"] + A["3"] + A["4"] + A["5"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{if($3 > 5 && $3 <= 15) A[$3]+=1;} END{print "6-15  : " A["6"] + A["7"] + A["8"] + A["9"] + A["10"] + A["11"] + A["12"] + A["13"] + A["14"] + A["15"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{if($3 > 15 && $3 <= 25) A[$3]+=1;} END{print "16-25 : " A["16"] + A["17"] + A["18"] + A["19"] + A["20"] + A["21"] + A["22"] + A["23"] + A["24"] + A["25"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{if($3 > 25 && $3 <= 35) A[$3]+=1;} END{print "26-35 : " A["26"] + A["27"] + A["28"] + A["29"] + A["30"] + A["31"] + A["32"] + A["33"] + A["34"] + A["35"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{if($3 > 35 && $3 <= 45) A[$3]+=1;} END{print "36-45 : " A["36"] + A["37"] + A["38"] + A["39"] + A["40"] + A["41"] + A["42"] + A["43"] + A["44"] + A["45"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{if($3 > 45 && $3 <= 55) A[$3]+=1;} END{print "46-55 : " A["46"] + A["47"] + A["48"] + A["49"] + A["50"] + A["51"] + A["52"] + A["53"] + A["54"] + A["55"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{if($3 > 55 && $3 <= 65) A[$3]+=1;} END{print "56-65 : " A["56"] + A["57"] + A["58"] + A["59"] + A["60"] + A["61"] + A["62"] + A["63"] + A["64"] + A["65"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{if($3 > 65 && $3 <= 75) A[$3]+=1;} END{print "66-75 : " A["66"] + A["67"] + A["68"] + A["69"] + A["70"] + A["71"] + A["72"] + A["73"] + A["74"] + A["75"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{if($3 > 75 && $3 <= 85) A[$3]+=1;} END{print "76-85 : " A["76"] + A["77"] + A["78"] + A["79"] + A["80"] + A["81"] + A["82"] + A["83"] + A["84"] + A["85"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{if($3 > 85 && $3 <= 95) A[$3]+=1;} END{print "86-95 : " A["86"] + A["87"] + A["88"] + A["89"] + A["90"] + A["91"] + A["92"] + A["93"] + A["94"] + A["95"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{if($3 > 95 && $3 <= 105) A[$3]+=1;} END{print "96-105: " A["96"] + A["97"] + A["98"] + A["99"] + A["100"] + A["101"] + A["102"] + A["103"] + A["104"] + A["105"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{if($3 > 105) A[$3]+=1;} END{print ">105  : " A["106"] + A["107"] + A["108"] + A["109"] + A["110"] + A["111"] + A["112"] + A["113"] + A["114"] + A["115"] + A["116"] + A["117"] + A["118"] + A["119"] + A["120"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{if($3 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None  : " A["None"];}'

    elif [ "${FILTER}" = "-g" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{if($3 <= 5) A[$3]+=1;} END{print "0-5   : " A["0"] + A["1"] + A["2"] + A["3"] + A["4"] + A["5"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{if($3 > 5 && $3 <= 15) A[$3]+=1;} END{print "6-15  : " A["6"] + A["7"] + A["8"] + A["9"] + A["10"] + A["11"] + A["12"] + A["13"] + A["14"] + A["15"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{if($3 > 15 && $3 <= 25) A[$3]+=1;} END{print "16-25 : " A["16"] + A["17"] + A["18"] + A["19"] + A["20"] + A["21"] + A["22"] + A["23"] + A["24"] + A["25"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{if($3 > 25 && $3 <= 35) A[$3]+=1;} END{print "26-35 : " A["26"] + A["27"] + A["28"] + A["29"] + A["30"] + A["31"] + A["32"] + A["33"] + A["34"] + A["35"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{if($3 > 35 && $3 <= 45) A[$3]+=1;} END{print "36-45 : " A["36"] + A["37"] + A["38"] + A["39"] + A["40"] + A["41"] + A["42"] + A["43"] + A["44"] + A["45"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{if($3 > 45 && $3 <= 55) A[$3]+=1;} END{print "46-55 : " A["46"] + A["47"] + A["48"] + A["49"] + A["50"] + A["51"] + A["52"] + A["53"] + A["54"] + A["55"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{if($3 > 55 && $3 <= 65) A[$3]+=1;} END{print "56-65 : " A["56"] + A["57"] + A["58"] + A["59"] + A["60"] + A["61"] + A["62"] + A["63"] + A["64"] + A["65"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{if($3 > 65 && $3 <= 75) A[$3]+=1;} END{print "66-75 : " A["66"] + A["67"] + A["68"] + A["69"] + A["70"] + A["71"] + A["72"] + A["73"] + A["74"] + A["75"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{if($3 > 75 && $3 <= 85) A[$3]+=1;} END{print "76-85 : " A["76"] + A["77"] + A["78"] + A["79"] + A["80"] + A["81"] + A["82"] + A["83"] + A["84"] + A["85"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{if($3 > 85 && $3 <= 95) A[$3]+=1;} END{print "86-95 : " A["86"] + A["87"] + A["88"] + A["89"] + A["90"] + A["91"] + A["92"] + A["93"] + A["94"] + A["95"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{if($3 > 95 && $3 <= 105) A[$3]+=1;} END{print "96-105: " A["96"] + A["97"] + A["98"] + A["99"] + A["100"] + A["101"] + A["102"] + A["103"] + A["104"] + A["105"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{if($3 > 105) A[$3]+=1;} END{print ">105  : " A["106"] + A["107"] + A["108"] + A["109"] + A["110"] + A["111"] + A["112"] + A["113"] + A["114"] + A["115"] + A["116"] + A["117"] + A["118"] + A["119"] + A["120"]}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{if($3 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None  : " A["None"];}'
    
    elif [ "${FILTER}" = "-s" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${WIDTH}" -F, '{if($3 <= 5) A[$3]+=1;} END{printf "0-5   : "; for(i = 0; i < (int((A["0"] + A["1"] + A["2"] + A["3"] + A["4"] + A["5"])/var)); i++) printf "#"; print ""}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${WIDTH}" -F, '{if($3 > 5 && $3 <= 15) A[$3]+=1;} END{printf "6-15  : "; for(i = 0; i < (int((A["6"] + A["7"] + A["8"] + A["9"] + A["10"] + A["11"] + A["12"] + A["13"] + A["14"] + A["15"])/var)); i++) printf "#"; print ""}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${WIDTH}" -F, '{if($3 > 15 && $3 <= 25) A[$3]+=1;} END{printf "16-25 : "; for(i = 0; i < (int((A["16"] + A["17"] + A["18"] + A["19"] + A["20"] + A["21"] + A["22"] + A["23"] + A["24"] + A["25"])/var)); i++) printf "#"; print ""}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${WIDTH}" -F, '{if($3 > 25 && $3 <= 35) A[$3]+=1;} END{printf "26-35 : "; for(i = 0; i < (int((A["26"] + A["27"] + A["28"] + A["29"] + A["30"] + A["31"] + A["32"] + A["33"] + A["34"] + A["35"])/var)); i++) printf "#"; print ""}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${WIDTH}" -F, '{if($3 > 35 && $3 <= 45) A[$3]+=1;} END{printf "36-45 : "; for(i = 0; i < (int((A["36"] + A["37"] + A["38"] + A["39"] + A["40"] + A["41"] + A["42"] + A["43"] + A["44"] + A["45"])/var)); i++) printf "#"; print ""}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${WIDTH}" -F, '{if($3 > 45 && $3 <= 55) A[$3]+=1;} END{printf "46-55 : "; for(i = 0; i < (int((A["46"] + A["47"] + A["48"] + A["49"] + A["50"] + A["51"] + A["52"] + A["53"] + A["54"] + A["55"])/var)); i++) printf "#"; print ""}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${WIDTH}" -F, '{if($3 > 55 && $3 <= 65) A[$3]+=1;} END{printf "56-65 : "; for(i = 0; i < (int((A["56"] + A["57"] + A["58"] + A["59"] + A["60"] + A["61"] + A["62"] + A["63"] + A["64"] + A["65"])/var)); i++) printf "#"; print ""}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${WIDTH}" -F, '{if($3 > 65 && $3 <= 75) A[$3]+=1;} END{printf "66-75 : "; for(i = 0; i < (int((A["66"] + A["67"] + A["68"] + A["69"] + A["70"] + A["71"] + A["72"] + A["73"] + A["74"] + A["75"])/var)); i++) printf "#"; print ""}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${WIDTH}" -F, '{if($3 > 75 && $3 <= 85) A[$3]+=1;} END{printf "76-85 : "; for(i = 0; i < (int((A["76"] + A["77"] + A["78"] + A["79"] + A["80"] + A["81"] + A["82"] + A["83"] + A["84"] + A["85"])/var)); i++) printf "#"; print ""}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${WIDTH}" -F, '{if($3 > 85 && $3 <= 95) A[$3]+=1;} END{printf "86-95 : "; for(i = 0; i < (int((A["86"] + A["87"] + A["88"] + A["89"] + A["90"] + A["91"] + A["92"] + A["93"] + A["94"] + A["95"])/var)); i++) printf "#"; print ""}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${WIDTH}" -F, '{if($3 > 95 && $3 <= 105) A[$3]+=1;} END{printf "96-105: "; for(i = 0; i < (int((A["96"] + A["97"] + A["98"] + A["99"] + A["100"] + A["101"] + A["102"] + A["103"] + A["104"] + A["105"])/var)); i++) printf "#"; print ""}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${WIDTH}" -F, '{if($3 > 105) A[$3]+=1;} END{printf ">105  : "; for(i = 0; i < (int((A["106"] + A["107"] + A["108"] + A["109"] + A["110"] + A["111"] + A["112"] + A["113"] + A["114"] + A["115"] + A["116"] + A["117"] + A["118"] + A["119"] + A["120"])/var)); i++) printf "#"; print ""}'
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${WIDTH}" -F, '{if($3 == "") A["None"]+=1;} END{if(A["None"] > 0) printf "None  : "; for(i = 0; i < (int(A["None"]/var)); i++) printf "#"; if(A["None"] > 0) print "";}'
    fi

elif [ "${COMMAND}" = "daily" ]; then
    if [ "${WIDTH}" = "" ]; then
        WIDTH=500
    fi

    if [ "${FILTER}" = "" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{if($2 != "") A[$2]+=1;} END{for(key in A) {printf "%s: %s\n", key, A[key]}}' | sort
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{if($2 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None: " A["None"];}'
    
    elif [ "${FILTER}" = "-a" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{if($2 != "") A[$2]+=1;} END{for(key in A) {printf "%s: %s\n", key, A[key]}}' | sort
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{if($2 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None: " A["None"];}'

    elif [ "${FILTER}" = "-b" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{if($2 != "") A[$2]+=1;} END{for(key in A) {printf "%s: %s\n", key, A[key]}}' | sort
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{if($2 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None: " A["None"];}'

    elif [ "${FILTER}" = "-g" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{if($2 != "") A[$2]+=1;} END{for(key in A) {printf "%s: %s\n", key, A[key]}}' | sort
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{if($2 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None: " A["None"];}'
    fi

elif [ "${COMMAND}" = "monthly" ]; then
    if [ "${WIDTH}" = "" ]; then
        WIDTH=10000
    fi

    if [ "${FILTER}" = "" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{if($2 != "") A[substr($2, 1, 7)]+=1;} END{for(key in A) {printf "%s: %s\n", key,A[key]}}' | sort
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{if($2 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None: " A["None"];}'
    
    elif [ "${FILTER}" = "-a" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{if($2 != "") A[substr($2, 1, 7)]+=1;} END{for(key in A) {printf "%s: %s\n", key, A[key]}}' | sort
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{if($2 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None: " A["None"];}'

    elif [ "${FILTER}" = "-b" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{if($2 != "") A[substr($2, 1, 7)]+=1;} END{for(key in A) {printf "%s: %s\n", key, A[key]}}' | sort
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{if($2 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None: " A["None"];}'

    elif [ "${FILTER}" = "-g" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{if($2 != "") A[substr($2, 1, 7)]+=1;} END{for(key in A) {printf "%s: %s\n", key, A[key]}}' | sort
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{if($2 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None: " A["None"];}'
    fi

elif [ "${COMMAND}" = "yearly" ]; then
    if [ "${WIDTH}" = "" ]; then
        WIDTH=100000
    fi

    if [ "${FILTER}" = "" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{if($2 != "") A[substr($2, 1, 4)]+=1;} END{for(key in A) {printf "%s: %s\n", key,A[key]}}' | sort
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{if($2 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None: " A["None"];}'
    
    elif [ "${FILTER}" = "-a" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{if($2 != "") A[substr($2, 1, 4)]+=1;} END{for(key in A) {printf "%s: %s\n", key,A[key]}}' | sort
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{if($2 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None: " A["None"];}'

    elif [ "${FILTER}" = "-b" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{if($2 != "") A[substr($2, 1, 4)]+=1;} END{for(key in A) {printf "%s: %s\n", key,A[key]}}' | sort
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{if($2 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None: " A["None"];}'

    elif [ "${FILTER}" = "-g" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{if($2 != "") A[substr($2, 1, 4)]+=1;} END{for(key in A) {printf "%s: %s\n", key,A[key]}}' | sort
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{if($2 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None: " A["None"];}'
    fi

elif [ "${COMMAND}" = "countries" ]; then
    if [ "${WIDTH}" = "" ]; then
        WIDTH=100
    fi

    if [ "${FILTER}" = "" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{if($8 != "") A[$8]+=1;} END{for(key in A) {printf "%s: %s\n", key, A[key]}}' | sort
    
    elif [ "${FILTER}" = "-a" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{if($8 != "") A[$8]+=1;} END{for(key in A) {printf "%s: %s\n", key, A[key]}}' | sort

    elif [ "${FILTER}" = "-b" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{if($8 != "") A[$8]+=1;} END{for(key in A) {printf "%s: %s\n", key, A[key]}}' | sort

    elif [ "${FILTER}" = "-g" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 ==<var' | awk -F, '{if($8 != "") A[$8]+=1;} END{for(key in A) {printf "%s: %s\n", key, A[key]}}' | sort
    fi

elif [ "${COMMAND}" = "districts" ]; then
    if [ "${WIDTH}" = "" ]; then
        WIDTH=1000
    fi

    if [ "${FILTER}" = "" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{if($6 != "") A[$6]+=1;} END{for(key in A) {printf "%s: %s\n", key, A[key]}}' | sort
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{if($6 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None: " A["None"];}'
    
    elif [ "${FILTER}" = "-a" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{if($6 != "") A[$6]+=1;} END{for(key in A) {printf "%s: %s\n", key, A[key]}}' | sort
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{if($6 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None: " A["None"];}'

    elif [ "${FILTER}" = "-b" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{if($6 != "") A[$6]+=1;} END{for(key in A) {printf "%s: %s\n", key, A[key]}}' | sort
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{if($6 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None: " A["None"];}'

    elif [ "${FILTER}" = "-g" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{if($6 != "") A[$6]+=1;} END{for(key in A) {printf "%s: %s\n", key, A[key]}}' | sort
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{if($6 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None: " A["None"];}'
    fi

elif [ "${COMMAND}" = "regions" ]; then
    if [ "${WIDTH}" = "" ]; then
        WIDTH=10000
    fi

    if [ "${FILTER}" = "" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{if($5 != "") A[$5]+=1;} END{for(key in A) {printf "%s: %s\n", key, A[key]}}' | sort
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -F, '{if($5 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None: " A["None"];}'
    
    elif [ "${FILTER}" = "-a" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{if($5 != "") A[$5]+=1;} END{for(key in A) {printf "%s: %s\n", key, A[key]}}' | sort
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 >= var' | awk -F, '{if($5 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None: " A["None"];}'

    elif [ "${FILTER}" = "-b" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{if($5 != "") A[$5]+=1;} END{for(key in A) {printf "%s: %s\n", key, A[key]}}' | sort
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${DATETIME}" -F, '$2 <= var' | awk -F, '{if($5 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None: " A["None"];}'

    elif [ "${FILTER}" = "-g" ]; then
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{if($5 != "") A[$5]+=1;} END{for(key in A) {printf "%s: %s\n", key, A[key]}}' | sort
        printf "%s\n" "${READ_INPUT}" | tail -n +2 | awk -v var="${GENDER}" -F, '$4 == var' | awk -F, '{if($5 == "") A["None"]+=1;} END{if(A["None"] > 0) print "None: " A["None"];}'
    fi
fi

exit 0

#!/bin/bash

export HOME=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

function usage() {
  echo "Usage: $(basename $0) [options]"
  echo "Options:"
  echo "   -t, --type       setting build type"
  echo "   Enable Build Type:"
  echo "      Debug: -g -O0"
  echo "      Release: -O3"
  echo "   -h, --help       usage"
  exit 1
}

function ErrorDetection {
    RET=$?
    echo "Error: FailCommand: $1 FailStatus: $RET"
    cd $HOME
    exit 1
}

while getopts t:h-: opt; do
    # OPTARG を = の位置で分割して opt と optarg に代入
    optarg="$OPTARG"
    if [[ "$opt" = - ]]; then
        opt="-${OPTARG%%=*}"
        optarg="${OPTARG/${OPTARG%%=*}/}"
        optarg="${optarg#=}"

        if [[ -z "$optarg" ]] && [[ ! "${!OPTIND}" = -* ]]; then
            optarg="${!OPTIND}"
            shift
        fi
    fi

    case "-$opt" in
        -t|--type)
            t="$optarg"
            ;;
        -h|--help)
            usage
            exit
            ;;
        --)
            break
            ;;
        -\?)
            exit 1
            ;;
        --*)
            echo "$0: illegal option -- ${opt##-}" >&2
            exit 1
            ;;
    esac
done

CBUILDTYPE=""

if [[ $t == "Debug" ]]; then
    CBUILDTYPE="-DCMAKE_BUILD_TYPE=Debug"
elif [[ $t == "Release" ]]; then
    CBUILDTYPE="-DCMAKE_BUILD_TYPE=Release"
elif [[ $t == "" ]]; then
    CBUILDTYPE=""
else
    echo "Unknown Build Type: $t"
    usage
    exit 1
fi

threadnum=$((($(nproc) / 2) + 1))

mkdir -p build || ErrorDetection "mkdir -p build"
pushd build
cmake $CBUILDTYPE .. || ErrorDetection "cmake ${CBUILDTYPE} .."
make -j${threadnum} || ErrorDetection "make -j${threadnum}"
popd

exit 0

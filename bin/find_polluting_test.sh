#!/bin/bash -euo pipefail

FAILING_TEST=${1:-""}
FILE=${2:-"target/test-reports/TESTS-TestSuites.xml"}
GRAILSW="./grailsw"
TEST_COMMAND="${GRAILSW} test-app -integration"
LOGFILE="${PWD}/$(basename $0)"
LOGFILE="${LOGFILE%%.*}.log"

usage() {
    echo "Usage: $0 <Failing Test> [path/to/TESTS-TestSuites.xml]" >&2
}

indexOf() {
    local needle="$1"
    shift
    local haystack=($@)
    local index=-1
    for i in $(seq 0 $((${#@} - 1))) ; do
        if [ "${needle}" = "${haystack[${i}]}" ]; then
            index=$i
            break
        fi
    done

    echo -n $index
}

if [ -z "${FAILING_TEST}" ]; then
    usage
    exit 1
fi

if ! [ -f "${FILE}" ]; then
    echo "Not a file: '${FILE}'" >&2
    usage
    exit 1
fi

if ! [ -x "${GRAILSW}" ]; then
    echo "must be run from the grails project root: '${FILE}'" >&2
    usage
    exit 1
fi

log_info() {
    echo "INFO: $@"
    echo "INFO: $@" >> "${LOGFILE}"
}

log_error() {
    echo "ERROR: $@" >&2
    echo "ERROR: $@" >> "${LOGFILE}"
}

is_test_failing() {
    grep -e '\(errors\|failures\)="[^0]' "${FILE}" | fgrep -q name='"'"${FAILING_TEST}"'"'
}

run_tests() {
    local failing_tests=$1
    shift
    local tests=($@)

    if [ 0 -eq ${#tests[@]} ]; then
        log_error "No tests passed in to run_tests"
        return 0
    fi

    log_info "Running: (${tests[@]} ${failing_test})"

    local passed=0
    if ${TEST_COMMAND} "${tests[@]}" "${failing_test}"; then
        log_info "all tests passed"
        passed=1
    fi

    if [ 1 -eq $passed ] || ! is_test_failing; then
        log_info "test passed"
        return 1
    elif [ 1 -eq ${#tests[@]} ]; then
        log_info "Success: ${tests[0]}" >> "${0}.log"
        echo "The culprit is ${tests[0]}"
        echo "use '${TEST_COMMAND} ${tests[0]} ${failing_test}' to test"
        return 0
    else
        log_info "test failed, splitting"
        split_then_run_tests "${failing_test}" "${tests[@]}"
    fi
}

split_then_run_tests() {
    local failing_test=$1
    shift
    local tests=($@)
    local test_size=${#tests[@]}

    local left_half_size=$((${test_size} / 2))
    local right_half_size=${left_half_size}
    if [ $((${left_half_size} + ${right_half_size})) -ne ${test_size} ]; then
        right_half_size=$((${right_half_size} + 1))
    fi

    local right_tests=(${tests[@]:${left_half_size}:${right_half_size}})
    local left_tests=()
    if [ $left_half_size -gt 0 ]; then
        left_tests=(${tests[@]:0:${left_half_size}})
    fi

    if ! run_tests "${failing_test}" "${right_tests[@]}"; then
        if ! run_tests "${failing_test}" "${left_tests[@]}"; then
            log_error "Polluting test not found"
        fi
    fi
}

TESTS=($(grep -o '<testsuite .*\<name="[^"]\+"' "${FILE}" | sed -e's/.* name="\([^"]*\)".*/\1/' | tr '\n' ' '))
echo "Tests: (${TESTS[@]})" > "${0}.log"

i=$(indexOf "${FAILING_TEST}" "${TESTS[@]}")

if [ -1 -eq $i ]; then
    echo "${FAILING_TEST} not found" >&2
    usage
    exit 1
fi

split_then_run_tests "${FAILING_TEST}" "${TESTS[@]:0:${i}}"

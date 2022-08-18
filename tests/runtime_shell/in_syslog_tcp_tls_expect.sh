#!/bin/sh

. ${FLB_RUNTIME_SHELL_PATH}/in_syslog_common.sh

input_generator() {
    result=$(wait_for_fluent_bit)

    if test "$result" -eq "0"
    then
        logger -d -n $LISTENER_HOST -P $LISTENER_PORT 'Hello!' -s 2>&1 | \
            openssl s_client -connect $LISTENER_HOST:$LISTENER_PORT 2>&1 >/dev/null
    fi
}

test_in_syslog_tcp_plaintext_filter_expect() {
    export LISTENER_VHOST=leo.vcap.me
    export LISTENER_HOST=127.0.0.1 
    export LISTENER_PORT=9999

    input_generator &

    $FLB_BIN -c $FLB_RUNTIME_SHELL_CONF/in_syslog_tcp_tls_expect.conf
}

# The following command launch the unit test
. $FLB_RUNTIME_SHELL_PATH/runtime_shell.env
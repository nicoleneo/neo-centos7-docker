#!/bin/bash
# Enable core dumps
echo '1' > /writable-proc/sys/kernel/core_uses_pid
echo '/logs/cores/core-%e-%t' > /writable-proc/sys/kernel/core_pattern
echo '2' > /writable-proc/sys/fs/suid_dumpable
chown $USER:$USER /logs/cores
#service sshd start
/usr/sbin/sshd &
su -l - $USER
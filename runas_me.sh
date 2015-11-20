#!/bin/bash
# ----- change uid/gid of "me" user to values
# ----- in $NEWUID and $NEWGID, or 500/500 if they
# ----- are not set, then execute the arguments as
# ----- a command.
#
# ---- usage:
# ----    runas_me.sh ls -l .
#
: ${NEWUID=500}
: ${NEWGID=500}
#
# ----- we can't change me user to a UID that is
# ----- alread in use
#
if [ $(grep -c ":\*:$NEWUID:" /etc/passwd) -gt 0 ]; then
    echo "cannot change me uid to $NEWUID: uid is already in use by:"
    echo $(grep -c ":\*:$NEWUID:")
    exit 1
fi
usermod -u $NEWUID me
#
# ----- if a group with GID=$NEWGID already exists
# -----    just switch me to that group, instead
# -----    of changing the GID of the me group
#
if [ $(grep -c ":$NEWGID:" /etc/group) -eq 0 ]; then
    groupmod -g $NEWGID me
else
    usermod -g $NEWGID me
fi
#
# ---- change the ownership of all of the "me" files to match
# ---- the new UID/GID
# ----- and move the temp $HOME directory to /home/me
# ----- because of the docker weirdness with permissions
#
chown -R me:$(id -g me)  /dhome/me
usermod --home /home/me --move-home me
#
# ----- execute the command provides as the "me" user
# ----- from the "me" home directory
#
cd /home/me
exec sudo -E -u me "$@"


# := if unset or null, replace.

one=''
testonea=${one-'testonea'}
printf "<testonea: ${testonea}>.\n"
testoneb=${one:-'testoneb'}
printf "<testoneb: ${testoneb}>.\n"
testonec=${one='testonec'}
printf "<testonec: ${testonec}>.\n"
testoned=${one:='testoned'}
printf "<testoned: ${testoned}>.\n"

two='a'
testtwoa=${two-'testtwoa'}
printf "<testtwoa: ${testtwoa}>.\n"
testtwob=${two:-'testtwob'}
printf "<testtwob: ${testtwob}>.\n"
testtwoc=${two='testtwoc'}
printf "<testtwoc: ${testtwoc}>.\n"
testtwod=${two:='testtwod'}
printf "<testtwod: ${testtwod}>.\n"

fight="${four}:0.0"
printf "[REPORT ] <fight: ${fight}>."

# THREE

#export HOSTNAME="$(hostname -f)"
#printf "[REPORT ] <HOSTNAME: ${HOSTNAME}>.\n"
#export DOMAIN=${HOSTNAME#*.}
#printf "[REPORT ] <DOMAIN: ${DOMAIN}>.\n"
#export SHORTHOSTNAME=${HOSTNAME%%.*}
#printf "[REPORT ] <SHORTHOSTNAME: ${SHORTHOSTNAME}>.\n"
#export REMOTEHOST="$(whoami | grep '^.*(\([^:)]*\).*$' | sed 's/^.*(\([^:)]*\).*$/\1/g')"
#printf "[REPORT ] <REMOTEHOST: ${REMOTEHOST}>.\n"


# Make sure the REMOTEHOST variable is set
#if [ -z $REMOTEHOST ]; then
#   export REMOTEHOST=$HOST
#fi

# Make sure the DISPLAY variable is set
#if [ -z $DISPLAY ]  && [ -n $REMOTEHOST ]; then
#   export DISPLAY=$REMOTEHOST:0.0
#fi

READNULLCMD DEFAULT=${PAGER}

# sets variable without needing to reassign
# colons suppress attempting to run the string
unset EGGS
: ${EGGS=spam}
echo 1 $EGGS     # 1 spam
unset EGGS
: ${EGGS:=spam}
echo 2 $EGGS     # 2 spam

EGGS=
: ${EGGS=spam}
echo 3 $EGGS     # 3        (set, but blank -> leaves alone)
EGGS=
: ${EGGS:=spam}
echo 4 $EGGS     # 4 spam

EGGS=cheese
: ${EGGS:=spam}
echo 5 $EGGS     # 5 cheese
EGGS=cheese
: ${EGGS=spam}
echo 6 $EGGS     # 6 cheese

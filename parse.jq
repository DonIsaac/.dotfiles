
# Concatinates an array of strings
def concat: reduce .[] as $x
	(""; . + $x + "\n")
;

##
# Turns a link record (each entry is to: from) and returns
# a list where each element is a string in the form `from;to`
# so that a bash script may easily parse it
def to_link_pair_list(prop):
	prop | to_entries | map(.value + ";" + .key)
;
. | to_link_pair_list(.link) | concat

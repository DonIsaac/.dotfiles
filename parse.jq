##
# Turns a link record (each entry is to: from) and returns
# a list where each element is a string in the form `to,from`
# so that a bash script may easily parse it
def to_link_pair_list(prop):
	prop | to_entries | map(.key + ";" + .value)
;

def concat: reduce .[] as $x
	(""; . + $x + "\n")
;
. | to_link_pair_list(.link) | concat

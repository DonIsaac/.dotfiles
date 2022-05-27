

# Check what kind of operating system/kernel we're running on
# return code is an int-encoded set of binary flags with the following shape:
#
#                  (linux?)(wsl?)(macos?)(known type):
#
# The following are common return codes:
# - unknown: 0 (0000)
# - Linux: 9 (1001)
# - WSL (Ubuntu): 13 (1101)
# - WSL (Unknown Distro): 4 (0100)
# - MacOS: 3 (0011)
export OS_FLAG_WSL=4
export OS_FLAG_LINUX=8
export OS_FLAG_MACOS=2
export OS_FLAG_KNOWN=1
function check_os() { 
    name=$(uname -s) # Get kernel name, equivalent to $(uname) or $(uname --kernel-name)
    name=${name,,}   # Convert to lower case

    # Check if MacOS 
    if [[ ${name} =~ darwin ]] ; then
        return $((OS_FLAG_MACOS | OS_FLAG_KNOWN))
    fi

    result=0
    if [[ ${name} =~ linux ]] ; then
        result=$((result | OS_FLAG_LINUX | OS_FLAG_KNOWN))
    fi

    kernel_release=$(uname -r) # Note that MacOS doesn't support full flag name
    kernel_release=${kernel_release,,} # Convert release name to lower case

    if [[ ${kernel_release} =~ wsl ]] ; then
        result=$((result | OS_FLAG_WSL))
    fi

    return $result
}

check_os
export OS_TYPE=$?

function has_command() {
    command -v "$1" >/dev/null 2>&1
}

export -f has_command
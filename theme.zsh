################################################################################
# Color theme file. Used in ~/.zshrc and ~/.p10k.zsh                           #                  
# Current Theme: Vaporwave                                                     #
#                                                                              #
# Run `colormap` (defined in ./aliases.zsh) to see available colors            #
################################################################################

# Primary Theme Colors
export DONISAAC_THEME_COLOR_PRIMARY_BASE=165               # Vibrant Purple
export DONISAAC_THEME_COLOR_PRIMARY_HIGHLIGHT=207          # Hot Pink
export DONISAAC_THEME_COLOR_PRIMARY_GRAY=97
export DONISAAC_THEME_COLOR_PRIMARY_GREY=97

# Secondary Colors
export DONISAAC_THEME_COLOR_SECONDARY_BASE=51              # Cyan/Aquamarine
export DONISAAC_THEME_COLOR_SECONDARY_HIGHLIGHT=51
export DONISAAC_THEME_COLOR_SECONDARY_GRAY=25              # Faded/Grey cyan
export DONISAAC_THEME_COLOR_SECONDARY_GREY=25              # Faded/Grey cyan

# Status Colors
export DONISAAC_THEME_COLOR_STATUS_INFO=51                 # Cyan
# export DONISAAC_THEME_COLOR_STATUS_SUCCESS=76              # Green
export DONISAAC_THEME_COLOR_STATUS_SUCCESS=${DONISAAC_THEME_COLOR_SECONDARY_HIGHLIGHT}
export DONISAAC_THEME_COLOR_STATUS_WARN=178                # Yellow/Orange
export DONISAAC_THEME_COLOR_STATUS_DANGER=166              # Orange
export DONISAAC_THEME_COLOR_STATUS_ERROR=160               # Red

# Light/Gray/Dark
export DONISAAC_THEME_COLOR_LIGHT=252
export DONISAAC_THEME_COLOR_GRAY=240
export DONISAAC_THEME_COLOR_DARK=017
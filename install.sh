##########################################################################################
#
# Magisk Module Installer Script
#
##########################################################################################
##########################################################################################
#
# Instructions:
#
# 1. Place your files into system folder (delete the placeholder file)
# 2. Fill in your module's info into module.prop
# 3. Configure and implement callbacks in this file
# 4. If you need boot scripts, add them into common/post-fs-data.sh or common/service.sh
# 5. Add your additional or modified system properties into common/system.prop
#
##########################################################################################

##########################################################################################
# Config Flags
##########################################################################################

# Set to true if you do *NOT* want Magisk to mount
# any files for you. Most modules would NOT want
# to set this flag to true
SKIPMOUNT=false

# Set to true if you need to load system.prop
PROPFILE=true

# Set to true if you need post-fs-data script
POSTFSDATA=true

# Set to true if you need late_start service script
LATESTARTSERVICE=true

##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# Check the documentations for more info why you would need this

# Construct your list in the following format
# This is an example
REPLACE_EXAMPLE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

# Construct your own list here
REPLACE="
"

##########################################################################################
#
# Function Callbacks
#
# The following functions will be called by the installation framework.
# You do not have the ability to modify update-binary, the only way you can customize
# installation is through implementing these functions.
#
# When running your callbacks, the installation framework will make sure the Magisk
# internal busybox path is *PREPENDED* to PATH, so all common commands shall exist.
# Also, it will make sure /data, /system, and /vendor is properly mounted.
#
##########################################################################################
##########################################################################################
#
# The installation framework will export some variables and functions.
# You should use these variables and functions for installation.
#
# ! DO NOT use any Magisk internal paths as those are NOT public API.
# ! DO NOT use other functions in util_functions.sh as they are NOT public API.
# ! Non public APIs are not guranteed to maintain compatibility between releases.
#
# Available variables:
#
# MAGISK_VER (string): the version string of current installed Magisk
# MAGISK_VER_CODE (int): the version code of current installed Magisk
# BOOTMODE (bool): true if the module is currently installing in Magisk Manager
# MODPATH (path): the path where your module files should be installed
# TMPDIR (path): a place where you can temporarily store files
# ZIPFILE (path): your module's installation zip
# ARCH (string): the architecture of the device. Value is either arm, arm64, x86, or x64
# IS64BIT (bool): true if $ARCH is either arm64 or x64
# API (int): the API level (Android version) of the device
#
# Availible functions:
#
# ui_print <msg>
#     print <msg> to console
#     Avoid using 'echo' as it will not display in custom recovery's console
#
# abort <msg>
#     print error message <msg> to console and terminate installation
#     Avoid using 'exit' as it will skip the termination cleanup steps
#
# set_perm <target> <owner> <group> <permission> [context]
#     if [context] is empty, it will default to "u:object_r:system_file:s0"
#     this function is a shorthand for the following commands
#       chown owner.group target
#       chmod permission target
#       chcon context target
#
# set_perm_recursive <directory> <owner> <group> <dirpermission> <filepermission> [context]
#     if [context] is empty, it will default to "u:object_r:system_file:s0"
#     for all files in <directory>, it will call:
#       set_perm file owner group filepermission context
#     for all directories in <directory> (including itself), it will call:
#       set_perm dir owner group dirpermission context
#
##########################################################################################
##########################################################################################
# If you need boot scripts, DO NOT use general boot scripts (post-fs-data.d/service.d)
# ONLY use module scripts as it respects the module status (remove/disable) and is
# guaranteed to maintain the same behavior in future Magisk releases.
# Enable boot scripts by setting the flags in the config section above.
##########################################################################################

# Set what you want to display when installing your module

# Copy/extract your module files into $MODPATH in on_install.
# Ready to perform volume keys
# Keycheck binary by someone755 @Github, idea for code below by Zappo @xda-developers
print_modname() {
  ui_print " "
}
on_install() {
  ui_print " 
  
░██████╗██╗░░░██╗██████╗░███████╗██████╗░
██╔════╝██║░░░██║██╔══██╗██╔════╝██╔══██╗
╚█████╗░██║░░░██║██████╔╝█████╗░░██████╔╝
░╚═══██╗██║░░░██║██╔═══╝░██╔══╝░░██╔══██╗
██████╔╝╚██████╔╝██║░░░░░███████╗██║░░██║
╚═════╝░░╚═════╝░╚═╝░░░░░╚══════╝╚═╝░░╚═╝



███████╗░█████╗░░██████╗████████╗
██╔════╝██╔══██╗██╔════╝╚══██╔══╝
█████╗░░███████║╚█████╗░░░░██║░░░
██╔══╝░░██╔══██║░╚═══██╗░░░██║░░░
██║░░░░░██║░░██║██████╔╝░░░██║░░░
╚═╝░░░░░╚═╝░░╚═╝╚═════╝░░░░╚═╝░░░



░█████╗░██╗░░██╗░█████╗░██████╗░░██████╗░███████╗
██╔══██╗██║░░██║██╔══██╗██╔══██╗██╔════╝░██╔════╝
██║░░╚═╝███████║███████║██████╔╝██║░░██╗░█████╗░░
██║░░██╗██╔══██║██╔══██║██╔══██╗██║░░╚██╗██╔══╝░░
╚█████╔╝██║░░██║██║░░██║██║░░██║╚██████╔╝███████╗
░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝░╚═════╝░╚══════╝ "
ui_print " "

ui_print "𝖲𝗎𝗉𝖾𝗋 𝖥𝖺𝗌𝗍 𝖢𝗁𝖺𝗋𝗀𝖾 By 🇹🇷 OXEALOT 🇹🇷 YT "
sleep 5
  ui_print "- MODÜL DOSYALARI AYRIŞTIRILIYOR"
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
  unzip -o "$ZIPFILE" 'addon/*' -d $TMPDIR >&2
  nth=$MODPATH/system/etc/.nth_fc/.fc_main.sh
  module=$TMPDIR/module.prop
  . $TMPDIR/addon/Volume-Key-Selector/preinstall.sh
  
  ui_print "- 🔥 𝖲𝗎𝗉𝖾𝗋 𝖥𝖺𝗌𝗍 𝖢𝗁𝖺𝗋𝗀𝖾 🔥 "
  
  ui_print "   "
ui_print "  [SES+] AŞAĞI ; [SES-] YÜKLE"
ui_print " BATARYA MAH DEĞERİNİ SEÇ "
sleep 5
ui_print "   1. ⚡2670mA / 16W⚡"
ui_print "   2. ⚡3000mA / 18W⚡"
ui_print "   3. ⚡3500mA / 21W⚡"
ui_print "   4. ⚡4000mA / 24W⚡"
ui_print "   5. ⚡4500mA / 25.6W⚡"
ui_print "   6. ⚡5000mA / 27W⚡"
ui_print "   7. ⚡6000mA / 30W⚡"
ui_print "   "
ui_print "  SEÇİLDİ:"
FC=1
while true; do
	ui_print "  $FC"
	if $VKSEL; then
		FC=$((FC + 1))
	else 
		break
	fi
	if [ $FC -gt 7 ]; then
		FC=1
	fi
done
ui_print "   "
ui_print "  SEÇİLDİ: $FC"
#
case $FC in
	1 ) FASTCHARGEMODE="2670";;
	2 ) FASTCHARGEMODE="3000";;
	3 ) FASTCHARGEMODE="3500";;
	4 ) FASTCHARGEMODE="4000";;
	5 ) FASTCHARGEMODE="4500";;
	6 ) FASTCHARGEMODE="5000";;
	7 ) FASTCHARGEMODE="6000";;
esac

ui_print "   "
ui_print "  HIZLI ŞARJ: $FASTCHARGEMODE MAH "
ui_print "   "
  sed -i "s/<PROFILE>/${FASTCHARGEMODE}/g" $nth
  
  #sed -i "s/${FCMODE}/${FASTCHARGEMODE}/g" $nth
  #sed -i "/version=/c version=${FCTEXT}+V1" $module
  #sed -i "/description=/c description=${TEXT}${TEXT1}" $module
ui_print "#######################################"
ui_print " "
ui_print " --> SUPER FAST CHARGE KURULDU !"
ui_print " "
ui_print "#######################################"
  }


# Only some special files require specific permissions
# This function will be called after on_install is done
# The default permissions should be good enough for most cases

set_permissions() {
  # The following is the default rule, DO NOT remove
  set_perm_recursive $MODPATH 0 0 0755 0644
  set_perm $MODPATH/service.sh 0 0 0777
  set_perm $MODPATH/system/etc/.nth_fc/SFC.sh 0 0 0777
  
}

# You can add more functions to assist your custom script code

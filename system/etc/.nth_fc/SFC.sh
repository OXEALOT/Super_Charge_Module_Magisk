#!/system/bin/sh
#Fast Charge
#Yapan: OXEALOT
Set_value()
{
    if [[ -f "$2" ]];
    then
        chmod 0666 "$2"
        echo "$1" > "$2"
        chmod 0444 "$2"
    fi
}
Fast_charge() {
paths=`ls /sys/class/power_supply/*/$1`
for path in $paths
    do
    Set_value $FC $path
done

}
FAST_CHARGE=<PROFILE>
FAST_CHARGE1=`expr $FAST_CHARGE + 1000`
FC=`expr $FAST_CHARGE \* 1000`
FCC=`expr $FAST_CHARGE1 \* 1000`
CF=`expr 4000 \* 1000`
BMS=/sys/devices/soc/800f000.qcom,spmi/spmi-0/spmi0-00/800f000.qcom,spmi:qcom,pm660@0:qpnp,fg/power_supply/bms

while true; do
Set_value '1' /sys/kernel/fast_charge/force_fast_charge
Set_value '1' /sys/class/power_supply/battery/system_temp_level
Set_value '1' /sys/kernel/fast_charge/failsafe
Set_value '1' /sys/class/power_supply/battery/allow_hvdcp3
Set_value '1' /sys/class/power_supply/usb/pd_allowed
Set_value '1' /sys/class/power_supply/battery/subsystem/usb/pd_allowed
Set_value '0' /sys/class/power_supply/battery/input_current_limited
Set_value '1' /sys/class/power_supply/battery/input_current_settled
Set_value '0' /sys/class/qcom-battery/restricted_charging
Set_value '150' /sys/class/power_supply/bms/temp_cool
Set_value '480' /sys/class/power_supply/bms/temp_hot
Set_value '450' /sys/class/power_supply/bms/temp_warm


Set_value '0' /sys/class/qcom-battery/restrict_chg

Set_value $FCC /sys/class/qcom-battery/restricted_current
Set_value $FCC /sys/class/qcom-battery/restrict_cur

Fast_charge current_max
Fast_charge hw_current_max
Fast_charge pd_current_max
Fast_charge ctm_current_max
Fast_charge sdp_current_max
Fast_charge constant_charge_current_max

sleep 5
chmod 777 /sys/class/power_supply/*/*
chmod 777 /sys/module/qpnp_smbcharger/*/*
chmod 777 /sys/module/dwc3_msm/*/*
chmod 777 /sys/module/phy_msm_usb/*/*
while true; do
echo '1' > /sys/kernel/fast_charge/force_fast_charge
echo '1' > /sys/class/power_supply/battery/system_temp_level
echo '1' > /sys/kernel/fast_charge/failsafe
echo '1' > /sys/class/power_supply/battery/allow_hvdcp3
echo '1' > /sys/class/power_supply/usb/pd_allowed
echo '1' > /sys/class/power_supply/battery/subsystem/usb/pd_allowed
echo '0' > /sys/class/power_supply/battery/input_current_limited
echo '1' > /sys/class/power_supply/battery/input_current_settled
echo '0' > /sys/class/qcom-battery/restricted_charging
echo '150' > /sys/class/power_supply/bms/temp_cool
echo '450' > /sys/class/power_supply/bms/temp_hot
echo '450' > /sys/class/power_supply/bms/temp_warm
echo '2450000' > /sys/class/power_supply/usb/current_max
echo '2450000' > /sys/class/power_supply/usb/hw_current_max
echo '2450000' > /sys/class/power_supply/usb/pd_current_max
echo '2450000' > /sys/class/power_supply/usb/ctm_current_max
echo '2450000' > /sys/class/power_supply/usb/sdp_current_max
echo '2450000' > /sys/class/power_supply/main/current_max
echo '2450000' > /sys/class/power_supply/main/constant_charge_current_max
echo '2450000' > /sys/class/power_supply/battery/current_max
echo '2450000' > /sys/class/power_supply/battery/constant_charge_current_max
echo '4500000' > /sys/class/qcom-battery/restricted_current
echo '2450000' > /sys/class/power_supply/pc_port/current_max
echo '2450000' > /sys/class/power_supply/constant_charge_current__max
sleep 1
done


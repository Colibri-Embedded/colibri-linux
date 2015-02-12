source $1/colors.sh

msg_info()
{
    echo -e "${On_Blue}${BWhite}$@ ${Color_Off}"
}

msg_warning()
{
    echo -e "${On_Yelow}${BWhite}$@ ${Color_Off}"
}

msg_error()
{
    echo -e "${On_Red}${BWhite}$@ ${Color_Off}"
}

msg_success()
{
    echo -e "${On_Green}${BWhite}$@ ${Color_Off}"
}

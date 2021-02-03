#!/bin/sh
# DavydovMA 2013040600 {
SOFT_FILE="tosedi_toolcheck.sh"
SOFT_NAME="sh.tosedi_toolcheck"
SOFT_VERSION="20.01"
SOFT_COPYRIGHT="Copyright (C) 1990-2020"
SOFT_AUTHOR="DavydovMA"
SOFT_URL="http://domain"
SOFT_EMAIL="dev-sh@domain"
#
# CODEPAGE: ru_RU.UTF-8
# sh.tosedi
# - набор shell скриптов.
# sh.tosedi_toolcheck
# - скрипт, проверяет наличие необходимых инструментов.


#################################
# ERROR*                        #
#
errno="0"			# return error code
# tool_sh
err_200="200"			# tool [id] need [root] user
err_201="201"			# tool [mkdir] not found
err_202="202"			# tool [mkdir] bug OR backup dir not create
#err_202="202"                   # tool [tar] file not read
err_209="209"			# [dev] not found OR not block
# tool_xxd
err_210="210"			# tool [xxd] not found
err_211="211"			# tool [xxd] bug OR dev bad signatue [0xAA55]
err_212="212"			# tool [xxd] bug OR dev bad ostype [0xEE | 0xEF]
# tool_sgdisk
err_220="220"			# tool [sgdisk] not found
err_221="221"			# tool [sqdisk] bug OR sector size not founs"
err_222="222"			# tool [sgdisk] bug OR lba begin not found
err_223="223"			# tool [sgdisk] bug OR lba end not found
err_224="224"			# tool [sgdisk] bug OR lba maximum not found
err_225="225"			# tool [sgdisk] bug OR lba free begin not found
# tool_dd
err_230="230"			# tool [dd] not found
err_231="231"			# tool [dd] bug OR GPT-1 not backup OR not shred
err_232="232"			# tool [dd] bug OR GPT-2 not backup OR not shred
err_234="234"			# tool [dd] bug OR backup write failed
# tool_tar
err_240="240"			# tool [tar] not found
err_241="241"			# tool [tar] bug OR file create failed
err_242="242"			# tool [tar] bug OR file not read
err_243="243"			# tool [tar] bug OR file not exctract
# tool_basename
err_250="250"			# tool [basename] not found
err_251="251"			# tool [basename] bug OR file name bug
# tool_cut
err_260="260"			# tool [cut] not found
# tool_expr
err_270="270"			# tool [expr] not found
# tool_sync
err_280="280"			# tool [sync] not found
err_281="281"			# tool [sync] bug OR sync failed
# part_sgdisk_*
err_320="320"			# tool [sgdisk] bug OR partition lba not found
# part_dd_*
err_330="330"			# tool [dd] bug OR partition not backup OR not shred
# part_cut_*
err_360="360"			# tool [cut] bug OR file name bug
#
#########################################
# Function: func_copy {                 #
#
func_copy(){
	echo ""
	echo "${SOFT_NAME} version ${SOFT_VERSION}, ${SOFT_COPYRIGHT} Free Software ${SOFT_AUTHOR}, Inc"
	echo "URL\t: ${SOFT_URL}"
	echo "e-mail\t: ${SOFT_EMAIL}"
	echo ""
}
#
# } Function: func_copy                 #
#########################################
#
#########################################
# Function: func_help {                 #
#
func_help(){
	echo ""
	echo "Usage:\t${0} [--help]"
	echo "Options:"
	echo "\t--help\t\t: this is help"
	echo "Error Code:"
	echo "\t${err_200}\t\t: tool [id] need [root] user"
	echo "\t${err_201}\t\t: tool [mkdir] not found"
	echo "\t${err_202}\t\t: tool [mkdir] bug OR backup dir not create"
	echo "\t${err_209}\t\t: [dev] not found OR not block"
	echo "\t${err_210}\t\t: tool [xxd] not found"
	echo "\t${err_211}\t\t: tool [xxd] OR dev bad signature [0xAA55]"
	echo "\t${err_212}\t\t: tool [xxd] OR dev bad ostype [0xEE | 0xEF]"
	echo "\t${err_220}\t\t: tool [sgdisk] not found"
	echo "\t${err_221}\t\t: tool [sqdisk] bug OR sector size bad"
	echo "\t${err_222}\t\t: tool [sgdisk] bug OR lba begin not found"
	echo "\t${err_223}\t\t: tool [sgdisk] bug OR lba end not found"
	echo "\t${err_224}\t\t: tool [sgdisk] bug OR lba maximum not found"
	echo "\t${err_225}\t\t: tool [sgdisk] bug OR lba free begin not found"
	echo "\t${err_230}\t\t: tool [dd] not found"
	echo "\t${err_231}\t\t: tool [dd] bug OR GPT-1 not backup OR not shred"
	echo "\t${err_232}\t\t: tool [dd] bug OR GPT-2 not backup OR not shred"
	echo "\t${err_234}\t\t: tool [dd] bug OR backup write failed"
	echo "\t${err_240}\t\t: tool [tar] not found"
	echo "\t${err_241}\t\t: tool [tar] bug OR file create failed"
	echo "\t${err_242}\t\t: tool [tar] bug OR file not read"
	echo "\t${err_243}\t\t: tool [tar] bug OR file not exctract"
	echo "\t${err_250}\t\t: tool [basename] not found"
	echo "\t${err_251}\t\t: tool [basename] bug OR file name bug"
	echo "\t${err_260}\t\t: tool [cut] not found"
	echo "\t${err_270}\t\t: tool [expr] not found"
	echo "\t${err_280}\t\t: tool [sync] not found"
	echo "\t${err_281}\t\t: tool [sync] bug OR sync failed"
	echo "\t${err_320}-*\t\t: tool [sgdisk] bug OR partition lba not found"
	echo "\t${err_330}-*\t\t: tool [dd] bug OR partition not backup OR not shred"
	echo "\t${err_360}-*\t\t: tool [dut] bug OR file name bug"
	echo ""
}
#
# } Function: func_help                 #
#########################################
#
func_copy
if  test "${1}" = "--help"  ; then
	func_help
	exit
fi
#
echo "------------- ---- ------{"

# tool id
echo "------------- ---- ------"
	tool_id=`id -u`
if test "${tool_id}" = "0" ;
then	# tool_id {
	echo	"id		: [root]"
	tool_mkdir=`mkdir --version 2> /dev/null`
if test "${?}" = "0" ;
then	# tool_mkdir {
	echo	"mkdir		: [Ok]"
	tool_xxd=`xxd --version 2> /dev/null`
if test "${?}" = "0" ;
then	# tool_xxd {
	echo	"xxd		: [Ok]"
	tool_sgdisk=`sgdisk --version 2> /dev/null`
if test "${?}" = "0" ;
then	# tool_sgdisk {
	echo	"sgdisk		: [Ok]"
	tool_dd=`dd --version 2> /dev/null`
if test "${?}" = "0" ;
then	# tool_dd {
	echo	"dd		: [Ok]"
	tool_tar=`tar --version 2> /dev/null`
if test "${?}" = "0" ;
then	# tool_tar {
	echo	"tar		: [Ok]"
	tool_basename=`basename --version 2> /dev/null`
if test "${?}" = "0" ;
then	# tool_basename {
	echo	"basename	: [Ok]"
	tool_cut=`cut --version 2> /dev/null`
if test "${?}" = "0" ;
then	# tool_cut {
	echo	"cut		: [Ok]"
	tool_expr=`expr --version 2> /dev/null`
if test "${?}" = "0" ;
then	# tool_expr {
	echo	"expr		: [Ok]"
	tool_sync=`expr --version 2> /dev/null`
if test "${?}" = "0" ;
then	# tool_sync {
	echo	"sync		: [Ok]"
# >>>
	echo	"check		: [end]"
# <<<
else	# : tool_sync
	errno="${err_280}"
fi	# } tool_sync
else	# : tool_expr
	errno="${err_270}"
fi	# } tool_expr
else	# : tool_cut
	errno="${err_260}"
fi	# } tool_cut
else	# : tool_basename
	errno="${err_250}"
fi	# } tool_basename
else	# : tool_tar
	errno="${err_240}"
fi	# } tool_tar
else	# : tool_dd
	errno="${err_230}"
fi	# } tool_dd
else	# : tool_sgdisk
	errno="${err_220}"
fi	# } tool_sgdisk
else	# : tool_xxd
	errno="${err_210}"
fi	# } tool_xxd
else	# : tool_mkdir
	errno="${err_201}"
fi	# } tool_mkdir
else	# : tool_id
	errno="${err_200}"
fi	# } tool_id

# ------------- ---- ------
# exit.error {
echo "------------- ---- ------"
if test "${errno}" = "0" ;
then
	echo "tools [all]	: [OK]"
else
	echo	"ERROR		: [${errno}]"
	func_help
	echo	"ERROR		: [${errno}]"
	echo	"WARNING!"
fi

echo "}------------- ---- ------"
	return ${errno}


# } DavydovMA 2020012200
#
# ------------- ---- ------
#
# Copyright (C) 1990-2020 Free Software DavydovMA
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
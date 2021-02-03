#!/bin/sh
# DavydovMA 2013040600 {
SOFT_FILE="tosedi_unused_clear.sh"
SOFT_NAME="sh.tosedi_unused_clear"
SOFT_VERSION="20.01"
SOFT_COPYRIGHT="Copyright (C) 1990-2020"
SOFT_AUTHOR="DavydovMA"
SOFT_URL="http://domain"
SOFT_EMAIL="dev-sh@domain"
#
# CODEPAGE: ru_RU.UTF-8
# sh.tosedi
# - набор shell скриптов.
# sh.tosedi_unused_clear
# - скрипт, обнуляет на диске GPT: неиспользуемое пространство.
#   Ну да, иногда оно имеет место быть, при определенном разбиении диска.
#   Чтобы поменьше ручками и не вспоминать каждый раз по новой.
#   В cli укажи путь к блочному устройству.
#   Для тестов ручками можно убрать нужные проверки - это же обыкновенный скриптик.


#########################################################
# Preset                                                #
#
sh_toolcheck="./tosedi_toolcheck.sh"			# sh for tool check
dump_disk="${1}"					# device from cli
disk_name=`basename ${dump_disk}`			# basename disk for file
dump_size="4096"					# minimal size of dump; see header of partition
from_dev="/dev/zero"
#
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
	echo "Usage:\t${0} [--help] | <device> [--yes]"
	echo "Options:"
	echo "\t--help\t\t: this is help"
	echo "\tdevice\t\t: block device"
	echo "\t--yes\t\t: YES from cli"
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


echo "------------- ---- ------"
	echo	"tool check	: [${sh_toolcheck}]"
	tool_check=`${sh_toolcheck}`
	err_ret="${?}"
if test "${err_ret}" = "0" ;
then	# check_tool {
	echo	"tool check	: [OK]"
echo "------------- ---- ------"
	echo	"dev check	: [${dump_disk}]"
if test -n "${dump_disk}" -a -b ${dump_disk} ;
then	# check_dev
	echo	"dev type	: [is block]"
# ! sgdisk -v not return error code !
	disk_sig=`xxd -g 1 -u -seek 510 -l 2 ${dump_disk} | cut -d " " -f -3`	# 000001fe: 55 AA | Signature: The Signature must be 0xaa55.
	err_ret="${?}"
	echo	"dev sig		: [${disk_sig}]"
if test "${disk_sig}" = "000001fe: 55 AA" ;
then	# check_sig
	disk_tos=`xxd -g 1 -u -seek 450 -l 1 ${dump_disk} | cut -d " " -f -2`	# 000001c2: EE | OSType: 0xEE (i.e., GPT Protective) is used by a protective MBR (see 5.2.2) to define a fake partition covering the entire disk. # 000001c2: EF | OSType: 0xEF (i.e., UEFI System Partition) defines a UEFI system partition.
	err_ret="${?}"
	echo	"dev ostype	: [${disk_tos}]"
# ! sgdisk -v not return error code !
if test "${disk_tos}" = "000001c2: EE" -o "${disk_tos}" = "000001c2: EF" ;
then	# check_ostype {
	size_sect=`sgdisk -p ${dump_disk} | grep -i "Sector size" | cut -d':' -f 2 | cut -d" " -f 2 | cut -d"/" -f 1 | tr -d " "`
	err_ret="${?}"
if test "${err_ret}" = "0" ;
then	# dev_sect_size {
	echo	"sector size	: [${size_sect}]"
	lba_beg=`sgdisk -p ${dump_disk} | grep -i "First usable sector is" | cut -d',' -f 1 | cut -d" " -f 5`
	err_ret="${?}"
if test "${err_ret}" = "0" ;
then	# lba_beg {
	echo	"lba begin	: [${lba_beg}]"
	lba_end=`sgdisk -p ${dump_disk} | grep -i "First usable sector is" | cut -d',' -f 2 | cut -d" " -f 6`
	err_ret="${?}"
if test "${err_ret}" = "0" ;
then	# lba_end {
	echo	"lba end		: [${lba_end}]"
	lba_max=`sgdisk -p ${dump_disk} | head -n 1 | grep -i "Disk" | cut -d" " -f 3`
	err_ret="${?}"
if test "${err_ret}" = "0" ;
then	# lba_max {
	echo	"lba maximum	: [${lba_max}]"
echo "------------- ---- ------"
	echo	"dev		: [${dump_disk}]"
	lba_free=`sgdisk -p ${dump_disk} | grep -i "Main partition table begins" | cut -d' ' -f 12 | cut -d" " -f 1`
	lba_fbeg=`expr ${lba_free} + 1`
	err_ret="${?}"
if test "${err_ret}" = "0" ;
then	# lba_fbeg {
	echo	"lba free begin	: [${lba_fbeg}]"
	lba_fsize=`expr ${lba_beg} - ${lba_fbeg}`
	err_ret="${?}"
if test "${err_ret}" = "0" ;
then	# lba_fsize {
	echo	"lba free size	: [${lba_fsize}]"
	echo	"from		: [${from_dev}]"
	echo	"WARNING!	: SHRED FREE UNUSED (YES/NO)"
if  test "${2}" = "--yes"  ;
then	# --yes {
	read_yesno="YES"
else	# : --yes
	read read_yesno
fi	# } --yes
if test "${read_yesno}" = "YES" ;
then	# read_yesno {
	echo	"SHRED		: [YES]"
	dd if=${from_dev} of=${dump_disk} seek=${lba_fbeg} bs=${size_sect} count=${lba_fsize} status=progress
	err_ret="${?}"
if test "${err_ret}" = "0" ;
then	# dd_shred {
	echo	"shred		: [OK]"
else	# : dd_shred
	errno=`expr ${err_330}`
	echo	"shred ERROR	: [${errno}]"
fi	# } dd_shred
echo "------------- ---- ------"
	echo	"sync all	: [${dump_disk}]"
	sync ${dump_disk}
	err_ret="${?}"
if test "${err_ret}" = "0" ;
then	# sync {
	echo	"sync all	: [OK]"
else	# : sync
	errno="${err_281}"
	echo	"sync ERROR	: [${errno}]"
fi	# } sync
else	# : read_yesno
	echo	"shred		: [NO]"
fi	# } read_yesno
else	# : lba_fsize
	errno="${err_FIXME}"
fi	# } lba_fsize
else	# : lba_fbeg
	errno="${err_225}"
fi	# } lba_fbeg
else	# : lba_max
	errno="${err_224}"
fi	# } lba_max
else	# : lba_end
	errno="${err_223}"
fi	# } lba_end
else	# : lba_beg
	errno="${err_222}"
fi	# } lba_beg
else	# : dev_sect_size
	errno="${err_221}"
fi	# } dev_sect_size
else	# : check_ostype
	errno="${err_212}"
fi	# } check_ostype
else	# : check_sig
	errno="${err_211}"
fi	# } check_sig
else	# : check_dev
	errno="${err_209}"
fi	# } check_dev
else	# : check_tool
	errno="${err_ret}"
fi	# } check_tool

echo "------------- ---- ------"
if test "${errno}" = "0" ;
then
	echo	"Oll Korrect:	: [o_O]"
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
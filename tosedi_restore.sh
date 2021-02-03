#!/bin/sh
# DavydovMA 2013040600 {
SOFT_FILE="tosedi_restore.sh"
SOFT_NAME="sh.tosedi_restore"
SOFT_VERSION="20.01"
SOFT_COPYRIGHT="Copyright (C) 1990-2020"
SOFT_AUTHOR="DavydovMA"
SOFT_URL="http://domain"
SOFT_EMAIL="dev-sh@domain"
#
# CODEPAGE: ru_RU.UTF-8
# sh.tosedi
# - набор shell скриптов.
# sh.tosedi_restore
# - скрипт, восстанавливает из резервной копии для диска GPT: заголовки, таблицы и т.д..
#   Чтобы поменьше ручками и не вспоминать каждый раз по новой.
#   В cli укажи путь к файлу резервной копии.
#   Для тестов ручками можно убрать нужные проверки - это же скриптик.


#########################################################
# Preset                                                #
#
sh_toolcheck="./tosedi_toolcheck.sh"			# sh for tool check
tar_file="${1}"
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
err_330="330"			# tool [dd] bug OR partition not backup
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
	echo "Usage:\t${0} [--help] | tarfile"
	echo "Options:"
	echo "\t--help\t\t: this is help"
	echo "\ttarfile\t\t: backup tarfile [tar.gz]"
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

echo "------------- ---- ------"
	echo	"tool check	: [${sh_toolcheck}]"
	tool_check=`${sh_toolcheck}`
	err_ret="${?}"
if test "${err_ret}" = "0" ;
then	# check_tool {
	echo	"tool check	: [OK]"
echo "------------- ---- ------"
	echo	"tar read	: [${tar_file}]"
if test -n "${tar_file}" -a -r "${tar_file}" ;
then	# tar_read
	echo	"tar exctract	: [${tar_file}]"
	tar -xvf ${tar_file} --overwrite --one-top-level
	err_ret="${?}"
if test "${err_ret}" = "0" ;
then	# tar_extract {
echo "------------- ---- ------"
	dump_dir=`basename -s .tar.gz ${tar_file}`
if test -n "${dump_dir}" ;
then	# basename_dump_dir {
	dump_dir="./${dump_dir}"
	echo	"source dir	: [${dump_dir}]"
	dump_count=`ls -1 ${dump_dir} | wc -l`
	echo 	"Dump count	: [*] [${dump_count}]"
	dump_index="0"
for dump_src in ` ls -1 ${dump_dir}` ;
do	# dump_dir_loop {
echo "------------- ---- ------"
	echo	"Dump		: [${dump_index}]"
	echo	"Dump found	: [${dump_src}]"
	dump_dev=` echo ${dump_src} | cut -d "_" -f 3 | cut -d "_" -f 1`
	dump_beg=` echo ${dump_src} | cut -d "_" -f 7 | cut -d "_" -f 1`
	dump_size=`echo ${dump_src} | cut -d "_" -f 9 | cut -d "." -f 1`
	echo	"Dump device	: [${dump_dev}]"
	echo	"Dump begin	: [${dump_beg}]"
	echo "dump size	: [${dump_size}]"
if test -n "${dump_dev}" -a -n "${dump_beg}" -a -n "${dump_size}" ;
then	# dump_src {
	echo	"DUMP		: RESTORE (YES/NO) ?"
	read read_yesno
if test "${read_yesno}" = "YES" ;
then	# dd_yesno {
	echo	"DUMP WRITE	: [YES]"
	dump_disk="/dev/${dump_dev}"
	echo	"check dev	: [${dump_disk}]"
if test -n "${dump_disk}" -a -b "${dump_disk}" ;
then	# check_dev
	echo	"check dev	: [is block]"
	dd if=${dump_dir}/${dump_src} of=${dump_disk} seek=${dump_beg} status=progress
	err_ret="${?}"
if test "${err_ret}" = "0" ;
then	# dd_write {
	echo	"sync write	: [${dump_disk}]"
	sync ${dump_disk}
	err_ret="${?}"
if test "${err_ret}" = "0" ;
then	# sync {
	echo	"sync dump	: [OK]"
else	# : sync
	errno="${err_281}"
	echo	"sync ERROR	: [${errno}]"
fi	# } sync
else	# : dd_write
	errno="${err_234}"
	echo	"dd ERROR	: [${errno}]"
fi	# } dd_write
else	# : check_dev
	errno="${err_209}"
	echo	"dd ERROR	: [${errno}]"
fi	# } check_dev
else	# : dd_yesno
	echo	"dump skip	: [NO]"
fi	# } dd_yesno
else	# : dump_src
	errno=` expr ${err_360} + ${dump_index}`
	echo	"dump ERROR	: [${errno}]"
fi	# } dump_src
	dump_index=`expr ${dump_index} + 1`
done	# } dump_dir_loop
else	# : basename_dump_dir
	errno="${err_251}"
fi	# } basename_dump_dir
else	# : tar_extract
	errno="${err_243}"
fi	# } tar_extract
else	# : tar_read
	errno="${err_242}"
fi	# } tar_read
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
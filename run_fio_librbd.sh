#!/bin/bash
set -x

#SHELL_FOLDER=$(dirname "$0")
#source ${SHELL_FOLDER}/common_variable_librbd

IOENGINE="rbd"

POOL_NAME="yujiang_metadata"
RBD_NAME="iscsirbdisa"

RW=(randwrite randread)
BS=(4k 8k 16k 256k 512k 1m)

NUMJOBS=1
DIRECT=1
SIZE="1024g"
IODEPTH=1024
RUNTIME=600

for rw_name in ${RW[@]}
do
  for bs_size in ${BS[@]}
  do
    ansible-playbook -i inventory/hosts -e @config.yml site.yml -vv
    fio -ioengine=${IOENGINE} -pool=${POOL_NAME} -rbdname=${RBD_NAME} -numjobs=${NUMJOBS} -direct=${DIRECT} -size=${SIZE} -iodepth=${IODEPTH} -runtime=${RUNTIME} -rw=${rw_name} -ba=${bs_size} -bs=${bs_size} -name="librbd_${IOENGINE}_${IODEPTH}_${rw_name}_${bs_size}" > librbd_${IOENGINE}_${IODEPTH}_${rw_name}_${bs_size}.log
  done
done


#!/bin/bash
set -x

NUMJOBS=1
DIRECT=1
SIZE="1024g"
IODEPTH=1024
RUNTIME=600
FILE_NAME="/dev/mapper/mpatha"

SHELL_FOLDER=$(dirname "$0")
source ${SHELL_FOLDER}/common_variable_iscsi

RW=(randwrite randread)
BS=(4k 8k 512k 1m)

for rw_name in ${RW[@]}
do
  for bs_size in ${BS[@]}
  do
    ansible-playbook -i inventory/hosts -e @config.yml site.yml -vv
    fio -ioengine=${IOENGINE} -numjobs=${NUMJOBS} -direct=${DIRECT} -size=${SIZE} -iodepth=${IODEPTH} -runtime=${RUNTIME} -rw=${rw_name} -ba=${bs_size} -bs=${bs_size} -filename=${FILE_NAME} -name="${IOENGINE}_${IODEPTH}_${rw_name}_${bs_size}" > iscsi_${IOENGINE}_${IODEPTH}_${rw_name}_${bs_size}.log
  done
done


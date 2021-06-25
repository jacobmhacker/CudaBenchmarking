#!/bin/bash

while getopts n:r:p:g: flag
do
	case "${flag}" in
		n) num_vals=${OPTARG};;
		r) num_runs=${OPTARG};;
		p) num_posix_threads=${OPTARG};;
		g) num_gpu_threads=${OPTARG};;
	esac
done

echo "Num vals: $num_vals";
echo "Num runs: $num_runs";
echo "Num Posix threads: $num_posix_threads";
echo "Num GPU threads: $num_gpu_threads";

temp_folder="tmp"
data_folder="data"
data_file_prefix="n${num_vals}_r${num_runs}_p${num_posix_threads}_g${num_gpu_threads}"
output_file="${data_file_prefix}_$(date +%s)_out"

if [ ! -d "${temp_folder}" ]
then
	mkdir $temp_folder
fi

for r_i in $(seq $num_runs)
do
	rand_data_file="${data_file_prefix}_$(date +%s)_${r_i}"

	echo $num_vals >> ${temp_folder}/${rand_data_file}
	echo $num_posix_threads >> ${temp_folder}/${rand_data_file}
	echo $num_gpu_threads >> ${temp_folder}/${rand_data_file}
	for n_i in $(seq $num_vals)
	do
		echo $RANDOM >> ${temp_folder}/${rand_data_file}
	done

	./bin/linear < ${temp_folder}/${rand_data_file} >> ${output_file}
done

rm -rf ${temp_folder}

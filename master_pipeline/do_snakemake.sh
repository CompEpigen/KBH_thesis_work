#!/bin/bash

#Package precheck
PKG_LIST=("samtools" "conda" "minimap2" "f5c")

for package in "${PKG_LIST[@]}"
do 
   $package --version >/dev/null
   if [ $? -eq 0 ]; then
       echo $package loaded
   else
       echo $package not found. Possible reasons include; not loaded, not installed, or not on PATH.
   fi
done

#Executing pipeline
cluster_script="bsub {params.misc} -n {params.slots} -W {params.runtime} -M {params.memusage}  -R \"rusage[mem={params.memusage}]\" -o .snakemake/logs/{params.jobname}.log -e .snakemake/logs/{params.jobname}.err"
snakemake -k --cluster "$cluster_script" --jobs 20 --latency-wait 120 $@
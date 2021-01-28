#!/bin/sh
# properties = {"type": "single", "rule": "ngmlr_align", "local": false, "input": ["GCF_000001405.26_GRCh38_genomic.fna", "data/FAB45271-152889212_Multi_SQK-LSK108_WA01.merged.fq"], "output": ["output/mapped/FAB45271-152889212_Multi_SQK-LSK108_WA01.sorted.bam"], "wildcards": {"sample": "FAB45271-152889212_Multi_SQK-LSK108_WA01"}, "params": {"jobname": "index_reads", "runtime": "16:00", "memusage": "20000", "slots": "15", "misc": " "}, "log": [], "threads": 1, "resources": {}, "jobid": 46, "cluster": {}}
 cd /icgc/dkfzlsdf/analysis/C010/brooks/meth_calling_pipeline && \
/home/k001y/.conda/envs/pycometh/bin/python \
-m snakemake output/mapped/FAB45271-152889212_Multi_SQK-LSK108_WA01.sorted.bam --snakefile /icgc/dkfzlsdf/analysis/C010/brooks/meth_calling_pipeline/Snakefile \
--force -j --keep-target-files --keep-remote \
--wait-for-files /icgc/dkfzlsdf/analysis/C010/brooks/meth_calling_pipeline/.snakemake/tmp.h79vlaal GCF_000001405.26_GRCh38_genomic.fna data/FAB45271-152889212_Multi_SQK-LSK108_WA01.merged.fq --latency-wait 120 \
 --attempt 1 --force-use-threads \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules ngmlr_align --nocolor --notemp --no-hooks --nolock \
--mode 2  && touch /icgc/dkfzlsdf/analysis/C010/brooks/meth_calling_pipeline/.snakemake/tmp.h79vlaal/46.jobfinished || (touch /icgc/dkfzlsdf/analysis/C010/brooks/meth_calling_pipeline/.snakemake/tmp.h79vlaal/46.jobfailed; exit 1)


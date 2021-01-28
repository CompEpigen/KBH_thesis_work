#!/bin/sh
# properties = {"type": "single", "rule": "call_meth", "local": false, "input": ["output/mapped/FAB45277-86567043_Multi_SQK-LSK108_WA01.sorted.bam", "output/mapped/FAB45277-86567043_Multi_SQK-LSK108_WA01.sorted.bam.bai", "GCF_000001405.26_GRCh38_genomic.fna", "data/FAB45277-86567043_Multi_SQK-LSK108_WA01.merged.fq", "data/FAB45277-86567043_Multi_SQK-LSK108_WA01.merged.fq.index", "data/FAB45277-86567043_Multi_SQK-LSK108_WA01.merged.fq.index.fai", "data/FAB45277-86567043_Multi_SQK-LSK108_WA01.merged.fq.index.gzi", "data/FAB45277-86567043_Multi_SQK-LSK108_WA01.merged.fq.index.readdb"], "output": ["output/meth/FAB45277-86567043_Multi_SQK-LSK108_WA01.meth_calls.tsv"], "wildcards": {"sample": "FAB45277-86567043_Multi_SQK-LSK108_WA01"}, "params": {"jobname": "call_meth", "runtime": "24:00", "memusage": "10000", "slots": "10", "misc": " "}, "log": [], "threads": 1, "resources": {}, "jobid": 85, "cluster": {}}
 cd /icgc/dkfzlsdf/analysis/C010/brooks/meth_calling_pipeline && \
/home/k001y/.conda/envs/pycometh/bin/python \
-m snakemake output/meth/FAB45277-86567043_Multi_SQK-LSK108_WA01.meth_calls.tsv --snakefile /icgc/dkfzlsdf/analysis/C010/brooks/meth_calling_pipeline/Snakefile \
--force -j --keep-target-files --keep-remote \
--wait-for-files /icgc/dkfzlsdf/analysis/C010/brooks/meth_calling_pipeline/.snakemake/tmp.vrjism4n output/mapped/FAB45277-86567043_Multi_SQK-LSK108_WA01.sorted.bam output/mapped/FAB45277-86567043_Multi_SQK-LSK108_WA01.sorted.bam.bai GCF_000001405.26_GRCh38_genomic.fna data/FAB45277-86567043_Multi_SQK-LSK108_WA01.merged.fq data/FAB45277-86567043_Multi_SQK-LSK108_WA01.merged.fq.index data/FAB45277-86567043_Multi_SQK-LSK108_WA01.merged.fq.index.fai data/FAB45277-86567043_Multi_SQK-LSK108_WA01.merged.fq.index.gzi data/FAB45277-86567043_Multi_SQK-LSK108_WA01.merged.fq.index.readdb --latency-wait 120 \
 --attempt 1 --force-use-threads \
--wrapper-prefix https://github.com/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules call_meth --nocolor --notemp --no-hooks --nolock \
--mode 2  && touch /icgc/dkfzlsdf/analysis/C010/brooks/meth_calling_pipeline/.snakemake/tmp.vrjism4n/85.jobfinished || (touch /icgc/dkfzlsdf/analysis/C010/brooks/meth_calling_pipeline/.snakemake/tmp.vrjism4n/85.jobfailed; exit 1)


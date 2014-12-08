mongo_agent_split_raw
=====================

[MongoAgent](https://github.com/dmlond/mongo_agent) that wraps [dmlond/split_raw](https://github.com/dmlond/split_raw)

Takes the raw fastq file ([g]zipped or not), splits it into smaller subsets using
split_raw, and creates align_subset_agent targetted tasks in the QUEUE.

See the [mongo_agent_alignment](https://github.com/dmlond/mongo_agent_alignment)
documentation for more details.

input task: {
  agent_name: 'split_agent',
  parent_id: 'id of the alignment_agent task that this is working on',
  build: 'dirname of build directory in /home/bwa_user/bwa_indexed',
  reference: 'filename of fasta file indexed in /home/bwa_user/bwa_indexed/build',
  raw_file: 'filename of fastq file in /home/bwa_user/data',
  ready: true
}

#!/usr/local/bin/ruby

require 'mongo_agent'

agent = MongoAgent::Agent.new({name: 'split_agent', queue: ENV['QUEUE']})
agent.work! { |task|
  #task = { build, reference, raw_file, parent_id, agent_name: split_agent, ready:true }
  response = nil

  raw_file = File.join('/home/bwa_user/data', task[:raw_file])
  if File.exists?(raw_file)
    files_produced = []
    command = [ "/usr/local/bin/split_raw.pl", "-z", "-f", task[:raw_file] ]
    @exit_status = 0
    IO.popen(command) do |subset_files|
      subset_files.each do |current_subset_filename|
        agent.db[agent.queue].insert({
          build: task[:build],
          reference: task[:reference],
          raw_file: task[:raw_file],
          subset: current_subset_filename.chomp,
          parent_id: task[:parent_id],
          agent_name: 'align_subset_agent',
          ready: true
        })
        files_produced << {
          name: current_subset_filename.chomp,
          sha1: `sha1sum #{ File.join('/home/bwa_user/data', current_subset_filename.chomp) }`.split(' ')[0]
        }
      end
      subset_files.close
      @exit_status = $?.exitstatus
    end
    if @exit_status > 0
     response = [false, {error_message: "problem splitting files", files: files_produced}]
    else
     response = [true, {files: files_produced}]
    end
  else
    response = [false, {error_message: "#{ task[:raw_file] } does not exist!" }]
  end
  response
}

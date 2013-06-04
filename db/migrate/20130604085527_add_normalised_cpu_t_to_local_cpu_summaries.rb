class AddNormalisedCpuTToLocalCpuSummaries < ActiveRecord::Migration
  def change
    add_column :local_cpu_summaries, :normalisedCpuT, :float
  end
end

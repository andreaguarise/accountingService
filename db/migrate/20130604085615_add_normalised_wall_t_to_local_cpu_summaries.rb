class AddNormalisedWallTToLocalCpuSummaries < ActiveRecord::Migration
  def change
    add_column :local_cpu_summaries, :normalisedWallT, :float
  end
end

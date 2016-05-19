class Commit < ActiveRecord::Base
  has_many :commit_files, dependent: :destroy

  has_many :lines_of_code_stats, dependent: :destroy

  belongs_to :repository

  default_scope { order('created_at ASC') }

  def files
    commit_files
  end

  def lines_of_code
    lines_of_code_stats.sum(:code)
  end
end

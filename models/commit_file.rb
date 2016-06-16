class CommitFile < ActiveRecord::Base
  belongs_to :commit
  has_one :commit_diff, dependent: :destroy

  def revisions
    @revisions ||= commit.repository.commits.map do |commit|
      file = commit.select_file(full_path)
      if file
        commit.commit_diffs.where(commit_file: file).count
      else
        0
      end
    end.sum
  end
end

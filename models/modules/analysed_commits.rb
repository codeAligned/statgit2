module AnalysedCommits
  include DateHelper

  def analysed_commits
    @analysed_commits ||= commits.where.not(author_id: nil)
  end

  def daily_commits
    @daily_commits ||= analysed_commits.uniq do |commit|
      iso_date(commit.date)
    end
  end

  def commit_activity
    @commit_activity ||= CommitActivity.new(self).call
  end

  def commits_per_day
    @commits_per_day ||= CommitsPerDay.new(self).call
  end

  def commits_per_hour
    @commits_per_hour ||= CommitsPerHour.new(self).call
  end

  def changes_per_hour
    @changes_per_hour ||= ChangesPerHour.new(self).call
  end
end

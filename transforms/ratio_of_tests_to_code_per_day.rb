class RatioOfTestsToCodePerDay
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    raw = repository.analysed_commits.uniq do |commit|
      iso_date(commit.date)
    end.map do |commit|
      [ iso_date(commit.date), commit.ratio_of_tests_to_code ]
    end

    Hash[raw]
  end
end

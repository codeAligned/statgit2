class LargestFiles
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    repository.latest_commit.files_with_revisions_and_sizes.select do |key, value|
      value[:size] > 0
    end.sort_by do |key, value|
      -value[:size]
    end
  end
end

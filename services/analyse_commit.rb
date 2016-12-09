class AnalyseCommit
  include CommandLineHelper

  attr_reader :commit, :options

  delegate :repository, to: :commit

  def initialize(commit:, options:)
    @commit = commit
    @options = options
  end

  def call
    LOG.info "Analysing commit #{commit.commit_hash} (#{percent_done})..."

    switched = false

    3.times do    # Rather than defining tool dependencies, just run all tools many times
      COMMIT_ANALYSERS.each do |tool|
        instance = tool.new(commit: commit)
        if instance.needs_update?
          unless switched
            execute_command "cd #{root_path} && git reset --hard && git checkout #{commit.commit_hash} && git reset --hard #{commit.commit_hash}"
            switched = true
          end

          LOG.info ">> #{tool}"
          instance.call
        end
      end
    end
  end

  private

  def percent_done
    sprintf "%0.1f%%", (repository.commits.find_index(commit) / repository.commits.count.to_f) * 100
  end
end

class CreateRepository
  attr_reader :url

  def initialize(url:)
    @url = url
  end

  def call
    Repository.where(url: url).first || new_repository
  end

  private

  def new_repository
    Repository.create!(
      url: url
    )
  end
end

class CommitFile < ActiveRecord::Base
  belongs_to :commit
  belongs_to :file_path

  has_one :commit_diff, dependent: :destroy

  has_many :file_todos, dependent: :destroy
  has_many :file_fixmes, dependent: :destroy
  has_many :file_sass_stylesheets, dependent: :destroy

  validates :full_path, presence: true
  validates :size, presence: true, numericality: { only_integer: true }

  def revisions
    @revisions ||= commit.repository.revisions_for(full_path) + 1     # if a file exists, it must have had at least one commit
  end

  def contributors
    @contributors ||= commit.repository.contributors_for(full_path)
  end

  def full_path
    @full_path ||= file_path.path
  end
end

class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  validates_uniqueness_of :idx, :scope => [:group_id]
  validates :subject, :length => { :maximum => 40 }
  validates :text, :presence => true, :length => { :maximum => 1000 }

  before_validation(on: :create) do
    self.idx = next_idx
  end

  private
  def next_idx
    group.posts.maximum('idx').to_i + 1
  end
end

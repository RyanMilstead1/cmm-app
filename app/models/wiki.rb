class Wiki < ApplicationRecord
  belongs_to :user
  has_many :collaborators
  has_many :collaborating_users, through: :collaborators, source: :user
  after_save :confirm_private_valid

  extend FriendlyId
  friendly_id :title, use: :slugged

  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true, length: { minimum: 20 }

  def confirm_private_valid
    if user.standard? && private
      update_attribute(:private, false)
    end
  end
end

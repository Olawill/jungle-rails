class Category < ApplicationRecord

  has_many :products

  validates :name, presence: true
  validate :name_not_empty_string

  private

  def name_not_empty_string
    if name.present? && name.strip.empty?
      errors.add(:name, "can't be just spaces")
    end
  end

end

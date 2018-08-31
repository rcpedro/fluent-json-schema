class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

class User < ApplicationRecord
  enum status: [:active, :inactive]
  
  has_many :students
  has_many :universities, through: :students

  has_one :current_student, -> { where(status: 'active') }, class_name: 'Student'
  has_one :current_university, through: :current_student, class_name: 'University'
end

class University < ApplicationRecord
  has_many :students
  has_many :users, through: :students
end

class Student < ApplicationRecord
  belongs_to :university
  belongs_to :user
end
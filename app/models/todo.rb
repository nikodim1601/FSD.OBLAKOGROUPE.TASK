class Todo < ApplicationRecord
  validates :text, presence: true, length: {maximum: 300}
  validates :project, presence: true
  validates :isCompleted, inclusion: [true, false] # Проверка не работает так, как я хочу. При передаче любой строки я получаю true.
  belongs_to :project
end

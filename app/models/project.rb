class Project < ApplicationRecord
  has_many :tasks
  belongs_to :user
  validates :subject, presence: true, length: { maximum: 20 }
  validates :description, presence: true, length: { maximum: 200 }

  MAX_GRUFF_PERIOD = 10

  TODO_STATUS = [
    :INITIAL,
    :PENNDING,
    :PROGLESS,
  ]

  def gruff_period
    period = []
    (self.start_at..self.end_at).each do |date|
      period.push date
    end
    if period.count > MAX_GRUFF_PERIOD
      div = period.count / MAX_GRUFF_PERIOD
      data = period
      period = []
      MAX_GRUFF_PERIOD.times do |t|
        period[t] = data[t * div]
      end
      period[0] = self.start_at
      period[period.count - 1] = self.end_at
    end
    period
  end

  def all_task_num
    self.tasks.count
  end

  def todo_task_num
    tasks.where(:status => TaskStatus::STATUS.values_at(*TODO_STATUS)).count
  end

  def progress
    prg = []
    prg[0] = 0
    gruff_period.each_with_index do |t, idx|
      #prg[idx + 1] = idx * 200
      prg[idx + 1] = idx * 200
    end
    prg = [0, 20, 100, 100, 120, 330, 1000]
    prg
  end

  def get_label
    label = {}
    label[0] = ''
    gruff_period.each_with_index do |t, idx|
      label[idx + 1] = t.strftime("%m/%d")
    end
    label
  end

  def seconds
    self.tasks.map {|t| t.seconds}.sum
  end

  def hours
    self.tasks.map {|t| t.hours}.sum
  end

  def minutes
    self.tasks.map {|t| t.minutes}.sum
  end
end

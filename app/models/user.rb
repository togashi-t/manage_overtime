class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :overtimes, dependent: :destroy

  def this_month_minute
    this_month = Time.zone.now.all_month
    self.overtimes.where(date: this_month).sum(:work_time_minute)
  end
end

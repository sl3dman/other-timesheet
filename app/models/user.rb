class User < ActiveRecord::Base
  
  has_many :timelogs
  belongs_to :school
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :school, :school_id, :tools, :conduct, :email, :password, :password_confirmation, :remember_me, :name_first, :name_last, :phone, :admin, :userid
  # attr_accessible :title, :body
  
  validates_uniqueness_of :userid
  
  def signed_in
    if self.timelogs.in_today.nil? || self.timelogs.in_today.empty?
      return false
    else
      return self.timelogs.in_today.first
    end
  end
  def full_name
    return "#{self.name_first} #{self.name_last}"
  end
  def total_hours
    total = 0
    self.timelogs.each do |log|
        total = total + log.time_logged
    end
    return Time.at(total).utc.strftime("%H:%M:%S")
  end
  def grouped_logs
    self.timelogs.order('timein asc').group_by{ |u| u.timein.beginning_of_week }
  end
end
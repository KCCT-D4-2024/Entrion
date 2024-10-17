class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  before_validation :set_dummy_email
  enum status: { default: 0, entered: 1, exited: 2 }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         authentication_keys: [:name]
  validates :name, presence: true, length: { minimum: 2 }
  validates_uniqueness_of :name
  validates_presence_of :name

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if name = conditions.delete(:name)
      where(conditions).where(["name = :value", { value: name }]).first
    else
      where(conditions).first
    end
  end

  def will_save_change_to_email?
    false
  end

  private
  def set_dummy_email
    if self.email.blank?
      self.email = "#{SecureRandom.uuid}@example.com"
    end
  end

  def update_entered_at
    if saved_change_to_status? && entered?
      self.entered_at = Time.now
    end
  end

  def update_exited_at
    if saved_change_to_status? && exited?
      self.exited_at = Time.now
    end
  end

end

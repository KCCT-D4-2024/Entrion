class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  after_update :broadcast_info
  before_validation :set_dummy_email
  enum status: { default: 0, entered: 1, exited: 2 }
  has_many :game_scores, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         authentication_keys: [:name]
  validates :name, presence: true, length: { minimum: 2 }
  validates_uniqueness_of :name
  validates_presence_of :name

  validate :password_allow_numeric_only

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

  def broadcast_info
    Rails.logger.info "Broadcasting user data..."
    ActionCable.server.broadcast "info_channel", {
      users_count: User.count,
      entered_count: User.entered.count,
      exited_count: User.exited.count,
      max_score: User.maximum(:total_score)
    }
  end

  def password_allow_numeric_only
    if password.present?
      unless password.match?(/\A\d+\z/) || password.match?(/\A[a-zA-Z0-9]+\z/)
        errors.add(:password, "は無効です。数字または英数字のみを使用してください。")
      end
    end
  end
end

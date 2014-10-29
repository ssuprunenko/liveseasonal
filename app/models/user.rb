# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  email         :string(255)
#  referral_code :string(255)
#  referrer_id   :integer
#  created_at    :datetime
#  updated_at    :datetime
#
class User < ActiveRecord::Base
    belongs_to :referrer, :class_name => "User", :foreign_key => "referrer_id"
    has_many :referrals, :class_name => "User", :foreign_key => "referrer_id"

    validates :email, :uniqueness => true, :format => { :with => /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i, :message => "Invalid email format." }
    validates :referral_code, :uniqueness => true

    before_create :create_referral_code
    after_create :send_welcome_email

    REFERRAL_STEPS = [
        {
            count: 6,
            reward: '$3',
            title: '3 dollars',
            class: "two"
        },
        {
            count: 12,
            reward: '$6',
            title: '6 dollars',
            class: "three"
        },
        {
            count: 24,
            reward: 'BER',
            title: 'Berlin, Germany',
            class: "four"
        },
        {
            count: 50,
            reward: 'BCN',
            title: 'Barcelona, Spain',
            class: "five"
        }
    ]

    private

    def create_referral_code
        referral_code = SecureRandom.hex(5)
        @collision = User.find_by_referral_code(referral_code)

        while !@collision.nil?
            referral_code = SecureRandom.hex(5)
            @collision = User.find_by_referral_code(referral_code)
        end

        self.referral_code = referral_code
    end

    def send_welcome_email
        UserMailer.delay.signup_email(self)
    end
end

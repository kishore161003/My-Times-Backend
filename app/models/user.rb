class User < ApplicationRecord
    has_secure_password
    validates :email, presence: true, uniqueness: true
    has_many :websites
    validates :extension_id, uniqueness: true, allow_blank: true
end

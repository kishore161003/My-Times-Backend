class Website < ApplicationRecord
    has_many :website_visits
    belongs_to :user
end

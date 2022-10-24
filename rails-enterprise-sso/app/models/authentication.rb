# app/models/authentication.rb
class Authentication < ActiveRecord::Base
  belongs_to :user
end

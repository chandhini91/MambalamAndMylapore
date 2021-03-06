require 'mongoid'
require 'bcrypt'
require 'pry'

module Platform
  module UserData

    class User
      include Mongoid::Document
      include BCrypt
      include Mongoid::Timestamps

      attr_accessor :password, :password_confirmation

      field :uname, :type => String
      field :fname, :type => String
      field :lname, :type => String
      field :email, :type => String
      field :password_hash, :type => String

      validates_presence_of :email, :message  => "Email id is required", format: { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
      validates_presence_of :uname, :message => "Username is required"
      validates_uniqueness_of :email, :message => "Email ID already taken"
      validates_uniqueness_of :uname, :message => "Username already taken"
      before_save :encrypt_password

      def encrypt_password
        self.password_hash = Password.create(@password)
      end
    end

    class UserSerialize
      def initialize(user)
        @user = UserSerialize.serialize(user)
      end

      def self.serialize(user)
        data = {}
        data[:user_id] = user.id.to_s
        data[:email] = user.email.to_s
        data[:first_name] = user.fname.to_s
        data[:last_name] = user.lname.to_s
        data[:password] = user.password_hash
        data[:errors] = user.errors.to_s if user.errors.any?
        data
      end
    end

  end
end

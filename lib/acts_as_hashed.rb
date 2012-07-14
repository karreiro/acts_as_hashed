require "acts_as_hashed/version"

module ActsAsHashed
  def acts_as_hashed
    before_create :set_hashed_code
    include InstanceMethods
  end

  module InstanceMethods
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def friendly_token
        SecureRandom.hex(16)
      end

      def hashed_code_exists?(hashed_code)
        !where(:hashed_code => hashed_code).count.zero?
      end
    end

    def set_hashed_code
      return unless hashed_code.nil?
      loop do
        self.hashed_code = self.class.friendly_token
        break self.hashed_code unless self.class.hashed_code_exists?(self.hashed_code)
      end
    end

  end
end

ActiveRecord::Base.extend ActsAsHashed

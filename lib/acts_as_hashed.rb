require "acts_as_hashed/version"

module ActsAsHashed
  def acts_as_hashed(callback_name = :before_create)
    set_hashed_code(callback_name)
    include InstanceMethods
  end

  private

  def set_hashed_code(callback_name)
    unless allowed_callbacks_to_hashed_code.include?(callback_name)
      raise ArgumentError.new("The valid callbacks options are: #{allowed_callbacks_to_hashed_code.to_sentence}")
    end
    public_send(callback_name, :set_hashed_code)
  end

  def allowed_callbacks_to_hashed_code
    [:before_validation, :before_create, :before_update, :before_save]
  end

  module InstanceMethods
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def friendly_token
        SecureRandom.hex
      end

      def hashed_code_exists?(hashed_code)
        where(:hashed_code => hashed_code).any?
      end

      def update_missing_hashed_code
        where(hashed_code: nil).find_each do |record|
          record.update_column(:hashed_code, friendly_token)
        end
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

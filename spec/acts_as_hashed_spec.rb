require 'spec_helper'
require 'active_record'
require File.expand_path(File.dirname(__FILE__) + "/../lib/acts_as_hashed")

DB_FILE = 'tmp/test_db'

FileUtils.mkdir_p File.dirname(DB_FILE)
FileUtils.rm_f DB_FILE

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => DB_FILE
ActiveRecord::Base.connection.execute 'CREATE TABLE some_models (id INTEGER NOT NULL PRIMARY KEY, hashed_code string)'
ActiveRecord::Base.connection.execute 'CREATE TABLE overwrited_models (id INTEGER NOT NULL PRIMARY KEY, hashed_code string)'
ActiveRecord::Base.connection.execute 'CREATE TABLE custom_callback_models (id INTEGER NOT NULL PRIMARY KEY, hashed_code string)'
ActiveRecord::Base.connection.execute 'CREATE TABLE invalid_exception_models (id INTEGER NOT NULL PRIMARY KEY, hashed_code string)'

class SomeModel < ActiveRecord::Base
  acts_as_hashed
end

class OverwritedModel < ActiveRecord::Base
  acts_as_hashed

  class << self
    def friendly_token
      SecureRandom.hex(5)
    end
  end
end

class CustomCallbackModel < ActiveRecord::Base
  acts_as_hashed :before_validation
end

describe ActsAsHashed do
  before(:each) do
    clean_database!
  end

  describe :save do

    context "new record" do
      let(:model) { SomeModel.new }

      context 'when hashed_code is nil' do
        it "should save hashed code" do
          SomeModel.stub(:friendly_token).and_return('new-hashed-code-here')
          expect {
            model.save!
          }.to change(model, :hashed_code).from(nil).to('new-hashed-code-here')
        end
      end
    end

    describe "persisted record" do
      let(:model) do
        model = SomeModel.new
        model.save!
        model
      end
      it "should save hashed code" do
        SomeModel.stub(:friendly_token).and_return('new-hashed-code-here')
        expect {
          model.save!
        }.to_not change(model, :hashed_code)
      end
    end

    context "overwrite friendly_token" do
      let!(:model) do
        model = OverwritedModel.new
        model.save
        model
      end
      it "should have hashed_code with lenght 10" do
        model.hashed_code.length.should == 10
      end
    end

    context "a custom callback ('before_validation') is used" do
      context "when validations are disabled" do
        let!(:model) do
          model = CustomCallbackModel.new
          model.save(validate: false)
          model
        end

        subject { model.hashed_code }

        it "returns nil" do
          expect(subject).to be_nil
        end
      end

      context "when validations are enabled" do
        let!(:model) do
          model = CustomCallbackModel.new
          model.save
          model
        end

        subject { model.hashed_code }

        it "returns something" do
          expect(subject).not_to be_nil
        end
      end

      context "when an invalid callback is used" do
        it "raises an error" do
          expect do
            class InvalidExceptionModel < ActiveRecord::Base
              acts_as_hashed :invalid_callback
            end
          end.to raise_error(ArgumentError)
        end
      end
    end
  end

  describe :update_missing_hashed_code do
    let!(:model) do
      model = SomeModel.new
      model.save
      model.update_column(:hashed_code, nil)
      model.reload
    end
    it { expect { SomeModel.update_missing_hashed_code }.to change { model.reload.hashed_code }.from(nil) }
  end
end

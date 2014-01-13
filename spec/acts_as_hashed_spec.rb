require 'spec_helper'
require 'active_record'
require File.expand_path(File.dirname(__FILE__) + "/../lib/acts_as_hashed")

DB_FILE = 'tmp/test_db'

FileUtils.mkdir_p File.dirname(DB_FILE)
FileUtils.rm_f DB_FILE

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => DB_FILE
ActiveRecord::Base.connection.execute 'CREATE TABLE some_models (id INTEGER NOT NULL PRIMARY KEY, hashed_code string)'
ActiveRecord::Base.connection.execute 'CREATE TABLE overwrited_models (id INTEGER NOT NULL PRIMARY KEY, hashed_code string)'

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

describe ActsAsHashed do
  before(:each) do
    clean_database!
  end
  describe :save do
    context "new record" do
      let(:model) { SomeModel.new }
      it "should save hashed code" do
        SomeModel.stub(:friendly_token).and_return('new-hashed-code-here')
        expect {
          model.save!
        }.to change(model, :hashed_code).from(nil).to('new-hashed-code-here')
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

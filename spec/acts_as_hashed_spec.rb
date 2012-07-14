require 'spec_helper'
require 'active_record'
require File.expand_path(File.dirname(__FILE__) + "/../lib/acts_as_hashed")

DB_FILE = 'tmp/test_db'

FileUtils.mkdir_p File.dirname(DB_FILE)
FileUtils.rm_f DB_FILE

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => DB_FILE
ActiveRecord::Base.connection.execute 'CREATE TABLE some_models (id INTEGER NOT NULL PRIMARY KEY, hashed_code string)'

class SomeModel < ActiveRecord::Base
  acts_as_hashed
end

describe ActsAsHashed do
  before(:each) do
    clean_database!
  end
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
end

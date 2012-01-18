describe LibCDB::CDB::Reader do

  before :all do
    @temp = tempfile

    db = LibCDB::CDB::Writer.new(@temp.to_io)
    TEST_DATA.each { |k, v| v.each { |w| db.store(k, w) } }
    db.close
  end

  after :all do
    @temp.unlink
  end

  describe "#initialize" do

    it "should not accept integers" do
      lambda { LibCDB::CDB::Reader.new(12345) }.should raise_error(TypeError)
    end

    it "should not accept pipes" do
      lambda { LibCDB::CDB::Reader.new(STDIN) }.should raise_error(SystemCallError)
    end

  end

  describe "empty" do

    before :all do
      @empt = tempfile
      LibCDB::CDB::Writer.new(@empt.to_io).close
    end

    after :all do
      @empt.unlink
    end

    before :each do
      @db = LibCDB::CDB::Reader.new(File.open(@empt.path))
    end

    after :each do
      @db.close
    end

    it "should know that it's not closed" do
      @db.should_not be_closed
    end

    it "should know that it's empty" do
      @db.should be_empty
    end

    it "should know its size" do
      @db.size.should == 0
    end

    it "should know if it doesn't have a key" do
      @db.should_not have_key('key3')
    end

    it "should know if it doesn't have a value" do
      @db.should_not have_value('value3.2')
    end

  end

  describe "non-empty" do

    before :each do
      @db = LibCDB::CDB::Reader.new(File.open(@temp.path))
    end

    after :each do
      @db.close
    end

    it "should know that it's not closed" do
      @db.should_not be_closed
    end

    it "should know that it's not empty" do
      @db.should_not be_empty
    end

    it "should know its size" do
      @db.size.should == 11
    end

    it "should know if it has a key" do
      @db.should have_key('key3')
    end

    it "should know if it doesn't have a key" do
      @db.should_not have_key('key33')
    end

    it "should know if it has a value" do
      @db.should have_value('value3.2')
    end

    it "should know if it doesn't have a value" do
      @db.should_not have_value('value33.22')
    end

    it "should get a single value" do
      @db['key1'].should == 'value1.1'
    end

    it "should not get non-existent value" do
      @db['key33'].should be_nil
    end

    it "should get each value" do
      TEST_DATA.each { |k, o|
        r = []
        @db.each(k) { |v| r << v }
        r.should == o
      }
    end

    it "should get all values" do
      TEST_DATA.each { |k, o|
        @db.fetch(k).should == o
      }
    end

    it "should get last value" do
      @db.fetch_last('key10').should == 'value10.10'
    end

    it "should find the key for a value" do
      @db.key('value3.2').should == 'key3'
    end

    it "should not find the key for a non-existent value" do
      @db.key('value33.22').should be_nil
    end

  end

end

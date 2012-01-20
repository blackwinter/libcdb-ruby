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

    it "should know its total" do
      @db.total.should == 0
    end

    it "should know its keys" do
      @db.keys.should == []
    end

    it "should know its values" do
      @db.values.should == []
    end

    it "should know if it doesn't have a key" do
      @db.should_not have_key('key3')
    end

    it "should know if it doesn't have a value" do
      @db.should_not have_value('value3.2')
    end

    it "should dump itself" do
      @db.dump.should == ''
    end

    it "should convert itself into a hash" do
      @db.to_h.should == {}
    end

    it "should convert itself into an array" do
      @db.to_a.should == []
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

    it "should know its total" do
      @db.total.should == 56
    end

    it "should know its keys" do
      @db.keys.should == TEST_DATA.map { |k, _| k }.uniq
    end

    it "should know its values" do
      @db.values.should == TEST_DATA.map { |_, v| v }.flatten
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

    it "should dump records for key" do
      d = []
      @db.each_dump('key3') { |e| d << e }
      d.should == %w[+4,8:key3->value3.1 +4,8:key3->value3.2 +4,8:key3->value3.3]
    end

    it "should convert itself into a hash" do
      h = {}
      TEST_DATA.each { |k, v| h[k] = v.size > 1 ? v : v.first }
      @db.to_h.should == h
    end

    it "should convert itself into an array" do
      a = []
      TEST_DATA.each { |k, v| v.each { |w| a << [k, w] } }
      @db.to_a.should == a
    end

  end

end

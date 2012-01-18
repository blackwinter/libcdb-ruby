describe LibCDB::CDB::Writer do

  describe "#initialize" do

    it "should not accept strings" do
      lambda { LibCDB::CDB::Writer.new('test') }.should raise_error(TypeError)
    end

    it "should not accept pipes" do
      lambda { LibCDB::CDB::Writer.new(STDOUT) }.should raise_error(SystemCallError)
    end

  end

  describe "#add" do

    before :each do
      @temp = tempfile
      @db = LibCDB::CDB::Writer.new(@temp.to_io)
    end

    after :each do
      @temp.unlink
    end

    it "should add data" do
      TEST_DATA.each { |k, v| v.each { |w| @db.add(k, w) } }
      @db.close
      @db.should be_closed
    end

  end

end

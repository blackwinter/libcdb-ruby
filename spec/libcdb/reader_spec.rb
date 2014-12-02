describe LibCDB::CDB::Reader do

  rbx = lambda { |msg| "Rubinius: #{msg}" if RUBY_ENGINE == 'rbx' }

  describe '#initialize' do

    it 'should not accept integers' do
      lambda { LibCDB::CDB::Reader.new(12345) }.should raise_error(TypeError)
    end

    it 'should not accept pipes' do
      lambda { LibCDB::CDB::Reader.new(STDIN) }.should raise_error(SystemCallError)
    end

    it 'should not accept empty files' do
      lambda { reader('empty.dump') }.should raise_error(SystemCallError)
    end

  end

  describe 'empty' do

    before :each do
      @db = reader(:empty)
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

    it 'should know its size', skip: rbx['invalid handle usage detected'] do
      @db.size.should == 0
    end

    it 'should know its total' do
      @db.total.should == 0
    end

    it 'should know its keys' do
      @db.keys.should == []
    end

    it 'should know its values' do
      @db.values.should == []
    end

    it "should know if it doesn't have a key" do
      @db.should_not have_key('k3')
    end

    it "should know if it doesn't have a value" do
      @db.should_not have_value('v3.2')
    end

    it 'should dump itself' do
      @db.dump.should == ''
    end

    it 'should convert itself into a hash' do
      @db.to_h.should == {}
    end

    it 'should convert itself into an array' do
      @db.to_a.should == []
    end

  end

  describe 'non-empty' do

    before :each do
      @db = reader
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

    it 'should know its size', skip: rbx['invalid handle usage detected'] do
      @db.size.should == TEST_DATA.size
    end

    it 'should know its total' do
      @db.total.should == TEST_DATA.values.flatten.size
    end

    it 'should know its keys' do
      @db.keys.should == TEST_DATA.map { |k, _| k }.uniq
    end

    it 'should know its values' do
      @db.values.should == TEST_DATA.map { |_, v| v }.flatten
    end

    it 'should know if it has a key', skip: rbx['key not found'] do
      @db.should have_key('k3')
    end

    it "should know if it doesn't have a key" do
      @db.should_not have_key('none')
    end

    it 'should know if it has a value', skip: rbx['value not found'] do
      @db.should have_value('v3.2')
    end

    it "should know if it doesn't have a value" do
      @db.should_not have_value('none')
    end

    it 'should get a single value' do
      @db['k1'].should == 'v1.1'
    end

    it 'should not get non-existent value' do
      @db['none'].should be_nil
    end

    it 'should get each value' do
      TEST_DATA.each { |k, o|
        r = []
        @db.each(k) { |v| r << v }
        r.should == o
      }
    end

    it 'should get all values' do
      TEST_DATA.each { |k, o|
        @db.fetch(k).should == o
      }
    end

    it 'should get last value' do
      @db.fetch_last('k10').should == 'v10.10'
    end

    it 'should find the key for a value', skip: rbx['the VM is exiting improperly'] do
      @db.key('v3.2').should == 'k3'
    end

    it 'should not find the key for a non-existent value' do
      @db.key('none').should be_nil
    end

    it 'should dump itself', skip: rbx['no block given'] do
      @db.dump.should == File.binread(data('test.dump'))
    end

    it 'should dump records for key', skip: rbx['no block given'] do
      d = []
      @db.each_dump('k3') { |e| d << e }
      d.should == %w[+2,4:k3->v3.1 +2,4:k3->v3.2 +2,4:k3->v3.3]
    end

    it 'should convert itself into a hash' do
      h = {}
      TEST_DATA.each { |k, v| h[k] = v.size > 1 ? v : v.first }
      @db.to_h.should == h
    end

    it 'should convert itself into an array' do
      a = []
      TEST_DATA.each { |k, v| v.each { |w| a << [k, w] } }
      @db.to_a.should == a
    end

    it 'should yield keys' do
      @db.each_key { |k| break k }.should == 'k1'
    end

    it 'should return an enumerator for #each_key without block' do
      @db.each_key.should be_a(Enumerator)
    end

    it 'should yield values' do
      @db.each_value { |v| break v }.should == 'v1.1'
    end

    it 'should return an enumerator for #each_value without block' do
      @db.each_value.should be_a(Enumerator)
    end

  end

end

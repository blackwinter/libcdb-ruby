require 'tempfile'

describe LibCDB::CDB::Writer do

  describe '#initialize' do

    it 'should not accept strings' do
      lambda { LibCDB::CDB::Writer.new('test') }.should raise_error(TypeError)
    end

    it 'should not accept pipes' do
      lambda { LibCDB::CDB::Writer.new(STDOUT) }.should raise_error(SystemCallError)
    end

  end

  describe 'when writing' do

    before do
      @temp = tempfile
      @db = LibCDB::CDB::Writer.new(@temp.to_io)
    end

    after do
      @temp.unlink
    end

    %w[insert replace store].each { |m|
      it "should #{m} data" do
        TEST_DATA.each { |k, v| v.each { |w| @db.send(m, k, w) } }

        @db.close
        @db.should be_closed
      end
    }

  end

end

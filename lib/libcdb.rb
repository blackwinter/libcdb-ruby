begin
  require "libcdb/#{RUBY_VERSION[/\d+.\d+/]}/libcdb_ruby"
rescue LoadError
  require 'libcdb/libcdb_ruby'
end

require 'libcdb/version'
require 'forwardable'

module LibCDB

  class CDB

    extend Forwardable

    MODE_READ  = 'r' # :nodoc:
    MODE_WRITE = 'w' # :nodoc:

    class << self

      # call-seq:
      #   CDB.open(path[, mode]) -> aReader | aWriter | aCDB
      #   CDB.open(path[, mode]) { |cdb| ... }
      #
      # Opens +path+ with +mode+. If a block is given, yields a _cdb_ object
      # according to +mode+ (see below) and returns the return value of the
      # block; the object is closed afterwards. Otherwise just returns the
      # object.
      #
      # <tt>r</tt>::  Reader
      # <tt>w</tt>::  Writer
      # <tt>r+</tt>:: CDB (initially opened for reading)
      # <tt>w+</tt>:: CDB (initially opened for writing)
      def open(path, mode = MODE_READ)
        klass, args = self, []

        case mode
          when 'r+'       then args = [mode = MODE_READ]
          when 'w+'       then args = [       MODE_WRITE]
          when MODE_READ  then klass        = Reader
          when MODE_WRITE then klass,  mode = Writer, 'w+'
          else raise ArgumentError, "illegal access mode #{mode}"
        end

        cdb = begin
          klass.new(io = File.open(path, mode), *args)
        rescue
          io.close if io
          raise
        end

        if block_given?
          begin
            yield cdb
          ensure
            cdb.close
          end
        else
          cdb
        end
      end

      # call-seq:
      #   CDB.foreach(path) { |key, val| ... }
      #   CDB.foreach(path, key) { |val| ... }
      #
      # Opens +path+ for reading and iterates over each key/value pair,
      # or, if +key+ is given, each value for +key+.
      def foreach(path, *key)
        open(path) { |cdb| cdb.each(*key) { |val| yield val } }
      end

      # call-seq:
      #   CDB.dump(path[, target[, separator]]) -> target
      #
      # Opens +path+ for reading and shovels each record dump into +target+
      # (followed by +separator+, if present). Returns +target+.
      def dump(path, target = '', separator = $\ || $/)
        open(path) { |cdb|
          cdb.each_dump { |dump|
            target << dump
            target << separator if separator
          }

          target
        }
      end

    end

    # call-seq:
    #   CDB.new(io[, mode]) -> aCDB
    #
    # Creates a new CDB object to interface with +io+. +mode+ must be the same
    # mode +io+ was opened in, either +r+ or +w+. Responds to both Reader and
    # Writer methods interchangeably by reopening +io+ in the corresponding mode
    # and instantiating a new Reader or Writer object with it. Note that +io+
    # will be truncated each time it's opened for writing.
    def initialize(io, mode = MODE_WRITE)
      @io, @mode = io, mode

      case mode
        when MODE_READ  then open_read
        when MODE_WRITE then open_write
        else raise ArgumentError, "illegal access mode #{mode}"
      end
    end

    # The underlying IO object.
    attr_reader :io

    # The current IO mode, either +r+ or +w+.
    attr_reader :mode

    # call-seq:
    #   cdb.reader -> aReader
    #
    # The Reader object associated with _cdb_.
    def reader
      @reader ||= open_read
    end

    # call-seq:
    #   cdb.writer -> aWriter
    #
    # The Writer object associated with _cdb_.
    def writer
      @writer ||= open_write
    end

    def_delegators :reader, :[], :dump, :each, :each_dump, :each_key,
                            :each_value, :empty?, :fetch, :fetch_all,
                            :fetch_first, :fetch_last, :get, :has_key?,
                            :has_value?, :include?, :key, :key?, :keys,
                            :length, :member?, :rget, :size, :to_a,
                            :to_h, :value?, :values, :values_at

    def_delegators :writer, :[]=, :add, :insert, :replace, :store

    # call-seq:
    #   cdb.read? -> true | false
    #
    # Whether _cdb_ is currently opened for reading.
    def read?
      !!@reader
    end

    # call-seq:
    #   cdb.write? -> true | false
    #
    # Whether _cdb_ is currently opened for writing.
    def write?
      !!@writer
    end

    # call-seq:
    #   cdb.open_read -> aReader
    #
    # Opens _cdb_ for reading and reopens #io accordingly.
    # Closes #writer if open.
    def open_read
      close_write(false)
      @reader = Reader.new(reopen(MODE_READ))
    end

    # call-seq:
    #   cdb.open_write -> aWriter
    #
    # Opens _cdb_ for writing and reopens #io accordingly.
    # Closes #reader if open. Note that #io will be truncated.
    def open_write
      close_read(false)
      @writer = Writer.new(reopen(MODE_WRITE))
    end

    # call-seq:
    #   cdb.close_read([strict]) -> nil
    #
    # If _cdb_ is currently opened for reading, closes the #reader (and #io
    # with it). Otherwise, if +strict+ is true, raises an IOError.
    def close_read(strict = true)
      if read?
        @reader.close
        @reader = nil
      elsif strict
        raise IOError, 'not opened for reading'
      end
    end

    # call-seq:
    #   cdb.close_write([strict]) -> nil
    #
    # If _cdb_ is currently opened for writing, closes the #writer (and #io
    # with it). Otherwise, if +strict+ is true, raises an IOError.
    def close_write(strict = true)
      if write?
        @writer.close
        @writer = nil
      elsif strict
        raise IOError, 'not opened for writing'
      end
    end

    # call-seq:
    #   cdb.close -> nil
    #
    # Closes both the #reader and the #writer, as well as #io. Doesn't raise
    # an IOError if either of them is already closed.
    def close
      close_read(false)
      close_write(false)
      io.close unless io.closed?
    end

    # call-seq:
    #   cdb.closed_read? -> true | false | nil
    #
    # Whether #reader is closed if _cdb_ is currently opened for reading.
    def closed_read?
      reader.closed? if read?
    end

    # call-seq:
    #   cdb.closed_write? -> true | false | nil
    #
    # Whether #writer is closed if _cdb_ is currently opened for writing.
    def closed_write?
      writer.closed? if write?
    end

    # call-seq:
    #   cdb.closed? -> true | false | nil
    #
    # Whether _cdb_ is closed. See #closed_read? and #closed_write?.
    def closed?
      read? ? closed_read? : write? ? closed_write? : nil
    end

    private

    # call-seq:
    #   cdb.reopen([mode]) -> anIO
    #
    # Reopens #io in +mode+ and returns it.
    def reopen(new_mode = MODE_READ)
      return io if mode == new_mode

      @mode = new_mode
      new_mode += '+' if new_mode == MODE_WRITE

      io.reopen(io.path, new_mode)
    end

  end

end

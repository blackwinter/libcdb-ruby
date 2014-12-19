begin
  require "libcdb/#{RUBY_VERSION[/\d+.\d+/]}/libcdb_ruby"
rescue LoadError => err
  raise unless err.path
  require 'libcdb/libcdb_ruby'
end

require 'libcdb/version'
require 'forwardable'

module LibCDB

  class CDB

    extend Forwardable

    MODE_READ  = 'r'.freeze  # :nodoc:
    MODE_WRITE = 'w'.freeze  # :nodoc:

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
        klass, args = _open_args(path, mode)

        cdb = begin
          klass.new(*args)
        rescue
          args.first.close
          raise
        end

        if block_given?
          begin
            yield cdb
          ensure
            err = $!

            begin
              cdb.close
            rescue
              raise unless err
            end

            raise err if err
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

      # call-seq:
      #   CDB.load(path, dump) -> aCDB
      #
      # Opens +path+ for writing and loads +dump+ into the database. +dump+
      # may be a string or an IO object. Returns the (unclosed) CDB object.
      def load(path, dump)
        require 'strscan'

        s, n, e = nil, 0, lambda { |m| s.eos? ?
          raise("Unexpected end of input (#{m} at #{n}).") :
          raise("#{m} at #{n}:#{s.pos}: #{s.peek(16).inspect}") }

        cdb = open(path, 'w+')

        dump.each_line { |line|
          n += 1

          s = StringScanner.new(line)

          e['Record identifier expected'] unless s.scan(/\+/)

          e['Key length expected'] unless s.scan(/\d+/)
          klen = s.matched.to_i

          e['Length separator expected'] unless s.scan(/,/)

          e['Value length expected'] unless s.scan(/\d+/)
          vlen = s.matched.to_i

          e['Key separator expected'] unless s.scan(/:/)

          key = ''
          klen.times { key << s.get_byte }

          e['Value separator expected'] unless s.scan(/->/)

          value = ''
          vlen.times { value << s.get_byte }

          e['Record terminator expected'] unless s.scan(/\n/)
          e['Unexpected data'] unless s.eos?

          cdb.store(key, value)
        }

        cdb
      end

      # call-seq:
      #   CDB.load_file(path, file) -> aCDB
      #
      # Loads the dump at +file+ into the database at +path+ (see #load).
      def load_file(path, file)
        File.open(file, 'rb') { |f| self.load(path, f) }
      end

      # call-seq:
      #   CDB.stats(path) -> aHash
      #
      # Returns a hash with the stats on +path+.
      def stats(path)
        {}.tap { |stats| open(path) { |cdb|
          stats[:records] = cnt = cdb.total

          stats[:keys]   = khash = { min: Float::INFINITY, avg: 0, max: 0 }
          stats[:values] = vhash = khash.dup

          stats[:hash] = Hash.new(0).update(distances: Hash.new([0, 0]))

          khash[:min] = vhash[:min] = 0 and break if cnt.zero?

          ktot, vtot, update = 0, 0, lambda { |h, s| s.bytesize.tap { |l|
            h[:min] = l if l < h[:min]
            h[:max] = l if l > h[:max]
          } }

          cdb.each_key   { |k| ktot += update[khash, k] }
          cdb.each_value { |v| vtot += update[vhash, v] }

          khash[:avg] = (ktot + cnt / 2) / cnt
          vhash[:avg] = (vtot + cnt / 2) / cnt

          # TODO: hash table stats
        } }
      end

      # call-seq:
      #   CDB.print_stats(path) -> aHash
      #
      # Prints the #stats on +path+.
      def print_stats(path)
        stats(path).tap { |s|
          r, k, v, h = s.values_at(:records, :keys, :values, :hash)

          v1, v2 = [:min, :avg, :max], [:tables, :entries, :collisions]

          puts 'number of records: %d'                    % r
          puts 'key min/avg/max length: %d/%d/%d'         % k.values_at(*v1)
          puts 'val min/avg/max length: %d/%d/%d'         % v.values_at(*v1)
          next # TODO: hash table stats
          puts 'hash tables/entries/collisions: %d/%d/%d' % h.values_at(*v2)
          puts 'hash table min/avg/max length: %d/%d/%d'  % h.values_at(*v1)
          puts 'hash table distances:'

          d = h[:distances]
          0.upto(9) { |i| puts ' d%d: %6d %2d%%' % [i, *d[i]] }
          puts ' >9: %6d %2d%%' % d[-1]
        }
      end

      private

      def _open_args(path, mode)
        klass, args = self, []

        case mode
          when 'r+'       then args = [mode = MODE_READ]
          when 'w+'       then args = [       MODE_WRITE]
          when MODE_READ  then klass        = Reader
          when MODE_WRITE then klass,  mode = Writer, 'w+'
          else raise ArgumentError, "illegal access mode #{mode.inspect}"
        end

        [klass, args.unshift(File.open(path, mode + 'b'))]
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
        else raise ArgumentError, "illegal access mode #{mode.inspect}"
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
                            :each_value, :empty?, :encoding, :encoding=,
                            :fetch, :fetch_all, :fetch_first, :fetch_last,
                            :get, :has_key?, :has_value?, :include?, :key,
                            :key?, :keys, :length, :member?, :rget, :size,
                            :to_a, :to_h, :total, :value?, :values, :values_at

    def_delegators :writer, :<<, :[]=, :add, :insert, :replace, :store

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

      io.reopen(io.path, new_mode + 'b')
    end

  end

end

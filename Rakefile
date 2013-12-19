require File.expand_path(%q{../lib/libcdb/version}, __FILE__)

begin
  require 'hen'

  cco = []

  if dir = ENV['TINYCDB']
    cco << "--with-cdb-include=#{dir}"
    cco << "--with-cdb-lib=#{dir}"
  end

  if dir = ENV['MINGW32']
    cco << "--with-cflags=\"-I#{dir}/include -L#{dir}/lib\""
  end

  Hen.lay! {{
    :gem => {
      :name      => %q{libcdb-ruby},
      :version   => LibCDB::CDB::VERSION,
      :summary   => %q{Ruby bindings for CDB Constant Databases.},
      :author    => %q{Jens Wille},
      :email     => %q{jens.wille@gmail.com},
      :license   => %q{AGPL-3.0},
      :homepage  => :blackwinter,
      :extension => {
        :cross_config_options => cco,
        :ruby_versions => RUBY_VERSION
      },
      required_ruby_version: '>= 1.9.2'
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end

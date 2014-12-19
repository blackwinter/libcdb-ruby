require_relative 'lib/libcdb/version'

begin
  require 'hen'

  Hen.lay! {{
    gem: {
      name:      %q{libcdb-ruby},
      version:   LibCDB::CDB::VERSION,
      summary:   %q{Ruby bindings for CDB Constant Databases.},
      author:    %q{Jens Wille},
      email:     %q{jens.wille@gmail.com},
      license:   %q{AGPL-3.0},
      homepage:  :blackwinter,
      extension: { with_cross_cdb: lambda { |dir| [dir] } },

      required_ruby_version: '>= 1.9.3'
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end

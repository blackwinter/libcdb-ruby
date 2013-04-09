# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "libcdb-ruby"
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille"]
  s.date = "2012-08-09"
  s.description = "Ruby bindings for CDB Constant Databases."
  s.email = "jens.wille@gmail.com"
  s.extensions = ["ext/libcdb/extconf.rb"]
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog", "ext/libcdb/libcdb.c", "ext/libcdb/ruby_cdb.c", "ext/libcdb/ruby_cdb_reader.c", "ext/libcdb/ruby_cdb_writer.c"]
  s.files = ["lib/libcdb-ruby.rb", "lib/cdb.rb", "lib/libcdb/version.rb", "lib/libcdb.rb", "COPYING", "TODO", "ChangeLog", "Rakefile", "README", "ext/libcdb/ruby_cdb_writer.c", "ext/libcdb/ruby_cdb.h", "ext/libcdb/libcdb_ruby.def", "ext/libcdb/extconf.rb", "ext/libcdb/ruby_cdb_writer.h", "ext/libcdb/ruby_libcdb.h", "ext/libcdb/ruby_cdb_reader.h", "ext/libcdb/libcdb.c", "ext/libcdb/ruby_cdb_reader.c", "ext/libcdb/ruby_cdb.c", "spec/spec_helper.rb", "spec/libcdb/reader_spec.rb", "spec/libcdb/writer_spec.rb", ".rspec"]
  s.homepage = "http://github.com/blackwinter/libcdb-ruby"
  s.rdoc_options = ["--charset", "UTF-8", "--line-numbers", "--all", "--title", "libcdb-ruby Application documentation (v0.0.4)", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Ruby bindings for CDB Constant Databases."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "libcdb-ruby"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille"]
  s.date = "2013-08-03"
  s.description = "Ruby bindings for CDB Constant Databases."
  s.email = "jens.wille@gmail.com"
  s.extensions = ["ext/libcdb/extconf.rb"]
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog", "ext/libcdb/libcdb.c", "ext/libcdb/ruby_cdb.c", "ext/libcdb/ruby_cdb_reader.c", "ext/libcdb/ruby_cdb_writer.c"]
  s.files = ["lib/cdb.rb", "lib/libcdb-ruby.rb", "lib/libcdb.rb", "lib/libcdb/version.rb", "COPYING", "ChangeLog", "README", "Rakefile", "TODO", "ext/libcdb/extconf.rb", "ext/libcdb/libcdb.c", "ext/libcdb/libcdb_ruby.def", "ext/libcdb/ruby_cdb.c", "ext/libcdb/ruby_cdb.h", "ext/libcdb/ruby_cdb_reader.c", "ext/libcdb/ruby_cdb_reader.h", "ext/libcdb/ruby_cdb_writer.c", "ext/libcdb/ruby_cdb_writer.h", "ext/libcdb/ruby_libcdb.h", "spec/libcdb/reader_spec.rb", "spec/libcdb/writer_spec.rb", "spec/spec_helper.rb", ".rspec"]
  s.homepage = "http://github.com/blackwinter/libcdb-ruby"
  s.licenses = ["AGPL"]
  s.rdoc_options = ["--charset", "UTF-8", "--line-numbers", "--all", "--title", "libcdb-ruby Application documentation (v0.1.0)", "--main", "README"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubygems_version = "2.0.6"
  s.summary = "Ruby bindings for CDB Constant Databases."
end

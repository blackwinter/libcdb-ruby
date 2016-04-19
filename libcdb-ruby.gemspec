# -*- encoding: utf-8 -*-
# stub: libcdb-ruby 0.2.1 ruby lib
# stub: ext/libcdb/extconf.rb

Gem::Specification.new do |s|
  s.name = "libcdb-ruby".freeze
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jens Wille".freeze]
  s.date = "2016-04-19"
  s.description = "Ruby bindings for CDB Constant Databases.".freeze
  s.email = "jens.wille@gmail.com".freeze
  s.extensions = ["ext/libcdb/extconf.rb".freeze]
  s.extra_rdoc_files = ["README".freeze, "COPYING".freeze, "ChangeLog".freeze, "ext/libcdb/libcdb.c".freeze, "ext/libcdb/ruby_cdb.c".freeze, "ext/libcdb/ruby_cdb_reader.c".freeze, "ext/libcdb/ruby_cdb_writer.c".freeze]
  s.files = ["COPYING".freeze, "ChangeLog".freeze, "README".freeze, "Rakefile".freeze, "TODO".freeze, "ext/libcdb/extconf.rb".freeze, "ext/libcdb/libcdb.c".freeze, "ext/libcdb/libcdb_ruby.def".freeze, "ext/libcdb/ruby_cdb.c".freeze, "ext/libcdb/ruby_cdb.h".freeze, "ext/libcdb/ruby_cdb_reader.c".freeze, "ext/libcdb/ruby_cdb_reader.h".freeze, "ext/libcdb/ruby_cdb_writer.c".freeze, "ext/libcdb/ruby_cdb_writer.h".freeze, "ext/libcdb/ruby_libcdb.h".freeze, "lib/cdb.rb".freeze, "lib/libcdb-ruby.rb".freeze, "lib/libcdb.rb".freeze, "lib/libcdb/version.rb".freeze, "spec/data/empty.cdb".freeze, "spec/data/empty.dump".freeze, "spec/data/test.cdb".freeze, "spec/data/test.dump".freeze, "spec/libcdb/reader_spec.rb".freeze, "spec/libcdb/writer_spec.rb".freeze, "spec/spec_helper.rb".freeze]
  s.homepage = "http://github.com/blackwinter/libcdb-ruby".freeze
  s.licenses = ["AGPL-3.0".freeze]
  s.post_install_message = "\nlibcdb-ruby-0.2.1 [2016-04-19]:\n\n* Housekeeping.\n\n".freeze
  s.rdoc_options = ["--title".freeze, "libcdb-ruby Application documentation (v0.2.1)".freeze, "--charset".freeze, "UTF-8".freeze, "--line-numbers".freeze, "--all".freeze, "--main".freeze, "README".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "2.6.3".freeze
  s.summary = "Ruby bindings for CDB Constant Databases.".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hen>.freeze, [">= 0.8.3", "~> 0.8"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake-compiler>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
    else
      s.add_dependency(%q<hen>.freeze, [">= 0.8.3", "~> 0.8"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rake-compiler>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<hen>.freeze, [">= 0.8.3", "~> 0.8"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rake-compiler>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
  end
end

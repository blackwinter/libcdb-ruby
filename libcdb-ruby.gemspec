# -*- encoding: utf-8 -*-
# stub: libcdb-ruby 0.1.1 ruby lib
# stub: ext/libcdb/extconf.rb

Gem::Specification.new do |s|
  s.name = "libcdb-ruby"
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jens Wille"]
  s.date = "2014-04-25"
  s.description = "Ruby bindings for CDB Constant Databases."
  s.email = "jens.wille@gmail.com"
  s.extensions = ["ext/libcdb/extconf.rb"]
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog", "ext/libcdb/libcdb.c", "ext/libcdb/ruby_cdb.c", "ext/libcdb/ruby_cdb_reader.c", "ext/libcdb/ruby_cdb_writer.c"]
  s.files = ["COPYING", "ChangeLog", "README", "Rakefile", "TODO", "ext/libcdb/extconf.rb", "ext/libcdb/libcdb.c", "ext/libcdb/libcdb_ruby.def", "ext/libcdb/ruby_cdb.c", "ext/libcdb/ruby_cdb.h", "ext/libcdb/ruby_cdb_reader.c", "ext/libcdb/ruby_cdb_reader.h", "ext/libcdb/ruby_cdb_writer.c", "ext/libcdb/ruby_cdb_writer.h", "ext/libcdb/ruby_libcdb.h", "lib/cdb.rb", "lib/libcdb-ruby.rb", "lib/libcdb.rb", "lib/libcdb/version.rb", "spec/libcdb/reader_spec.rb", "spec/libcdb/writer_spec.rb", "spec/spec_helper.rb"]
  s.homepage = "http://github.com/blackwinter/libcdb-ruby"
  s.licenses = ["AGPL-3.0"]
  s.post_install_message = "\nlibcdb-ruby-0.1.1 [2014-04-25]:\n\n* <b>Dropped support for Ruby 1.9.2.</b>\n* Housekeeping.\n\n"
  s.rdoc_options = ["--title", "libcdb-ruby Application documentation (v0.1.1)", "--charset", "UTF-8", "--line-numbers", "--all", "--main", "README"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.2.2.x"
  s.summary = "Ruby bindings for CDB Constant Databases."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hen>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<hen>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<hen>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end

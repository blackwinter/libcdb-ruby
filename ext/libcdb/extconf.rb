require 'mkmf'

dir_config('cdb')

if have_library('cdb', 'cdb_init') && have_header('cdb.h') && have_macro('TINYCDB_VERSION', 'cdb.h')
  create_makefile('libcdb/libcdb_ruby')
else
  abort '*** ERROR: missing required library to compile this module'
end

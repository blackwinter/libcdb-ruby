#include "ruby_libcdb.h"

VALUE mLibCDB;

void
Init_libcdb_ruby(void) {
  /*
   * LibCDB namespace.
   */
  mLibCDB = rb_define_module("LibCDB");

  rcdb_init_cdb();
  rcdb_init_reader();
  rcdb_init_writer();
}

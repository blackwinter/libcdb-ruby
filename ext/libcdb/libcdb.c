#include "ruby_libcdb.h"

void
Init_libcdb_ruby(void) {
  char libcdb_version[8];
  snprintf(libcdb_version, 7, "%g", TINYCDB_VERSION);

  /*
   * LibCDB namespace.
   */
  mLibCDB = rb_define_module("LibCDB");

  rcdb_init_cdb();
  rcdb_init_reader();
  rcdb_init_writer();
}

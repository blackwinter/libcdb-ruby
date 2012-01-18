#include "ruby_libcdb.h"

void
rcdb_init_cdb(void) {
  char libcdb_version[8];
  snprintf(libcdb_version, 7, "%g", TINYCDB_VERSION);

  /*
   * See README.
   */
  cCDB = rb_define_class_under(mLibCDB, "CDB", rb_cObject);

  /* The TinyCDB library version. */
  rb_define_const(cCDB, "LIBCDB_VERSION", rb_str_new2(libcdb_version));
}

#ifndef RUBY_LIBCDB_H
#define RUBY_LIBCDB_H

#include <ruby.h>
#include <ruby/io.h>
#include <ruby/st.h>
#include <cdb.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>

#include "ruby_cdb.h"
#include "ruby_cdb_reader.h"
#include "ruby_cdb_writer.h"

extern VALUE mLibCDB;

#endif  /* RUBY_LIBCDB_H */

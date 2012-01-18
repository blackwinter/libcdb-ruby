#ifndef __RUBY_LIBCDB_H__
#define __RUBY_LIBCDB_H__

#include <ruby.h>
#if HAVE_RUBY_IO_H
#include <ruby/io.h>
#else
#include <rubyio.h>
#endif
#if HAVE_RUBY_ST_H
#include <ruby/st.h>
#else
#include <st.h>
#endif
#include <cdb.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>

#include "ruby_cdb.h"
#include "ruby_cdb_reader.h"
#include "ruby_cdb_writer.h"

VALUE mLibCDB;

#endif  /* __RUBY_LIBCDB_H__ */

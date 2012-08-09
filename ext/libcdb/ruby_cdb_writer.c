#include "ruby_libcdb.h"

VALUE cCDBWriter;

RCDB_DEFINE_ALLOC(writ, cdb_make)

/*
 * call-seq:
 *   writer.closed? -> true | false
 *
 * Whether _writer_ is closed.
 */
static VALUE
rcdb_writer_closed_p(VALUE self) {
  return rb_attr_get(self, rb_intern("closed"));
}

/*
 * call-seq:
 *   new(io) -> aWriter
 *
 * Creates a new Writer instance to interface with +io+. +io+ must be opened
 * for writing (+w+); in addition, it must be opened for read-write (<tt>w+</tt>)
 * if #insert or #replace are to be used.
 */
static VALUE
rcdb_writer_initialize(VALUE self, VALUE io) {
  RCDB_INITIALIZE(writ, WRIT, cdb_make, make_start)

  if (lseek(cdb_fileno(ptr), 0, SEEK_SET) == -1) {
    rb_sys_fail(0);
  }

  return self;
}

/* Helper method */
static int
rcdb_writer_push_pair(st_data_t key, st_data_t val, st_data_t ary) {
  rb_ary_push((VALUE)ary, rb_ary_new3(2, (VALUE)key, (VALUE)val));
  return ST_CONTINUE;
}

/* Helper method */
static void
rcdb_writer_put_pair(struct cdb_make *cdbm, VALUE key, VALUE val, enum cdb_put_mode mode) {
  StringValue(key);
  StringValue(val);

  if (cdb_make_put(cdbm,
        RSTRING_PTR(key), RSTRING_LEN(key),
        RSTRING_PTR(val), RSTRING_LEN(val),
        mode) == -1) {
    rb_sys_fail(0);
  }
}

/* Helper method */
static void
rcdb_writer_put_value(struct cdb_make *cdbm, VALUE key, VALUE val, enum cdb_put_mode mode) {
  long i;

  switch (TYPE(val)) {
    case T_ARRAY:
      switch (mode) {
        case CDB_PUT_REPLACE:
          /* remove any existing record */
          cdb_make_find(cdbm,
            RSTRING_PTR(key),
            RSTRING_LEN(key),
            CDB_FIND_REMOVE);

          /* add all */
          mode = CDB_PUT_ADD;

          break;
        case CDB_PUT_INSERT:
          /* see if key already exists */
          switch (cdb_make_exists(cdbm,
                    RSTRING_PTR(key),
                    RSTRING_LEN(key))) {
            case 0:
              /* doesn't exist, add all */
              mode = CDB_PUT_ADD;
              break;
            case -1:
              /* error */
              rb_sys_fail(0);
              break;
            default:
              /* ignore, won't add any */
              break;
          }

          break;
        default:
          /* no need to touch mode */
          break;
      }

      for (i = 0; i < RARRAY_LEN(val); i++) {
        rcdb_writer_put_pair(cdbm, key, RARRAY_PTR(val)[i], mode);
      }

      break;
    default:
      rcdb_writer_put_pair(cdbm, key, val, mode);
      break;
  }
}

/* Helper method */
static VALUE
rcdb_writer_put(int argc, VALUE *argv, VALUE self, enum cdb_put_mode mode) {
  struct cdb_make *cdbm = NULL;
  VALUE arg, val;
  long i;

  RCDB_WRITER_GET(self, cdbm);

  switch (argc) {
    case 1:
      arg = argv[0];

      switch (TYPE(arg)) {
        case T_ARRAY:
          val = rb_str_new2("");

          for (i = 0; i < RARRAY_LEN(arg); i++) {
            rcdb_writer_put_pair(cdbm, RARRAY_PTR(arg)[i], val, mode);
          }

          break;
        case T_HASH:
          val = rb_ary_new();
          st_foreach(RHASH_TBL(arg), rcdb_writer_push_pair, val);

          for (i = 0; i < RARRAY_LEN(val); i++) {
            rcdb_writer_put_value(cdbm,
              rb_ary_entry(RARRAY_PTR(val)[i], 0),
              rb_ary_entry(RARRAY_PTR(val)[i], 1),
              mode);
          }

          break;
        default:
          rb_raise(rb_eTypeError,
            "wrong argument type %s (expected Array or Hash)",
            rb_obj_classname(arg));

          break;
      }

      break;
    case 2:
      rcdb_writer_put_value(cdbm, argv[0], argv[1], mode);
      break;
    default:
      RCDB_RAISE_ARGS(1, 2)
      break;
  }

  return self;
}

/*
 * call-seq:
 *   writer.store(key, val) -> writer
 *   writer.store(key, [val, ...]) -> writer
 *   writer.store([key, ...]) -> writer
 *   writer.store({ key => val, ... }) -> writer
 *
 * Stores records in the database and returns _writer_. Records are stored
 * unconditionally, so duplicate keys will produce multiple records.
 *
 * If a single key/value pair is given, a record with key +key+ and value
 * +val+ is created; if +val+ is an array, one record per value is created
 * for +key+. If an array of keys is given, one record per key with an empty
 * value is created. If a hash of key/value pairs is given, one record per
 * key/value pair is created; the same logic as for a single key/value pair
 * applies.
 */
static VALUE
rcdb_writer_store(int argc, VALUE *argv, VALUE self) {
  return rcdb_writer_put(argc, argv, self, CDB_PUT_ADD);
}

/*
 * call-seq:
 *   writer.replace(key, val) -> writer
 *   writer.replace(key, [val, ...]) -> writer
 *   writer.replace([key, ...]) -> writer
 *   writer.replace({ key => val, ... }) -> writer
 *
 * Stores records in the database and returns _writer_. Records with
 * duplicate keys are replaced.
 *
 * The arguments are treated the same as in #store, so duplicate keys
 * <em>in the arguments</em> will produce multiple records.
 */
static VALUE
rcdb_writer_replace(int argc, VALUE *argv, VALUE self) {
  return rcdb_writer_put(argc, argv, self, CDB_PUT_REPLACE);
}

/*
 * call-seq:
 *   writer.insert(key, val) -> writer
 *   writer.insert(key, [val, ...]) -> writer
 *   writer.insert([key, ...]) -> writer
 *   writer.insert({ key => val, ... }) -> writer
 *
 * Stores records in the database and returns _writer_. Records will only
 * be inserted if they don't already exist in the database.
 *
 * The arguments are treated the same as in #store, so duplicate keys
 * <em>in the arguments</em> will produce multiple records.
 */
static VALUE
rcdb_writer_insert(int argc, VALUE *argv, VALUE self) {
  return rcdb_writer_put(argc, argv, self, CDB_PUT_INSERT);
}

/*
 * call-seq:
 *   writer.close -> nil
 *
 * Closes _writer_, as well as the underlying IO object.
 */
static VALUE
rcdb_writer_close(VALUE self) {
  struct cdb_make *cdbm = NULL;

  if (RTEST(rcdb_writer_closed_p(self))) {
    return Qnil;
  }

  RCDB_WRITER_GET(self, cdbm);
  rb_iv_set(self, "closed", Qtrue);

  if (cdb_make_finish(cdbm) == -1) {
    rb_sys_fail(0);
  }

  rb_io_close(rb_iv_get(self, "@io"));

  return Qnil;
}

RCDB_DEFINE_INSPECT(writ)

void rcdb_init_writer(void) {
  /*
   * The writer for creating CDB files. See Reader for reading them.
   */
  cCDBWriter = rb_define_class_under(cCDB, "Writer", rb_cObject);
  rb_define_alloc_func(cCDBWriter, rcdb_writer_alloc);

  rb_define_method(cCDBWriter, "close",      rcdb_writer_close,       0);
  rb_define_method(cCDBWriter, "closed?",    rcdb_writer_closed_p,    0);
  rb_define_method(cCDBWriter, "initialize", rcdb_writer_initialize,  1);
  rb_define_method(cCDBWriter, "insert",     rcdb_writer_insert,     -1);
  rb_define_method(cCDBWriter, "inspect",    rcdb_writer_inspect,     0);
  rb_define_method(cCDBWriter, "replace",    rcdb_writer_replace,    -1);
  rb_define_method(cCDBWriter, "store",      rcdb_writer_store,      -1);

  rb_define_alias(cCDBWriter, "<<",  "store");
  rb_define_alias(cCDBWriter, "[]=", "replace");
  rb_define_alias(cCDBWriter, "add", "store");
}

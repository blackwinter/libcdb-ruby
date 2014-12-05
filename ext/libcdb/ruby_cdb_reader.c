#include "ruby_libcdb.h"

VALUE cCDBReader;

RCDB_DEFINE_ALLOC(read, cdb)

/*
 * call-seq:
 *   reader.closed? -> true | false
 *
 * Whether _reader_ is closed.
 */
static VALUE
rcdb_reader_closed_p(VALUE self) {
  return rb_attr_get(self, rb_intern("closed"));
}

/*
 * call-seq:
 *   new(io) -> aReader
 *
 * Creates a new Reader instance to interface with +io+. +io+ must be opened
 * for reading (+r+).
 */
static VALUE
rcdb_reader_initialize(VALUE self, VALUE io) {
  RCDB_INITIALIZE(read, READ, cdb, init)
  rb_iv_set(self, "@encoding", rb_enc_default_external());
  return self;
}

RCDB_READER_DEFINE_READ(key)
RCDB_READER_DEFINE_READ(data)

/* Helper method */
static VALUE
rcdb_reader_iter_push(VALUE val, VALUE ary) {
  return rb_ary_push(ary, val);
}

/* Helper method */
static VALUE
rcdb_reader_iter_aset(VALUE pair, VALUE hash) {
  VALUE key = rb_ary_entry(pair, 0);
  VALUE val = rb_ary_entry(pair, 1);
  VALUE old = rb_hash_aref(hash, key);

  switch (TYPE(old)) {
    case T_NIL:
      rb_hash_aset(hash, key, val);
      break;
    case T_ARRAY:
      rb_ary_push(old, val);
      break;
    default:
      rb_hash_aset(hash, key, rb_ary_new3(2, old, val));
      break;
  }

  return Qnil;
}

/* Helper method */
static VALUE
rcdb_reader_break_equal(VALUE val, VALUE ary) {
  RCDB_READER_BREAK_EQUAL(val, Qtrue)
}

/* Helper method */
static VALUE
rcdb_reader_break_equal2(VALUE pair, VALUE ary) {
  RCDB_READER_BREAK_EQUAL(rb_ary_entry(pair, 1), rb_ary_entry(pair, 0))
}

/* Helper method */
static VALUE
rcdb_reader_break_shift(VALUE val, VALUE ary) {
  rb_ary_shift(ary);
  rb_iter_break();

  return Qnil;
}

/* Helper method */
static VALUE
rcdb_reader_iter_inc(VALUE val, long *i) {
  ++*i;
  return Qnil;
}

/* Helper method */
static VALUE
rcdb_reader_iter_dump(VALUE val, VALUE str) {
  rb_str_append(str, val);
  rb_str_cat2(str, "\n");

  return Qnil;
}

/* Helper method */
static VALUE
rcdb_reader_dump_pair(VALUE key, VALUE val) {
  VALUE str = rb_str_new2("");

  rb_str_cat2(str, "+");
  rb_str_append(str, RCDB_READER_STRING_LEN(key));
  rb_str_cat2(str, ",");
  rb_str_append(str, RCDB_READER_STRING_LEN(val));
  rb_str_cat2(str, ":");
  rb_str_append(str, key);
  rb_str_cat2(str, "->");
  rb_str_append(str, val);

  return str;
}

/* Helper method */
static VALUE
rcdb_reader_yield_dump(VALUE pair, VALUE ary) {
  return rb_yield(rcdb_reader_dump_pair(
    rb_ary_entry(pair, 0), rb_ary_entry(pair, 1)));
}

/* Helper method */
static VALUE
rcdb_reader_yield_dump2(VALUE val, VALUE ary) {
  return rb_yield(rcdb_reader_dump_pair(rb_ary_entry(ary, 0), val));
}

/*
 * call-seq:
 *   reader.each { |key, val| ... } -> reader
 *   reader.each(key) { |val| ... } -> reader
 *   reader.each([key]) -> anEnumerator
 *
 * Iterates over each key/value pair, or, if +key+ is given, each value
 * for +key+. Returns _reader_, or, if no block is given, an enumerator.
 */
static VALUE
rcdb_reader_each(int argc, VALUE *argv, VALUE self) {
  struct cdb *cdb = NULL;
  struct cdb_find cdbf;
  unsigned cdbp;
  VALUE key;

  RCDB_RETURN_ENUMERATOR(1);
  RCDB_READER_GET(self, cdb);

  if (rb_scan_args(argc, argv, "01", &key) == 1 && !NIL_P(key)) {
    StringValue(key);

    if (cdb_findinit(&cdbf, cdb, RSTRING_PTR(key), RSTRING_LEN(key)) == -1) {
      rb_sys_fail(0);
    }

    while (cdb_findnext(&cdbf) > 0) {
      rb_yield(RCDB_READER_READ(data));
    }
  }
  else {
    cdb_seqinit(&cdbp, cdb);

    while (cdb_seqnext(&cdbp, cdb) > 0) {
      rb_yield(rb_ary_new3(2,
        RCDB_READER_READ(key),
        RCDB_READER_READ(data)));
    }
  }

  return self;
}

/*
 * call-seq:
 *   reader.each_dump { |dump| ... } -> reader
 *   reader.each_dump(key) { |dump| ... } -> reader
 *   reader.each_dump([key]) -> anEnumerator
 *
 * Iterates over each record dump, or, if +key+ is given, each record dump
 * for +key+. Returns _reader_, or, if no block is given, an enumerator.
 */
static VALUE
rcdb_reader_each_dump(int argc, VALUE *argv, VALUE self) {
  VALUE key;

  RCDB_RETURN_ENUMERATOR(1);

  if (rb_scan_args(argc, argv, "01", &key) == 1 && !NIL_P(key)) {
    StringValue(key);

    RCDB_READER_ITERATE0(each, yield_dump2, rb_ary_new3(1, key))
  }
  else {
    RCDB_READER_ITERATE1(each, yield_dump, rb_ary_new())
  }

  return self;
}

/*
 * call-seq:
 *   reader.each_key { |key| ... } -> reader
 *   reader.each_key -> anEnumerator
 *
 * Iterates over each _unique_ key. Returns _reader_,
 * or, if no block is given, an enumerator.
 */
static VALUE
rcdb_reader_each_key(VALUE self) {
  struct cdb *cdb = NULL;
  unsigned cdbp;
  VALUE key, hash = rb_hash_new();

  RCDB_RETURN_ENUMERATOR_NONE;
  RCDB_READER_GET(self, cdb);
  cdb_seqinit(&cdbp, cdb);

  while (cdb_seqnext(&cdbp, cdb) > 0) {
    if (NIL_P(rb_hash_lookup(hash, key = RCDB_READER_READ(key)))) {
      rb_hash_aset(hash, key, Qtrue);
      rb_yield(key);
    }
  }

  return self;
}

/*
 * call-seq:
 *   reader.each_value { |val| ... } -> reader
 *   reader.each_value -> anEnumerator
 *
 * Iterates over each value. Returns _reader_,
 * or, if no block is given, an enumerator.
 */
static VALUE
rcdb_reader_each_value(VALUE self) {
  struct cdb *cdb = NULL;
  unsigned cdbp;

  RCDB_RETURN_ENUMERATOR_NONE;
  RCDB_READER_GET(self, cdb);
  cdb_seqinit(&cdbp, cdb);

  while (cdb_seqnext(&cdbp, cdb) > 0) {
    rb_yield(RCDB_READER_READ(data));
  }

  return self;
}

/*
 * call-seq:
 *   reader.fetch(key) -> anArray
 *
 * Fetch all values for +key+.
 */
static VALUE
rcdb_reader_fetch(VALUE self, VALUE key) {
  VALUE ary = rb_ary_new();
  RCDB_READER_ITERATE0(each, iter_push, ary)
  return ary;
}

/*
 * call-seq:
 *   reader.fetch_first(key) -> aString | nil
 *
 * Fetch first value for +key+. Returns +nil+ if +key+ was not found.
 */
static VALUE
rcdb_reader_fetch_first(VALUE self, VALUE key) {
  struct cdb *cdb = NULL;
  VALUE val = Qnil;

  StringValue(key);
  RCDB_READER_GET(self, cdb);

  if (cdb_find(cdb, RSTRING_PTR(key), RSTRING_LEN(key)) > 0) {
    val = RCDB_READER_READ(data);
  }

  return val;
}

/*
 * call-seq:
 *   reader.fetch_last(key) -> aString | nil
 *
 * Fetch last value for +key+. Returns +nil+ if +key+ was not found.
 */
static VALUE
rcdb_reader_fetch_last(VALUE self, VALUE key) {
  struct cdb *cdb = NULL;
  struct cdb_find cdbf;
  VALUE val = Qnil;
  unsigned pos = 0;
  size_t len = 0;

  StringValue(key);
  RCDB_READER_GET(self, cdb);

  if (cdb_findinit(&cdbf, cdb, RSTRING_PTR(key), RSTRING_LEN(key)) == -1) {
    rb_sys_fail(0);
  }

  while (cdb_findnext(&cdbf) > 0) {
    pos = cdb_datapos(cdb);
    len = cdb_datalen(cdb);
  }

  if (pos > 0) {
    val = rb_str_buf_new(len);
    cdb_read(cdb, RSTRING_PTR(val), len, pos);
    rb_str_set_len(val, len);
  }

  return val;
}

/*
 * call-seq:
 *   reader.keys -> anArray
 *
 * Returns an array of all _unique_ keys.
 */
static VALUE
rcdb_reader_keys(VALUE self) {
  RCDB_READER_ITERATE(each_key, iter_push, rb_ary_new())
}

/*
 * call-seq:
 *   reader.values -> anArray
 *
 * Returns an array of all values.
 */
static VALUE
rcdb_reader_values(VALUE self) {
  RCDB_READER_ITERATE(each_value, iter_push, rb_ary_new())
}

/*
 * call-seq:
 *   reader.values_at(key, ...) -> anArray
 *
 * Returns an array containing the values associated with the given keys.
 */
static VALUE
rcdb_reader_values_at(int argc, VALUE *argv, VALUE self) {
  VALUE ary = rb_ary_new();
  int i;

  for (i = 0; i < argc; i++) {
    rb_ary_push(ary, rcdb_reader_fetch(self, argv[i]));
  }

  return ary;
}

/*
 * call-seq:
 *   reader.has_key?(key) -> true | false
 *
 * Whether key +key+ exists in the database.
 */
static VALUE
rcdb_reader_has_key_p(VALUE self, VALUE key) {
  RCDB_READER_ITERATE_ARY(each_key, break_equal,
    rb_ary_new3(2, Qfalse, key))
}

/*
 * call-seq:
 *   reader.has_value?(val) -> true | false
 *
 * Whether value +val+ exists in the database.
 */
static VALUE
rcdb_reader_has_value_p(VALUE self, VALUE val) {
  RCDB_READER_ITERATE_ARY(each_value, break_equal,
    rb_ary_new3(2, Qfalse, val))
}

/*
 * call-seq:
 *   reader.key(val) -> aString | nil
 *
 * Returns the first key associated with value
 * +val+, or +nil+ if +val+ was not found.
 */
static VALUE
rcdb_reader_key(VALUE self, VALUE val) {
  RCDB_READER_ITERATE_ARY(each, break_equal2,
    rb_ary_new3(2, Qnil, val))
}

/*
 * call-seq:
 *   reader.empty? -> true | false
 *
 * Whether the database is empty.
 */
static VALUE
rcdb_reader_empty_p(VALUE self) {
  RCDB_READER_ITERATE_ARY(each_key, break_shift,
    rb_ary_new3(2, Qtrue, Qfalse))
}

/*
 * call-seq:
 *   reader.size -> anInteger
 *
 * The number of _unique_ records in the database. Cf. #total.
 */
static VALUE
rcdb_reader_size(VALUE self) {
  long i = 0;
  RCDB_READER_ITERATE1(each_key, iter_inc, (VALUE)&i)
  return LONG2NUM(i);
}

/*
 * call-seq:
 *   reader.total -> anInteger
 *
 * The number of _total_ records in the database. Cf. #size.
 */
static VALUE
rcdb_reader_total(VALUE self) {
  struct cdb *cdb = NULL;
  unsigned cdbp;
  long i = 0;

  RCDB_READER_GET(self, cdb);
  cdb_seqinit(&cdbp, cdb);

  while (cdb_seqnext(&cdbp, cdb) > 0) {
    ++i;
  }

  return LONG2NUM(i);
}

/*
 * call-seq:
 *   reader.dump -> aString
 *
 * Returns a dump of the database.
 */
static VALUE
rcdb_reader_dump(VALUE self) {
  RCDB_READER_ITERATE(each_dump, iter_dump, rb_str_new2(""))
}

/*
 * call-seq:
 *   reader.to_h -> aHash
 *
 * Converts the database into a hash of #size keys associated with
 * their value, or, if there are multiple, an array of their values.
 *
 *   reader.to_h.size == reader.size
 */
static VALUE
rcdb_reader_to_h(VALUE self) {
  RCDB_READER_ITERATE(each, iter_aset, rb_hash_new())
}

/*
 * call-seq:
 *   reader.to_a -> anArray
 *
 * Converts the database into an array of #total key/value pairs.
 *
 *   reader.to_a.size == reader.total
 */
static VALUE
rcdb_reader_to_a(VALUE self) {
  RCDB_READER_ITERATE(each, iter_push, rb_ary_new())
}

/*
 * call-seq:
 *   reader.close -> nil
 *
 * Closes _reader_, as well as the underlying IO object.
 */
static VALUE
rcdb_reader_close(VALUE self) {
  struct cdb *cdb = NULL;

  if (RTEST(rcdb_reader_closed_p(self))) {
    return Qnil;
  }

  RCDB_READER_GET(self, cdb);
  rb_iv_set(self, "closed", Qtrue);

  cdb_free(cdb);
  rb_io_close(rb_iv_get(self, "@io"));

  return Qnil;
}

RCDB_DEFINE_INSPECT(read)

void
rcdb_init_reader(void) {
  /*
   * The reader for reading CDB files. See Writer for creating them.
   */
  cCDBReader = rb_define_class_under(cCDB, "Reader", rb_cObject);
  rb_define_alloc_func(cCDBReader, rcdb_reader_alloc);
  rb_include_module(cCDBReader, rb_mEnumerable);

  rb_define_attr(cCDBReader, "encoding", 1, 1);

  rb_define_method(cCDBReader, "close",       rcdb_reader_close,        0);
  rb_define_method(cCDBReader, "closed?",     rcdb_reader_closed_p,     0);
  rb_define_method(cCDBReader, "dump",        rcdb_reader_dump,         0);
  rb_define_method(cCDBReader, "each",        rcdb_reader_each,        -1);
  rb_define_method(cCDBReader, "each_dump",   rcdb_reader_each_dump,   -1);
  rb_define_method(cCDBReader, "each_key",    rcdb_reader_each_key,     0);
  rb_define_method(cCDBReader, "each_value",  rcdb_reader_each_value,   0);
  rb_define_method(cCDBReader, "empty?",      rcdb_reader_empty_p,      0);
  rb_define_method(cCDBReader, "fetch",       rcdb_reader_fetch,        1);
  rb_define_method(cCDBReader, "fetch_first", rcdb_reader_fetch_first,  1);
  rb_define_method(cCDBReader, "fetch_last",  rcdb_reader_fetch_last,   1);
  rb_define_method(cCDBReader, "has_key?",    rcdb_reader_has_key_p,    1);
  rb_define_method(cCDBReader, "has_value?",  rcdb_reader_has_value_p,  1);
  rb_define_method(cCDBReader, "initialize",  rcdb_reader_initialize,   1);
  rb_define_method(cCDBReader, "inspect",     rcdb_reader_inspect,      0);
  rb_define_method(cCDBReader, "key",         rcdb_reader_key,          1);
  rb_define_method(cCDBReader, "keys",        rcdb_reader_keys,         0);
  rb_define_method(cCDBReader, "size",        rcdb_reader_size,         0);
  rb_define_method(cCDBReader, "to_a",        rcdb_reader_to_a,         0);
  rb_define_method(cCDBReader, "to_h",        rcdb_reader_to_h,         0);
  rb_define_method(cCDBReader, "total",       rcdb_reader_total,        0);
  rb_define_method(cCDBReader, "values",      rcdb_reader_values,       0);
  rb_define_method(cCDBReader, "values_at",   rcdb_reader_values_at,   -1);

  rb_define_alias(cCDBReader, "[]",        "fetch_first");
  rb_define_alias(cCDBReader, "fetch_all", "fetch");
  rb_define_alias(cCDBReader, "get",       "fetch_first");
  rb_define_alias(cCDBReader, "include?",  "has_key?");
  rb_define_alias(cCDBReader, "key?",      "has_key?");
  rb_define_alias(cCDBReader, "length",    "size");
  rb_define_alias(cCDBReader, "member?",   "has_key?");
  rb_define_alias(cCDBReader, "rget",      "fetch_last");
  rb_define_alias(cCDBReader, "value?",    "has_value?");
}

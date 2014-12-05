#ifndef RCDB_READER_H
#define RCDB_READER_H

#define RCDB_READER_GET(obj, ptr) RCDB_GET_STRUCT(read, cdb, obj, ptr)

#define RCDB_READER_ITERATE0(method, block, arg) \
  rb_block_call(self, rb_intern(#method), 1, &key, rcdb_reader_##block, arg);

#define RCDB_READER_ITERATE1(method, block, arg) \
  VALUE ret = arg;\
  rb_block_call(self, rb_intern(#method), 0, 0, rcdb_reader_##block, ret);

#define RCDB_READER_ITERATE(method, block, arg) \
  RCDB_READER_ITERATE1(method, block, arg)\
  return ret;

#define RCDB_READER_ITERATE_ARY(method, block, arg) \
  RCDB_READER_ITERATE1(method, block, arg)\
  return rb_ary_entry(ret, 0);

#define RCDB_READER_BREAK_EQUAL(val, ret) \
  if (RTEST(rb_funcall(val, rb_intern("=="), 1, rb_ary_entry(ary, 1)))) {\
    rb_ary_store(ary, 0, ret);\
    rb_iter_break();\
  }\
\
  return Qnil;

#define RCDB_READER_DEFINE_READ(what) \
static VALUE \
rcdb_reader_read_##what(struct cdb *cdb) {\
  size_t len = cdb_##what##len(cdb);\
  VALUE ret = rb_str_buf_new(len);\
\
  cdb_read(cdb, RSTRING_PTR(ret), len, cdb_##what##pos(cdb));\
  rb_str_set_len(ret, len);\
\
  return ret;\
}

#define RCDB_READER_READ(what) rb_funcall(rcdb_reader_read_##what(cdb),\
  rb_intern("force_encoding"), 1, rb_iv_get(self, "@encoding"))

#define RCDB_READER_STRING_LEN(str) \
  rb_funcall(LONG2NUM(RSTRING_LEN(str)), rb_intern("to_s"), 0)

extern VALUE cCDBReader;
void rcdb_init_reader(void);

#endif /* RCDB_READER_H */

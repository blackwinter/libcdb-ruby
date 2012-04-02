#ifndef __RCDB_READER_H__
#define __RCDB_READER_H__

#define RCDB_READER_GET(obj, ptr) RCDB_GET_STRUCT(read, cdb, obj, ptr)

#define RCDB_READER_DEFINE_CALL(iter) \
static VALUE \
_rcdb_reader_call_##iter(VALUE args) {\
  VALUE self = rb_ary_shift(args);\
  return rb_funcall2(self, rb_intern(#iter),\
    RARRAY_LEN(args), RARRAY_PTR(args));\
}

#define RCDB_READER_ITERATE0(method, block, arg1, arg2) \
  VALUE arg = arg1;\
  rb_iterate(_rcdb_reader_call_##method, arg2, _rcdb_reader_##block, arg);

#define RCDB_READER_ITERATE1(method, block, arg1) \
  RCDB_READER_ITERATE0(method, block, arg1, rb_ary_new3(1, self))

#define RCDB_READER_ITERATE(method, block, arg1) \
  RCDB_READER_ITERATE1(method, block, arg1)\
  return arg;

#define RCDB_READER_ITERATE_ARY(method, block, arg1) \
  RCDB_READER_ITERATE1(method, block, arg1)\
  return rb_ary_entry(arg, 0);

#define RCDB_READER_BREAK_EQUAL(val, ret) \
  if (RTEST(rb_funcall(val, rb_intern("=="), 1, rb_ary_entry(ary, 1)))) {\
    rb_ary_store(ary, 0, ret);\
    rb_iter_break();\
  }\
\
  return Qnil;

#define RCDB_READER_DEFINE_READ(what) \
static VALUE \
_rcdb_reader_read_##what(struct cdb *cdb) {\
  size_t len;\
  VALUE ret;\
\
  len = cdb_##what##len(cdb);\
  ret = rb_str_buf_new(len);\
\
  cdb_read(cdb, RSTRING_PTR(ret), len, cdb_##what##pos(cdb));\
  rb_str_set_len(ret, len);\
\
  return ret;\
}

extern VALUE cCDBReader;
void rcdb_init_reader(void);

#endif /* __RCDB_READER_H__ */

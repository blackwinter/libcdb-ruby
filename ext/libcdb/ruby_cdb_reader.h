#ifndef __RCDB_READER_H__
#define __RCDB_READER_H__

#define Get_CDB_Reader(obj, var) {\
  if (RTEST(rcdb_reader_closed_p(obj))) {\
    rb_raise(rb_eRuntimeError, "closed stream");\
  }\
  else {\
    Data_Get_Struct((obj), struct cdb, (var));\
  }\
}

#define CALL_ITERATOR(iter) {\
  VALUE self = rb_ary_shift(args);\
  return rb_funcall2(self, rb_intern(iter),\
    RARRAY_LEN(args), RARRAY_PTR(args));\
}

#define ITER_RESULT(method, block) {\
  rb_iterate(method, rb_ary_new3(1, self), block, ary);\
  return rb_ary_entry(ary, 0);\
}

#define VALUE_EQUAL(val) \
  RTEST(rb_funcall((val), rb_intern("=="), 1, rb_ary_entry(ary, 1)))

VALUE cCDBReader;
void rcdb_init_reader(void);

#endif /* __RCDB_READER_H__ */

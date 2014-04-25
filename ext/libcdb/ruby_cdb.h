#ifndef RUBY_CDB_H
#define RUBY_CDB_H

#define RCDB_GET_STRUCT(what, _struct, obj, ptr) \
  if (RTEST(rcdb_##what##er_closed_p(obj))) {\
    rb_raise(rb_eIOError, "closed stream");\
  }\
  else {\
    Data_Get_Struct((obj), struct _struct, (ptr));\
  }\

#define RCDB_DEFINE_ALLOC(what, _struct) \
static void \
rcdb_##what##er_free(void *ptr) {\
  xfree(ptr);\
}\
\
static VALUE \
rcdb_##what##er_alloc(VALUE klass) {\
  struct _struct *ptr = ALLOC(struct _struct);\
  return Data_Wrap_Struct(klass, NULL, rcdb_##what##er_free, ptr);\
}

#define RCDB_INITIALIZE(what, WHAT, _struct, init) \
  struct _struct *ptr = NULL;\
  rb_io_t *fptr;\
\
  Check_Type(io, T_FILE);\
  GetOpenFile(io, fptr);\
\
  rb_io_check_##what##able(fptr);\
  rb_iv_set(self, "@io", io);\
  rb_iv_set(self, "closed", Qfalse);\
\
  RCDB_##WHAT##ER_GET(self, ptr);\
\
  if (cdb_##init(ptr, fptr->fd) == -1) {\
    rb_sys_fail(0);\
  }

#define RCDB_RAISE_ARGS(min, max) \
  rb_raise(rb_eArgError,\
    "wrong number of arguments (%d for " #min "-" #max ")", argc);

#define RCDB_RETURN_ENUMERATOR(self, argc, argv, max) \
  if (argc > max) {\
    RCDB_RAISE_ARGS(0, max)\
  }\
\
  RETURN_ENUMERATOR(self, argc, argv)

#define RCDB_DEFINE_INSPECT(what) \
static VALUE \
rcdb_##what##er_inspect(VALUE self) {\
  VALUE str = rb_call_super(0, NULL);\
\
  if (RTEST(rcdb_##what##er_closed_p(self))) {\
    rb_funcall(str,\
      rb_intern("insert"), 2, INT2FIX(-2), rb_str_new2(" (closed)"));\
  }\
\
  return str;\
}

extern VALUE cCDB;
void rcdb_init_cdb(void);

#endif  /* RUBY_CDB_H */

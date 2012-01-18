#ifndef __RCDB_WRITER_H__
#define __RCDB_WRITER_H__

#define Get_CDB_Writer(obj, var) {\
  if (RTEST(rcdb_writer_closed_p(obj))) {\
    rb_raise(rb_eRuntimeError, "closed stream");\
  }\
  else {\
    Data_Get_Struct((obj), struct cdb_make, (var));\
  }\
}

VALUE cCDBWriter;
void rcdb_init_writer(void);

#endif  /* __RCDB_WRITER_H__ */

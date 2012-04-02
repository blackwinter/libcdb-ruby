#ifndef __RCDB_WRITER_H__
#define __RCDB_WRITER_H__

#define RCDB_WRITER_GET(obj, ptr) RCDB_GET_STRUCT(writ, cdb_make, obj, ptr)

extern VALUE cCDBWriter;
void rcdb_init_writer(void);

#endif  /* __RCDB_WRITER_H__ */

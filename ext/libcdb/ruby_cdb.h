#ifndef __RUBY_CDB_H__
#define __RUBY_CDB_H__

#ifdef HAVE_RUBY_IO_H
#define GetFileFD(fptr) (fptr)->fd
#else
#define GetFileFD(fptr) fileno((fptr)->f)
#endif

VALUE cCDB;
void rcdb_init_cdb(void);

#endif  /* __RUBY_CDB_H__ */

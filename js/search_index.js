var search_data = {"index":{"info":[["LibCDB","","LibCDB.html","","<p>LibCDB namespace.\n"],["LibCDB::CDB","","LibCDB/CDB.html","","<p>See README.\n"],["LibCDB::CDB::Reader","","LibCDB/CDB/Reader.html","","<p>The reader for reading CDB files. See Writer for creating them.\n"],["LibCDB::CDB::Version","","LibCDB/CDB/Version.html","",""],["LibCDB::CDB::Writer","","LibCDB/CDB/Writer.html","","<p>The writer for creating CDB files. See Reader for reading them.\n"],["Object","","Object.html","",""],["<<","LibCDB::CDB::Writer","LibCDB/CDB/Writer.html#method-i-3C-3C","(*args)",""],["[]","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-5B-5D","(p1)",""],["[]=","LibCDB::CDB::Writer","LibCDB/CDB/Writer.html#method-i-5B-5D-3D","(*args)",""],["add","LibCDB::CDB::Writer","LibCDB/CDB/Writer.html#method-i-add","(*args)",""],["close","LibCDB::CDB","LibCDB/CDB.html#method-i-close","()","<p>Closes both the #reader and the #writer, as well as #io. Doesn’t raise an\nIOError if either of them is …\n"],["close","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-close","()","<p>Closes <em>reader</em>, as well as the underlying IO object.\n"],["close","LibCDB::CDB::Writer","LibCDB/CDB/Writer.html#method-i-close","()","<p>Closes <em>writer</em>, as well as the underlying IO object.\n"],["close_read","LibCDB::CDB","LibCDB/CDB.html#method-i-close_read","(strict = true)","<p>If <em>cdb</em> is currently opened for reading, closes the #reader (and\n#io with it). Otherwise, if <code>strict</code> is …\n"],["close_write","LibCDB::CDB","LibCDB/CDB.html#method-i-close_write","(strict = true)","<p>If <em>cdb</em> is currently opened for writing, closes the #writer (and\n#io with it). Otherwise, if <code>strict</code> is …\n"],["closed?","LibCDB::CDB","LibCDB/CDB.html#method-i-closed-3F","()","<p>Whether <em>cdb</em> is closed. See #closed_read? and #closed_write?.\n"],["closed?","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-closed-3F","()","<p>Whether <em>reader</em> is closed.\n"],["closed?","LibCDB::CDB::Writer","LibCDB/CDB/Writer.html#method-i-closed-3F","()","<p>Whether <em>writer</em> is closed.\n"],["closed_read?","LibCDB::CDB","LibCDB/CDB.html#method-i-closed_read-3F","()","<p>Whether #reader is closed if <em>cdb</em> is currently opened for reading.\n"],["closed_write?","LibCDB::CDB","LibCDB/CDB.html#method-i-closed_write-3F","()","<p>Whether #writer is closed if <em>cdb</em> is currently opened for writing.\n"],["dump","LibCDB::CDB","LibCDB/CDB.html#method-c-dump","(path, target = '', separator = $\\ || $/)","<p>Opens <code>path</code> for reading and shovels each record dump into\n<code>target</code> (followed by <code>separator</code>, if present). …\n"],["dump","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-dump","()","<p>Returns a dump of the database.\n"],["each","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-each","(p1 = v1)","<p>Iterates over each key/value pair, or, if <code>key</code> is given, each\nvalue for <code>key</code>. Returns <em>reader</em>, or, if no …\n"],["each_dump","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-each_dump","(p1 = v1)","<p>Iterates over each record dump, or, if <code>key</code> is given, each\nrecord dump for <code>key</code>. Returns <em>reader</em>, or, if …\n"],["each_key","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-each_key","()","<p>Iterates over each <em>unique</em> key. Returns <em>reader</em>, or, if no\nblock is given, an enumerator.\n"],["each_value","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-each_value","()","<p>Iterates over each value. Returns <em>reader</em>, or, if no block is\ngiven, an enumerator.\n"],["empty?","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-empty-3F","()","<p>Whether the database is empty.\n"],["fetch","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-fetch","(p1)","<p>Fetch all values for <code>key</code>.\n"],["fetch_all","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-fetch_all","(p1)",""],["fetch_first","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-fetch_first","(p1)","<p>Fetch first value for <code>key</code>. Returns <code>nil</code> if\n<code>key</code> was not found.\n"],["fetch_last","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-fetch_last","(p1)","<p>Fetch last value for <code>key</code>. Returns <code>nil</code> if\n<code>key</code> was not found.\n"],["foreach","LibCDB::CDB","LibCDB/CDB.html#method-c-foreach","(path, *key)","<p>Opens <code>path</code> for reading and iterates over each key/value pair,\nor, if <code>key</code> is given, each value for <code>key</code> …\n"],["get","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-get","(p1)",""],["has_key?","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-has_key-3F","(p1)","<p>Whether key <code>key</code> exists in the database.\n"],["has_value?","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-has_value-3F","(p1)","<p>Whether value <code>val</code> exists in the database.\n"],["include?","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-include-3F","(p1)",""],["insert","LibCDB::CDB::Writer","LibCDB/CDB/Writer.html#method-i-insert","(*args)","<p>Stores records in the database and returns <em>writer</em>. Records will\nonly be inserted if they don’t already …\n"],["key","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-key","(p1)","<p>Returns the first key associated with value <code>val</code>, or\n<code>nil</code> if <code>val</code> was not found.\n"],["key?","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-key-3F","(p1)",""],["keys","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-keys","()","<p>Returns an array of all <em>unique</em> keys.\n"],["length","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-length","()",""],["member?","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-member-3F","(p1)",""],["new","LibCDB::CDB","LibCDB/CDB.html#method-c-new","(io, mode = MODE_WRITE)","<p>Creates a new CDB object to interface with <code>io</code>.\n<code>mode</code> must be the same mode <code>io</code> was opened in,\neither <code>r</code> …\n"],["new","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-c-new","(p1)","<p>Creates a new Reader instance to interface with <code>io</code>.\n<code>io</code> must be opened for reading (<code>r</code>).\n"],["new","LibCDB::CDB::Writer","LibCDB/CDB/Writer.html#method-c-new","(p1)","<p>Creates a new Writer instance to interface with <code>io</code>.\n<code>io</code> must be opened for writing (<code>w</code>); in addition,\nit …\n"],["open","LibCDB::CDB","LibCDB/CDB.html#method-c-open","(path, mode = MODE_READ)","<p>Opens <code>path</code> with <code>mode</code>. If a block is given, yields\na <em>cdb</em> object according to <code>mode</code> (see below) and\nreturns …\n"],["open_read","LibCDB::CDB","LibCDB/CDB.html#method-i-open_read","()","<p>Opens <em>cdb</em> for reading and reopens #io accordingly. Closes #writer\nif open.\n"],["open_write","LibCDB::CDB","LibCDB/CDB.html#method-i-open_write","()","<p>Opens <em>cdb</em> for writing and reopens #io accordingly. Closes #reader\nif open. Note that #io will be truncated. …\n"],["read?","LibCDB::CDB","LibCDB/CDB.html#method-i-read-3F","()","<p>Whether <em>cdb</em> is currently opened for reading.\n"],["reader","LibCDB::CDB","LibCDB/CDB.html#method-i-reader","()","<p>The Reader object associated with <em>cdb</em>.\n"],["reopen","LibCDB::CDB","LibCDB/CDB.html#method-i-reopen","(new_mode = MODE_READ)","<p>Reopens #io in <code>mode</code> and returns it.\n"],["replace","LibCDB::CDB::Writer","LibCDB/CDB/Writer.html#method-i-replace","(*args)","<p>Stores records in the database and returns <em>writer</em>. Records with\nduplicate keys are replaced.\n<p>The arguments …\n"],["rget","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-rget","(p1)",""],["size","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-size","()","<p>The number of <em>unique</em> records in the database. Cf. #total.\n"],["store","LibCDB::CDB::Writer","LibCDB/CDB/Writer.html#method-i-store","(*args)","<p>Stores records in the database and returns <em>writer</em>. Records are\nstored unconditionally, so duplicate keys …\n"],["to_a","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-to_a","()","<p>Converts the database into an array of #total key/value pairs.\n\n<pre>reader.to_a.size == reader.total</pre>\n"],["to_a","LibCDB::CDB::Version","LibCDB/CDB/Version.html#method-c-to_a","()","<p>Returns array representation.\n"],["to_h","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-to_h","()","<p>Converts the database into a hash of #size keys associated with their\nvalue, or, if there are multiple, …\n"],["to_s","LibCDB::CDB::Version","LibCDB/CDB/Version.html#method-c-to_s","()","<p>Short-cut for version string.\n"],["total","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-total","()","<p>The number of <em>total</em> records in the database. Cf. #size.\n"],["value?","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-value-3F","(p1)",""],["values","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-values","()","<p>Returns an array of all values.\n"],["values_at","LibCDB::CDB::Reader","LibCDB/CDB/Reader.html#method-i-values_at","(*args)","<p>Returns an array containing the values associated with the given keys.\n"],["write?","LibCDB::CDB","LibCDB/CDB.html#method-i-write-3F","()","<p>Whether <em>cdb</em> is currently opened for writing.\n"],["writer","LibCDB::CDB","LibCDB/CDB.html#method-i-writer","()","<p>The Writer object associated with <em>cdb</em>.\n"],["COPYING","","COPYING.html","","<p>License for libcdb-ruby\n\n<pre>                    GNU AFFERO GENERAL PUBLIC LICENSE\n                       Version ...</pre>\n"],["ChangeLog","","ChangeLog.html","","<p>Revision history for libcdb-ruby\n<p>0.0.2 [2012-01-20]\n<p>Refactored C code to DRY.\n"],["README","","README.html","","<p>libcdb-ruby - Ruby bindings for CDB Constant Databases.\n<p>VERSION\n<p>This documentation refers to libcdb-ruby …\n"]],"searchIndex":["libcdb","cdb","reader","version","writer","object","<<()","[]()","[]=()","add()","close()","close()","close()","close_read()","close_write()","closed?()","closed?()","closed?()","closed_read?()","closed_write?()","dump()","dump()","each()","each_dump()","each_key()","each_value()","empty?()","fetch()","fetch_all()","fetch_first()","fetch_last()","foreach()","get()","has_key?()","has_value?()","include?()","insert()","key()","key?()","keys()","length()","member?()","new()","new()","new()","open()","open_read()","open_write()","read?()","reader()","reopen()","replace()","rget()","size()","store()","to_a()","to_a()","to_h()","to_s()","total()","value?()","values()","values_at()","write?()","writer()","copying","changelog","readme"],"longSearchIndex":["libcdb","libcdb::cdb","libcdb::cdb::reader","libcdb::cdb::version","libcdb::cdb::writer","object","libcdb::cdb::writer#<<()","libcdb::cdb::reader#[]()","libcdb::cdb::writer#[]=()","libcdb::cdb::writer#add()","libcdb::cdb#close()","libcdb::cdb::reader#close()","libcdb::cdb::writer#close()","libcdb::cdb#close_read()","libcdb::cdb#close_write()","libcdb::cdb#closed?()","libcdb::cdb::reader#closed?()","libcdb::cdb::writer#closed?()","libcdb::cdb#closed_read?()","libcdb::cdb#closed_write?()","libcdb::cdb::dump()","libcdb::cdb::reader#dump()","libcdb::cdb::reader#each()","libcdb::cdb::reader#each_dump()","libcdb::cdb::reader#each_key()","libcdb::cdb::reader#each_value()","libcdb::cdb::reader#empty?()","libcdb::cdb::reader#fetch()","libcdb::cdb::reader#fetch_all()","libcdb::cdb::reader#fetch_first()","libcdb::cdb::reader#fetch_last()","libcdb::cdb::foreach()","libcdb::cdb::reader#get()","libcdb::cdb::reader#has_key?()","libcdb::cdb::reader#has_value?()","libcdb::cdb::reader#include?()","libcdb::cdb::writer#insert()","libcdb::cdb::reader#key()","libcdb::cdb::reader#key?()","libcdb::cdb::reader#keys()","libcdb::cdb::reader#length()","libcdb::cdb::reader#member?()","libcdb::cdb::new()","libcdb::cdb::reader::new()","libcdb::cdb::writer::new()","libcdb::cdb::open()","libcdb::cdb#open_read()","libcdb::cdb#open_write()","libcdb::cdb#read?()","libcdb::cdb#reader()","libcdb::cdb#reopen()","libcdb::cdb::writer#replace()","libcdb::cdb::reader#rget()","libcdb::cdb::reader#size()","libcdb::cdb::writer#store()","libcdb::cdb::reader#to_a()","libcdb::cdb::version::to_a()","libcdb::cdb::reader#to_h()","libcdb::cdb::version::to_s()","libcdb::cdb::reader#total()","libcdb::cdb::reader#value?()","libcdb::cdb::reader#values()","libcdb::cdb::reader#values_at()","libcdb::cdb#write?()","libcdb::cdb#writer()","","",""]}}
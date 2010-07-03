#!/bin/sh

#
# fastpack - a simple App::FatPacker helper
#

fatpack trace -Ilib -e 'use Hitagi; use Try::Tiny;use Devel::StackTrace;use Devel::StackTrace::AsHTML;'

# optional things: Sub::Name
egrep -v '^(File/Spec.pm|File/Spec/Unix.pm|Scalar/Util.pm|List/Util.pm|Sub/Name.pm|IO.pm|IO/Seekable.pm|IO/Handle.pm|Data/Dumper.pm|Cwd.pm|IO/File.pm|Storable.pm)$' fatpacker.trace | \
    egrep -v '^(Digest/SHA1.pm|Log/Agent.pm|Log/Agent/Priorities.pm|Log/Agent/Formatting.pm|Log/Agent/Message.pm)$' | \
    egrep -v '^(DB/Schema.pm)$' | \
    # require these modules on the server
    egrep -v '^(DBI.pm|auto/DBI/DESTROY.al|HTTP/Message.pm)$' > fatpacker.trace2

PERL5LIB=lib:$PERL5LIB fatpack packlists-for `cat fatpacker.trace2` > fatpacker.packlists
fatpack tree `cat fatpacker.packlists`
[ -d lib ] || mkdir lib

fatpack file > hitagi.pl
echo "1;" >> hitagi.pl


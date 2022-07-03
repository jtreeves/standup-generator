use Test::Simple tests => 1;
use Cwd;
use StandupGenerator qw( find_last_file );

my $BASE = getcwd;
 
ok( find_last_file("${BASE}/data") eq 's1d03.txt', 'can find last file' );

1;
use Test::Simple tests => 2;
use Cwd;
use StandupGenerator qw( find_last_file );

my $BASE = getcwd;
 
ok( find_last_file("${BASE}/data") eq 's1d03.txt', 'can find last file in directory with standups' );
ok( find_last_file("${BASE}") eq 's0d0.txt', 'will designate dummy file as last file in directory without standups' );

1;
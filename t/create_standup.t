use Test::Simple tests => 2;
use Cwd;
use StandupGenerator qw( create_standup );

my $BASE = getcwd;
 
ok( create_standup("${BASE}/data") eq 's1d04.txt', 'will increment standup when creating new file' );
ok( create_standup("${BASE}") eq 's1d01.txt', 'will initiate dummy file if folder initially empty of text files' );

system("rm ${BASE}/data/s1d04.txt");
system("rm ${BASE}/s1d01.txt");

1;
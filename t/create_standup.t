use Test::Simple tests => 3;
use Cwd;
use StandupGenerator qw( create_standup );

my $BASE = getcwd;
 
ok( create_standup("${BASE}/data") eq 's1d04.txt', 'will increment standup when creating new file' );
ok( create_standup("${BASE}") eq 's1d01.txt', 'will initiate dummy file if folder initially empty of text files' );

open my $fh, '<', "${BASE}/s1d01.txt";
my $dummy_file_content = do { local $/; <$fh> };
my $dummy_today_index = index($dummy_file_content, 'TODAY') + 6;
my $dummy_blockers_index = index($dummy_file_content, 'BLOCKERS') + 9;
my $dummy_today_content = substr($dummy_file_content, $dummy_today_index, $dummy_blockers_index - $dummy_today_index - 11);
close($fh);

ok( $dummy_today_content eq '- ', 'dummy file contains empty bullets');

system("rm ${BASE}/data/s1d04.txt");
system("rm ${BASE}/s1d01.txt");

1;
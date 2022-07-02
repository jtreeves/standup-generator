package StandupGenerator;

# Execute this command from the shell via this command:
# perl -e 'require "./lib/StandupGenerator.pm"; StandupGenerator::open_standup("/Users/jtreeves/Dropbox/Programming/mock-standups", 2, 7)'
# Replace current sting inside innermost double-quotes with path for whatever directory will contain the standups, then follow with sprint number and day number

sub open_standup {
    my ($path, $sprint, $day) = @_;
    my $cmd = "open ${path}/s${sprint}d${day}.txt";
    system($cmd);
}

1;
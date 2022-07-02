package StandupGenerator;

# Execute this command from the shell via this command:
# perl -e 'require "./lib/StandupGenerator.pm"; StandupGenerator::open_file("~/.viminfo")'
# Replace current sting inside innermost double-quotes with path for whatever file you wish to open

sub open_file {
    my ($path) = @_;
    my $cmd = "open ${path}";
    system($cmd);
}

1;
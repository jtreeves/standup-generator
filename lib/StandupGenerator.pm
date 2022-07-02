package StandupGenerator;

sub find_last_file {
    my ($path) = @_;
    opendir my $dir, $path;
    my @files = readdir $dir;
    closedir $dir;
    my @sorted = sort compare_files @files;
    my $files_length = scalar(@files);
    my $last_file = $sorted[$files_length - 1];
    return $last_file;
}

sub compare_files {
    my $a_d_index = index($a, 'd');
    my $b_d_index = index($b, 'd');
    my $a_size = length($a) - 4;
    my $b_size = length($b) - 4;
    my $a_sprint = substr($a, 1, $a_d_index - 1);
    my $b_sprint = substr($b, 1, $b_d_index - 1);
    my $a_day = substr($a, $a_d_index + 1, $a_size - $a_d_index - 1);
    my $b_day = substr($b, $b_d_index + 1, $b_size - $b_d_index - 1);

    if ($a_sprint < $b_sprint) {
        return -1;
    } elsif ($b_sprint < $a_sprint) {
        return 1;
    } else {
        if ($a_day < $b_day) {
            return -1;
        } elsif ($b_day < $a_day) {
            return 1;
        } else {
            return 0;
        }
    }
}

sub create_standup {
    my ($path) = @_;
    my $last = find_last_file $path;
    print($last);
}

# Execute this subroutine from the shell via this command:
# perl -e 'require "./lib/StandupGenerator.pm"; StandupGenerator::open_standup("/Users/jtreeves/Dropbox/Programming/mock-standups", 2, 7)'
# Replace current sting inside innermost double-quotes with path for whatever directory will contain the standups, then follow with sprint number and day number

sub open_standup {
    my ($path, $sprint, $day) = @_;
    my $cmd = "open ${path}/s${sprint}d${day}.txt";
    system($cmd);
}

sub view_standups_from_week {

}

sub set_aliases {
    # csu, osu, wsu
}

1;
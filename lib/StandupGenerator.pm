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
    my ($first_file, $second_file) = ($a, $b);
    my $first_file_d_index = index($first_file, 'd');
    my $second_file_d_index = index($second_file, 'd');
    my $first_file_size = length($first_file) - 4;
    my $second_file_size = length($second_file) - 4;
    my $first_file_sprint = substr($first_file, 1, $first_file_d_index - 1);
    my $second_file_sprint = substr($second_file, 1, $second_file_d_index - 1);
    my $first_file_day = substr($first_file, $first_file_d_index + 1, $first_file_size - $first_file_d_index - 1);
    my $second_file_day = substr($second_file, $second_file_d_index + 1, $second_file_size - $second_file_d_index - 1);

    if ($first_file_sprint < $second_file_sprint) {
        return -1;
    } elsif ($second_file_sprint < $first_file_sprint) {
        return 1;
    } else {
        if ($first_file_day < $second_file_day) {
            return -1;
        } elsif ($second_file_day < $first_file_day) {
            return 1;
        } else {
            return 0;
        }
    }
}

sub create_standup {
    my ($path) = @_;
    my $last_file = find_last_file $path;
    my $last_file_size = length($last_file) - 4;
    my $last_file_d_index = index($last_file, 'd');
    my $last_file_sprint = substr($last_file, 1, $last_file_d_index - 1);
    my $last_file_day = substr($last_file, $last_file_size - 1, 1);
    my $next_file_sprint;
    my $next_file_day;

    if ($last_file_day == '0') {
        $next_file_day = 1;
        $next_file_sprint = $last_file_sprint + 1;
    } else {
        $next_file_day = $last_file_day + 1;
        $next_file_sprint = $last_file_sprint;
    }
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
    # 
}

sub set_aliases {
    # csu, osu, wsu
}

1;
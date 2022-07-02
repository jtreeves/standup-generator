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

# Execute this subroutine from the shell via this command:
# perl -e 'require "./lib/StandupGenerator.pm"; StandupGenerator::open_standup("/Users/jtreeves/Dropbox/Programming/mock-standups", 2, 7)'
# Replace current sting inside innermost double-quotes with path for whatever directory will contain the standups, then follow with sprint number and day number

sub open_standup {
    my ($path, $sprint, $day) = @_;
    my $command = "open ${path}/s${sprint}d${day}.txt";
    system($command);
}

sub create_standup {
    my ($path) = @_;
    my $last_file = find_last_file $path;
    my $last_file_path = "${path}/${last_file}";
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

    my $next_standup = "s${next_file_sprint}d${next_file_day}";
    my $next_file = "${next_standup}.txt";
    my $next_file_path = "${path}/${next_file}";

    open my $fh, '<', $last_file_path;
    my $last_file_content = do { local $/; <$fh> };
    close($fh);
    my $yesterday_index = index($last_file_content, 'YESTERDAY') + 10;
    my $today_index = index($last_file_content, 'TODAY') + 6;
    my $blockers_index = index($last_file_content, 'BLOCKERS') + 9;
    my $file_length = length($last_file_content);
    my $yesterday_content = substr($last_file_content, $yesterday_index, $today_index - $yesterday_index);
    my $today_content = substr($last_file_content, $today_index, $blockers_index - $today_index - 11);
    my $blockers_content = substr($last_file_content, $blockers_index, $file_length - $blockers_index);
    my $next_file_content = "STANDUP: ${next_standup}\n\nYESTERDAY\n${today_content}\n\nTODAY\n${today_content}\n\nBLOCKERS\n${blockers_content}";

    open my $new_fh, '>', $next_file_path;
    print $new_fh $next_file_content;
    close($new_fh);

    open_standup $path, $next_file_sprint, $next_file_day;
}

sub view_standups_from_week {
    my ($path) = @_;
    my $last_file = find_last_file $path;
    my $last_file_path = "${path}/${last_file}";
    my $last_file_size = length($last_file) - 4;
    my $last_file_d_index = index($last_file, 'd');
    my $last_file_sprint = substr($last_file, 1, $last_file_d_index - 1);
    my $last_file_day = substr($last_file, $last_file_size - 1, 1);

    if ($last_file_day > 5) {
        open_standup $path, $last_file_sprint, 4;
        open_standup $path, $last_file_sprint, 5;
        open_standup $path, $last_file_sprint, 6;
        open_standup $path, $last_file_sprint, 7;
        open_standup $path, $last_file_sprint, 8;
        open_standup $path, $last_file_sprint, 9;
    } else {
        open_standup $path, $last_file_sprint - 1, 9;
        open_standup $path, $last_file_sprint - 1, 10;
        open_standup $path, $last_file_sprint, 1;
        open_standup $path, $last_file_sprint, 2;
        open_standup $path, $last_file_sprint, 3;
        open_standup $path, $last_file_sprint, 4;
    }
}

# To execute, run the following command in the shell:
# perl -e 'require "./lib/StandupGenerator.pm"; StandupGenerator::set_aliases("/Users/jtreeves/Dropbox/Programming/mock-standups")'
# Replace innermost string with path to whatever directory you want to use

sub set_aliases {
    my ($path) = @_;
    my $perl_file = "/Users/jtreeves/Dropbox/Programming/standup-generator/lib/StandupGenerator.pm";
    my @sections = split('/', $path);
    my $user = $sections[2];
    my $base = "/Users/${user}";
    my $config;
    my $zsh = "${base}/.zshrc";
    my $bash = "${base}/.bashrc";

    if (-e $zsh) {
        $config = $zsh;
    } else {
        $config = $bash;
    }

    open my $fh, '<', $config;
    my $config_content = do { local $/; <$fh> };
    close($fh);

    my $osu = "function osu() {\n\tsprint=\$1\n\tday=\$2\n\texport sprint\n\texport day\n\tperl -e 'require \"${perl_file}\"; StandupGenerator::open_standup(\"${path}\", \$ENV{sprint}, \$ENV{day})'\n}";
    my $csu = "function csu() {\n\tperl -e 'require \"${perl_file}\"; StandupGenerator::create_standup(\"${path}\")'\n}";
    my $wsu = "function wsu() {\n\tperl -e 'require \"${perl_file}\"; StandupGenerator::view_standups_from_week(\"${path}\")'\n}";
    my $updated_content = "${config_content}\n\n${osu}\n\n${csu}\n\n${wsu}";

    open my $new_fh, '>', $config;
    print $new_fh $updated_content;
    close($new_fh);
}

1;
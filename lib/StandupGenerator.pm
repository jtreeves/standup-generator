package StandupGenerator;

use base 'Exporter';
our @EXPORT_OK = qw( find_last_file create_standup open_standup );

sub find_last_file {
    my ($path) = @_;
    opendir my $dir, $path;
    my @files = readdir $dir;
    closedir $dir;
    my @sorted = sort @files;
    my $files_length = scalar(@files);
    my $last_file = $sorted[$files_length - 1];

    if (index($last_file, '.txt') == -1) {
        $last_file = 's0d0.txt';
    }

    return $last_file;
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
        $next_file_day = '01';
        $next_file_sprint = $last_file_sprint + 1;
    } else {
        $next_day = $last_file_day + 1;
        $next_file_day = "0${next_day}";
        $next_file_sprint = $last_file_sprint;

        if ($next_file_day == '010') {
            $next_file_day = '10';
        }
    }

    my $next_file = "s${next_file_sprint}d${next_file_day}.txt";
    my $next_file_path = "${path}/${next_file}";

    open my $fh, '<', $last_file_path;
    my $last_file_content = do { local $/; <$fh> };
    close($fh);
    my $today_index = index($last_file_content, 'TODAY') + 6;
    my $blockers_index = index($last_file_content, 'BLOCKERS') + 9;
    my $file_length = length($last_file_content);
    my $today_content;
    my $blockers_content;

    if ($last_file eq "s0d0.txt") {
        $today_content = "- ";
        $blockers_content = "- ";
    } else {
        $today_content = substr($last_file_content, $today_index, $blockers_index - $today_index - 11);
        $blockers_content = substr($last_file_content, $blockers_index, $file_length - $blockers_index);
    }

    my $next_file_content = "STANDUP: SPRINT ${next_file_sprint} - DAY ${next_file_day}\n\nYESTERDAY\n${today_content}\n\nTODAY\n${today_content}\n\nBLOCKERS\n${blockers_content}";

    open my $new_fh, '>', $next_file_path;
    print $new_fh $next_file_content;
    close($new_fh);

    open_standup $path, $next_file_sprint, $next_file_day;

    return $next_file;
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
        for (my $i = 4; $i <= 9; $i = $i + 1) {
            my $temp_day = "0${i}";
            open_standup $path, $last_file_sprint, $temp_day;
        }
    } else {
        for (my $i = 9; $i <= 10; $i = $i + 1) {
            my $temp_day;

            if ($i == 9) {
                $temp_day = '09';
            } else {
                $temp_day = $i;
            }

            open_standup $path, $last_file_sprint - 1, $temp_day;
        }

        for (my $i = 1; $i <= 4; $i = $i + 1) {
            my $temp_day = "0${i}";
            open_standup $path, $last_file_sprint, $temp_day;
        }
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
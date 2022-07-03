package StandupGenerator::Creator;

use base 'Exporter';
use StandupGenerator::Accessor;
use StandupGenerator::Helper;

our @EXPORT = qw( 
    create_new
);

sub create_new {
    my ($path) = @_;
    my $last_file = StandupGenerator::Helper::find_last_file($path);
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

    StandupGenerator::Accessor::open_one($path, $next_file_sprint, $next_file_day);

    return $next_file;
}

1;
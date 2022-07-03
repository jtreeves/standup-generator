package StandupGenerator::Accessor;

use base 'Exporter';
use StandupGenerator::Helper;

our @EXPORT = qw( 
    open_one
    open_many
);

sub open_one {
    my ($path, $sprint, $day) = @_;
    my $command = "open ${path}/s${sprint}d${day}.txt";
    system($command);
}

sub open_many {
    my ($path) = @_;
    my $last_file = StandupGenerator::Helper::find_last_file($path);
    my $last_file_path = "${path}/${last_file}";
    my $last_file_size = length($last_file) - 4;
    my $last_file_d_index = index($last_file, 'd');
    my $last_file_sprint = substr($last_file, 1, $last_file_d_index - 1);
    my $last_file_day = substr($last_file, $last_file_size - 1, 1);

    if ($last_file_day > 5) {
        for (my $i = 4; $i <= 9; $i = $i + 1) {
            my $new_day = "0${i}";
            open_one($path, $last_file_sprint, $new_day);
        }
    } else {
        open_one($path, $last_file_sprint - 1, '09');
        open_one($path, $last_file_sprint - 1, '10');

        for (my $i = 1; $i <= 4; $i = $i + 1) {
            my $new_day = "0${i}";
            open_one($path, $last_file_sprint, $new_day);
        }
    }
}

1;
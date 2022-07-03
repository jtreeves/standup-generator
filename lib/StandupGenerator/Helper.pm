package StandupGenerator::Helper;

use base 'Exporter';

our @EXPORT = qw( 
    find_last_file
);

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

1;
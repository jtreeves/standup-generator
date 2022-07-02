package StandupGenerator;

# Execute this subroutine from the shell via this command:
# perl -e 'require "./lib/StandupGenerator.pm"; StandupGenerator::open_standup("/Users/jtreeves/Dropbox/Programming/mock-standups", 2, 7)'
# Replace current sting inside innermost double-quotes with path for whatever directory will contain the standups, then follow with sprint number and day number

sub open_standup {
    my ($path, $sprint, $day) = @_;
    my $cmd = "open ${path}/s${sprint}d${day}.txt";
    system($cmd);
}

sub create_standup {

}

sub find_last_file {
    my ($path) = @_;
    opendir my $dir, $path;
    my @files = readdir $dir;
    closedir $dir;
    my @sorted = sort compare_files @files;
    my $filesLength = scalar(@files);
    my $lastFile = $sorted[$filesLength - 1];
    print($lastFile);
}

sub compare_files {
    my $aDIndex = index($a, 'd');
    my $bDIndex = index($b, 'd');
    my $aSize = length($a) - 4;
    my $bSize = length($b) - 4;
    my $aSprint = substr($a, 1, $aDIndex - 1);
    my $bSprint = substr($b, 1, $bDIndex - 1);
    my $aDay = substr($a, $aDIndex + 1, $aSize - $aDIndex - 1);
    my $bDay = substr($b, $bDIndex + 1, $bSize - $bDIndex - 1);

    if ($aSprint < $bSprint) {
        return -1;
    } elsif ($bSprint < $aSprint) {
        return 1;
    } else {
        if ($aDay < $bDay) {
            return -1;
        } elsif ($bDay < $aDay) {
            return 1;
        } else {
            return 0;
        }
    }
}

1;
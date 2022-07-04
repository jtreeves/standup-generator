package StandupGenerator;

use base 'Exporter';
use StandupGenerator::Creator;
use StandupGenerator::Accessor;
use StandupGenerator::Manipulator;

our @EXPORT = qw( 
    create_standup 
    open_standup 
    view_standups_from_week
    set_aliases
);

# Creates a new standup file when given a directory, with identifiers that increment off of the directory's last file and contents pulled from yesterday's standup file 
sub create_standup {
    my ($path) = @_;
    StandupGenerator::Creator::create_new($path);
}

# Execute this subroutine from the shell via this command:
# perl -e 'require "./lib/StandupGenerator.pm"; StandupGenerator::open_standup("/Users/jtreeves/Dropbox/Programming/mock-standups", 2, 7)'
# Replace current sting inside innermost double-quotes with path for whatever directory will contain the standups, then follow with sprint number and day number

# Opens an existing standup file when given a directory, a sprint number, and a two-digit string for the day
sub open_standup {
    my ($path, $sprint, $day) = @_;
    StandupGenerator::Accessor::open_one($path, $sprint, $day);
}

# Opens all standup files in a directory from the past week, along with the coming Monday's standup file, if they exist
sub view_standups_from_week {
    my ($path) = @_;
    StandupGenerator::Accessor::open_many($path);
}

# To execute, run the following command in the shell:
# perl -Ilib -e 'require "./lib/StandupGenerator.pm"; StandupGenerator::set_aliases("/Users/jtreeves/Dropbox/Programming/mock-standups")'
# Replace innermost string with path to whatever directory you want to use

# Append some functions to the user's configuration file to make it easier for the user to execute key methods from this package via the CLI, with all functions automatically referencing the correct directory
sub set_aliases {
    my ($path) = @_;
    StandupGenerator::Manipulator::save_script_shortcuts($path);
}

1;
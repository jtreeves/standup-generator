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

sub create_standup {
    my ($path) = @_;
    StandupGenerator::Creator::create_new($path);
}

# Execute this subroutine from the shell via this command:
# perl -e 'require "./lib/StandupGenerator.pm"; StandupGenerator::open_standup("/Users/jtreeves/Dropbox/Programming/mock-standups", 2, 7)'
# Replace current sting inside innermost double-quotes with path for whatever directory will contain the standups, then follow with sprint number and day number

sub open_standup {
    my ($path, $sprint, $day) = @_;
    StandupGenerator::Accessor::open_one($path, $sprint, $day);
}

sub view_standups_from_week {
    my ($path) = @_;
    StandupGenerator::Accessor::open_many($path);
}

# To execute, run the following command in the shell:
# perl -e 'require "./lib/StandupGenerator.pm"; StandupGenerator::set_aliases("/Users/jtreeves/Dropbox/Programming/mock-standups")'
# Replace innermost string with path to whatever directory you want to use

sub set_aliases {
    my ($path) = @_;
    StandupGenerator::Manipulator::save_script_shortcuts($path);
}

1;
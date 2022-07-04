package StandupGenerator::Accessor;

use base 'Exporter';
use StandupGenerator::Helper;

our @EXPORT = qw( 
    open_one
    open_many
);

# Open a standup file when given a full path, sprint number, and two-digit string for day
sub open_one {
    my ($path, $sprint, $day) = @_;
    my $command = "open ${path}/s${sprint}d${day}.txt";
    system($command);
}

# Open all standup files for the past week within a given directory
sub open_many {
    my ($path) = @_;
    my $last_file = StandupGenerator::Helper::find_last_file($path);
    my %last_file_identifiers = StandupGenerator::Helper::extract_identifiers($last_file);
    my $last_file_sprint = $last_file_identifiers{'sprint'};
    my $last_file_day = $last_file_identifiers{'day'};

    if ($last_file_day > 5) {
        # All days will fall within the current sprint
        for (my $i = 4; $i <= 9; $i = $i + 1) {
            my $new_day = "0${i}";
            open_one($path, $last_file_sprint, $new_day);
        }
    } else {
        # Since a new sprint has just begun, days will be split between the current sprint and the previous sprint
        open_one($path, $last_file_sprint - 1, '09');
        open_one($path, $last_file_sprint - 1, '10');

        for (my $i = 1; $i <= 4; $i = $i + 1) {
            my $new_day = "0${i}";
            open_one($path, $last_file_sprint, $new_day);
        }
    }
}

1;

__END__

=pod

=head1 NAME

StandupGenerator::Accessor - opens files for user

=head1 DESCRIPTION

The Accessor module surfaces methods to allow the user to open specific standup files. It contains functions to open either one standup file within a directory or a collection of standup files within a directory.

=head1 METHODS

=head2 C<open_one>

This method lets the user open a single standup file stored in a specific directory.

=head3 Arguments

=over

=item C<$path>

A string containing the full file path for the directory containing the standup file. It should begin with I</Users/>.

=item C<$sprint>

A number representing the sprint of the standup.

=item C<$day>

A string containing a two-digit representation of the day of the standup. Single digit numbers will begin with I<'0'>.

=back

=head3 Returns

If the I<.txt> file exists, then the method will open it in the user's default editor (e.g., TextEdit). However, nothing will be explicitly returned.

=head3 Examples

    use StandupGenerator::Accessor;
    StandupGenerator::Accessor::open_one('/Users/johndoe/projects/super-important-project/standups', 3, '07');

This command will open the file I<s3d07.txt>, stored within the I<standups> directory within the I<super-important-project> directory.
    
    use StandupGenerator::Accessor;
    StandupGenerator::Accessor::open_one('/Users/johndoe/projects/super-important-project/standups', 3, 7);

This command will not open any file since the day was not provided as a two-digit string. (The program will not generate any file named I<s3d7.txt>.)

=head2 C<open_many>

This method lets the user open a collection of standup files stored in a specific directory. The intent is to open all standups for the past week. It assumes the last standup in the given directory is either a Friday or Monday, and it opens six files as a result (Monday's through Friday's along with the following Monday's).

=head3 Arguments

=over

=item C<$path>

A string containing the full file path for the directory containing the standup files. It should begin with I</Users/>.

=back

=head3 Returns

If the path leads to a directory that contains I<.txt> files formatted with the standups naming convention, then the method will open six of those files in the user's default editor (e.g., TextEdit). However, nothing will be explicitly returned. 

=head3 Examples

    use StandupGenerator::Accessor;
    StandupGenerator::Accessor::open_many('/Users/johndoe/projects/super-important-project/standups');

This command will open six files stored within the I<standups> directory within the I<super-important-project> directory. If the last created file ends in a number greater than five, then the files opened will be I<d04>, I<d05>, I<d06>, I<d07>, I<d08>, and I<d09> for the current sprint. Otherwise, it will open the files I<d01>, I<d02>, I<d03>, and I<d04> from the current sprint along with files I<d09> and I<d10> from the preceding sprint.
    
    use StandupGenerator::Accessor;
    StandupGenerator::Accessor::open_many('/Users/johndoe/projects/super-important-project/');

This command will not open any file since the directory in question does not contain any standups (assuming that's the case with this file structure).

=cut
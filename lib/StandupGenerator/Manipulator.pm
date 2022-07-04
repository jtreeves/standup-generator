package StandupGenerator::Manipulator;

use base 'Exporter';

our @EXPORT = qw( 
    save_script_shortcuts
);

# Updates a user's local zsh or bash config file with functions allowing the user to implement methods from the package via the CLI using far less typing
sub save_script_shortcuts {
    my ($path) = @_;
    my $perl_file = "/Users/jtreeves/Dropbox/Programming/standup-generator/lib/StandupGenerator.pm";
    my @sections = split('/', $path);
    my $user = $sections[2];
    my $base = "/Users/${user}";
    my $config;
    my $zsh = "${base}/.zshrc";
    my $bash = "${base}/.bashrc";

    if (-e $zsh) {
        # Plan to update user's zsh file if it exists
        $config = $zsh;
    } else {
        # Plan to update user's bash file if user does not use zsh
        $config = $bash;
    }

    open my $fh, '<', $config;
    my $config_content = do { local $/; <$fh> };
    close($fh);

    # Create three functions for creating and opening standup files, then bundle them together into a single string for group insertion
    my $osu = "# Executes open_standup function from standup-generator Perl module\n# Takes three arguments: path to directory housing standups, sprint number, and string of day beginning with 0 (e.g., '04', not 4)\nfunction osu() {\n\tsprint=\$1\n\tday=\$2\n\texport sprint\n\texport day\n\tperl -e -Ilib 'require \"${perl_file}\"; StandupGenerator::open_standup(\"${path}\", \$ENV{sprint}, \$ENV{day})'\n}";
    my $csu = "# Executes create_standup function from standup-generator Perl module; it takes no arguments\nfunction csu() {\n\tperl -Ilib -e 'require \"${perl_file}\"; StandupGenerator::create_standup(\"${path}\")'\n}";
    my $wsu = "# Executes view_standups_from_week function from standup-generator Perl module; it takes no arguments\nfunction wsu() {\n\tperl -Ilib -e 'require \"${perl_file}\"; StandupGenerator::view_standups_from_week(\"${path}\")'\n}";
    my $updated_content = "${config_content}\n\n${osu}\n\n${csu}\n\n${wsu}";

    # Append new shortcuts to the end of existing config file
    open my $new_fh, '>', $config;
    print $new_fh $updated_content;
    close($new_fh);
}

1;
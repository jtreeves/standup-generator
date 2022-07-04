# Standup Generator

*An easy way to create .txt files to keep track of your daily standups for team meetings*

**Contents**
1. [Description](https://github.com/jtreeves/standup-generator#description)
2. [Inspiration](https://github.com/jtreeves/standup-generator#inspiration)
3. [Requirements](https://github.com/jtreeves/standup-generator#requirements)
4. [Installation](https://github.com/jtreeves/standup-generator#installation)
5. [Features](https://github.com/jtreeves/standup-generator#features)
6. [Usage](https://github.com/jtreeves/standup-generator#usage)
7. [Code Examples](https://github.com/jtreeves/standup-generator#code-examples)
8. [Testing](https://github.com/jtreeves/standup-generator#testing)
9. [Future Goals](https://github.com/jtreeves/standup-generator#future-goals)

## Description

Standup Generator is a module for creating and editing standup files. It is a **Perl** package for use on a **MacOS** computer via a CLI configured to work with either zsh or bash. It contains three main methods: one for creating a new standup *.txt* file, based on whatever the previous standup file contained; another for opening standup files in your default text editor; and a final one for viewing all the standup files from the past week. It also includes a helper method that you can execute via the CLI to update your config files with shortcuts to enable you to execute those main methods with less typing on your end.

## Inspiration

I like to type out my standups before delivering them in my team's daily morning meetings. Otherwise, I'll just end up rambling, and I'll often forget to include an important element. After creating basic *.txt* files for my standups over the course of a few weeks, I found that the files turned into ad hoc to-do lists that helped me stay on track with my work. However, creating those files from scratch every day was inefficient, so I came up with some bash scripts to streamline the process. As always, I soon realized that I could still factor out more inefficiencies. At that point, I decided to switch to a more robust scripting language that I could use to create a package that I could publish in case other people wanted to use my same shortcuts. I started playing around with Perl, and this package is the result. While it's only in a rudimentary stage and could still be improved upon (see [Future Goals](https://github.com/jtreeves/standup-generator#future-goals) below), I think it's adequate for basic usage.

## Requirements

- MacOS
- Perl 5
- CLI configured to work with either zsh or bash

## Installation

### Download Package

Ensure you already have Perl and CPAN on your local computer. (You can check this by executing `perl -v` and `cpan -v`, respectively.) If you do not already have CPAN's CLI shortcut, you can install it by executing `cpan App::cpanminus`. Download the package by executing this command in your CLI:

```
cpan StandupGenerator
```

### Create Local Repository

Ensure you already have Perl on your local computer. (You can check this by executing `perl -v`.)

1. Fork this repository
2. Clone it to your local computer
3. Execute any of the methods from this package from within your local version of the directory with a version of this command:

```
perl -Ilib -e 'require "./lib/StandupGenerator.pm"; StandupGenerator::create_standup("/Users/johndoe/projects/super-important-project/standups")'
```

Replace `create_standup` with whichever top-level method you want to use, and replace the inner string with the full file path to the directory in which you plan to store standups.

## Features

- Method to create a new standup file based off of information from yesterday's standup file
- Method to open a standup file based on parameters
- Method to open all standup files from the past week

## Usage

### Short Approach

After downloading the package, execute a version of the following command to automatically add the below shortcuts to your zsh or bash config file.

```
perl -Ilib -e 'require "./lib/StandupGenerator.pm"; StandupGenerator::set_aliases("/Users/johndoe/projects/super-important-project/standups")'
```

Replace the inner string with the exact path to the directory you plan to use to store your standups.

You can execute this command multiple times to reset the directory for your standups. For instance, after completing a project but before starting another, you would want to reset the directory to the directory for the new project. Each time you execute the command, three new functions will be added to the bottom of your zsh or bash config file. As a result, if you generate aliases on five different occassions, your zsh or bash config file will now have 15 different functions at the end of its file. Later commands always override earlier, identical commands, so this won't affect its ability to operate. However, feel free to delete older instances of the shortcuts as you see fit.

#### `csu`

This method **c**reates a new **s**tand**u**p. It is a shortcut for the `create_standup` method. It takes no arguments. It will create the file in the appropriate folder, then open it in your default text editor (e.g., TextEdit). If yesterday's standup was *s2d07.txt*, then to create and open *s2d08.txt*, merely run:

```
csu
```

#### `osu`

This method **o**pens an existing **s**tand**u**p. It is a shortcut for the `open_standup` method. It takes two arguments: a number for the sprint and two-digit string for the day. It will open the corresponding file from the already aliased folder in your default text editor (e.g., TextEdit). If you want to open *s1d03.txt*, then merely run:

```
osu 1 '03'
```

#### `wsu`

This method opens all of this past **w**eek's **s**tand**u**ps. It is a shortcut for the `view_standups_from_week` method. It takes no arguments. It will open six files from the already aliased folder in your default text editor (e.g., TextEdit). The files will be for the standups from Monday through Friday of the week in question, along with the following Monday's. It determines which files to open based on the last file in the directory, which it uses to determine the likely week. If it's Friday and you have already preemptively created this coming Monday's standup, which happens to be *s4d09.txt*, then you can open *s4d04.txt*, *s4d05.txt*, *s4d06.txt*, *s4d07.txt*, *s4d08.txt*, and *s4d09.txt* by merely running:

```
wsu
```

### Long Approach

If you don't want your config files edited and are fine with writing out long commands evertime, you can instead use the full commands.

Execute any of the methods from this package with a version of this command:

```
perl -Ilib -e 'require "./lib/StandupGenerator.pm"; StandupGenerator::create_standup("/Users/johndoe/projects/super-important-project/standups")'
```

Replace `create_standup` with whichever top-level method you want to use, and replace the inner string with the full file path to the directory in which you plan to store standups. Make sure you include all necessary parameters for the method you wish to use.

## Code Examples

**Helper function to find the last file in a directory**
```perl
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
```

**Open a file via the system command based on specific parameters**
```perl
sub open_one {
    my ($path, $sprint, $day) = @_;
    my $command = "open ${path}/s${sprint}d${day}.txt";
    system($command);
}
```

## Testing

This repository uses the **Test::Simple** module for testing, which should come bundled with Perl by default. Tests are spread across 8 files within the `t` directory. To run all tests within a file, execute a version of this command:

```
perl -Ilib t/routines/create_new.t
```

Adjust file path appropriately.

## Future Goals

- Check config file for existence of shortcuts before inserting them when using the `save_script_shortcuts` method, and delete the existing ones before adding the new ones, to avoid adding redundant shortcuts to the user's config file
- Make Windows compatible, possibly with a separate version of this package
- Add fallback config file options to `save_script_shortcuts` method in case user uses neither zsh nor bash
- Error handling for cases like attempting to open a file that doesn't exist, especially in the context of the `open_many` method, and for running `find_last_file` in a directory with non-standup files (either *.txt* or otherwise)
- More tests for edge cases, along with a way to test the `save_script_shortcuts` method
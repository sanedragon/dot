#!/usr/local/bin/vod_perl -w

use strict;
use AppropriateLibrary 'vod';
use RTK::Util::ReasonableParams;

use RTK::Util::Misc qw/
    get_cmdline_options
    generate_date_range
    unique
/;

use Aliases qw/
    RTK::Util::DateTime
/;

sub usage
{
    <<USAGE;

This script is a convenience script to output SQL for generating out-of-date
transactions for the VOD database. It can output either to stdout or to an
output file.

Options for @{[ __FILE__ ]}:

    --cable-system-no <cable_system_no[,cable_system_no,...]>
        VOD cable systems (given by number as listed in the VOD database).

    --start-date <start_date>
        The first date of a range, inclusive.

    --end-date <end_date>
        The last date of a range, inclusive.

    --output-file <filename>
        The name of a file to which to output the generated SQL. Otherwise, SQL
        is sent to stdout.

USAGE
}

sub run()
{
    my @cable_system_nos;
    my $start_date;
    my $end_date;
    my $output_file;

    get_cmdline_options(
        { argv => \@ARGV, usage => usage() },
        'cable-system-no=s'  => \@cable_system_nos,
        'start-date=s'       => \$start_date,
        'end-date=s'         => \$end_date,
        'output-file=s'      => \$output_file,
    );

    my $invalid_option_combination;
    @cable_system_nos = split(/,/,join(',',@cable_system_nos));

    unless ($start_date) {
        print "ERROR: Must supply a start date\n";
        $invalid_option_combination = 1;
    } else {
        $start_date = DateTime->new($start_date);
        unless($start_date) {
            print "ERROR: Invalid start date given: $start_date\n";
            $invalid_option_combination = 1;
        }
    }

    if ($end_date) {
        $end_date = DateTime->new($end_date);
        unless($end_date) {
            print "ERROR: Invalid end date given: $end_date\n";
            $invalid_option_combination = 1;
        }
    } else {
        $end_date = DateTime->now();
    }

    unless (scalar(@cable_system_nos)) {
        print "ERROR: Must supply some cable systems\n";
        $invalid_option_combination = 1;
    }

    if ($invalid_option_combination) {
        print usage();
        exit;
    }

    my $preamble = <<PREAMBLE;
select nextval('xtn_batch_no_sequence');

insert into
    out_of_date_xtns(batch_no, cable_system_no, order_day, week, month)
values
PREAMBLE

    my $sql_fh;
    if ($output_file) {
        open($sql_fh, ">", $output_file) or die "Could not open output file!";
        print $sql_fh $preamble;
    } else {
        print $preamble;
    }

    for my $dt (generate_date_range($start_date, $end_date, 'is_on_or_before'))
    {
        my $date = $dt->as_str('YYYY-MM-DD');
        for my $cs (@cable_system_nos)
        {
            my $row = "    (currval('xtn_batch_no_sequence'), $cs, '$date', vod_week_ending('$date'), date_trunc('month', '$date'))";
            if ($output_file) {
                print $sql_fh $row;
                if ($dt->compare($end_date) != 0 || $cs != $cable_system_nos[-1]) {
                    print $sql_fh ",";
                }
                print $sql_fh "\n";
            } else {
                print $row;
                if ($dt->compare($end_date) != 0 || $cs != $cable_system_nos[-1]) {
                    print ",";
                }
                print "\n";
            }
        }
    }

    if ($output_file) {
        print $sql_fh ";\n";
        close $sql_fh;
    } else {
        print ";\n";
    }
}

run();

1;

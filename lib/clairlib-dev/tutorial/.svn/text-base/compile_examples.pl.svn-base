#!/usr/bin/perl

use strict;
use warnings;


open TEX_FILE, "> examples.tex";

# Use small typewriter font for boxedverbatim
print TEX_FILE "\\let\\oldboxedverbatim=\\boxedverbatim\n";
print TEX_FILE "\\renewcommand{\\boxedverbatim}{\\footnotesize\\oldboxedverbatim}\n\n";


print TEX_FILE "\\subsection{List of Recipes}\n\n";
print TEX_FILE "\\begin{itemize}\n";
print TEX_FILE "\\item Unit Tests\n\n";
generate_table_of_contents(*TEX_FILE, "t");
print TEX_FILE "\\item Example Tests\n\n";
generate_table_of_contents(*TEX_FILE, "test");
print TEX_FILE "\\item Utilities\n\n";
generate_table_of_contents(*TEX_FILE, "util");
print TEX_FILE "\\end{itemize}\n\n";

print TEX_FILE "\\subsection{Unit Tests}\n\n";
print TEX_FILE "This section contains the unit tests included with Clairlib.\n\n";
generate_recipes(*TEX_FILE, "t");
print TEX_FILE "\\subsection{Example tests}\n\n";
print TEX_FILE "This section contains the different sample programs that show";
print TEX_FILE " off the features included in Clairlib.\n\n";
generate_recipes(*TEX_FILE, "test");
print TEX_FILE "\\subsection{Utilities}\n\n";
print TEX_FILE "This section contains different utility scripts that perform";
print TEX_FILE " common tasks.\n\n";
generate_recipes(*TEX_FILE, "util");
close TEX_FILE;

sub generate_table_of_contents {
  my $texfile = shift;
  my $dir = shift;

  *TEX_FILE = $texfile;

  my @filelist = ();
  open FILELIST, "core_${dir}_filelist.txt";
  while (<FILELIST>) {
    chomp;
    push @filelist, $_;
  }
  close FILELIST;
  open FILELIST, "ext_${dir}_filelist.txt";
  while (<FILELIST>) {
    chomp;
    push @filelist, $_;
  }
  close FILELIST;

  # Output table of contents

  print TEX_FILE "\\begin{itemize}\n";
  foreach my $filename (@filelist) {
    # Get the full filepath so we can open the file.
    my $filepath = "../$dir/$filename";

    # Escape the underscores
    $filename =~ s/_/\\_/g;

    print TEX_FILE "  \\item $filename\n\n";

    my @contents = `cat $filepath`;
    foreach my $line (@contents) {
      if ($line =~ /#\W+functionality:(.*)/) {
        # Underscore business as described above applies also to functionality lines
        my $func_line = $1;
        $func_line =~ s/_/\\_/g;
        print TEX_FILE $func_line, "\n";
      }
    }
  }
  print TEX_FILE "\\end{itemize}\n\n";
}


sub generate_recipes {
  my $texfile = shift;
  my $dir = shift;

  *TEX_FILE = $texfile;

  my @filelist = ();
  open FILELIST, "core_${dir}_filelist.txt";
  while (<FILELIST>) {
    chomp;
    push @filelist, $_;
  }
  close FILELIST;
  open FILELIST, "ext_${dir}_filelist.txt";
  while (<FILELIST>) {
    chomp;
    push @filelist, $_;
  }
  close FILELIST;

  foreach my $filename (@filelist) {
    # Get the full filepath so we can open the file.
    my $filepath = "../$dir/$filename";

    # Escape the underscores
    $filename =~ s/_/\\_/g;

    print TEX_FILE "\\subsubsection{$filename}\n";

    my @contents = `cat $filepath`;

    my $arrayref = process(\@contents);
    print_to_file(*TEX_FILE, $arrayref);
  }
}

sub process {
        my $orig_text_ref = shift;
        my @orig_text = @$orig_text_ref;
        my @new_text = ();

        foreach my $line (@orig_text) {
                chop $line;

                # Don't lose empty lines
                if ($line eq "") {
                        push @new_text, $line;
                }

                while ($line ne "") {
                        # $this_line is the next line that we extract
                        # if any of the line is left, that will be saved as $line
                  my $this_line = "";

                        # Try to match the largest string from the beginning
                        # that ends at whitespace (or the end of a line)
                        # and will fit in one line on a page
                        # Allow up to 80 characters on a line.
                  if ($line =~ m/^(.{0,79}(\s|$)+)(.*)/) {
                    $this_line = $1;
                    $line = $3;
                        } else {
                    # If you can't match that, then just get the most that can
                                # fit on a page.
                                $line =~ m/(.{0,79})(.*)/;
                    $this_line = $1;
                    $line = $2;
                  }

                  if ($line ne "") {
                                # Pad the line until it is 80 characters long
                                # (Guaranteeing that every line will get at least one space)
                                # So that every '\' is at the same horizontal placement
                                while (length($this_line) < 80) {
                                        $this_line .= " ";
                                }
                                $this_line .= "\\";
                  }

                        push @new_text, $this_line;
                }

        }

        return \@new_text;
}

sub print_to_file {
  my $texfile = shift;
  my $text_ref = shift;
  my @text = @$text_ref;

  *TEX_FILE = $texfile;
  my $i = 0;

        # Print out each line of the text.
        # We'll allow 67 lines per boxedverbatim, but after that
        # we'll start a new one so that the file doesn't overflow
        # on a page.
        foreach my $line (@text) {
                # If we're printing the first line, or the first line
                # after a boxedverbatim ended, begin a boxverbatim
                if ($i == 0) {
                        print TEX_FILE "\\begin{boxedverbatim}\n\n";
                }

                print TEX_FILE "$line\n";

                ++$i;

                if ($i == 67) {
                        print TEX_FILE "\n\\end{boxedverbatim}\n\n\n";
                        $i = 0;
                }
        }

        # If we're inside a boxedverbatim, end it.
        if ($i != 0) {
                print TEX_FILE "\n\\end{boxedverbatim}\n\n\n";
        }
}


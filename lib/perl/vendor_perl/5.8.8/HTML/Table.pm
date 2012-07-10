package HTML::Table;
use strict;
use warnings;

use vars qw($VERSION $AUTOLOAD);
$VERSION = '2.05';

use overload	'""'	=>	\&getTable,
				fallback => undef;

=head1 NAME

HTML::Table - produces HTML tables

=head1 SYNOPSIS

  use HTML::Table;

  $table1 = new HTML::Table($rows, $cols);
    or
  $table1 = new HTML::Table(-rows=>26,
                            -cols=>2,
                            -align=>'center',
                            -rules=>'rows',
                            -border=>0,
                            -bgcolor=>'blue',
                            -width=>'50%',
                            -spacing=>0,
                            -padding=>0,
                            -style=>'color: blue',
                            -class=>'myclass',
                            -head=> ['head1', 'head2'],
                            -data=> [ ['1:1', '1:2'], ['2:1', '2:2'] ] );
   or
  $table1 = new HTML::Table( [ ['1:1', '1:2'], ['2:1', '2:2'] ] );

  $table1->setCell($cellrow, $cellcol, 'This is Cell 1');
  $table1->setCellBGColor('blue');
  $table1->setCellColSpan(1, 1, 2);
  $table1->setRowHead(1);
  $table1->setColHead(1);

  $table1->print;

  $table2 = new HTML::Table;
  $table2->addRow(@cell_values);
  $table2->addCol(@cell_values2);

  $table1->setCell(1,1, "$table2->getTable");
  $table1->print;

=head1 REQUIRES

Perl5.002

=head1 EXPORTS

Nothing

=head1 DESCRIPTION

HTML::Table is used to generate HTML tables for
CGI scripts.  By using the methods provided fairly
complex tables can be created, manipulated, then printed
from Perl scripts.  The module also greatly simplifies
creating tables within tables from Perl.  It is possible
to create an entire table using the methods provided and
never use an HTML tag.

HTML::Table also allows for creating dynamically sized
tables via its addRow and addCol methods.  These methods
automatically resize the table if passed more cell values
than will fit in the current table grid.

Methods are provided for nearly all valid table, row, and
cell tags specified for HTML 3.0.

A Japanese translation of the documentation is available at:

	http://member.nifty.ne.jp/hippo2000/perltips/html/table.htm


=head1 METHODS

  [] indicate optional parameters. default value will
     be used if no value is specified
     
  row_num indicates that a row number is required.  
  	Rows are numbered from 1.  To refer to the last row use the value -1.

  col_num indicates that a col number is required.  
  	Cols are numbered from 1.  To refer to the last col use the value -1.


=head2 Creation

=over 4

=item new HTML::Table([num_rows, num_cols])

Creates a new HTML table object.  If rows and columns
are specified, the table will be initialized to that
size.  Row and Column numbers start at 1,1.  0,0 is
considered an empty table.

=item new HTML::Table([-rows=>num_rows, 
		 -cols=>num_cols, 
		 -border=>border_width,
		 -align=>table_alignment,
		 -style=>table_style,
 		 -class=>table_class,
		 -bgcolor=>back_colour, 
		 -width=>table_width, 
		 -spacing=>cell_spacing, 
		 -padding=>cell_padding])

Creates a new HTML table object.  If rows and columns
are specified, the table will be initialized to that
size.  Row and Column numbers start at 1,1.  0,0 is
considered an empty table.

=back

=head2 Table Level Methods

=over 4

=item setBorder([pixels])

Sets the table Border Width

=item setWidth([pixels|percentofscreen])

Sets the table width

 	$table->setWidth(500);
  or
 	$table->setWidth('100%');

=item setCellSpacing([pixels])

=item setCellPadding([pixels])

=item setCaption("CaptionText" [, top|bottom])

=item setBGColor([colorname|colortriplet])

=item autoGrow([1|true|on|anything|0|false|off|no|disable])

Switches on (default) or off automatic growing of the table
if row or column values passed to setCell exceed current
table size.

=item setAlign ( [ left , center , right ] ) 

=item setRules ( [ rows , cols , all, both , groups  ] ) 

=item setStyle ( 'css style' ) 

Sets the table style attribute.

=item setClass ( 'css class' ) 

Sets the table class attribute.

=item setAttr ( 'user attribute' ) 

Sets a user defined attribute for the table.  Useful for when
HTML::Table hasn't implemented a particular attribute yet

=item sort ( [sort_col_num, sort_type, sort_order, num_rows_to_skip] )

        or 
  sort( -sort_col => sort_col_num, 
        -sort_type => sort_type,
        -sort_order => sort_order,
        -skip_rows => num_rows_to_skip,
        -strip_html => strip_html,
        -strip_non_numeric => strip_non_numeric,
        -presort_func => \&filter_func )

    sort_type in { ALPHA | NUMERIC }, 
    sort_order in { ASC | DESC },
    strip_html in { 0 | 1 }, defaults to 1,
    strip_non_numeric in { 0 | 1 }, defaults to 1

  Sort all rows on a given column (optionally skipping table header rows
  by specifiying num_rows_to_skip).

  By default sorting ignores HTML Tags and &nbsp, setting the strip_html parameter to 0 
  disables this behaviour.

  By default numeric Sorting ignores non numeric chararacters, setting the strip_non_numeric
  parameter to 0 disables this behaviour.

  You can provide your own pre-sort function, useful for pre-processing the cell contents 
  before sorting for example dates.


=item getTableRows

Returns the number of rows in the table.

=item getTableCols

Returns the number of columns in the table.

=item getStyle

Returns the table's style attribute.

=back

=head2 Cell Level Methods

=over 4

=item setCell(row_num, col_num, "content")

Sets the content of a table cell.  This could be any
string, even another table object via the getTable method.
If the row and/or column numbers are outside the existing table
boundaries extra rows and/or columns are created automatically.

=item setCellAlign(row_num, col_num, [center|right|left])

Sets the horizontal alignment for the cell.

=item setCellVAlign(row_num, col_num, [center|top|bottom|middle|baseline])

Sets the vertical alignment for the cell.

=item setCellWidth(row_num, col_num, [pixels|percentoftable])

Sets the width of the cell.

=item setCellHeight(row_num, col_num, [pixels])

Sets the height of the cell.

=item setCellHead(row_num, col_num)

Sets cell to be of type head (Ie <th></th>)

=item setCellNoWrap(row_num, col_num, [0|1])

Sets the NoWrap attribute of the cell.

=item setCellBGColor(row_num, col_num, [colorname|colortriplet])

Sets the background colour for the cell

=item setCellRowSpan(row_num, col_num, num_cells)

Causes the cell to overlap a number of cells below it.
If the overlap number is greater than number of cells 
below the cell, a false value will be returned.

=item setCellColSpan(row_num, col_num, num_cells)

Causes the cell to overlap a number of cells to the right.
If the overlap number is greater than number of cells to
the right of the cell, a false value will be returned.

=item setCellSpan(row_num, col_num, num_rows, num_cols)

Joins the block of cells with the starting cell specified.
The joined area will be num_cols wide and num_rows deep.

=item setCellFormat(row_num, col_num, start_string, end_string)

Start_string should be a string of valid HTML, which is output before
the cell contents, end_string is valid HTML that is output after the cell contents.
This enables formatting to be applied to the cell contents.

	$table->setCellFormat(1, 2, '<b>', '</b>');

=item setCellStyle (row_num, col_num, 'css style') 

Sets the cell style attribute.

=item setCellClass (row_num, col_num, 'css class') 

Sets the cell class attribute.

=item setCellAttr (row_num, col_num, 'user attribute') 

Sets a user defined attribute for the cell.  Useful for when
HTML::Table hasn't implemented a particular attribute yet

=item setLastCell*

All of the setCell methods have a corresponding setLastCell method which 
does not accept the row_num and col_num parameters, but automatically applies
to the last row and last col of the table.

=item getCell(row_num, col_num)

Returns the contents of the specified cell as a string.

=item getCellStyle(row_num, col_num)

Returns cell's style attribute.

=back

=head2 Column Level Methods

=over 4

=item addCol("cell 1 content" [, "cell 2 content",  ...])

Adds a column to the right end of the table.  Assumes if
you pass more values than there are rows that you want
to increase the number of rows.

=item setColAlign(col_num, [center|right|left])

Applies setCellAlign over the entire column.

=item setColVAlign(col_num, [center|top|bottom|middle|baseline])

Applies setCellVAlign over the entire column.

=item setColWidth(col_num, [pixels|percentoftable])

Applies setCellWidth over the entire column.

=item setColHeight(col_num, [pixels])

Applies setCellHeight over the entire column.

=item setColHead(col_num)

Applies setCellHead over the entire column.

=item setColNoWrap(col_num, [0|1])

Applies setCellNoWrap over the entire column.

=item setColBGColor(row_num, [colorname|colortriplet])

Applies setCellBGColor over the entire column.

=item setColFormat(col_num, start_string, end_sting)

Applies setCellFormat over the entire column.

=item setColStyle (col_num, 'css style') 

Applies setCellStyle over the entire column.

=item setColClass (col_num, 'css class') 

Applies setCellClass over the entire column.

=item setColAttr (col_num, 'user attribute') 

Applies setCellAttr over the entire column.

=item setLastCol*

All of the setCol methods have a corresponding setLastCol method which 
does not accept the col_num parameter, but automatically applies
to the last col of the table.

=item getColStyle(col_num)

Returns column's style attribute.  Only really useful after setting a column's style via setColStyle().

=back

=head2 Row Level Methods

=over 4

=item addRow("cell 1 content" [, "cell 2 content",  ...])

Adds a row to the bottom of the table.  Assumes if you
pass more values than there are columns that you want
to increase the number of columns.

=item setRowAlign(row_num, [center|right|left])

Applies setCellAlign over the entire row.

=item setRowVAlign(row_num, [center|top|bottom|middle|baseline])

Applies setCellVAlign over the entire row.

=item setRowWidth(row_num, [pixels|percentoftable])

Applies setCellWidth over the entire row.

=item setRowHeight(row_num, [pixels])

Applies setCellHeight over the entire row.

=item setRowHead(row_num)

Applies setCellHead over the entire row.

=item setRowNoWrap(col_num, [0|1])

Applies setCellNoWrap over the entire row.

=item setRowBGColor(row_num, [colorname|colortriplet])

Applies setCellBGColor over the entire row.

=item setRowFormat(row_num, start_string, end_string)

Applies setCellFormat over the entire row.

=item setRowStyle (row_num, 'css style') 

Applies setCellStyle over the entire row.

=item setRowClass (row_num, 'css class') 

Applies setCellClass over the entire row.

=item setRowAttr (row_num, 'user attribute') 

Applies setCellAttr over the entire row.

=item setLastRow*

All of the setRow methods have a corresponding setLastRow method which 
does not accept the row_num parameter, but automatically applies
to the last row of the table.

=item getRowStyle(row_num)

Returns row's style attribute.

=back

=head2 Output Methods

=over 4

=item getTable

Returns a string containing the HTML representation
of the table.

The same effect can also be achieved by using the object reference 
in a string scalar context.

For example...

	This code snippet:

		$table = new HTML::Table(2, 2);
		print '<p>Start</p>';
		print $table->getTable;
		print '<p>End</p>';

	would produce the same output as:

		$table = new HTML::Table(2, 2);
		print "<p>Start</p>$table<p>End</p>";

=item print

Prints HTML representation of the table to STDOUT

=back

=head1 CLASS VARIABLES

=head1 HISTORY

This module was originally created in 1997 by Stacy Lacy and whose last 
version was uploaded to CPAN in 1998.  The module was adopted in July 2000 
by Anthony Peacock in order to distribute a revised version.  This adoption 
took place without the explicit consent of Stacy Lacy as it proved impossible 
to contact them at the time.  Explicit consent for the adoption has since been 
received.

=head1 AUTHOR

Anthony Peacock, a.peacock@chime.ucl.ac.uk
Stacy Lacy (Original author)

=head1 CONTRIBUTIONS

Douglas Riordan <doug.riordan@gmail.com>
For get methods for Style attributes.

Jay Flaherty, fty@mediapulse.com
For ROW, COL & CELL HEAD methods. Modified the new method to allow hash of values.

John Stumbles, john@uk.stumbles.org
For autogrow behaviour of setCell, and allowing alignment specifications to be case insensitive

Arno Teunisse, Arno.Teunisse@Simac.nl
For the methods adding rules, styles and table alignment attributes.

Ville Skyttä, ville.skytta@iki.fi
For general fixes

Paul Vernaza, vernaza@stwing.upenn.edu
For the setLast... methods

David Link, dvlink@yahoo.com
For the sort method

Tommi Maekitalo, t.maekitalo@epgmbh.de
For adding the 'head' parameter to the new method and for adding the initialisation from an array ref 
to the new method.

=head1 COPYRIGHT

Copyright (c) 2000-2007 Anthony Peacock, CHIME.
Copyright (c) 1997 Stacy Lacy

This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

perl(1), CGI(3)

=cut

#-------------------------------------------------------
# Subroutine:  	new([num_rows, num_cols])
#            or new([-rows=>num_rows,
#                   -cols=>num_cols,
#                   -border=>border_width,
#                   -bgcolor=>back_colour,
#                   -width=>table_width,
#                   -spacing=>cell_spacing,
#                   -padding=>cell_padding]); 
# Author:       Stacy Lacy	
# Date:		30 Jul 1997
# Modified:     30 Mar 1998 - Jay Flaherty
# Modified:     13 Feb 2001 - Anthony Peacock
# Modified:     30 Aug 2002 - Tommi Maekitalo
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub new {

# Creates new table instance
my $type = shift;
my $class = ref($type) || $type;
my $self = {};
bless( $self, $class); 

# If paramter list is a hash (of the form -param=>value, ...)
if (defined $_[0] && $_[0] =~ /^-/) {
    my %flags = @_;
    $self->{border} = defined $flags{-border} && _is_validnum($flags{-border}) ? $flags{-border} : undef;
    $self->{align} = $flags{-align} || undef;
    $self->{rules} = $flags{-rules} || undef;
    $self->{style} = $flags{-style} || undef;
    $self->{class} = $flags{-class} || undef;
    $self->{bgcolor} = $flags{-bgcolor} || undef;
    $self->{background} = $flags{-background} || undef;
    $self->{width} = $flags{-width} || undef;
    $self->{cellspacing} = defined $flags{-spacing} && _is_validnum($flags{-spacing}) ? $flags{-spacing} : undef;
    $self->{cellpadding} = defined $flags{-padding} && _is_validnum($flags{-padding}) ? $flags{-padding} : undef;
    $self->{last_col} = $flags{-cols} || 0;

    if ($flags{-head})
    {
      $self->addRow(@{$flags{-head}});
      $self->setRowHead(1);
    }

    if ($flags{-data})
    {
      foreach (@{$flags{-data}})
      {
        $self->addRow(@$_);
      }
    }

	if ($self->{last_row}) {
		$self->{last_row} = $flags{-rows} if (defined $flags{-rows} && $self->{last_row} < $flags{-rows});
	} else {
	    $self->{last_row} = $flags{-rows} || 0;
	}

}
elsif (ref $_[0])
{
    # Array-reference [ ['row0col0', 'row0col1'], ['row1col0', 'row1col1'] ]
    $self->{last_row} = 0;
    $self->{last_col} = 0;
    foreach (@{$_[0]})
    {
      $self->addRow(@$_);
    }

}
else # user supplied row and col (or default to 0,0)
{
    $self->{last_row} = shift || 0;
    $self->{last_col} = shift || 0;
}

# Table Auto-Grow mode (default on)
$self->{autogrow} = 1;

return $self;
}	

#-------------------------------------------------------
# Subroutine:  	getTable
# Author:       Stacy Lacy
# Date:			30 July 1997
# Modified:     19 Mar 1998 - Jay Flaherty
# Modified:     13 Feb 2001 - Anthony Peacock
# Modified:		23 Oct 2001 - Terence Brown
# Modified:		05 Jan 2002 - Arno Teunisse
# Modified:		10 Jan 2002 - Anthony Peacock
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub getTable {
   my $self = shift;
   my $html="";

   # this sub returns HTML version of the table object
   if ((! $self->{last_row}) || (! $self->{last_col})) {
      return ;  # no rows or no cols
   }

	# Table tag
   $html .="\n<table";
   $html .=" border=\"$self->{border}\"" if defined $self->{border};
   $html .=" cellspacing=\"$self->{cellspacing}\"" if defined $self->{cellspacing};
   $html .=" cellpadding=\"$self->{cellpadding}\"" if defined $self->{cellpadding};
   $html .=" width=\"$self->{width}\"" if defined $self->{width};
   $html .=" bgcolor=\"$self->{bgcolor}\"" if defined $self->{bgcolor};
   $html .=" background=\"$self->{background}\"" if defined $self->{background};
   $html .=" rules=\"$self->{rules}\"" if defined $self->{rules} ;		# add rules for table
   $html .=" align=\"$self->{align}\"" if defined $self->{align} ; 		# alignment of the table
   $html .=" style=\"$self->{style}\"" if defined $self->{style} ; 		# style for the table
   $html .=" class=\"$self->{class}\"" if defined $self->{class} ; 		# class for the table
   $html .=" $self->{attr}" if defined $self->{attr} ;		 		# user defined attribute string
   $html .=">\n";
   if (defined $self->{caption}) {
      $html .="<caption";
      $html .=" align=\"$self->{caption_align}\"" if (defined $self->{caption_align});
      $html .=">$self->{caption}</caption>\n";
   }

   my ($i, $j);
	for ($i=1;$i <= ($self->{last_row});$i++){
    	# Print each row of the table   
		$html .="<tr" ;		

		# Set the row attributes (if any)
		$html .= ' bgcolor="' . $self->{rows}[$i]->{bgcolor} . '"' if defined $self->{rows}[$i]->{bgcolor};
		$html .= ' align="' . $self->{rows}[$i]->{align} . '"'  if defined $self->{rows}[$i]->{align};	
		$html .= ' valign="' . $self->{rows}[$i]->{valign} . '"'  if defined $self->{rows}[$i]->{valign} ;
		$html .= ' style="' . $self->{rows}[$i]->{style} . '"'  if defined $self->{rows}[$i]->{style} ;
		$html .= ' class="' . $self->{rows}[$i]->{class} . '"'  if defined $self->{rows}[$i]->{class} ;
		$html .= ' nowrap="' . $self->{rows}[$i]->{nowrap} . '"'  if defined $self->{rows}[$i]->{nowrap} ;
		$html .= " $self->{rows}[$i]->{attr}" if defined $self->{rows}[$i]->{attr} ;
		$html .= ">" ; 	# Closing tr tag
		
      for ($j=1; $j <= ($self->{last_col}); $j++) {
          
          if (defined $self->{rows}[$i]->{cells}[$j]->{colspan} && $self->{rows}[$i]->{cells}[$j]->{colspan} eq "SPANNED"){
             $html.="<!-- spanned cell -->";
             next
          }
          
          # print cell
          # if head flag is set print <th> tag else <td>
          if (defined $self->{rows}[$i]->{cells}[$j]->{head}) {
            $html .="<th";
          } else { 
            $html .="<td";
          }

          # if alignment options are set, add them in the cell tag
          $html .=' align="' . $self->{rows}[$i]->{cells}[$j]->{align} . '"'
                if defined $self->{rows}[$i]->{cells}[$j]->{align};
          
          $html .=" valign=\"" . $self->{rows}[$i]->{cells}[$j]->{valign} . "\""
                if defined $self->{rows}[$i]->{cells}[$j]->{valign};
          
          # apply custom height and width to the cell tag
          $html .=" width=\"" . $self->{rows}[$i]->{cells}[$j]->{width} . "\""
                if defined $self->{rows}[$i]->{cells}[$j]->{width};
                
          $html .=" height=\"" . $self->{rows}[$i]->{cells}[$j]->{height} . "\""
                if defined $self->{rows}[$i]->{cells}[$j]->{height};
                    
          # apply background color if set
          $html .=" bgcolor=\"" . $self->{rows}[$i]->{cells}[$j]->{bgcolor} . "\""
                if defined $self->{rows}[$i]->{cells}[$j]->{bgcolor};

          # apply style if set
          $html .=" style=\"" . $self->{rows}[$i]->{cells}[$j]->{style} . "\""
                if defined $self->{rows}[$i]->{cells}[$j]->{style};

          # apply class if set
          $html .=" class=\"" . $self->{rows}[$i]->{cells}[$j]->{class} . "\""
                if defined $self->{rows}[$i]->{cells}[$j]->{class};

          # User defined attribute
          $html .=" " . $self->{rows}[$i]->{cells}[$j]->{attr}
                if defined $self->{rows}[$i]->{cells}[$j]->{attr};

          # if nowrap mask is set, put it in the cell tag
          $html .=" nowrap" if defined $self->{rows}[$i]->{cells}[$j]->{nowrap};
          
          # if column/row spanning is set, put it in the cell tag
          # also increment to skip spanned rows/cols.
          if (defined $self->{rows}[$i]->{cells}[$j]->{colspan}) {
            $html .=" colspan=\"" . $self->{rows}[$i]->{cells}[$j]->{colspan} ."\"";
          }
          if (defined $self->{rows}[$i]->{cells}[$j]->{rowspan}){
            $html .=" rowspan=\"" . $self->{rows}[$i]->{cells}[$j]->{rowspan} ."\"";
          }
          
          # Finish up Cell by ending cell start tag, putting content and cell end tag
          $html .=">";
          $html .= $self->{rows}[$i]->{cells}[$j]->{startformat} if defined $self->{rows}[$i]->{cells}[$j]->{startformat} ;
          $html .= $self->{rows}[$i]->{cells}[$j]->{contents} if defined $self->{rows}[$i]->{cells}[$j]->{contents};
		  $html .= $self->{rows}[$i]->{cells}[$j]->{endformat} if defined $self->{rows}[$i]->{cells}[$j]->{endformat} ;
          
          # if head flag is set print </th> tag else </td>
          if (defined $self->{rows}[$i]->{cells}[$j]->{head}) {
            $html .= "</th>";
          } else {
            $html .= "</td>";
          }
      }
      $html .="</tr>\n";
   }
   $html .="</table>\n";

   return ($html);
}

#-------------------------------------------------------
# Subroutine:  	print
# Author:       Stacy Lacy	
# Date:		30 Jul 1997
#-------------------------------------------------------
sub print {
   my $self = shift;
   print $self->getTable;
}

#-------------------------------------------------------
# Subroutine:  	autoGrow([1|on|true|0|off|false]) 
# Author:       John Stumbles
# Date:		08 Feb 2001
# Description:  switches on (default) or off auto-grow mode
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub autoGrow {
    my $self = shift;
    $self->{autogrow} = shift;
	if ( defined $self->{autogrow} && $self->{autogrow} =~ /^(?:no|off|false|disable|0)$/i ) {
	    $self->{autogrow} = 0;
	} else {
		$self->{autogrow} = 1;
	}
}


#-------------------------------------------------------
# Table config methods
# 
#-------------------------------------------------------

#-------------------------------------------------------
# Subroutine:  	setBorder([pixels]) 
# Author:       Stacy Lacy	
# Date:		30 Jul 1997
# Modified:     12 Jul 2000 - Anthony Peacock (To allow zero values)
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setBorder {
    my $self = shift;
    $self->{border} = shift;
    $self->{border} = 1 unless ( &_is_validnum($self->{border}) ) ;
}

#-------------------------------------------------------
# Subroutine:  	setBGColor([colorname|colortriplet]) 
# Author:       Stacy Lacy	
# Date:		30 Jul 1997
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setBGColor {
   my $self = shift;
   $self->{bgcolor} = shift || undef;
}

#-------------------------------------------------------
# Subroutine:  	setStyle(css style) 
# Author:       Anthony Peacock
# Date:		6 Mar 2002
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setStyle {
   my $self = shift;
   $self->{style} = shift || undef;
}

#-------------------------------------------------------
# Subroutine:  	setClass(css class) 
# Author:       Anthony Peacock
# Date:			22 July 2002
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setClass {
   my $self = shift;
   $self->{class} = shift || undef;
}

#-------------------------------------------------------
# Subroutine:  	setWidth([pixels|percentofscreen]) 
# Author:       Stacy Lacy	
# Date:		30 Jul 1997
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setWidth {
   my $self = shift;
   my $value = shift;
   
   if ( $value !~ /^\s*\d+%?/ ) {
      print STDERR "$0:setWidth:Invalid value $value\n";
      return 0;
   } else {
      $self->{width} = $value;
   }    
}

#-------------------------------------------------------
# Subroutine:  	setCellSpacing([pixels]) 
# Author:       Stacy Lacy	
# Date:		30 Jul 1997
# Modified:     12 Jul 2000 - Anthony Peacock (To allow zero values)
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setCellSpacing {
    my $self = shift;
    $self->{cellspacing} = shift;
    $self->{cellspacing} = 1 unless ( &_is_validnum($self->{cellspacing}) ) ;
}

#-------------------------------------------------------
# Subroutine:  	setCellPadding([pixels]) 
# Author:       Stacy Lacy	
# Date:		30 Jul 1997
# Modified:     12 Jul 2000 - Anthony Peacock (To allow zero values)
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setCellPadding {
    my $self = shift;
    $self->{cellpadding} = shift;
    $self->{cellpadding} = 1 unless ( &_is_validnum($self->{cellpadding}) ) ;
}

#-------------------------------------------------------
# Subroutine:  	setCaption("CaptionText" [, "TOP|BOTTOM]) 
# Author:       Stacy Lacy	
# Date:		30 Jul 1997
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setCaption {
   my $self = shift;
   $self->{caption} = shift ;
   my $align = lc(shift);
   if (defined $align && (($align eq 'top') || ($align eq 'bottom')) ) {
      $self->{caption_align} = $align;
   } else {
      $self->{caption_align} = 'top';
   }
}

#-------------------------------------------------------
# Subroutine:  	setAlign([left|right|center]) 
# Author:         Arno Teunisse	 ( freely copied from setBGColor
# Date:		      05 Jan 2002
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setAlign {
   my $self = shift;
   $self->{align} = shift || undef;
}

#-------------------------------------------------------
# Subroutine:  	setRules([left|right|center]) 
# Author:         Arno Teunisse	 ( freely copied from setBGColor
# Date:		      05 Jan 2002
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
# parameter  	[ none | groups | rows| cols | all ]
#-------------------------------------------------------
sub setRules {
   my $self = shift;
   $self->{rules} = shift || undef;
}

#-------------------------------------------------------
# Subroutine:  	setAttr("attribute string") 
# Author:         Anthony Peacock
# Date:		      10 Jan 2002
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setAttr {
   my $self = shift;
   $self->{attr} = shift || undef;
}

#-------------------------------------------------------
# Subroutine:  	getTableRows 
# Author:       Joerg Jaspert
# Date:			4 Aug 2001
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub getTableRows{
    my $self = shift;
    return $self->{last_row};
}

#-------------------------------------------------------
# Subroutine:  	getTableCols 
# Author:       Joerg Jaspert
# Date:			4 Aug 2001
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub getTableCols{
    my $self = shift;
    return $self->{last_col};
}

#-------------------------------------------------------
# Subroutine:   getStyle
# Author:       Douglas Riordan
# Date:         30 Nov 2005
# Description:  getter for table style
#-------------------------------------------------------

sub getStyle {
    return shift->{style} || undef;
}

#-------------------------------------------------------
# Subroutine:  	sort (sort_col_num, [ALPHA|NUMERIC], [ASC|DESC], 
#                         num_rows_to_skip)
#               sort (-sort_col=>sort_col_num, 
#                         -sort_type=>[ALPHA|NUMERIC], 
#                         -sort_order=>[ASC|DESC], 
#                         -skip_rows=>num_rows_to_skip,
#                         -strip_html=>[0|1],         # default 1
#                         -strip_non_numeric=>[0|1],  # default 1 
#                                                     # for sort_type=NUMERIC
#                         -presort_func=>\&filter,
#                     )
# Author:       David Link
# Date:		28 Jun 2002
# Modified: 09 Apr 2003 -- dl  Added options: -strip_html, 
#                                  -strip_non_numeric, and -presort_func.
# Modified: 23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub sort {
  my $self = shift;
  my ($sort_col, $sort_type, $sort_order, $skip_rows, 
      $strip_html, $strip_non_numeric, $presort_func);
  $strip_html = 1;
  $strip_non_numeric = 1;

  if (defined $_[0] && $_[0] =~ /^-/) {
      my %flag = @_;
      $sort_col = $flag{-sort_col} || 1;
      $sort_type = $flag{-sort_type} || "alpha";
      $sort_order = $flag{-sort_order} || "asc";
      $skip_rows = $flag{-skip_rows} || 0;
      $strip_html = $flag{-strip_html} if defined($flag{-strip_html});
      $strip_non_numeric = $flag{-strip_non_numeric} 
          if defined($flag{-strip_non_numeric});
      $presort_func = $flag{-presort_func} || undef;
  }
  else {
      $sort_col = shift || 1;
      $sort_type = shift || "alpha";
      $sort_order = shift || "asc";
      $skip_rows = shift || 0;
      $presort_func = undef;
  }
  my $cmp_symbol = lc($sort_type) eq "alpha" ? "cmp" : "<=>";
  my ($first, $last) = lc($sort_order) eq "asc"?("\$a", "\$b"):("\$b", "\$a");
  my $piece1 = qq/\$self->{rows}[$first]->{cells}[$sort_col]->{contents}/;
  my $piece2 = qq/\$self->{rows}[$last]->{cells}[$sort_col]->{contents}/;
  if ($strip_html) {
      $piece1 = qq/&_stripHTML($piece1)/;
      $piece2 = qq/&_stripHTML($piece2)/;
  }
  if ($presort_func) {
      $piece1 = qq/\&{\$presort_func}($piece1)/;
      $piece2 = qq/\&{\$presort_func}($piece2)/;
  } 
  if (lc($sort_type) ne 'alpha' && $strip_non_numeric) {
      $piece1 = qq/&_stripNonNumeric($piece1)/;
      $piece2 = qq/&_stripNonNumeric($piece2)/;
  }
  my $sortfunc = qq/sub { $piece1 $cmp_symbol $piece2 }/;
  my $sorter = eval($sortfunc);
  my @sortkeys = sort $sorter (($skip_rows+1)..$self->{last_row});

	my @holdtable = @{$self->{rows}};
	my $i = $skip_rows+1;
	for my $k (@sortkeys) {
		$self->{rows}[$i++] = $holdtable[$k];
	}
}

#-------------------------------------------------------
# Subroutine:   _stripHTML (html_string)
# Author:       David Link
# Date:         12 Feb 2003
#-------------------------------------------------------
sub _stripHTML {
    $_ = $_[0]; 
    s/ \< [^>]* \> //gx;
    s/\&nbsp;/ /g;
    return $_;  	
}	

#-------------------------------------------------------
# Subroutine:   _stripNonNumeric (string)
# Author:       David Link
# Date:         04 Apr 2003
# Description:  Remove all non-numeric char from a string
#                 For efficiency does not deal with:
#                 1. nested '-' chars.,  2. multiple '.' chars.
#-------------------------------------------------------
sub _stripNonNumeric {
    $_ = $_[0]; 
    s/[^0-9.+-]//g;
    return 0 if !$_;
    return $_;
}

#-------------------------------------------------------
# Cell config methods
# 
#-------------------------------------------------------

#-------------------------------------------------------
# Subroutine:  	setCell(row_num, col_num, "content") 
# Author:       Stacy Lacy	
# Date:		30 Jul 1997
# Modified:     08 Feb 2001 - John Stumbles to allow auto-growing of table
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setCell {
   my $self = shift;
   (my $row = shift) || return 0;
   (my $col = shift) || return 0;

	# If -1 is used in either the row or col parameter, use the last row or cell
	$row = $self->{last_row} if $row == -1;
	$col = $self->{last_col} if $col == -1;

   if ($row < 1) {
      print STDERR "$0:setCell:Invalid table row reference $row:$col\n";
      return 0;
   }
   if ($col < 1) {
      print STDERR "$0:setCell:Invalid table column reference $row:$col\n";
      return 0;
   }
   if ($row > $self->{last_row}) {
      if ($self->{autogrow}) {
        $self->{last_row} = $row ;
      } else {
        print STDERR "$0:setCell:Invalid table row reference $row:$col\n";
      }
   }
   if ($col > $self->{last_col}) {
      if ($self->{autogrow}) {
        $self->{last_col} = $col ;
      } else {
        print STDERR "$0:setCell:Invalid table column reference $row:$col\n";
      }
   }
	$self->{rows}[$row]->{cells}[$col]->{contents} = shift;
   return ($row, $col);

}

#-------------------------------------------------------
# Subroutine:  	getCell(row_num, col_num) 
# Author:       Anthony Peacock	
# Date:		27 Jul 1998
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub getCell {
   my $self = shift;
   (my $row = shift) || return 0;
   (my $col = shift) || return 0;

	# If -1 is used in either the row or col parameter, use the last row or cell
	$row = $self->{last_row} if $row == -1;
	$col = $self->{last_col} if $col == -1;

   if (($row > $self->{last_row}) || ($row < 1) ) {
      print STDERR "$0:getCell:Invalid table reference $row:$col\n";
      return 0;
   }
   if (($col > $self->{last_col}) || ($col < 1) ) {
      print STDERR "$0:getCell:Invalid table reference $row:$col\n";
      return 0;
   }

   return $self->{rows}[$row]->{cells}[$col]->{contents} ;
}

#-------------------------------------------------------
# Subroutine:   getCellStyle($row_num, $col_num)
# Author:       Douglas Riordan
# Date:         30 Nov 2005
# Description:  getter for cell style
#-------------------------------------------------------

sub getCellStyle {
    my ($self, $row, $col) = @_;

    return $self->_checkRowAndCol('getCellStyle', {row => $row, col => $col})
        ? $self->{rows}[$row]->{cells}[$col]->{style}
        : undef;
}

#-------------------------------------------------------
# Subroutine:  	setCellAlign(row_num, col_num, [center|right|left]) 
# Author:       Stacy Lacy	
# Date:		30 Jul 1997
# Modified:     13 Feb 2001 - Anthony Peacock for case insensitive
#                             alignment parameters
#                             (suggested by John Stumbles)
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setCellAlign {
   my $self = shift;
   (my $row = shift) || return 0;
   (my $col = shift) || return 0;
	my $align = lc(shift);

	# If -1 is used in either the row or col parameter, use the last row or cell
	$row = $self->{last_row} if $row == -1;
	$col = $self->{last_col} if $col == -1;

   if (($row > $self->{last_row}) || ($row < 1) ) {
      print STDERR "$0:setCellAlign:Invalid table reference\n";
      return 0;
   }
   if (($col > $self->{last_col}) || ($col < 1) ) {
      print STDERR "$0:setCellAlign:Invalid table reference\n";
      return 0;
   }

   if (! $align) {
      #return to default alignment if none specified
      undef $self->{rows}[$row]->{cells}[$col]->{align};
      return ($row, $col);
   }

   if (! (($align eq 'center') || ($align eq 'right') || 
          ($align eq 'left'))) {
      print STDERR "$0:setCellAlign:Invalid alignment type\n";
      return 0;
   }

   # We have a valid alignment type so let's set it for the cell
   $self->{rows}[$row]->{cells}[$col]->{align} = $align;
   return ($row, $col);
}

#-------------------------------------------------------
# Subroutine:  	setCellVAlign(row_num, col_num, [center|top|bottom|middle|baseline]) 
# Author:       Stacy Lacy	
# Date:		30 Jul 1997
# Modified:     13 Feb 2001 - Anthony Peacock for case insensitive
#                             alignment parameters
#                             (suggested by John Stumbles)
# Modified:		22 Aug 2003 - Alejandro Juarez to add MIDDLE and BASELINE
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setCellVAlign {
   my $self = shift;
   (my $row = shift) || return 0;
   (my $col = shift) || return 0;
   my $valign = lc(shift);
   
	# If -1 is used in either the row or col parameter, use the last row or cell
	$row = $self->{last_row} if $row == -1;
	$col = $self->{last_col} if $col == -1;

   if (($row > $self->{last_row}) || ($row < 1) ) {
      print STDERR "$0:setCellVAlign:Invalid table reference\n";
      return 0;
   }
   if (($col > $self->{last_col}) || ($col < 1) ) {
      print STDERR "$0:setCellVAlign:Invalid table reference\n";
      return 0;
   }

   if (! $valign) {
      #return to default alignment if none specified
      undef $self->{"table:valign"}{"$row:$col"};
      return ($row, $col);
   }

   if (! (($valign eq "center") || ($valign eq "top") || 
          ($valign eq "bottom")  || ($valign eq "middle") ||
		  ($valign eq "baseline")) ) {
      print STDERR "$0:setCellVAlign:Invalid alignment type\n";
      return 0;
   }

   # We have a valid valignment type so let's set it for the cell
   $self->{rows}[$row]->{cells}[$col]->{valign} = $valign;
   return ($row, $col);
}

#-------------------------------------------------------
# Subroutine:  	setCellHead(row_num, col_num, [0|1]) 
# Author:       Jay Flaherty
# Date:		19 Mar 1998
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setCellHead{
   my $self = shift;
   (my $row = shift) || return 0;
   (my $col = shift) || return 0;
   my $value = shift || 1;

	# If -1 is used in either the row or col parameter, use the last row or cell
	$row = $self->{last_row} if $row == -1;
	$col = $self->{last_col} if $col == -1;

   if (($row > $self->{last_row}) || ($row < 1) ) {
      print STDERR "$0:setCellHead:Invalid table reference\n";
      return 0;
   }
   if (($col > $self->{last_col}) || ($col < 1) ) {
      print STDERR "$0:setCellHead:Invalid table reference\n";
      return 0;
   }

   $self->{rows}[$row]->{cells}[$col]->{head} = $value;
   return ($row, $col);
}

#-------------------------------------------------------
# Subroutine:  	setCellNoWrap(row_num, col_num, [0|1]) 
# Author:       Stacy Lacy	
# Date:		30 Jul 1997
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setCellNoWrap {
   my $self = shift;
   (my $row = shift) || return 0;
   (my $col = shift) || return 0;
   (my $value = shift);

	# If -1 is used in either the row or col parameter, use the last row or cell
	$row = $self->{last_row} if $row == -1;
	$col = $self->{last_col} if $col == -1;

   if (($row > $self->{last_row}) || ($row < 1) ) {
      print STDERR "$0:setCellNoWrap:Invalid table reference\n";
      return 0;
   }
   if (($col > $self->{last_col}) || ($col < 1) ) {
      print STDERR "$0:setCellNoWrap:Invalid table reference\n";
      return 0;
   }

   $self->{rows}[$row]->{cells}[$col]->{nowrap} = $value;
   return ($row, $col);
}

#-------------------------------------------------------
# Subroutine:  	setCellWidth(row_num, col_num, [pixels|percentoftable]) 
# Author:       Stacy Lacy	
# Date:		30 Jul 1997
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setCellWidth {
   my $self = shift;
   (my $row = shift) || return 0;
   (my $col = shift) || return 0;
   (my $value = shift);

	# If -1 is used in either the row or col parameter, use the last row or cell
	$row = $self->{last_row} if $row == -1;
	$col = $self->{last_col} if $col == -1;

   if (($row > $self->{last_row}) || ($row < 1) ) {
      print STDERR "$0:setCellWidth:Invalid table reference\n";
      return 0;
   }
   if (($col > $self->{last_col}) || ($col < 1) ) {
      print STDERR "$0:setCellWidth:Invalid table reference\n";
      return 0;
   }

   if (! $value) {
      #return to default alignment if none specified
      undef $self->{"table:width"}{"$row:$col"};
      return ($row, $col);
   }

   if ( $value !~ /^\s*\d+%?/ ) {
      print STDERR "$0:setCellWidth:Invalid value $value\n";
      return 0;
   } else {
      $self->{rows}[$row]->{cells}[$col]->{width} = $value;
      return ($row, $col);
   }
}

#-------------------------------------------------------
# Subroutine:  	setCellHeight(row_num, col_num, [pixels]) 
# Author:       Stacy Lacy	
# Date:		30 Jul 1997
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setCellHeight {
   my $self = shift;
   (my $row = shift) || return 0;
   (my $col = shift) || return 0;
   (my $value = shift);

	# If -1 is used in either the row or col parameter, use the last row or cell
	$row = $self->{last_row} if $row == -1;
	$col = $self->{last_col} if $col == -1;

   if (($row > $self->{last_row}) || ($row < 1) ) {
      print STDERR "$0:setCellHeight:Invalid table reference\n";
      return 0;
   }
   if (($col > $self->{last_col}) || ($col < 1) ) {
      print STDERR "$0:setCellHeight:Invalid table reference\n";
      return 0;
   }

   if (! $value) {
      #return to default alignment if none specified
      undef $self->{"table:cellheight"}{"$row:$col"};
      return ($row, $col);
   }

   if (! ($value > 0)) {
      print STDERR "$0:setCellHeight:Invalid value $value\n";
      return 0;
   } else {
      $self->{rows}[$row]->{cells}[$col]->{height} = $value;
      return ($row, $col);
   }
}

#-------------------------------------------------------
# Subroutine:  	setCellBGColor(row_num, col_num, [colorname|colortrip]) 
# Author:       Stacy Lacy	
# Date:		30 Jul 1997
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setCellBGColor {
   my $self = shift;
   (my $row = shift) || return 0;
   (my $col = shift) || return 0;
   (my $value = shift);

	# If -1 is used in either the row or col parameter, use the last row or cell
	$row = $self->{last_row} if $row == -1;
	$col = $self->{last_col} if $col == -1;

   if (($row > $self->{last_row}) || ($row < 1) ) {
      print STDERR "$0:setCellBGColor:Invalid table reference\n";
      return 0;
   }
   if (($col > $self->{last_col}) || ($col < 1) ) {
      print STDERR "$0:setCellBGColor:Invalid table reference\n";
      return 0;
   }

   if (! $value) {
      #return to default alignment if none specified
      undef $self->{"table:cellbgcolor"}{"$row:$col"};
   }

   # BG colors are too hard to verify, let's assume user
   # knows what they are doing
   $self->{rows}[$row]->{cells}[$col]->{bgcolor} = $value;
   return ($row, $col);
}

#-------------------------------------------------------
# Subroutine:  	setCellSpan(row_num, col_num, num_rows, num_cols)
# Author:       Anthony Peacock
# Date:			22 July 2002
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setCellSpan {
   my $self = shift;
   (my $row = shift) || return 0;
   (my $col = shift) || return 0;
   (my $num_rows = shift);
   (my $num_cols = shift);

	# If -1 is used in either the row or col parameter, use the last row or cell
	$row = $self->{last_row} if $row == -1;
	$col = $self->{last_col} if $col == -1;

   if (($row > $self->{last_row}) || ($row < 1) ) {
      print STDERR "$0:setCellpan:Invalid table reference\n";
      return 0;
   }
   if (($col > $self->{last_col}) || ($col < 1) ) {
      print STDERR "$0:setCellSpan:Invalid table reference\n";
      return 0;
   }

   if (! $num_cols || ! $num_rows) {
      #return to default if none specified
      undef $self->{rows}[$row]->{cells}[$col]->{colspan};
      undef $self->{rows}[$row]->{cells}[$col]->{rowspan};
   }

   $self->{rows}[$row]->{cells}[$col]->{colspan} = $num_cols;
   $self->{rows}[$row]->{cells}[$col]->{rowspan} = $num_rows;

   $self->_updateSpanGrid($row,$col);
   
   return ($row, $col);
}

#-------------------------------------------------------
# Subroutine:  	setCellRowSpan(row_num, col_num, num_cells)
# Author:       Stacy Lacy	
# Date:		31 Jul 1997
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setCellRowSpan {
   my $self = shift;
   (my $row = shift) || return 0;
   (my $col = shift) || return 0;
   (my $value = shift);

	# If -1 is used in either the row or col parameter, use the last row or cell
	$row = $self->{last_row} if $row == -1;
	$col = $self->{last_col} if $col == -1;

   if (($row > $self->{last_row}) || ($row < 1) ) {
      print STDERR "$0:setCellRowSpan:Invalid table reference\n";
      return 0;
   }
   if (($col > $self->{last_col}) || ($col < 1) ) {
      print STDERR "$0:setCellRowSpan:Invalid table reference\n";
      return 0;
   }

   if (! $value) {
      #return to default alignment if none specified
      undef $self->{rows}[$row]->{cells}[$col]->{rowspan};
   }

   $self->{rows}[$row]->{cells}[$col]->{rowspan} = $value;
   
   $self->_updateSpanGrid($row,$col);
   
   return ($row, $col);
}

#-------------------------------------------------------
# Subroutine:  	setCellColSpan(row_num, col_num, num_cells)
# Author:       Stacy Lacy	
# Date:		31 Jul 1997
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setCellColSpan {
   my $self = shift;
   (my $row = shift) || return 0;
   (my $col = shift) || return 0;
   (my $value = shift);

	# If -1 is used in either the row or col parameter, use the last row or cell
	$row = $self->{last_row} if $row == -1;
	$col = $self->{last_col} if $col == -1;

   if (($row > $self->{last_row}) || ($row < 1) ) {
      print STDERR "$0:setCellColSpan:Invalid table reference\n";
      return 0;
   }

   if (($col > $self->{last_col}) || ($col < 1) ) {
      print STDERR "$0:setCellColSpan:Invalid table reference\n";
      return 0;
   }

   if (! $value) {
      #return to default alignment if none specified
      undef $self->{rows}[$row]->{cells}[$col]->{colspan};
   }

   $self->{rows}[$row]->{cells}[$col]->{colspan} = $value;

   $self->_updateSpanGrid($row,$col);
   
   return ($row, $col);
}

#-------------------------------------------------------
# Subroutine:  	setCellFormat(row_num, col_num, start_string, end_string) 
# Author:       Anthony Peacock
# Date:			21 Feb 2001
# Description:	Sets start and end HTML formatting strings for
#               the cell content
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setCellFormat {
   my $self = shift;
   (my $row = shift) || return 0;
   (my $col = shift) || return 0;
   (my $start_string = shift);
   (my $end_string = shift);

	# If -1 is used in either the row or col parameter, use the last row or cell
	$row = $self->{last_row} if $row == -1;
	$col = $self->{last_col} if $col == -1;

   if (($row > $self->{last_row}) || ($row < 1) ) {
      print STDERR "$0:setCellFormat:Invalid table reference\n";
      return 0;
   }
   if (($col > $self->{last_col}) || ($col < 1) ) {
      print STDERR "$0:setCellFormat:Invalid table reference\n";
      return 0;
   }

   if (! $start_string) {
      #return to default format if none specified
      undef $self->{rows}[$row]->{cells}[$col]->{startformat};
      undef $self->{rows}[$row]->{cells}[$col]->{endformat};
   }
	else
	{
		# No checks will be made on the validity of these strings
		# User must take responsibility for results...
		$self->{rows}[$row]->{cells}[$col]->{startformat} = $start_string;
		$self->{rows}[$row]->{cells}[$col]->{endformat} = $end_string;
   }
   return ($row, $col);
}

#-------------------------------------------------------
# Subroutine:  	setCellStyle(row_num, col_num, "Style") 
# Author:       Anthony Peacock	
# Date:			10 Jan 2002
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------

sub setCellStyle {
   my $self = shift;
   (my $row = shift) || return 0;
   (my $col = shift) || return 0;
   (my $value = shift);

	# If -1 is used in either the row or col parameter, use the last row or cell
	$row = $self->{last_row} if $row == -1;
	$col = $self->{last_col} if $col == -1;

   if (($row > $self->{last_row}) || ($row < 1) ) {
      print STDERR "$0:setCellStyle:Invalid table reference\n";
      return 0;
   }
   if (($col > $self->{last_col}) || ($col < 1) ) {
      print STDERR "$0:setCellStyle:Invalid table reference\n";
      return 0;
   }

   if (! $value) {
      #return to default style if none specified
      undef $self->{rows}[$row]->{cells}[$col]->{style};
      return ($row, $col);
   }

   $self->{rows}[$row]->{cells}[$col]->{style} = $value;
   return ($row, $col);
}

#-------------------------------------------------------
# Subroutine:  	setCellClass(row_num, col_num, "class") 
# Author:       Anthony Peacock	
# Date:			22 July 2002
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setCellClass {
   my $self = shift;
   (my $row = shift) || return 0;
   (my $col = shift) || return 0;
   (my $value = shift);

	# If -1 is used in either the row or col parameter, use the last row or cell
	$row = $self->{last_row} if $row == -1;
	$col = $self->{last_col} if $col == -1;

   if (($row > $self->{last_row}) || ($row < 1) ) {
      print STDERR "$0:setCellClass:Invalid table reference\n";
      return 0;
   }
   if (($col > $self->{last_col}) || ($col < 1) ) {
      print STDERR "$0:setCellClass:Invalid table reference\n";
      return 0;
   }

   if (! $value) {
      #return to default class if none specified
      undef $self->{rows}[$row]->{cells}[$col]->{class};
      return ($row, $col);
   }

   $self->{rows}[$row]->{cells}[$col]->{class} = $value;
   return ($row, $col);
}

#-------------------------------------------------------
# Subroutine:  	setCellAttr(row_num, col_num, "cell attribute string") 
# Author:       Anthony Peacock
# Date:			10 Jan 2002
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setCellAttr {
   my $self = shift;
   (my $row = shift) || return 0;
   (my $col = shift) || return 0;
   (my $value = shift);

	# If -1 is used in either the row or col parameter, use the last row or cell
	$row = $self->{last_row} if $row == -1;
	$col = $self->{last_col} if $col == -1;

   if (($row > $self->{last_row}) || ($row < 1) ) {
      print STDERR "$0:setCellAttr:Invalid table reference\n";
      return 0;
   }
   if (($col > $self->{last_col}) || ($col < 1) ) {
      print STDERR "$0:setCellAttr:Invalid table reference\n";
      return 0;
   }

   if (! $value) {
      undef $self->{rows}[$row]->{cells}[$col]->{attr};
   }

   $self->{rows}[$row]->{cells}[$col]->{attr} = $value;
   return ($row, $col);
}

#-------------------------------------------------------
# Row config methods
# 
#-------------------------------------------------------


#-------------------------------------------------------
# Subroutine:  	addRow("cell 1 content" [, "cell 2 content",  ...]) 
# Author:       Stacy Lacy	
# Date:		30 Jul 1997
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub addRow {
   my $self = shift;

   # this sub should add a row, using @_ as contents
   my $count = @_;
   # if number of cells is greater than cols, let's assume
   # we want to add a column.
   $self->{last_col} = $count if ($count > $self->{last_col});
   $self->{last_row}++;  # increment number of rows
   for (my $i = 1; $i <= $count; $i++) {
      # Store each value in cell on row
         $self->{rows}[$self->{last_row}]->{cells}[$i]->{contents} = shift;
   }
   return $self->{last_row};
   
}

#-------------------------------------------------------
# Subroutine:  	setRowAlign(row_num, [center|right|left]) 
# Author:       Stacy Lacy
# Date:			30 Jul 1997
# Modified:		05 Jan 2002 - Arno Teunisse
# Modified:		10 Jan 2002 - Anthony Peacock
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setRowAlign {
	my $self = shift;
	(my $row = shift) || return 0;
	my $align = shift;

	# If -1 is used in the row parameter, use the last row
	$row = $self->{last_row} if $row == -1;

	if ( $row > $self->{last_row} || $row < 1 ) {
		print STDERR "\n$0:setRowAlign: Invalid table reference" ;
		return 0;
	} elsif ( $align !~ /left|right|center/i ) {
		print STDERR "\nsetRowAlign: Alignment can be : 'left | right | center' : Cur value: $align\n";
		return 0;
	}
	
   $self->{rows}[$row]->{align} = $align  ;
}

#-------------------------------------------------------
# Subroutine:	setRowStyle
# Comment:		to insert a css style the <tr > Tag
# Author:		Arno Teunisse
# Date:			05 Jan 2002
# Modified: 	10 Jan 2002 - Anthony Peacock
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setRowStyle {
	my $self = shift;
	(my $row = shift) || return 0;
	my $html_str = shift;

	# If -1 is used in the row parameter, use the last row
	$row = $self->{last_row} if $row == -1;

	if ( $row > $self->{last_row} || $row < 1 ) {
		print STDERR "\n$0:setRowStyle: Invalid table reference" ;
		return 0;
	}
	
	$self->{rows}[$row]->{style} = $html_str  ;
}

#-------------------------------------------------------
# Subroutine:	setRowClass
# Comment:		to insert a css class in the <tr > Tag
# Author:		Anthony Peacock (based on setRowStyle by Arno Teunisse)
# Date:			22 July 2002
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setRowClass {
	my $self = shift;
	(my $row = shift) || return 0;
	my $html_str = shift;

	# If -1 is used in the row parameter, use the last row
	$row = $self->{last_row} if $row == -1;

	if ( $row > $self->{last_row} || $row < 1 ) {
		print STDERR "\n$0:setRowClass: Invalid table reference" ;
		return 0;
	}
	
	$self->{rows}[$row]->{class} = $html_str ;
}


#-------------------------------------------------------
# Subroutine:  	setRowVAlign(row_num, [center|top|bottom]) 
# Author:       Stacy Lacy	
# Date:			30 Jul 1997
# Modified:		23 Oct 2003 - Anthony Peacock
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setRowVAlign {
   my $self = shift;
   (my $row = shift) || return 0;
   my $valign = shift;

	# If -1 is used in the row parameter, use the last row
	$row = $self->{last_row} if $row == -1;

	if ( $row > $self->{last_row} || $row < 1 ) {
		print STDERR "\n$0:setRowVAlign: Invalid table reference" ;
		return 0;
	}
	
	$self->{rows}[$row]->{valign} = $valign ;
}

#-------------------------------------------------------
# Subroutine:  	setRowHead(row_num, [0|1]) 
# Author:       Stacy Lacy	
# Date:			30 Jul 1997
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setRowHead {
   my $self = shift;
   (my $row = shift) || return 0;
   my $value = shift || 1;

	# If -1 is used in the row parameter, use the last row
	$row = $self->{last_row} if $row == -1;

	if ( $row > $self->{last_row} || $row < 1 ) {
		print STDERR "\n$0:setRowHead: Invalid table reference" ;
		return 0;
	}

   # this sub should change the head flag of a row;
   my $i;
   for ($i=1;$i <= $self->{last_col};$i++) {
      $self->setCellHead($row, $i, $value);
   }
}

#-------------------------------------------------------
# Subroutine:  	setRowNoWrap(row_num, col_num, [0|1]) 
# Author:       Anthony Peacock
# Date:		22 Feb 2001
# Modified:		23 Oct 2003 - Anthony Peacock
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setRowNoWrap {
   my $self = shift;
   (my $row = shift) || return 0;
   my $value = shift;
   
	# If -1 is used in the row parameter, use the last row
	$row = $self->{last_row} if $row == -1;

	if ( $row > $self->{last_row} || $row < 1 ) {
		print STDERR "\n$0:setRowNoWrap: Invalid table reference" ;
		return 0;
	}
	
	$self->{rows}[$row]->{nowrap} = $value ;
}

#-------------------------------------------------------
# Subroutine:  	setRowWidth(row_num, [pixels|percentoftable]) 
# Author:       Anthony Peacock
# Date:		22 Feb 2001
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setRowWidth {
   my $self = shift;
   (my $row = shift) || return 0;
   my $value = shift;
   
	# If -1 is used in the row parameter, use the last row
	$row = $self->{last_row} if $row == -1;

	if ( $row > $self->{last_row} || $row < 1 ) {
		print STDERR "\n$0:setRowWidth: Invalid table reference" ;
		return 0;
	}

   # this sub should change the cell width of a row;
   my $i;
   for ($i=1;$i <= $self->{last_col};$i++) {
      $self->setCellWidth($row, $i, $value);
   }
}

#-------------------------------------------------------
# Subroutine:  	setRowHeight(row_num, [pixels]) 
# Author:       Anthony Peacock
# Date:		22 Feb 2001
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setRowHeight {
   my $self = shift;
   (my $row = shift) || return 0;
   my $value = shift;
   
	# If -1 is used in the row parameter, use the last row
	$row = $self->{last_row} if $row == -1;

	if ( $row > $self->{last_row} || $row < 1 ) {
		print STDERR "\n$0:setRowHeight: Invalid table reference" ;
		return 0;
	}

   # this sub should change the cell height of a row;
   my $i;
   for ($i=1;$i <= $self->{last_col};$i++) {
      $self->setCellHeight($row, $i, $value);
   }
}

#-------------------------------------------------------
# Subroutine:  	setRowBGColor(row_num, [colorname|colortriplet]) 
# Author:		Arno Teunisse 	
# Date:			08 Jan 2002
# Modified:		10 Jan 2002 - Anthony Peacock
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setRowBGColor {
	my $self = shift;
	(my $row = shift) || return 0;
	my $value = shift;

	# If -1 is used in the row parameter, use the last row
	$row = $self->{last_row} if $row == -1;

	# You cannot set a nonexistent row
	if ( $row > $self->{last_row} || $row < 1 ) {
		print STDERR "\n$0:setRowBGColor: Invalid table reference" ;
		return 0;
	}
	
	$self->{rows}[$row]->{bgcolor} = $value  ;
}


#-------------------------------------------------------
# Subroutine:  	setRowFormat(row_num, start_string, end_string) 
# Author:       Anthony Peacock
# Date:			21 Feb 2001
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setRowFormat {
   my $self = shift;
   (my $row = shift) || return 0;
   my ($start_string, $end_string) = @_;
   
	# If -1 is used in the row parameter, use the last row
	$row = $self->{last_row} if $row == -1;

	# You cannot set a nonexistent row
	if ( $row > $self->{last_row} || $row < 1 ) {
		print STDERR "\n$0:setRowFormat: Invalid table reference" ;
		return 0;
	}

   # this sub should set format strings for each
   # cell in a row given a row number;
   my $i;
   for ($i=1;$i <= $self->{last_col};$i++) {
      $self->setCellFormat($row,$i, $start_string, $end_string);
   }
}

#-------------------------------------------------------
# Subroutine:	setRowAttr(row, "Attribute string")
# Comment:		To add user defined attribute to specified row
# Author:		Anthony Peacock
# Date:			10 Jan 2002
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub setRowAttr {
	my $self = shift;
	(my $row = shift) || return 0;
	my $html_str = shift;

	# If -1 is used in the row parameter, use the last row
	$row = $self->{last_row} if $row == -1;

	# You cannot set a nonexistent row
	if ( $row > $self->{last_row} || $row < 1 ) {
		print STDERR "\n$0:setRowAttr: Invalid table reference" ;
		return 0;
	}
	
	$self->{rows}[$row]->{attr} = $html_str;
}

#-------------------------------------------------------
# Subroutine:   getRowStyle($row_num)
# Author:       Douglas Riordan
# Date:         1 Dec 2005
# Description:  getter for row style
#-------------------------------------------------------

sub getRowStyle {
    my ($self, $row) = @_;

    return $self->_checkRowAndCol('getRowStyle', {row => $row})
        ? $self->{rows}[$row]->{style}
        : undef;
}

#-------------------------------------------------------
# Col config methods
# 
#-------------------------------------------------------

#-------------------------------------------------------
# Subroutine:  	addCol("cell 1 content" [, "cell 2 content",  ...]) 
# Author:       Stacy Lacy	
# Date:		30 Jul 1997
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub addCol {
   my $self = shift;
      
   # this sub should add a column, using @_ as contents
   my $count= @_;
   # if number of cells is greater than rows, let's assume
   # we want to add a row.
   $self->{last_row} = $count if ($count >$self->{last_row});
   $self->{last_col}++;  # increment number of rows
   my $i;
   for ($i=1;$i <= $count;$i++) {
      # Store each value in cell on row
      $self->{rows}[$i]->{cells}[$self->{last_col}]->{contents} = shift;
   }
   return $self->{last_col};

}

#-------------------------------------------------------
# Subroutine:  	setColAlign(col_num, [center|right|left]) 
# Author:       Stacy Lacy	
# Date:		30 Jul 1997
#-------------------------------------------------------
sub setColAlign {
   my $self = shift;
   (my $col = shift) || return 0;
   my $align = shift;

	# If -1 is used in the col parameter, use the last col
	$col = $self->{last_col} if $col == -1;

	# You cannot set a nonexistent row
	if ( $col > $self->{last_col} || $col < 1 ) {
		print STDERR "\n$0:setColAlign: Invalid table reference" ;
		return 0;
	}

   # this sub should align a col given a col number;
   my $i;
   for ($i=1;$i <= $self->{last_row};$i++) {
      $self->setCellAlign($i,$col, $align);
   }
}

#-------------------------------------------------------
# Subroutine:  	setColVAlign(col_num, [center|top|bottom])
# Author:       Stacy Lacy	
# Date:		30 Jul 1997
#-------------------------------------------------------
sub setColVAlign {
   my $self = shift;
   (my $col = shift) || return 0;
   my $valign = shift;

	# If -1 is used in the col parameter, use the last col
	$col = $self->{last_col} if $col == -1;

	# You cannot set a nonexistent row
	if ( $col > $self->{last_col} || $col < 1 ) {
		print STDERR "\n$0:setColVAlign: Invalid table reference" ;
		return 0;
	}

   # this sub should align a all rows given a column number;
   my $i;
   for ($i=1;$i <= $self->{last_row};$i++) {
      $self->setCellVAlign($i,$col, $valign);
   }
}

#-------------------------------------------------------
# Subroutine:  	setColHead(col_num, [0|1]) 
# Author:       Jay Flaherty
# Date:		30 Mar 1998
#-------------------------------------------------------
sub setColHead {
   my $self = shift;
   (my $col = shift) || return 0;
   my $value = shift || 1;

	# If -1 is used in the col parameter, use the last col
	$col = $self->{last_col} if $col == -1;

	# You cannot set a nonexistent row
	if ( $col > $self->{last_col} || $col < 1 ) {
		print STDERR "\n$0:setColHead: Invalid table reference" ;
		return 0;
	}

   # this sub should set the head attribute of a col given a col number;
   my $i;
   for ($i=1;$i <= $self->{last_row};$i++) {
      $self->setCellHead($i,$col, $value);
   }
}

#-------------------------------------------------------
# Subroutine:  	setColNoWrap(row_num, col_num, [0|1]) 
# Author:       Stacy Lacy	
# Date:		30 Jul 1997
#-------------------------------------------------------
sub setColNoWrap {
   my $self = shift;
   (my $col = shift) || return 0;
   my $value = shift;

	# If -1 is used in the col parameter, use the last col
	$col = $self->{last_col} if $col == -1;

	# You cannot set a nonexistent row
	if ( $col > $self->{last_col} || $col < 1 ) {
		print STDERR "\n$0:setColNoWrap: Invalid table reference" ;
		return 0;
	}

   # this sub should change the wrap flag of a column;
   my $i;
   for ($i=1;$i <= $self->{last_row};$i++) {
      $self->setCellNoWrap($i,$col, $value);
   }
}

#-------------------------------------------------------
# Subroutine:  	setColWidth(col_num, [pixels|percentoftable]) 
# Author:       Anthony Peacock
# Date:		22 Feb 2001
#-------------------------------------------------------
sub setColWidth {
   my $self = shift;
   (my $col = shift) || return 0;
   my $value = shift;

	# If -1 is used in the col parameter, use the last col
	$col = $self->{last_col} if $col == -1;

	# You cannot set a nonexistent row
	if ( $col > $self->{last_col} || $col < 1 ) {
		print STDERR "\n$0:setColWidth: Invalid table reference" ;
		return 0;
	}

   # this sub should change the cell width of a col;
   my $i;
   for ($i=1;$i <= $self->{last_row};$i++) {
      $self->setCellWidth($i, $col, $value);
   }
}

#-------------------------------------------------------
# Subroutine:  	setColHeight(col_num, [pixels]) 
# Author:       Anthony Peacock
# Date:		22 Feb 2001
#-------------------------------------------------------
sub setColHeight {
   my $self = shift;
   (my $col = shift) || return 0;
   my $value = shift;
   
	# If -1 is used in the col parameter, use the last col
	$col = $self->{last_col} if $col == -1;

	# You cannot set a nonexistent row
	if ( $col > $self->{last_col} || $col < 1 ) {
		print STDERR "\n$0:setColHeight: Invalid table reference" ;
		return 0;
	}

   # this sub should change the cell height of a col;
   my $i;
   for ($i=1;$i <= $self->{last_row};$i++) {
      $self->setCellHeight($i, $col, $value);
   }
}

#-------------------------------------------------------
# Subroutine:  	setColBGColor(col_num, [colorname|colortriplet]) 
# Author:       Jay Flaherty
# Date:		16 Nov 1998
#-------------------------------------------------------
sub setColBGColor{
   my $self = shift;
   (my $col = shift) || return 0;
   my $value = shift || 1;

	# If -1 is used in the col parameter, use the last col
	$col = $self->{last_col} if $col == -1;

	# You cannot set a nonexistent row
	if ( $col > $self->{last_col} || $col < 1 ) {
		print STDERR "\n$0:setColBGColor: Invalid table reference" ;
		return 0;
	}

   # this sub should set bgcolor for each
   # cell in a col given a col number;
   my $i;
   for ($i=1;$i <= $self->{last_row};$i++) {
      $self->setCellBGColor($i,$col, $value);
   }
}

#-------------------------------------------------------
# Subroutine:  	setColStyle(col_num, "style") 
# Author:       Anthony Peacock
# Date:			10 Jan 2002
#-------------------------------------------------------
sub setColStyle{
   my $self = shift;
   (my $col = shift) || return 0;
   my $value = shift || 1;

	# If -1 is used in the col parameter, use the last col
	$col = $self->{last_col} if $col == -1;

	# You cannot set a nonexistent row
	if ( $col > $self->{last_col} || $col < 1 ) {
		print STDERR "\n$0:setColStyle: Invalid table reference" ;
		return 0;
	}

   # this sub should set style for each
   # cell in a col given a col number;
   my $i;
   for ($i=1;$i <= $self->{last_row};$i++) {
      $self->setCellStyle($i,$col, $value);
   }
}

#-------------------------------------------------------
# Subroutine:  	setColClass(col_num, 'class') 
# Author:       Anthony Peacock
# Date:			22 July 2002
#-------------------------------------------------------
sub setColClass{
   my $self = shift;
   (my $col = shift) || return 0;
   my $value = shift || 1;

	# If -1 is used in the col parameter, use the last col
	$col = $self->{last_col} if $col == -1;

	# You cannot set a nonexistent row
	if ( $col > $self->{last_col} || $col < 1 ) {
		print STDERR "\n$0:setColClass: Invalid table reference" ;
		return 0;
	}

   # this sub should set class for each
   # cell in a col given a col number;
   my $i;
   for ($i=1;$i <= $self->{last_row};$i++) {
      $self->setCellClass($i,$col, $value);
   }
}

#-------------------------------------------------------
# Subroutine:  	setColFormat(row_num, start_string, end_string) 
# Author:       Anthony Peacock
# Date:			21 Feb 2001
#-------------------------------------------------------
sub setColFormat{
   my $self = shift;
   (my $col = shift) || return 0;
   my ($start_string, $end_string) = @_;
   
	# If -1 is used in the col parameter, use the last col
	$col = $self->{last_col} if $col == -1;

	# You cannot set a nonexistent row
	if ( $col > $self->{last_col} || $col < 1 ) {
		print STDERR "\n$0:setColFormat: Invalid table reference" ;
		return 0;
	}

   # this sub should set format strings for each
   # cell in a col given a col number;
   my $i;
   for ($i=1;$i <= $self->{last_row};$i++) {
      $self->setCellFormat($i,$col, $start_string, $end_string);
   }
}

#-------------------------------------------------------
# Subroutine:	setColAttr(col, "Attribute string")
# Author:		Benjamin Longuet
# Date:			27 Feb 2002
#-------------------------------------------------------
sub setColAttr {
   my $self = shift;
   (my $col = shift) || return 0;
   my $html_str = shift;

	# If -1 is used in the col parameter, use the last col
	$col = $self->{last_col} if $col == -1;

	# You cannot set a nonexistent row
	if ( $col > $self->{last_col} || $col < 1 ) {
		print STDERR "\n$0:setColAttr: Invalid table reference" ;
		return 0;
	}

   # this sub should set attribute string for each
   # cell in a col given a col number;
   my $i;
   for ($i=1;$i <= $self->{last_row};$i++) {
      $self->setCellAttr($i,$col, $html_str);
   }
}

#-------------------------------------------------------
# Subroutine:   getColStyle($col_num)
# Author:       Douglas Riordan
# Date:         1 Dec 2005
# Description:  getter for col style
#-------------------------------------------------------

sub getColStyle {
    my ($self, $col) = @_;

    if ($self->_checkRowAndCol('getColStyle', {col => $col})) {
        my $last_row = $self->{last_row};
        return $self->{rows}->[$last_row]->{cells}[$col]->{style};
    }
    else {
        return undef;
    }
}

#-------------------------------------------------------
#*******************************************************
#
# End of public methods
# 
# The following methods are internal to this package
#
#*******************************************************
#-------------------------------------------------------

#-------------------------------------------------------
# Subroutine:  	_updateSpanGrid(row_num, col_num)
# Author:       Stacy Lacy	
# Date:		31 Jul 1997
# Modified:     23 Oct 2003 - Anthony Peacock (Version 2 new data structure)
#-------------------------------------------------------
sub _updateSpanGrid {
   my $self = shift;
   (my $row = shift) || return 0;
   (my $col = shift) || return 0;

   my $colspan = $self->{rows}[$row]->{cells}[$col]->{colspan} || 0;
   my $rowspan = $self->{rows}[$row]->{cells}[$col]->{rowspan} || 0;

	if ($self->{autogrow}) {
		$self->{last_col} = $col + $colspan - 1 unless $self->{last_col} > ($col + $colspan - 1 );
		$self->{last_row} = $row + $rowspan - 1 unless $self->{last_row} > ($row + $rowspan - 1 );
	}

   my ($i, $j);
   if ($colspan) {
      for ($j=$col+1;(($j <= $self->{last_col}) && ($j <= ($col +$colspan -1))); $j++ ) {
			$self->{rows}[$row]->{cells}[$j]->{colspan} = "SPANNED";
      }
   }
   if ($rowspan) {
      for ($i=$row+1;(($i <= $self->{last_row}) && ($i <= ($row +$rowspan -1))); $i++) {
			$self->{rows}[$i]->{cells}[$col]->{colspan} = "SPANNED";
      }
   }

   if ($colspan && $rowspan) {
      # Spanned Grid
      for ($i=$row+1;(($i <= $self->{last_row}) && ($i <= ($row +$rowspan -1))); $i++) {
         for ($j=$col+1;(($j <= $self->{last_col}) && ($j <= ($col +$colspan -1))); $j++ ) {
			$self->{rows}[$i]->{cells}[$j]->{colspan} = "SPANNED";
         }
      }
   }
}

#-------------------------------------------------------
# Subroutine:  	_getTableHashValues(tablehashname)
# Author:       Stacy Lacy	
# Date:		31 Jul 1997
#-------------------------------------------------------
sub _getTableHashValues {
   my $self = shift;
   (my $hashname = shift) || return 0;

   my ($i, $j, $retval);
   for ($i=1; $i <= ($self->{last_row}); $i++) {
      for ($j=1; $j <= ($self->{last_col}); $j++) {
         $retval.= "|$i:$j| " . ($self->{"$hashname"}{"$i:$j"}) . " ";
      }
      $retval.=" |<br />";
   }

   return $retval;
}

#-------------------------------------------------------
# Subroutine:  	_is_validnum(string_value)
# Author:       Anthony Peacock	
# Date:			12 Jul 2000
# Description:	Checks the string value passed as a parameter
#               and returns true if it is >= 0
# Modified:		23 Oct 2001 - Terence Brown
# Modified:     30 Aug 2002 - Tommi Maekitalo
#-------------------------------------------------------
sub _is_validnum {
	my $str = shift;

	if ( defined($str) && $str =~ /^\s*\d+\s*$/ && $str >= 0 ) {
		return 1;
	} else {
		return;
	}
}

#----------------------------------------------------------------------
# Subroutine: _install_stateful_set_method
# Author: Paul Vernaza
# Date: 1 July 2002
# Description: Generates and installs a stateful version of the given
# setter method (in the sense that it 'remembers' the last row or 
# column in the table and passes it as an implicit argument).
#----------------------------------------------------------------------
sub _install_stateful_set_method {
    my ($called_method, $real_method) = @_;

    my $row_andor_cell = $real_method =~ /^setCell/ ?
	'($self->getTableRows, $self->getTableCols)' :
	$real_method =~ /^setRow/ ? '$self->getTableRows' :
	$real_method =~ /^setCol/ ? '$self->getTableCols' :
	die 'can\'t determine argument type(s)';
    
    { no strict 'refs';
      *$called_method = sub {
	  my $self = shift();
	  return &$real_method($self, eval ($row_andor_cell), @_);
      }; }
}

#----------------------------------------------------------------------
# Subroutine: AUTOLOAD
# Author: Paul Vernaza
# Date: 1 July 2002
# Description: Intercepts calls to setLast* methods, generates them 
# if possible from existing set-methods that require explicit row/column.
# Modified: 23 January 2006 - Suggestion by Gordon Lack
# Modified: 1 February 2006 - Made the "Usupported method" code more flexible.
#----------------------------------------------------------------------

sub AUTOLOAD {
    (my $called_method = $AUTOLOAD ) =~ s/.*:://;
    (my $real_method = $called_method) =~ s/^setLast/set/;

    return if ($called_method eq 'DESTROY');

    die sprintf("Unsupported method $called_method call in %s\n", __PACKAGE__) unless defined(&$real_method);

    _install_stateful_set_method($called_method, $real_method);
    goto &$called_method;
}


#----------------------------------------------------------------------
# Subroutine:   _checkRowAndCol($caller_method, $hsh_ref)
# Author:       Douglas Riordan
# Date:         30 Nov 2005
# Description:  validates row and col coordinates
#----------------------------------------------------------------------

sub _checkRowAndCol {
    my ($self, $method, $attrs) = @_;

    if (defined $attrs->{row}) {
        my $row = $attrs->{row};
        # if -1 is used in the row parameter, use the last row
        $row = $self->{last_row} if $row == -1;
        if ($row > $self->{last_row} || $row < 1) {
            print STDERR "$0: $method - Invalid table row reference\n";
            return 0;
        }
    }

    if (defined $attrs->{col}) {
        my $col = $attrs->{col};
        # if -1 is used in the col parameter, use the last col
        $col = $self->{last_col} if $col == -1;
        if ($col > $self->{last_col} || $col < 1) {
            print STDERR "$0: $method - Invalid table col reference\n";
            return 0;
        }
    }

    return 1;
}

1;

__END__



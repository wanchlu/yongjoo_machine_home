#!/usr/bin/perl

use strict;
use warnings;
  
use Net::eBay;
use Data::Dumper;
use DateTime::Precise;

sub usage {
  my ($msg) = @_;

  print STDERR "Error!  $msg \n\n
USAGE: $0 [--distance zipcode distance_in_miles] [--seller seller] terms
";
  exit 1;
}

sub printable { 
  my $str = shift; 
  $str =~ tr/\x80-\xFF//d; 
  $str =~ tr/\x00-\x1F//d; 
  return $str; 
} 

my $eBay = new Net::eBay;

my ($seller, $zip, $distance, $category, $completed, $exclude, $detail, $nobids, $all, $nobins, $nofeatured, $minprice, $maxprice);

my $done = 0;
do {
  $done = 0;
  if( $ARGV[0] eq '--seller' ) {
    $done = 1;
    shift;
    $seller = shift;
  } elsif( $ARGV[0] eq '--category' ) {
    $done = 1;
    shift;
    $category = shift;
  } elsif( $ARGV[0] eq '--minprice' ) {
    $done = 1;
    shift;
    $minprice = shift;
  } elsif( $ARGV[0] eq '--maxprice' ) {
    $done = 1;
    shift;
    $maxprice = shift;
  } elsif( $ARGV[0] eq '--nobins' ) {
    $done = 1;
    $nobins = 1;
    shift;
  } elsif( $ARGV[0] eq '--nofeatured' ) {
    $done = 1;
    $nofeatured = 1;
    shift;
  } elsif( $ARGV[0] eq '--exclude-seller' ) {
    $done = 1;
    shift;
    $exclude = shift;
  } elsif( $ARGV[0] eq '--completed' ) {
    $done = 1;
    shift;
    $completed = 1;
  } elsif( $ARGV[0] eq '--all' ) {
    $done = 1;
    shift;
    $all = 1;
  } elsif( $ARGV[0] eq '--detail' ) {
    $done = 1;
    shift;
    $detail = 1;
  } elsif( $ARGV[0] eq '--nobids' ) {
    $done = 1;
    shift;
    $nobids = 1;
  } elsif( $ARGV[0] eq '--distance' ) {
    $done = 1;
    shift;
    $zip = shift || usage "no zipcode";
    usage "bad zipcode '$zip'" unless $zip =~ /^\d+/;
    $distance = shift || usage "no distance";
    usage "bad distance '$distance'" unless $distance =~ /^\d+/;
  }
} while( $done && @ARGV);

my $query = join(" ", @ARGV );

# use new eBay API
$eBay->setDefaults( { API => 2, debug => 0, compatibility => 415 } );

my $request =
  {
   Query => $query,
   Pagination => {
                  EntriesPerPage => 399,
                  PageNumber => 1,
                 },
  };

#print STDERR "Query = $query.\n";

if( defined $seller ) {
  $request->{UserIdFilter}->{IncludeSellers} = $seller;
}

if( defined $exclude ) {
  my @exclude = split( /,/, $exclude );
  $request->{UserIdFilter}->{ExcludeSellers} = \@exclude;
}

if( defined $distance && defined $zip ) {
  $request->{ProximitySearch} = { MaxDistance => $distance, PostalCode => $zip };
}

my $priceFilter = undef;
$priceFilter->{MinPrice} = $minprice if $minprice;
$priceFilter->{MaxPrice} = $maxprice if $maxprice;

$request->{PriceRangeFilter} = $priceFilter if $priceFilter;

my $result;
my $items;

$request->{CategoryID} = $category if(defined $category); 
$request->{SearchType} = 'Completed' if(defined $completed); 

$request->{ItemTypeFilter} = 'AllItemTypes' if $all;
  
$result = $eBay->submitRequest( "GetSearchResults", $request );

print Dumper( $result ) if $detail;

#print STDERR "Before: Ref( result ) = " . ref( $result ) . ".\n";

my $exitcode;

if( ref( $result ) eq 'HASH' && defined  $result->{SearchResultItemArray} ) {
  $exitcode = 0; # good
  #print STDERR "Good results, ref = " . ref( $result ) . ", keys = " . join( ',', keys %$result ) . ".\n";
} else {
  #print STDERR "Exiting with error!\n";
  if( $result->{Ack} eq 'Success' ) {
    # Succeeded, but no results
    print STDERR "Nothing found.\n";
    exit 0;
  } else {
    print STDERR "ERROR During Query.\n";
    print Dumper( $result );
    exit 1;
  }
}

$items = $result->{SearchResultItemArray}->{SearchResultItem};

binmode STDOUT, ":utf8";

if( ref $result ) {
  if( $items ) { 
    $items = [$items] if( ref $items eq 'HASH' );
    foreach my $i (@$items) {
      my $item = $i->{Item};

      # Apply extra filters
      next if $nofeatured && ref $item->{ListingEnhancement};
      next if $nobins     && $item->{BuyItNowPrice};
      
      print "$item->{ItemID} ";
      
      my $endtime = $item->{ListingDetails}->{EndTime};
      $endtime =~ s/T/ /;
      $endtime =~ s/\.\d\d\d//;
      $endtime =~ s/Z/ GMT/;
      
      ############################################################
      # now figure out ending time in the LOCAL timezone
      # (not GMT and not necessarily California time)
      ############################################################
      my $local_endtime;
      {
        my $t1 = DateTime::Precise->new;
        $t1->set_from_datetime( $endtime );
        my $epoch = $t1->unix_seconds_since_epoch;
        my $t2 = DateTime::Precise->new;
        $t2->set_localtime_from_epoch_time( $epoch );
        #print "t1=" . $t1->asctime . " ($epoch) -> " . $t2->asctime . ".\n";
        $local_endtime = $t2->dprintf("%~M %D,%h:%m");
      }
      
      


      print sprintf( "%2d ", $item->{SellingStatus}->{BidCount} || 0 ) unless $nobids;
      print sprintf( "%25s ", $local_endtime );
      my $price = (0 &&defined $category
                   ? $item->{SellingStatus}->{CurrentPrice}
                   : $item->{SellingStatus}->{CurrentPrice}->{content} );
      print sprintf( "%7.2f ", $price );
      print printable( " $item->{Title} " );
      print "\n";

    }
  } else {
    #print Dumper( $result );
  }
} else {
  print "Unparsed result: \n$result\n\n";
}


exit $exitcode;

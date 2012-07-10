#!/usr/bin/perl

use strict;
use warnings;
  
use Net::eBay;
use Data::Dumper;

my $eBay = new Net::eBay;

# use new eBay API
$eBay->setDefaults( { API => 2, debug => 0 } );

my $nowatch = 0;
my $bidsonly = 0;

while( @ARGV ) {
  if( $ARGV[0] eq '--nowatch' ) {
    shift @ARGV;
    $nowatch = 1;
  } elsif( $ARGV[0] eq '--bidsonly' ) {
    shift @ARGV;
    $bidsonly = 1;
  } else {
    last;
  }
}

my $result = $eBay->submitRequest( "GetMyeBaySelling",
                                   {
                                    ActiveList => {
                                                   Sort => 'TimeLeft',
                                                   Pagination => {
                                                                  EntriesPerPage => 100,
                                                                  PageNumber => 1
                                                                 }
                                                  }
                                   }
                                 );
my $watching = 0;
my $items = 0;
my $things = 0;
my $selling = 0;
my $dollars = 0.0;
my $disinterest = 0;
  
if( ref $result ) {
  #print "Result: " . Dumper( $result ) . "\n";

  print "   Item        W  B   Price Q   Title\n";
  #      7551933377   0  0   49.99 1 Siliconix Transistor tester IPT II 2 Monitor

  my $items = $result->{ActiveList}->{ItemArray}->{Item};
  $items = [$items] unless (ref $items) =~ /^ARRAY/;
  my $count = 0;
  foreach my $item (@$items) {
    $items++;
    unless( defined $item->{ItemID} ) {
      print STDERR "Error! No ItemID!\n" . Dumper( $result ) . "\n\n";
      exit 1;
    }

    next if $bidsonly && !$item->{SellingStatus}->{BidCount};
    
    print "$item->{ItemID} ";
    if( $nowatch ) {
      print "    ";
    } else {
      print sprintf( "%3d ", $item->{WatchCount} || 0 );
    }

    $disinterest++ if !$item->{WatchCount};
    
    $watching += $item->{WatchCount} || 0;
    my $bidcount = $item->{SellingStatus}->{BidCount};
    my $curprice = $item->{SellingStatus}->{CurrentPrice}->{content};
    my $q = $item->{Quantity};
    
    print sprintf( "%2d ", $bidcount || 0 );
    print sprintf( "%7.2f ", $curprice );

    if( $bidcount ) {
      $selling++;
      $dollars += $q*$curprice;
    }
    
    $things += $q;

    if( defined $item->{QuantityAvailable} && $item->{QuantityAvailable} != $item->{Quantity} ) {
      $q = "$item->{QuantityAvailable}/$item->{Quantity}";
    }

    print "$q $item->{Title} ";
    print "\n";

    $count++;
  }

  if( !$nowatch ) {
    print "$count listings, $things things, $result->{SellingSummary}->{AuctionBidCount} bids, $selling will sell, \$$dollars, $watching watchers, $disinterest without interest\n";
  }
} else {
  print STDERR "Unparsed result: \n$result\n\n";
  exit 1;
}

exit 0;

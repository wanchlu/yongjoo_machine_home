#!/usr/bin/perl

#
# This script is kind of big compared to others. That's because it is
# not just a sample script, I use this script daily to sell stuff on eBay.
# Hence a lot of things here are tailored to my own use of eBay. This
# script does not let you control every parameter of ebay's AddItem call,
# and sets some defaults that I like (like using UPS if I specify shipping
# weight). Use it as a guide to write your own scripts, no more. 
#

use Net::eBay;
use Data::Dumper;
use Cwd;

my $usage = "usage: $0 {options} category minbid name";

my $command = "$0 '" . join( "' '", @ARGV ) . "'";

my $subtitle   = undef;
my $siteid     = 0;
my $fake       = 0;
my $debug      = 0;
my $quantity   = 1;
my $sitehosted = undef;
my $shipping   = undef;
my $zipcode    = "60532";
my $listingType = undef;
my $duration   = 7;
my $done = 1;

sub get_argument {
  my ($name,$ref) = @_;
  if( $ARGV[0] eq "--$name" ) {
    shift @ARGV;
    $$ref = shift @ARGV;
    die "--$name requires an argument!" unless defined $$ref;
    return 1;
  }
  return undef;
}

while( $done ) {
  $done = 0;

  #print STDERR "A0=$ARGV[0].\n";
  
  next if $done = get_argument( 'type', \$listingType );
  next if $done = get_argument( 'subtitle', \$subtitle );
  next if $done = get_argument( 'duration', \$duration );
  next if $done = get_argument( 'quantity', \$quantity );
  next if $done = get_argument( 'zipcode', \$zipcode );
  next if $done = get_argument( 'shipping', \$shipping );
  next if $done = get_argument( 'siteid', \$siteid );
  next if $done = get_argument( 'sitehosted', \$sitehosted );
  
  if( $ARGV[0] eq '--debug' ) {
    shift @ARGV;
    $debug = 1;
    $done = 1;
    next;
  }
  
  if( $ARGV[0] eq '--fake' ) {
    shift @ARGV;
    $fake = 1;
    $done = 1;
    next;
  }
}

my $category = shift @ARGV || die $usage;
die "$usage (cat=$category)"  unless $category =~ /^\d+(,\d+)*$/;

my $minimumBid = shift @ARGV || die $usage;

my $bin;

if( $minimumBid =~ /(\d+(\.\d+)?)(\/\d+)?/ ) {
  $bin = $3;
  $bin =~ s/\///g;
  $minimumBid =~ s/\/.*$//;
} else {
  die $usage;
}


my $name = join( " ", @ARGV) || die $usage;

my $ptitle = $name;
$ptitle =~ s/\"/\\\"/g;

###################################################################### Check args
if( defined $listingType ) {
  my $legal = {
               Chinese => 1,
               Dutch => 1,
               Auction => 1,
               StoresFixedPrice => 1,
               FixedPriceItem => 1,
              };
  die "Illegal auction type '$listingType'. Legal codes are: " . join( ', ', sort keys %$legal )
    unless $legal->{$listingType};
}


open( INDEX, "index.html" ) || die "Cannot open index.html";
my $index = "";
$index .= "$_" while <INDEX>;
close( INDEX );



my $picurl;

if( -f ".picurl" ) {
  open( PIC, ".picurl" );
  $picurl = <PIC>;
  chomp $picurl;
  close( PIC );
}

my $appData = `pwd`;
{
  chomp $appData;
  my @d = split( /\//, $appData );
  $appData = pop @d;
}

my $eBay = new Net::eBay();
$eBay->setDefaults( { siteid => $siteid, debug => $debug } );

# use new eBay API
$eBay->setDefaults( { API => 2, debug => $debug } );

#########################################
# Now interpret shipping!
#
# Format: [weight[-size1xsize2xsize3]]+handling
#
# no weight means fixed shipping cost equal to 'handling'
#
# Examples:
#
#    70-12x22x13+15 -- 70 lbs, 12x22x13 in, 15 dollars handling
#    +15            -- $15 fixed fee
#    40+15          -- no size (default 12x12x12_
#
# Note that I use UPS ground only as my shipping method
#

my $shippingDetails;

if( $index =~ /FIXED_SHIPPING_COST=(\d+(\.\d*)?)/ ) {
  my $new_shipping = "+$1"; # flat from auction text

  die "Shipping mismatch: $shipping vs. $new_shipping"
    if defined $shipping && $shipping && $shipping ne $1;
  
  $shipping = $new_shipping;
}

{
  my $s = $shipping;
  my $weight = undef;
  $weight = $1 if $s =~ s/^(\d+)//;

  my ($d1, $d2, $d3) = (12, 12, 12);
  ($d1, $d2, $d3) = ($1, $2, $3) if $weight && $s =~ s/^-(\d+)x(\d+)x(\d+)//;

  my $handling = 0;
  $handling = $1 if $s =~ s/^\+(\d+(\.\d+)?)//;

  print STDERR "SHIPPING: Weight = $weight, dimensions = $d1-$d2-$d3, handling = $handling.\n";

  die "Incorrectly specified shipping '$shipping' => '$s'" unless $s eq "";

  if( $weight ) {
    # Calculated Rate
    $shippingDetails = {
                        CalculatedShippingRate => {
                                                   OriginatingPostalCode => $zipcode,
                                                   PackageDepth => $d1,
                                                   PackageLength => $d2,
                                                   PackageWidth => $d3,
                                                   PackagingHandlingCosts => { _attributes => { currencyID => 'USD' },
                                                                               _value => $handling
                                                                             },
                                                   WeightMajor => $weight,
                                                   ShippingPackage => 'PackageThickEnvelope',
                                                  },
                        ShippingServiceOptions => {
                                                   ShippingService => 'UPSGround'
                                                  },
                        ShippingType => 'Calculated',
                       };
  } else {
    # Flat Rate
    #
    # If handling is not specified, no shipping details will be provided!
    #
    if( $handling ) {
      $shippingDetails = {
                          ShippingServiceOptions => {
                                                     ShippingService => 'Other',
                                                     ShippingServiceCost => $handling
                                                    },
                          ShippingType => 'Flat',
                         };
    } 
  }
  
  #print STDERR "\n\nShipping $shippingDetails: \n" . Dumper( $shippingDetails ) . "\n";

  #exit 0;
}

# Now verify that the item either has shipping, or is local pickup only, or is freight.
{
  my $noship_ok = undef;
  $noship_ok = 1 if $index =~ /can only be shipped via freight/s;
  $noship_ok = 1 if $index =~ /Local pickup ONLY/s;

  die "You have not specified shipping cost, local pickup, or freight. Aborting."
    unless $shipping || $noship_ok;
}

my $args =
  {
     Item =>
     {
         debug => $debug,
      #BuyItNowPrice => 6.0,
      Title => $ptitle,
      Country => "US",
      Currency => "USD",
      Description => "<![CDATA[ $index ]]>", 
      ListingDuration => "Days_$duration",
      Location => "Lisle, IL",
      PostalCode => $zipcode,
      PaymentMethods => [ 'PayPal', 'Other', 'CashOnPickup', 'MOCC'],
      PayPalEmailAddress => 'ichudov@algebra.com',
      PrimaryCategory => {
                          CategoryID => [ split( /,/, $category ) ]
                         },
      Quantity => $quantity,
      RegionID => 0,
      StartPrice => $minimumBid,
      HitCounter => 'GreenLED'
     }
  };

#$args->{Item}->{ApplicationData} = $appData if defined $appData && $appData;

$args->{Item}->{BuyItNowPrice} = $bin if $bin;

$args->{Item}->{ListingType} = $listingType if defined $listingType;

if( $shippingDetails ) {
  $args->{Item}->{ShippingDetails} = $shippingDetails;
}

if( defined $subtitle ) {
  $args->{Item}->{SubTitle} = $subtitle;
}

if( $picurl ) {
  if( 0 ) {
    $args->{Item}->{VendorHostedPicture} =
      {
       GalleryType => 'Gallery',
       GalleryURL => $picurl,
       PictureURL => $picurl,
       SelfHostedURL => $picurl,
      };
  } else {
    $args->{Item}->{PictureDetails} = {
                                       GalleryType => 'Gallery',
                                       GalleryURL  => $picurl,
                                       PictureURL => $picurl,
                                      };
  }
}

if( $sitehosted ) {
  $args->{Item}->{SiteHostedPicture}->{PictureURL} = $sitehosted;
}

print "

                ________________________________________
                R E V I E W    Y O U R     A U C T I O N
                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  Title:    $ptitle
            ####################################################### (" . length( $ptitle ) . "/55)
";

if( $subtitle ) {
  print "
  SubTitle: $subtitle
            ####################################################### (" . length( $subtitle ) . "/55)
";
}

print "
  Category      : $category
  Starting Price: $minimumBid
  BIN           : $bin
  Shipping      : $shipping
";

if( length( $ptitle ) > 55 ) {
  print STDERR "Error, title too long.\n";
  exit;
}

{
  my $verify = $eBay->submitRequest( 'VerifyAddItem', $args );
  
  my $total = 0;
  foreach my $fee (@{$verify->{Fees}->{Fee}}) {
    my $amount = $fee->{Fee}->{content};
    
    next unless $amount > 0 && $fee->{Name} ne 'ListingFee';
    
    print sprintf( "%16s", $fee->{Name} ) . ": $amount.\n";
    $total += $amount;
  }
  print "       TOTAL FEE: $total            <===** \n\n";

  unless( $total ) {
    print Dumper( $verify );
    exit 1;
  }
}

if( !$fake && -t STDIN ) {
  print "Press Enter to continue:\n";
  my $dummy = <STDIN>;
}


unless( $fake ) {
  open( SAVE, ">relist.sh" );
  print SAVE "$command\n\n";
  close( SAVE );
  chmod 0755, "relist.sh";
}

######################################## Bunching
my $fn = "$ENV{HOME}/.ebay-bunch.sh";
if( -t STDIN && -f $fn ) {
  open( BUNCH, ">>$fn" ) || die "Cannot append to $fn";
  print BUNCH "cd " . getcwd . "; ./relist.sh\n";
  close( BUNCH );
  print "Added to bunch $fn.\n";
  exit( 0 );
}

my $request = $fake ? "VerifyAddItem" : "AddItem";
my $result = $eBay->submitRequest( $request, $args );

if( ref $result ) {
  if( $result->{ItemID} ) {
    unless( $fake ) {
      open( ITEM, ">item.txt" );
      print ITEM "$result->{ItemID}\n";
      close( ITEM );
    }
    
    if( $fake ) {
      print "FAKE LISTING ATTEMPT SUCCEEDED!\n\n";
    } else {
      #print "Result: " . Dumper( $result ) . "\n";
      print "----------------------------------------------------------------- CONGRATS
Your item was listed:

  $eBay->{public_url}?ViewItem&item=$result->{ItemID}

";
    }
    my $total = 0;
    foreach my $fee (@{$result->{Fees}->{Fee}}) {
      my $amount = $fee->{Fee}->{content};
      
      next unless $amount > 0 && $fee->{Name} ne 'ListingFee';
      
      print "Fee: $fee->{Name}: $amount.\n";
      $total += $amount;
    }
    print "-----------------------------
TOTAL FEE: $total

";
    system( "check-ebay-activity.sh reset & " );

    if( open( ANN, ">annotation.txt" ) ) {
      print ANN $ptitle;
      close( ANN );
      
      system( "cpak annotation.txt" );
      print STDERR "Wrote and COPIED annotation.txt\n";
      
    } else {
      print STDERR "FAILED TO WRITE annotation.txt\n";
    }
  } else {
    print "ERROR in Result: " . Dumper( $result ) . "\n";
    
  }
} else {
  print "Unparsed result: \n$result\n\n";
}



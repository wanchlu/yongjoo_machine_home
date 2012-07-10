#!/usr/local/bin/perl

# script: test_linear_algebra.pl
# functionality: A variety of arithmetic tests of the linear algebra module 

use strict;
use warnings;
use FindBin;
use Clair::Utils::LinearAlgebra;

my @v1 = ("1", "2", "3", "4");
my @v2 = ("5", "6", "7", "8");
my @v3 = ("2", "4", "6", "8", "10");
my @v4 = ("1", "3", "5", "7", "9");
my @v5 = ("1", "1", "2", "3", "5");
my @v6 = ("3", "2", "1", "0", "2");

#Test Two -- Inner Product of Vectors One and Two
#Test Two Expected -- 70

print "inner product of ", list_to_string(@v1), " and ", list_to_string(@v2), 
      "\n";
my $test1 = Clair::Utils::LinearAlgebra::innerProduct (\@v1,\@v2);
print "$test1\n";


#Test Seven -- Subtraction of Vectors One and Two
#Test Seven Expected -- (-4, -4, -4, -4)

print "difference of ", list_to_string(@v1), " and ", list_to_string(@v2), "\n";
my @diff = Clair::Utils::LinearAlgebra::subtract (\@v1,\@v2);
print list_to_string(@diff), "\n";

#Test Twelve -- Addition of Vectors One and Two
#Test Twelve Expected -- (6, 8, 10, 12)

print "sum of ", list_to_string(@v1), " and ", list_to_string(@v2), "\n";
my @sum1 = Clair::Utils::LinearAlgebra::add (\@v1,\@v2);
print list_to_string(@sum1), "\n";

#Test Fifteen -- Addition of Vectors Three and Four and Five
#Test Fifteen Expected -- (4, 8, 13, 18, 24)

print "sum of ", list_to_string(@v3), " and ", list_to_string(@v4), " and ", 
    list_to_string(@v5), "\n";
my @sum2 = Clair::Utils::LinearAlgebra::add (\@v3,\@v4,\@v5);
print list_to_string(@sum2), "\n";

#Test Seventeen -- Addition of Vectors One and Two
#Test Seventeen Expected -- (3, 4, 5, 6)

print "mean of ", list_to_string(@v1), " and ", list_to_string(@v2), "\n";
my @mean1 = Clair::Utils::LinearAlgebra::average (\@v1,\@v2);
print list_to_string(@mean1), "\n";

#Test Twenty -- Addition of Vectors Three and Four and Six
#Test Twenty Expected -- (2, 3, 4, 5, 7)

print "mean of ", list_to_string(@v3), " and ", list_to_string(@v4), " and ", 
    list_to_string(@v6), "\n";
my @mean2 = Clair::Utils::LinearAlgebra::average (\@v3,\@v4,\@v6);
print list_to_string(@mean2), "\n";

sub list_to_string {
    return join " ", @_;
}

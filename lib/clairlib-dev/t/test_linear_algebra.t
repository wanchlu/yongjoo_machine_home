# script: test_linear_algebra.t
# functionality: A variety of arithmetic tests of the linear algebra module 

use strict;
use warnings;
use Test::More tests => 20;

use Clair::Utils::LinearAlgebra;

my @v1 = ("1", "2", "3", "4");
my @v2 = ("5", "6", "7", "8");
my @v3 = ("2", "4", "6", "8", "10");
my @v4 = ("1", "3", "5", "7", "9");
my @v5 = ("1", "1", "2", "3", "5");
my @v6 = ("3", "2", "1", "0", "2");

### Inner Product Tests

#Test One -- Inner Product of Vector One
#Test One Expected -- Error Message (Only one Vector)

my @a = Clair::Utils::LinearAlgebra::innerProduct (\@v1);
my @ea = ("e");
is_deeply( \@a, \@ea, "Test One" );

#Test Two -- Inner Product of Vectors One and Two
#Test Two Expected -- 70

my @b = Clair::Utils::LinearAlgebra::innerProduct (\@v1,\@v2);
my @eb = ("70");
is_deeply( \@b, \@eb, "Test Two" );

#Test Three -- Inner Product of Vectors Two and Three
#Test Three Expected -- Error Message (Lengths do not Match)

my @c = Clair::Utils::LinearAlgebra::innerProduct (\@v2,\@v3);
my @ec = ("e");
is_deeply( \@c, \@ec, "Test Three" );

#Test Four -- Inner Product of Vectors Three and Four
#Test Four Expected -- 190

my @d = Clair::Utils::LinearAlgebra::innerProduct (\@v3,\@v4);
my @ed = ("190");
is_deeply( \@d, \@ed, "Test Four" );

#Test Five -- Inner Product of Vectors Three and Four and Five
#Test Five Expected -- Error (Cannot Perform on More than Two)

my @e = Clair::Utils::LinearAlgebra::innerProduct (\@v3,\@v4,\@v5);
my @ee = ("e");
is_deeply( \@e, \@ee, "Test Five" );

### Subtraction Tests

#Test Six -- Subtraction of Vector One
#Test Six Expected -- Error Message (Only one Vector)

my @f = Clair::Utils::LinearAlgebra::subtract (\@v1);
my @ef = ("e");
is_deeply( \@f, \@ef, "Test Six" );

#Test Seven -- Subtraction of Vectors One and Two
#Test Seven Expected -- (-4, -4, -4, -4)

my @g = Clair::Utils::LinearAlgebra::subtract (\@v1,\@v2);
my @eg = ("-4", "-4", "-4", "-4");
is_deeply( \@g, \@eg, "Test Seven" );

#Test Eight -- Subtraction of Vectors Two and Three
#Test Eight Expected -- Error Message (Lengths do not Match)

my @h = Clair::Utils::LinearAlgebra::subtract (\@v2,\@v3);
my @eh = ("e");
is_deeply( \@h, \@eh, "Test Eight" );

#Test Nine -- Subtraction of Vectors Three and Four
#Test Nine Expected -- (1, 1, 1, 1, 1)

my @i = Clair::Utils::LinearAlgebra::subtract (\@v3,\@v4);
my @ei = ("1", "1", "1", "1", "1");
is_deeply( \@i, \@ei, "Test Nine" );

#Test Ten -- Subtraction of Vectors Three and Four and Five
#Test Ten Expected -- (0, 0, -1, -2, -4)

my @j = Clair::Utils::LinearAlgebra::subtract (\@v3,\@v4,\@v5);
my @ej = ("0", "0", "-1", "-2", "-4");
is_deeply( \@j, \@ej, "Test Ten" );

### Addition Tests

#Test Eleven -- Addition of Vector One
#Test Eleven Expected -- Error Message (Only one Vector)

my @k = Clair::Utils::LinearAlgebra::add (\@v1);
my @ek = ("e");
is_deeply( \@k, \@ek, "Test Eleven" );

#Test Twelve -- Addition of Vectors One and Two
#Test Twelve Expected -- (6, 8, 10, 12)

my @l = Clair::Utils::LinearAlgebra::add (\@v1,\@v2);
my @el = ("6", "8", "10", "12");
is_deeply( \@l, \@el, "Test Twelve" );

#Test Thirteen -- Addition of Vectors Two and Three
#Test Thirteen Expected -- Error Message (Lengths do not Match)

my @m = Clair::Utils::LinearAlgebra::add (\@v2,\@v3);
my @em = ("e");
is_deeply( \@m, \@em, "Test Thirteen" );

#Test Fourteen -- Addition of Vectors Three and Four
#Test Fourteen Expected -- (3, 7, 11, 15, 19)

my @n = Clair::Utils::LinearAlgebra::add (\@v3,\@v4);
my @en = ("3", "7", "11", "15", "19");
is_deeply( \@n, \@en, "Test Fourteen" );

#Test Fifteen -- Addition of Vectors Three and Four and Five
#Test Fifteen Expected -- (4, 8, 13, 18, 24)

my @o = Clair::Utils::LinearAlgebra::add (\@v3,\@v4,\@v5);
my @eo = ("4", "8", "13", "18", "24");
is_deeply( \@o, \@eo, "Test Fifteen" );

### Average Tests

#Test Sixteen -- Average of Vector One
#Test Sixteen Expected -- Error Message (Only one Vector)

my @p = Clair::Utils::LinearAlgebra::average (\@v1);
my @ep = ("e");
is_deeply( \@p, \@ep, "Test Sixteen" );

#Test Seventeen -- Addition of Vectors One and Two
#Test Seventeen Expected -- (3, 4, 5, 6)

my @q = Clair::Utils::LinearAlgebra::average (\@v1,\@v2);
my @eq = ("3", "4", "5", "6");
is_deeply( \@q, \@eq, "Test Seventeen" );

#Test Eighteen -- Addition of Vectors Two and Three
#Test Eighteen Expected -- Error Message (Lengths do not Match)

my @r = Clair::Utils::LinearAlgebra::average (\@v2,\@v3);
my @er = ("e");
is_deeply( \@r, \@er, "Test Eighteen" );

#Test Nineteen -- Addition of Vectors Three and Four
#Test Nineteen Expected -- (1.5, 3.5, 5.5, 7.5, 9.5)

my @s = Clair::Utils::LinearAlgebra::average (\@v3,\@v4);
my @es = ("1.5", "3.5", "5.5", "7.5", "9.5");
is_deeply( \@s, \@es, "Test Nineteen" );

#Test Twenty -- Addition of Vectors Three and Four and Six
#Test Twenty Expected -- (2, 3, 4, 5, 7)

my @t = Clair::Utils::LinearAlgebra::average (\@v3,\@v4,\@v6);
my @et = ("2", "3", "4", "5", "7");
is_deeply( \@t, \@et, "Test Twenty" );

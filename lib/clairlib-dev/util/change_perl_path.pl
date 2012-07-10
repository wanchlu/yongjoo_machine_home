#!/usr/bin/perl

$dir=shift;



$path=shift;
open(ALL,"find $dir -name '*.pl' -print|");

print ALL;


foreach $file (<ALL>)
{

        chomp($file);
        print $file;
        open (NEW,"> $file.tmp") or warn " A problem occured. Cann't process this file\n";
        open(FH,"< $file") or warn " A problem occured. Cann't process this file\n";
        foreach $line (<FH>) {

                if($line =~ m/^#!/ && $line =~ m/perl/)
                {
                          @words = split(/ /, $line);
                        $line="#!$path";
                                for($i=1;$i<@words;$i++)
                                {
                                        $line=$line." ".$words[$i];
                                }
                        $line=$line."\n";
                }



                print NEW $line;

        }



        close(FH);
        close(NEW);
        unlink($file) or warn " A problem occured. Cann't process this file\n";
        rename("$file.tmp",$file) or warn " A problem occured. Can't process this file\n";
        print "  done...\n";
}






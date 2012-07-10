# script: mjschal_make_header.pl
# functionality: 

`mkdir temp`;

@files = `ls -1 *.pl`;

foreach my $filename (@files) {
    chomp($filename);
    my $filetext_old = `cat $filename`;
    my $filetext_new = "# script: $filename\n# functionality: \n\n$filetext_old";
    open (newfile, ">temp/$filename");
    print newfile $filetext_new;
    close newfile;
}

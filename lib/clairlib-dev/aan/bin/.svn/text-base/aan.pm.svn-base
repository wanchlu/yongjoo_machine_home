package aan;

use strict;

sub buildmeta {
	my $metafile = $_[$0];	
	open(IN, $metafile) || die("Metadata Error\n");
	chomp (my @metadata = <IN>);
	close IN;
	if ($metadata[$#metadata] ne "") {
		push (@metadata, "");
	}

	my %meta = ();
	my $id = "";
	my $title = "";
	my $author = "";
	my $year = "";
	my $venue = "";
	foreach my $m (@metadata) {
		$m =~ s/ +$//;
		if ($m =~ m/^id = /) {
#print "extracting id:$m\n";
			$id = $m;
			$id =~ s/^id = {//;
			$id =~ s/}//;
#print "id: $id\n";
		}
		elsif ($m =~ m/^author = /) {
			$author = $m;
			$author =~ s/^author = {//;
			$author =~ s/}//;
			$author =~ s/"//g;
#print "author: $m\n";
		}
		elsif ($m =~ m/^title = /) {
			$title = $m;
			$title =~ s/^title = {//;
			$title =~ s/}//;
			$title =~ s/,//g;
			$title =~ s/"//g;
		}
		elsif ($m =~ m/^year = /) {
			$year = $m;
			$year =~ s/^year = {//;
			$year =~ s/}//;
			$year =~ s/,//g;
			$year =~ s/"//g;
		}
		elsif ($m =~ m/^venue = /) {
			$venue = $m;
			$venue =~ s/^venue = {//;
			$venue =~ s/}//;
			$venue =~ s/,//g;
			$venue =~ s/"//g;
		}
#elsif ($m eq "") {
		else {
#print "reeached here\n";
			my $string = $author . " ::: " . $title . " ::: " . $year . " ::: " . $venue;
			$meta{$id} = $string;
#print "in aan.pm meta{$id} = $string\n";
			$author = "";
			$title = "";
			$year = "";
			$venue = "";
			$id = "";
		}
	}
#	open (OUT, "+>./meta.txt");
#	foreach my $id ( sort keys %meta ) {
#		print OUT "$id $meta{$id}\n";
#	}
#	close OUT;
	return %meta;
}

sub select_year {
		
		my ($id, $to_year, $self);
		$self = 0;
		$id = $_[0];
		my @paper_id =  split(//,"$id");
		$to_year = $_[1];
		my $paper_year;
		if($paper_id[1] == '0')
		{
				$paper_year = "20" . $paper_id[1] . $paper_id[2];
		}
		else
		{
				$paper_year = "19" . $paper_id[1] . $paper_id[2];
		}
		if($paper_year <= $to_year)
		{
				$self = 1;
		}
		$self;
}

1;

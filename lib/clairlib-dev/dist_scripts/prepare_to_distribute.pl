#!/usr/bin/perl

chdir "/data0/projects/clairlib-dev/dist_scripts";

#update documentation
#`./update_documentation.pl` 
#or die "update_documentation.pl failed";

# Create the directory, and copy the base files
system "./copy_base.pl";
if ($? != 0) {
	exit($?);
}

@versions = ("clairlib", "clairlibBio", "clairlibPolisci", "clairlibAll"); 

foreach $dist (@versions) {
	print "$dist\n";
	# Copy the files to clairlib 
	system "./copy_to_clairlib.pl $dist";
	if ($? != 0) {
		exit($?);
	}
	
	# Create the new tar file 
	system "./tar_clairlib.pl $dist";
	if ($? != 0) {
		exit($?);
	}

	# Create the new perldoc 
	system "./create_perldoc.pl $dist";
	if ($? != 0) {
		exit($?);
	}
}

# Update the tests on the clairlib webpage 
system "./copy_tests_to_webpage.pl";
if ($? != 0) {
	exit($?);
}

# Create the additional tar.gz file (with Nutch) 
system "./additional_tar.pl";
if ($? != 0) {
	exit($?);
}

chdir "/data0/projects/clairlib-dev/dist_scripts";
`./update_documentation.pl` 
or die "update_documentation.pl failed";
	
# Delete files copied to clairlib that are now in the tar file and move tar files
`perl remove_from_clairlib.pl`;

package Clair::Network::DoreianMrvar;
use Clair::Network::SignedNetwork;
use Clair::Network::Spectral;

sub new{
	my $class = shift;
	my $net = shift;
	if(not defined $net){
		die "No network passed";
	}
	my $K = shift;
	if(not defined $K){
		$K=2;
	}
#	use Data::Dumper;
#	print Dumper($net->get_vertices());
	my $self = bless{
			network=>new Clair::Network::SignedNetwork(network => $net->deep_copy_graph()),
			K => $K}, $class;
#	print Dumper($self->{"network"}->get_vertices());
	return $self;
}

sub _initialize{
	my $self = shift;
	my $p_graph = new Clair::Network::SignedNetwork(network =>$self->{"network"}->deep_copy_graph());
	my @neg_edges = @{$p_graph->get_negative_edges()};
	foreach my $e (@neg_edges){
		$p_graph->remove_edge($e);
	}
#	use Data::Dumper;
#	print Dumper($self->{"network"}->get_vertices());
	my $spectral = new Clair::Network::Spectral($p_graph,"gap");
        my ($a,$b) = $spectral->get_partitions();
	return ($a,$b);
}

sub partition{
	my $self = shift;
	my $net = $self->{network};
	my ($a,$b) = $self->_initialize();
	
	use Data::Dumper;
	my @initial = ();
	push @initial,[@$a];
	push @initial,[@$b];
#	print Dumper(@initial),"\n\n\n";
	#my @transofrmations = $self->get_transformations(\@initial);
	my $val = $self->_calculate_p(\@initail);
#	print "Val = $val\n\n";
	my $min = $val;
	my @bestcut = @initial;
#	print Dumper @{$bestcut[1]};
	my $found_better_cut;
	do{
		my @transformations = @{$self->_get_transformations(\@bestcut)};
	#	print "Trans :", Dumper(@transformations);
		$found_better_cut = 0;
		foreach my $tans(@transformations){
			my @trans = @$tans;
#			print Dumper(@trans);
			my $new_val = $self->_calculate_p(\@trans);
	#		print Dumper(@$tans);
		#	print "new val = $new_val\n";
			if($new_val<$min){
				$min = $new_val;
				@bestcut = @trans;
			#	print "Found Less\n";
				$found_better_cut = 1;
			}
		}
	}while($found_better_cut==1);
	
	return ($bestcut[0],$bestcut[1]);	
}

sub _get_transformations{
	my $self  = shift;
	my $ref = shift;
	my @cut = @$ref;
	#print "Cut = ",Dumper @cut;
	my @a = @{$cut[0]};
	#print "aaaaaa $a[0] $a[1]";
	my @b = @{$cut[1]};
	my @tansformations = ();
	#print "kkkkk",scalar(@a),"\n";
	for(my $i=0; $i < scalar(@a); $i++){
		my @a2 = ();
		my @b2 = ();
		for(my $j=0; $j < scalar(@a); $j++){
			push @a2, $a[$j] if($i!=$j);
		}
		push @b2, $a[$i];
		push @b2,@b;
		my @trans = ();
		push @trans, [@a2];
		push @trans, [@b2];
	#	print "tttt : ",Dumper @trans;
		push @transformations, [@trans];
	}
	for(my $i=0; $i< scalar(@b); $i++){
                my @a2 = ();
                my @b2 = ();
                for(my $j=0; $j < scalar(@b); $j++){
                        push @b2, $b[$j] if($i!=$j);
                }
                push @a2, $b[$i];
                push @a2,@a;
                my @trans = ();
                push @trans, [@a2];
                push @trans, [@b2];
                push @transformations, [@trans];
        }
	for(my $i=0; $i< scalar(@a); $i++){
		for(my $j=0; $j< scalar(@b); $j++){
			my @a2 = ();
        	        my @b2 = ();
	                for(my $k=0; $k < scalar(@a); $k++){
                               push @a2, $a[$k] if($k!=$i);
                        }
			for(my $k=0; $k < scalar(@b); $k++){
                 	       push @b2, $b[$k] if($k!=$j);
	                }
			push @a2, $b[$j];
			push @b2, $a[$i];
			my @trans = ();
                	push @trans, [@a2];
        	        push @trans, [@b2];
	                push @transformations, [@trans];
		}
	}
#	print "TRAAAAMSSSSS ==== ", Dumper(@transformations);
	return \@transformations;
}

sub _calculate_p{
	my $self = shift;
	my $ref = shift;
	my @parts = @$ref;
#	print "Parts: ",Dumper(parts)," end Parts";
	my @a = @{$parts[0]};
	my @b = @{$parts[1]};
#	print "aaaaa", Dumper @a,"bbbb";

	my $net = $self->{network};
	my @edges = $net->get_edges();
	my $p=0;
	foreach my $e (@edges){
		my @edge = @$e;
#		print "Negative\n" if($net->is_negative_edge($edge[0],$edge[1]));
		if($self->_is_edge_internal($e,\@a) or $self->_is_edge_internal($e,\@b)){
		#	print "Internal\n";
			if($net->is_negative_edge($edge[0],$edge[1])){
				$p++;		
				#print "Negative Internal\n";
			}
		}else{
			if($net->is_positive_edge($edge[0],$edge[1])){
				$p++;
				#print "Positive External\n";
			}
		}
	}	
	return $p;
}

sub _is_edge_internal{
	my $self = shift;
	my $e = shift;
	my $ref = shift;
	my @part = @$ref;
#	print Dumper @part;
	my @edge = @$e;
#	print "eeee $edge[0] $edge[1]\n";
	if ((grep {$_ eq $edge[0]} @part) and (grep {$_ eq $edge[1]} @part)){
		return 1;	
	}else{
		return 0;
	}
}

1;

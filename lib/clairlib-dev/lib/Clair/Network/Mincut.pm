package Clair::Network::Mincut;
use Clair::Network;

@ISA = qw(Clair::Network);

sub new {
    my $class = shift;
    my $net = shift;
    my $self = bless {
                    network => $net,
                    }, $class;
    return $self;
}

sub _min_cut_phase{
    my $self = shift;
    my $net = $self->{network};
    my $node_count = $net->num_nodes();
    my @nodes = $net->get_vertices();
    use Data::Dumper;
    $start_node = $nodes[0];
    my @A = ();
    push @A,$start_node;

    my $max=0;
    my $most_tight;
    my $sum=0;
    while(scalar(@A)<$node_count){
         $max=0;
         loop:foreach my $node (@nodes){
                   $sum = 0;
                   foreach my $a (@A){
                            if("$a" eq "$node"){
                                next loop;
                            }else{
                                  if ($net->has_edge ($node,$a)){
                                          $sum += $net->get_edge_weight($node,$a);
                                  }elsif($net->has_edge($a,$node)){
                                          $sum += $net->get_edge_weight($a,$node);
                                  }
                            }
                   }
                   if($sum > $max){
                           $most_tight = $node;
                           $max = $sum;
                   }

          }
          push @A,$most_tight;
    }
    $self->merge($A[$node_count-1],$A[$node_count-2]);
    my @parta;
    pop @A;
    foreach my $n (@A){
            my @ns = split(/\|/,$n);
   #         print "$n to : ",Dumper(@ns);
            foreach my $m (@ns){
                        push @parta,$m unless($m eq "|");
            }
    }
    my @partb;
    my @nsb = split(/\|/,$most_tight);
    foreach my $m (@nsb){
           push @partb,$m unless($m eq "|");
    }
    return (\@parta, \@partb, $max);
}

sub merge{
    my $self = shift;
    my $net = $self->{network};
    my $node1 = shift;
    my $node2 = shift;
    my @nodes = $net->get_vertices();
    $net->remove_edge($node1,$node2);
    my $merged_node = $node1."|".$node2;
    $net->add_node($merged_node);
    foreach $node (@nodes){
             my $weight=0;
             if($net->has_edge($node,$node1) || $net->has_edge($node1,$node) ||
                $net->has_edge($node,$node2) || $net->has_edge($node2,$node) ){
                 if($net->has_edge($node,$node1)){
                     $weight+=$net->get_edge_weight($node,$node1);
                     $net->remove_edge($node,$node1);
                 }elsif($net->has_edge($node1,$node)){
                     $weight+=$net->get_edge_weight($node1,$node);
                     $net->remove_edge($node1,$node);
                 }
                 if($net->has_edge($node,$node2)){
                     $weight+=$net->get_edge_weight($node,$node2);
                     $net->remove_edge($node,$node2);
                 }elsif($net->has_edge($node2,$node)){
                     $weight+=$net->get_edge_weight($node2,$node);
                     $net->remove_edge($node2,$node);
                 }
                 $net->add_weighted_edge($node,$merged_node,$weight);
             }
    }
    $net->remove_node($node1);
    $net->remove_node($node2);
}

sub mincut{
    my $self = shift;
    my $net = $self->{network};
    my $total_w = 0;
    foreach my $e($net->get_edges()){
            $total_w += $net->get_edge_weight(@$e[0],@$e[1]);
    }
    my $num_nodes = scalar($net->get_vertices());
    my($parta, $partb, $w)=$self->_min_cut_phase();
    my $min_weight = $w;
    my @min_parta=@$parta;
    my @min_partb=@$partb;
    my $i=0;
    while ($net->num_nodes()>1 ){
            $i--;
            ($parta, $partb, $w)=$self->_min_cut_phase();
   #         print "Part a = ", join(" ",@$parta),"\n";
   #         print "Part b = ", join(" ",@$partb),"\n";
   #        print "Weight = $w\n";
   #         print "Diff = ",10*$w/$total_w + 10*abs(scalar(@$parta)- scalar(@$partb))/$num_nodes,"\n\n";
        if($total_w ==0){
		last;
	}elsif((10*$w/$total_w + 10*abs(scalar(@$parta)- scalar(@$partb))/$num_nodes <= 10*$min_weight/$total_w + 10*abs(scalar(@min_parta)-scalar(@min_partb))/$num_nodes)){
#            if($w<$min_weight){
                 @min_parta=@$parta;
                 @min_partb=@$partb;
                 $min_weight = $w;
            }
    }
    return (\@min_parta,\@min_partb,$min_weight);
}

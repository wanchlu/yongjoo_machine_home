package Clair::Network::SignedNetwork;

#use Clair::Network;

@ISA = qw(Clair::Network);

sub new{
        my $class = shift;
        my(%params) = @_;
	my $self;
	if(defined $params{"network"}){
		$self = $params{"network"};
	}else{
	        $self = new Clair::Network(@_);
	}
        return(bless($self, $class));

}

sub is_negative_edge{
        my $self = shift;
        my $u = shift;
        my $v = shift;
        if($self->get_edge_weight($u,$v)<0){
                return 1;
        }else{
                return 0;
        }
}

sub is_positive_edge{
        my $self = shift;
        my $u = shift;
        my $v = shift;
        return !$self->is_negative_edge($u,$v);
}

sub is_negative_triangle{
        my $self = shift;
        my $triangle = shift;
        my %parameters = @_;
        my $delim = "-";
          if (exists $parameters{delim}) {
                    $delim = $parameters{delim};
          }

        my @vertices = split(/$delim/,$triangle);
        my $x = $vertices[0];
        my $y = $vertices[1];
        my $z = $vertices[2];
        if($self->is_negative_edge($x,$y) and $self->is_negative_edge($x,$z)  and $self->is_negative_edge($y,$z)){
                return 1;
        }else{
                return 0;
        }
}

sub is_balanced{
        my $self = shift;
        my $triangle = shift;
        my %parameters = @_;
        my $delim = "-";
        if (exists $parameters{delim}) {
                   $delim = $parameters{delim};
        }
        my @vertices = split(/$delim/,$triangle);
        my $x = $vertices[0];
        my $y = $vertices[1];
        my $z = $vertices[2];
	$positive_edges = 0;
        $positive_edges++ if($self->is_positive_edge($x,$y));
	$positive_edges++ if($self->is_positive_edge($x,$z));
	$positive_edges++ if($self->is_positive_edge($y,$z));
	if($positive_edges == 0 or $positive_edges == 2){
		return (0,$positive_edges);
	}else{
		return (1,$positive_edges);
	}
}

sub get_negative_edges{
        my $self = shift;
        my @neg_edges=();
	my @edges = $self->get_edges;
	foreach my $edge (@edges) {
                my ($u, $v) = @{$edge};
                if($self->is_negative_edge($u,$v)){
                        push @neg_edges, $edge;
                }
        }
        return \@neg_edges;
}

sub get_negative_triangles{
        my $self = shift;
        my ($triangles, $n,$m) = $self->get_triangles();
        my @neg_triangles = ();
        foreach my $triangle (@$triangles){
                if($self->is_negative_triangle($triangle)){
                        push @neg_triangles, $triangle;
                }
        }
        return \@neg_triangles;
}

sub is_negative_triplet{
        my $self = shift;
        my $triplet = shift;
        my %parameters = @_;
        my $delim = "-";
        if (exists $parameters{delim}) {
                $delim = $parameters{delim};
        }

        my @vertices = split(/$delim/,$triplet);
        my $x = $vertices[0];
        my $y = $vertices[1];
        my $z = $vertices[2];
        if($self->is_negative_edge($x,$y) and $self->is_negative_edge($x,$z)){
                return 1;
        }else{
                return 0;
        }
}

sub get_negative_triplets{
        my $self = shift;
        my $triplets = $self->get_triplets();
        my @neg_triplets = ();
        foreach my $triplet (@$triplets){
                if($self->is_negative_triplet($triplet)){
                        push @neg_triplets, $triplet;
                }
        }
        return \@neg_triplets;
}
1;

__END__

=pod

=head1 NAME

Clair::Network::SignedNetwork - Network with signed edges.

=head1 VERSION

Version 0.01

=head1 SYNOPSIS
        $singed_net = new Clair::Network::SignedNetwork;
        $singed_net->add_weighted_edge("a","b",-1);
        $singed_net->add_weighted_edge("a","c",1);
        $singed_net->add_weighted_edge("b","c",-1);
        ...
        if($singed_net->is_negative_edge("a","b")){
            ....
        }
        @neg_edges = @{$singed_net->get_negative_edges()};

=head1 METHODS

=head2 new

Function: Creates a new Clair::Network::SignedNetwork object
Usage: $net = new Clair::Network::SignedNetwork
Parameters: none
returns: Clair::Network:SignedNetowrk object

=head2 is_negative_edge

Function:  Check if an edges has negtive sign.
Usage: $net->is_negative_edge($u,$v)
Parameters: - $u a node, one end of an edge (source node if the graph is directed)
            - $v a node, the other end of the edge (target edge if the graph is directed)
returns: 1 if the edge is negative and 0 otherwise.

=head2 is_positive_edge

Function:  Check if an edges has positive sign.
Usage: $net->is_positive_edge($u,$v)
Parameters: - $u a node, one end of an edge (source node if the graph is directed)
            - $v a node, the other end of the edge (target edge if the graph is directed)
returns: 1 if the edge is positive and 0 otherwise.


=head2 is_negative_triangle

Function:  Check if a triangle is negative; i.e all its edges has negaive sign.
Usage: $net->is_negative_triangle($t)
Parameters: - $t a tringle formated as "u-v-w" where u,v, and w are the vertices of the triangle
returns: 1 if the triangle is negative and 0 otherwise.


=head2 get_negative_edges

Function:  Retrns all the negative edges in the network
Usage: @neg_edges = @{$net->get_negative_edges()};
Parameters: - none
returns: a reference to an array of all the negative edges in the network.


=head2 get_negative_triangles

Function:  Retrns all the negative triangles in the network
Usage: @neg_edges = @{$net->get_negative_triangles()};
Parameters: - none
returns: a reference to an array of all the negative triangles in the network.
Each element of the array is formated as "u-v-w" where u,v, and w are the vertices of the triangle.

=head2 get_negative_negative_triplets

Function:  Retrns all the negative triplits (Opened Triangles) in the network
Usage: @neg_triplets = @{$net->get_negative_triplets()};
Parameters: - none
returns: a reference to an array of all the negative triplits in the network.
Each element of the array is formated as "u-v-w" where u is the head of the triplet and
v and w are the ends of the triplit.


=head1 Bugs

Report Bugs to <<clair (at) umich.edu>>

=cut


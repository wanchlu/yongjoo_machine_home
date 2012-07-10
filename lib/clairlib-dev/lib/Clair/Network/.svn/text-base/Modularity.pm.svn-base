package Clair::Network::Modularity;

use strict;
use warnings;
use Data::Dumper;

our @ISA = qw(Clair::Network);


sub new{
    my $class=shift;
    my $self = bless({ },$class);
    return $self;
}

sub modularity{
    my $self = shift;
    my $net_file = shift;
    if (not defined $net_file){
        print STDERR "Network file is not defined\n";
        exit;
    }
    my $partitions_file = shift;
    if (not defined $partitions_file){
        print STDERR "Partitions file is not defined\n";
        exit;
    }
    open IN, $net_file || die "$!";
    my %binaryNet=();
    while(<IN>){
       chomp $_;
       my @arr = split(/ /, $_);
       my $first =$arr[0];
       my $second = $arr[1];
       $binaryNet{$first}{$second} = 1;
       $binaryNet{$second}{$first} = 1;
    }
    close IN;
    my %all_nodes=();
    my $labels_file = shift;
    open IN, $partitions_file || die "$!";
    my %communities = ();
    my %ids = ();
    while(<IN>){
        chomp $_;
        my @arr = split(/ /, $_);
        my $node = $arr[0];
        if(not defined $labels_file){
           $ids{$node}=$node;
        }
        $all_nodes{$node} =1;
        my $comm = $arr[1];
        $communities{$comm}{$node} =1 ;
    }
    close IN;
    if(defined $labels_file){
        open IN, $labels_file || die "$!";
        while(<IN>){
            chomp $_;
            my @arr = split(/ /, $_ );
            my $id = $arr[0];
            my $label = $arr[1];
            $ids{$id} = $label;
        }
        close IN;
    }
    my %sent_to_com = ();
    my $ind = 0;
    my %cid_to_ind =();
    for my $comm (keys %communities){
        for my $node (keys %{$communities{$comm}}){
            my $id = $ids{$node};
            if(!exists $cid_to_ind{$comm}){
                $cid_to_ind{$comm} = $ind;
                ++$ind;
            }
            my $commInd = $cid_to_ind{$comm};
            $sent_to_com{$id} = $commInd;
        }
    }
    my $commSize = keys(%sent_to_com);
    my $newcommIndex = 1000;
    for my $other_sent (keys %all_nodes){
        if(! exists $sent_to_com{$other_sent} ){
            $sent_to_com{$other_sent} = $newcommIndex;
            ++$newcommIndex;
        }
    }
    $commSize = keys(%sent_to_com);
    my $summsize = 5;
    my %comsize = ();
    my %comms = ();
    for my $sent (keys %sent_to_com){
        my $comm = $sent_to_com{$sent};
        if(! exists $comsize{$comm}){
            $comsize{$comm} = 1;
        }else{
            $comsize{$comm} = $comsize{$comm} +1 ;
        }
        $comms{$comm}{$sent} = 1 ;
    }
    my $cr_size = 0;
    my $ohsize = keys (%comsize);
    my @sortedcoms = sort {$comsize{$b} <=> $comsize{$a}} keys %comsize ;
    my %summary = ();
    while($cr_size < $summsize){
        my $added = 0;
      outter: for my $com (@sortedcoms){
          if($comsize{$com} == 1){
              my $rand_num = rand();
              if($rand_num > 0.05){
                  next outter;
              }
          }
        inner:    for my $sentid (keys %{$comms{$com}}){
            if($cr_size >= $summsize){
                last outter;
            }
            $summary{$sentid} = 1;
            delete($comms{$com}{$sentid});
            $cr_size = $cr_size +1;
            $added = 1;
            last inner;
        }
      }
        if($added == 0){
            last;
        }
    }
    my %commMatrix = ();

    for my $sent1 (keys %sent_to_com){
        for my $sent2 (keys %sent_to_com){
            my $comind1 = $sent_to_com{$sent1};
            my $comind2 = $sent_to_com{$sent2};
            if(exists $binaryNet{$sent1}{$sent2} && $binaryNet{$sent1}{$sent2} == 1){
                if(! exists $commMatrix{$comind1}{$comind2}){
                    $commMatrix{$comind1}{$comind2} = 0;
                }
                $commMatrix{$comind1}{$comind2} = $commMatrix{$comind1}{$comind2} +1;
            }
        }
    }

    my $sum = 0;

    for my $comind1 (keys %commMatrix){
        for my $comind2 (keys %commMatrix){
            $sum = $sum + $commMatrix{$comind1}{$comind2};
        }
    }

    my %a = ();

    for my $comind1 (keys %commMatrix){
        for my $comind2 (keys %commMatrix){
            $commMatrix{$comind1}{$comind2} = $commMatrix{$comind1}{$comind2}/$sum ;
        }
    }

    for my $comind1 (keys %commMatrix){
        $a{$comind1} = 0;
        for my $comind2 (keys %commMatrix){
            $a{$comind1} = $a{$comind1} + $commMatrix{$comind1}{$comind2};
        }
    }


    my $Q = 0;
    for my $comind1 (keys %commMatrix){
        my $a2 = ($a{$comind1}* $a{$comind1});
        $Q = $Q + $commMatrix{$comind1}{$comind1};
        $Q = $Q -  $a2;
    }

    if($Q < 0){
        $Q = 0;
    }
    return $Q;

}

1;

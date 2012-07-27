#!/usr/bin/perl -w
`nohup ./gth.pl &`;
sleep (30);
while (1) {
    my $r = rand(60);

    if (rand(2) == 1) {
        `kill $(ps ux |grep gth |grep -v grep | awk '{print $2}')`;
        sleep (rand(60));
        `nohup ./gth.pl $r &`;
    }
    sleep (10);
    sleep ($r);
}

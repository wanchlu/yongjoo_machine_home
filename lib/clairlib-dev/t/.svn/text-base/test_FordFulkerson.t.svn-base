# script: test_FordFulkerson
# functionality: Test FordFulkerson algorithm

use Clair::Network::FordFulkerson;
use Clair::Network;
use Test::More tests => 4;

use_ok('Clair::Network::FordFulkerson');
use_ok('Clair::Network');

$G = new Clair::Network();

$G->add_node("s");
$G->add_node("o");
$G->add_node("p");
$G->add_node("q");
$G->add_node("r");
$G->add_node("t");

$G->add_edge("s","o");
$G->set_edge_attribute("s", "o",'capacity',3);
$G->add_edge("s","p");
$G->set_edge_attribute("s", "p",'capacity',3);
$G->add_edge("o","p");
$G->set_edge_attribute("o", "p",'capacity',2);
$G->add_edge("o","q");
$G->set_edge_attribute("o", "q",'capacity',3);
$G->add_edge("p","r");
$G->set_edge_attribute("p", "r",'capacity',2);
$G->add_edge("r","t");
$G->set_edge_attribute("r", "t",'capacity',3);
$G->add_edge("q","r");
$G->set_edge_attribute("q", "r",'capacity',4);
$G->add_edge("q","t");
$G->set_edge_attribute("q", "t",'capacity',2);

$FF=new Clair::Network::FordFulkerson($G,"s","t");
($flow,$max)=$FF->run();


is($max, 5, "Check the maximum flow value");

$so=$flow->get_edge_attribute("s","o",'flow');
$sp=$flow->get_edge_attribute("s","p",'flow');
$oq=$flow->get_edge_attribute("o","q",'flow');
$qr=$flow->get_edge_attribute("q","r",'flow');
$op=$flow->get_edge_attribute("o","p",'flow');
$pr=$flow->get_edge_attribute("p","r",'flow');
$qt=$flow->get_edge_attribute("q","t",'flow');
$rt=$flow->get_edge_attribute("r","t",'flow');

is(($so,$sp,$oq,$qr,$op,$qr,$qt,$rt), (3,2,3,1,0,2,2,3) , "Check the flow network");















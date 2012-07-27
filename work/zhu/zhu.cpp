#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <iostream>
using namespace std;


typedef struct edge {
  unsigned int ids[2];
  double weight;
} edge_t;


typedef struct node {
  double *old_values;
  double *new_values;
  double influx;
  char labeled;
}node_t;

unsigned int n_edges=0, n_nodes=0;

short n_classes;

char *train_label_file, *test_label_file, *sim_file, *output_file;

node_t *nodes;
edge_t *edges;

void process_args(int argc, char **argv);
void read_labels();
void read_edges();
double propagate_labels();
void output_labels ();

void determine_limits () {
  FILE *fp;
  fp = fopen (sim_file, "r");
  unsigned int n1, n2;
  double weight;

  while ((fscanf(fp, "%d %d %f\n", &n1, &n2, &weight)) != EOF) {
    if (weight <= 0.0) continue;
    n_edges++;
    if (n1 > n_nodes) {
      n_nodes = n1;
    }
    if (n2 > n_nodes) {
      n_nodes = n2;
    }
  }
  fclose (fp);
}


/*** MAIN FUNCTION ***/
int main (int argc, char **argv) {

  // process the command line
  process_args (argc, argv);

  determine_limits();

  // check if there is something wrong in the command
  if (n_nodes <= 0 || n_edges <= 0) {
    fprintf (stderr, "Incorrect or missing node numbers\n");
    exit (1);
  }

//fprintf (stderr, "allocating edges..\n");
  edges = (edge_t *) malloc(n_edges * sizeof(edge_t));
  read_edges();

  //fprintf (stderr, "allocating nodes..\n");
  nodes = (node_t *) malloc(n_nodes * sizeof(node_t));
  memset (nodes, 0, n_nodes * sizeof(node_t));
  for (unsigned int i=0; i < n_nodes; i++) {
    nodes[i].old_values = (double *) malloc (n_classes * sizeof(double));
    nodes[i].new_values = (double *) malloc (n_classes * sizeof(double));
  }

  read_labels();

  for (unsigned int i=0; i < n_nodes; i++) {
    for (short j=0; j < n_classes; j++) {
      if (!nodes[i].labeled)
         nodes[i].old_values[j] = 1.0 / n_classes;
      nodes[i].new_values[j] = 0;
    }
  }

  // compute the influx (weighted degree) of each node
  for (unsigned int i=0; i < n_edges; i++) {
    nodes[edges[i].ids[0]].influx += edges[i].weight;
    nodes[edges[i].ids[1]].influx += edges[i].weight;
  }

  double max_error;

  do {
    max_error = propagate_labels();
  //  fprintf (stderr, "error: %f\n", max_error);
  } while (max_error > 0.0002);

  output_labels();

  return 0;
}


void output_labels () {
  FILE *gp;
  gp = fopen (test_label_file, "r");
  int total=0,correct=0;

  FILE *fp;
  fp = fopen (output_file, "w");

  for (unsigned int i=0; i < n_nodes; i++) {
    if (!nodes[i].labeled) {
      short label;
      fscanf (gp, "%hd\n", &label);
      total++;
      if (nodes[i].old_values[0] < nodes[i].old_values[1])
      {
          if (! (nodes[i].old_values[0] >=0 and nodes[i].old_values[0] <= 1)){
              cout<<sim_file;
              cout<<i;
          }
      fprintf (fp, "%d\t1\t%f\t%f\n", i+1 , nodes[i].old_values[0], nodes[i].old_values[1]);
       if (label == 1)
         correct++;
      }
      else
      {
          if (! (nodes[i].old_values[0] >=0 and nodes[i].old_values[0] <= 1)){
              cout<<sim_file;
              cout<<i;
          }
      fprintf (fp, "%d\t0\t%f\t%f\n", i+1 , nodes[i].old_values[0], nodes[i].old_values[1]);
       if (label == 0)
         correct++;
      }
    }
  }
  fclose (gp);
  fclose (fp);

  printf ("Accuracy: %d / %d : %f\n",
                   correct, total, (correct+0.0)/total);
}



double propagate_labels() {

  double max_error = 0;

  for (unsigned int i=0; i < n_edges; i++) {
    if (!(nodes[edges[i].ids[0]].labeled)) {
      for (short j=0; j < n_classes; j++) {
        nodes[edges[i].ids[0]].new_values[j] += nodes[edges[i].ids[1]].old_values[j] * edges[i].weight;
      //  fprintf(stderr," - node %d update class %d value to %f\n", edges[i].ids[0], j, nodes[edges[i].ids[0]].new_values[j]);
      }
    }
    if (!(nodes[edges[i].ids[1]].labeled)) {
      for (short j=0; j < n_classes; j++) {
        nodes[edges[i].ids[1]].new_values[j] += nodes[edges[i].ids[0]].old_values[j] * edges[i].weight;
       // fprintf(stderr," - node %d update class %d value to %f\n", edges[i].ids[0], j, nodes[edges[i].ids[0]].new_values[j]);
      }
    }
  }

  for (unsigned int i=0; i < n_nodes; i++) {
    if ((!nodes[i].labeled) && nodes[i].influx > 0) {
      for (short j=0; j < n_classes; j++) {
        double new_value = nodes[i].new_values[j] / nodes[i].influx;
        double error = new_value - nodes[i].old_values[j];
        if (error < 0) error = -error;
        if (error > max_error) max_error = error;
        nodes[i].old_values[j] = new_value;
        nodes[i].new_values[j] = 0;
      //  fprintf(stderr," --- node %d update class %d value to %f\n", i, j, new_value);
      }
    }
  }

  return max_error;

}



// read edge information from file
void read_edges() {
  FILE *fp;
  unsigned int count=0, n1, n2;
  double weight;
  fp = fopen (sim_file, "r");

  while ((fscanf(fp, "%d %d %f\n", &n1, &n2, &weight)) != EOF) {
    if (weight > 0.0) {
      edges[count].ids[0] = n1-1;
      edges[count].ids[1] = n2-1;
      edges[count].weight = weight;
      count++;
    }
  }
  fclose (fp);
}


// read labeled nodes information from file
void read_labels() {
  FILE *fp;
  unsigned int n1;
  short c;
  fp = fopen (train_label_file, "r");

  while ((fscanf(fp, "%d %hd\n", &n1, &c)) != EOF) {
    nodes[n1-1].old_values[c] = 1.0;
    nodes[n1-1].labeled = 1;
    //fprintf (stderr, "label: %hd\n", c);
  }
  fclose(fp);
}


void process_args(int argc, char **argv) {
  for (int argi = 1; argi < argc; ) {
    if (strcmp(argv[argi], "-out") == 0) {
      if (argc <= argi + 1) goto usage;
      output_file = strdup(argv[argi+1]);
      argi += 2;
    }
    else if (strcmp(argv[argi], "-graph") == 0) {
      if (argc <= argi + 1) goto usage;
      sim_file = strdup(argv[argi+1]);
      argi += 2;
    }
    else if (strcmp(argv[argi], "-trainlabels") == 0) {
      if (argc <= argi + 1) goto usage;
      train_label_file = strdup(argv[argi+1]);
      argi += 2;
    }
    else if (strcmp(argv[argi], "-testlabels") == 0) {
      if (argc <= argi + 1) goto usage;
      test_label_file = strdup(argv[argi+1]);
      argi += 2;
    }
    else if (strcmp(argv[argi], "-classes") == 0) {
      if (argc <= argi + 1) goto usage;
      n_classes = atoi(argv[argi+1]);
      argi += 2;
      //fprintf (stderr, "classes: %hd\n", n_classes);
    }
  }
  return;
  usage:
  fprintf(stderr, "Incorrect command line!!!\n");
  exit(1);
}


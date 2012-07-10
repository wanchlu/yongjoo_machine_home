#include <stdio.h>
#include <string.h>
#include <stdlib.h>

//#include <vector>

#define TO_FEATURES 0
#define FROM_FEATURES 1

#define MAX_ITERATIONS 44


/* edge type declaration */
typedef struct edge {
  unsigned int ids[2];  // the index of the nodes pointed by the edge
                        // 0th is the feature node, 1st is the data node
  float weight;    // weight of the edge
}edge_t;


/* feature or unlabeled node type declaration */
typedef struct unlabeled_node {
  float *old_values;     // probabilities for the 0 and 1 classes
  float *new_values;
}unlabeled_node_t;


/* array of nodes and the size of the array */
typedef struct node_set {
  unlabeled_node_t *nodes;
  unsigned int size;
}node_set_t;

/* array of edges and the size of the array */
typedef struct edge_set {
  edge_t *edges;
  unsigned int size;
}edge_set_t;


/* labeled data nodes,
   unlabeled data nodes, and
   feature nodes */
node_set_t nodes_unlabeled, nodes_feature;

/* test labels for performance evaluation */
short int *test_labels;
short int *train_labels;
short int n_class = 0;
unsigned int n_train;

/* feature nodes <-> labeled nodes edges  AND
   feature nodes <-> unlabeled nodes edges */
edge_set_t edges_labeled, edges_unlabeled;

char *to_edges_file;
char *from_edges_file;
char *train_labels_file;
char *test_labels_file;
char *output_file;

/* discounting factor */
float discount_f = 0.0;

float alpha = 1.0;

/* function declarations */
void read_edges (char *, edge_t *);
void add_and_normalize (node_set_t);
void multiply_from_labeled_nodes
        (edge_set_t, short *, node_set_t);
void multiply_using_edges (edge_set_t, unlabeled_node_t *, unlabeled_node_t *, int);
void process_args(int, char **);
void read_labels (char *, short int *);
void initialize_nodes (unlabeled_node_t *, unsigned int);
void output_labels (unlabeled_node_t *, unsigned int, short *);
unsigned int number_correct(unlabeled_node_t *, unsigned int);


void determine_limits () {
  FILE *fp;
  unsigned int feat_id, node_id, count = 0;
  float weight;

  nodes_feature.size = n_train = 
  edges_labeled.size = edges_unlabeled.size = 0;

  fp = fopen (to_edges_file, "r");

  while ((fscanf(fp, "%d %d %f\n", &feat_id, &node_id, &weight)) != EOF) {
    edges_labeled.size++;
    if (feat_id > nodes_feature.size) {
      nodes_feature.size = feat_id;
    }
    if (node_id > n_train) {
      n_train = node_id;
    }
  }

  fclose (fp);

  fp = fopen (from_edges_file, "r");

  while ((fscanf(fp, "%d %d %f\n", &feat_id, &node_id, &weight)) != EOF) {
    edges_unlabeled.size++;
    if (feat_id > nodes_feature.size) {
      nodes_feature.size = feat_id;
    }
    if (node_id > nodes_unlabeled.size) {
      nodes_unlabeled.size = node_id;
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
  if (n_train <= 0 || nodes_unlabeled.size <= 0 ||
      nodes_feature.size <= 0 || edges_labeled.size <= 0 || 
      edges_unlabeled.size <= 0 || discount_f <= 0) {
    fprintf (stderr, "Incorrect or missing node numbers\n");
    exit (1);
  }

  fprintf (stderr, "allocating edges\n");
  edges_labeled.edges =
     (edge_t *) malloc (edges_labeled.size * sizeof (edge_t));
  edges_unlabeled.edges =
     (edge_t *) malloc (edges_unlabeled.size * sizeof (edge_t));

  test_labels = (short int*) malloc (nodes_unlabeled.size * sizeof(short int));
  train_labels = (short *) malloc (n_train * sizeof (short));

  // read the training labels from file
  fprintf (stderr, "reading train labels\n");
  read_labels (train_labels_file, train_labels);

  // read the test labels from file
  fprintf (stderr, "reading test labels\n");
  read_labels (test_labels_file, test_labels);

  n_class++;

  fprintf (stderr, "allocating nodes\n");

  nodes_unlabeled.nodes =
     (unlabeled_node_t *) malloc (nodes_unlabeled.size * sizeof (unlabeled_node_t));
  for (unsigned int i=0; i < nodes_unlabeled.size; i++) {
    nodes_unlabeled.nodes[i].new_values = (float *) malloc(n_class*sizeof(float));
    nodes_unlabeled.nodes[i].old_values = (float *) malloc(n_class*sizeof(float));
  }

  nodes_feature.nodes =
     (unlabeled_node_t *) malloc (nodes_feature.size * sizeof (unlabeled_node_t));
  for (unsigned int i=0; i < nodes_feature.size; i++) {
    nodes_feature.nodes[i].new_values = (float *) malloc(n_class*sizeof(float));
    nodes_feature.nodes[i].old_values = (float *) malloc(n_class*sizeof(float));
  }


  // read the edge information (between labeled nodes and the features)
  fprintf (stderr, "reading labeled edges\n");
  read_edges (to_edges_file, edges_labeled.edges);

  // read the edge information (between unlabeled nodes and the features)
  fprintf (stderr, "reading unlabeled edges\n");
  read_edges (from_edges_file, edges_unlabeled.edges);

  // initialization..
  // put 0.5 and 0.5 to the feature and test (unlabeled) nodes
  fprintf (stderr, "initializing...\n");
  initialize_nodes (nodes_unlabeled.nodes, nodes_unlabeled.size);
  initialize_nodes (nodes_feature.nodes, nodes_feature.size);

  for (int i=0; i < MAX_ITERATIONS; i++) {
    fprintf (stderr, "Iteration %d\n", i);

    // multiply labeled nodes with the edges and
    // put the values in the feature nodes
    multiply_from_labeled_nodes (edges_labeled, train_labels,
                          nodes_feature);
    // add the old values of the feature nodes to themselves and
    // normalize the rows
    add_and_normalize (nodes_feature);

    // multiply feature nodes with the edges and
    // put the values in the unlabeled nodes
    multiply_using_edges (edges_unlabeled, nodes_feature.nodes,
                          nodes_unlabeled.nodes, FROM_FEATURES);
    // add the old values of the unlabeled nodes to themselves and
    // normalize the rows
    add_and_normalize (nodes_unlabeled);

    // multiply unlabeled nodes with the edges and
    // put the values in the feature nodes
    multiply_using_edges (edges_unlabeled, nodes_unlabeled.nodes,
                          nodes_feature.nodes, TO_FEATURES);
    // add the old values of the feature nodes to themselves and
    // normalize the rows
    add_and_normalize (nodes_feature);

    alpha *= discount_f;

    unsigned int size = nodes_unlabeled.size;
    unsigned int correct = number_correct(nodes_unlabeled.nodes, size);
    printf ("Accuracy: %d / %d : %f\n", correct, size, (correct+0.0)/size);
  }

  // output the class probabilities 
  output_labels (nodes_unlabeled.nodes, nodes_unlabeled.size, test_labels);
}

unsigned int number_correct(unlabeled_node_t *nodes, unsigned int size) {
  unsigned int correct = 0;
  for (int i=0; i < size; i++) {
    if (nodes[i].old_values[0] < nodes[i].old_values[1])
    {
     if (test_labels[i] == 1)
       correct++;
    }
    else
    {
     if (test_labels[i] == 0)
       correct++;
    }
  }
  return correct;
}


void output_labels (unlabeled_node_t *nodes, unsigned int size, short *labels) {
  unsigned int i, correct=0;
  FILE *fp;
  fp = fopen (output_file, "w");
  for (i=0; i < size; i++) {
    if (nodes[i].old_values[0] < nodes[i].old_values[1])
    {
     if (test_labels[i] == 1)
       correct++;
    }
    else
    {
     if (test_labels[i] == 0)
       correct++;
    }
    fprintf (fp, "%f\t%f\n", nodes[i].old_values[0], nodes[i].old_values[1]);
  }
  fclose (fp);
  printf ("Accuracy: %d / %d : %f\n",
                   correct, size, (correct+0.0)/size);
}


// initially both class probabilities are equal for unlabeled
// and feature nodes
void initialize_nodes (unlabeled_node_t *nodes, unsigned int size) {
  unsigned int i;
  for (i=0; i < size; i++) {
   for (int j=0; j < n_class; j++) {
    nodes[i].old_values[j] = 1.0 / n_class;
    nodes[i].new_values[j] = 0.0;
   }
  }
}


void read_labels (char *filename, short *labels) {
  FILE *fp;
  fp = fopen (filename, "r");
  int count = 0;
  short int label;
  while ((fscanf(fp, "%hd\n", &label)) != EOF) {
    if (label > n_class) {
      n_class = label;
    }
    labels[count++] = label;
  }
  fclose (fp);
}


void read_edges (char *filename, edge_t *edges) {
  FILE *fp;
  unsigned int feat_id, node_id, count = 0;
  float weight;
  fp = fopen (filename, "r");

  while ((fscanf(fp, "%d %d %f\n", &feat_id, &node_id, &weight)) != EOF) {
    edges[count].ids[0] = feat_id-1;
    edges[count].ids[1] = node_id-1;
    edges[count].weight = weight;
    count++;
  }

  fclose (fp);
}


// add the old values to the new values
// and then row-normalize the given node set
void add_and_normalize (node_set_t node_set) {
  unsigned int i;
  unlabeled_node_t *nodes = node_set.nodes;

  for (i=0; i < node_set.size; i++) {
    float total = 0;
    for (int j=0; j < n_class; j++) {
      // add the old value to the new value
      total += (nodes[i].old_values[j] += nodes[i].new_values[j]);
      // make the new values zero for future multiplications
      nodes[i].new_values[j] = 0;
    }
    for (int j=0; j < n_class; j++) {
      // now normalize the row
      nodes[i].old_values[j] /= total;
    }
  }
}

void multiply_from_labeled_nodes
        (edge_set_t edge_set, short *labels, node_set_t features) {
  unsigned int i;
  edge_t *edges = edge_set.edges;
  for (i=0; i < edge_set.size; i++) {
    short nonzero_f = labels[edges[i].ids[1]];
    (features.nodes[edges[i].ids[0]]).new_values[nonzero_f] +=
                                              alpha * edges[i].weight;
  }
}

// multiply the values in the "from" nodes with the
// edge weights and put as the values of the "to" nodes
void multiply_using_edges
        (edge_set_t edge_set, unlabeled_node_t *from, unlabeled_node_t *to, int dir) {
  unsigned int i;
  edge_t *edges = edge_set.edges;

  for (i=0; i < edge_set.size; i++) {
    for (int j=0; j < n_class; j++) {
      to[edges[i].ids[dir]].new_values[j] += alpha *
        from[edges[i].ids[1-dir]].old_values[j] * edges[i].weight;
    }
  }

}


void process_args(int argc, char **argv) {
  for (int argi = 1; argi < argc; ) {
    if (strcmp(argv[argi], "-out") == 0) {
      if (argc <= argi + 1) goto usage;
      output_file = strdup(argv[argi+1]);
      argi += 2;
    }
    else if (strcmp(argv[argi], "-toedges") == 0) {
      if (argc <= argi + 1) goto usage;
      to_edges_file = strdup(argv[argi+1]);
      argi += 2;
    }
    else if (strcmp(argv[argi], "-fromedges") == 0) {
      if (argc <= argi + 1) goto usage;
      from_edges_file = strdup(argv[argi+1]);
      argi += 2;
    }
    else if (strcmp(argv[argi], "-trainlabels") == 0) {
      if (argc <= argi + 1) goto usage;
      train_labels_file = strdup(argv[argi+1]);
      argi += 2;
    }
    else if (strcmp(argv[argi], "-testlabels") == 0) {
      if (argc <= argi + 1) goto usage;
      test_labels_file = strdup(argv[argi+1]);
      argi += 2;
    }
    else if (strcmp(argv[argi], "-d") == 0) {
      if (argc <= argi + 1) goto usage;
      discount_f = atof(argv[argi+1]);
      argi += 2;
    }
    else if (strcmp(argv[argi], "-nl") == 0) {
      if (argc <= argi + 1) goto usage;
      n_train = atoi(argv[argi+1]);
      argi += 2;
    }
    else if (strcmp(argv[argi], "-nu") == 0) {
      if (argc <= argi + 1) goto usage;
      nodes_unlabeled.size = atoi(argv[argi+1]);
      argi += 2;
    }
    else if (strcmp(argv[argi], "-nf") == 0) {
      if (argc <= argi + 1) goto usage;
      nodes_feature.size = atoi(argv[argi+1]);
      argi += 2;
    }
    else if (strcmp(argv[argi], "-el") == 0) {
      if (argc <= argi + 1) goto usage;
      edges_labeled.size = atoi(argv[argi+1]);
      argi += 2;
    }
    else if (strcmp(argv[argi], "-eu") == 0) {
      if (argc <= argi + 1) goto usage;
      edges_unlabeled.size = atoi(argv[argi+1]);
      argi += 2;
    }
  }
  return;
  usage:
  fprintf(stderr, "Incorrect command line!!!\n");
  exit(1);
}

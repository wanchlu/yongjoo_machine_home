#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <iostream>
#include <sstream>

//#include <vector>

#define TO_FEATURES 0
#define FROM_FEATURES 1
#define MAX_NAME_LENGTH 140

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
  bool wasCorrect;       // was correct in the previous iteration
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

typedef struct node_name{
  char node_name[MAX_NAME_LENGTH];
}node_name_t;


/* labeled data nodes,
   unlabeled data nodes, and
   feature nodes */
node_set_t nodes_labeled, nodes_unlabeled, nodes_feature;

/* test labels for performance evaluation */
short int *test_labels;
short int *train_labels;
short int n_class = 0;
unsigned int n_train;

/* names arrays */
node_name_t *nodes_labeled_names;
node_name_t *nodes_unlabeled_names;
node_name_t *nodes_feature_names;

/* feature nodes <-> labeled nodes edges  AND
   feature nodes <-> unlabeled nodes edges */
edge_set_t edges_labeled, edges_unlabeled;

char *to_edges_file;
char *from_edges_file;
char *train_labels_file;
char *test_labels_file;
char *output_file;
char *feature_names_file;

/* discounting factor */
float discount_f = 0.0;

float alpha = 1.0;

/* function declarations */
void read_edges (char *, edge_t *);
void read_feature_names (char *);
void add_and_normalize (node_set_t);
void multiply_from_labeled_nodes
        (edge_set_t, short *, node_set_t);
void multiply_using_edges (edge_set_t, unlabeled_node_t *, unlabeled_node_t *, int);
void process_args(int, char **);
void read_labels (char *, short int *, node_name_t *);
void initialize_nodes (unlabeled_node_t *, unsigned int);
void output_labels (unlabeled_node_t *, unsigned int, short *);
unsigned int number_correct(unlabeled_node_t *, unsigned int);


void determine_limits () {
  FILE *fp;
  unsigned int feat_id, node_id, count = 0;
  float weight;

  nodes_feature.size = n_train = 
  edges_labeled.size = edges_unlabeled.size = nodes_labeled.size = 0;

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

  nodes_labeled.size = n_train;

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

  nodes_feature_names = (node_name_t *) malloc (MAX_NAME_LENGTH * nodes_feature.size * sizeof(node_name_t));

  fprintf (stderr, "allocating edges\n");
  edges_labeled.edges =
     (edge_t *) malloc (edges_labeled.size * sizeof (edge_t));
  edges_unlabeled.edges =
     (edge_t *) malloc (edges_unlabeled.size * sizeof (edge_t));

  test_labels = (short int*) malloc (nodes_unlabeled.size * sizeof(short int));
  nodes_unlabeled_names = (node_name_t *) malloc (MAX_NAME_LENGTH * nodes_unlabeled.size * sizeof(node_name_t));

  train_labels = (short *) malloc (n_train * sizeof (short));
  nodes_labeled_names = (node_name_t *) malloc (MAX_NAME_LENGTH * nodes_labeled.size * sizeof(node_name_t));

  // read the training (labeled) labels and names from file
  fprintf (stderr, "reading train labels\n");
  read_labels (train_labels_file, train_labels, nodes_labeled_names);

  // read the test (unlabeled) labels and names from file
  fprintf (stderr, "reading test labels\n");
  read_labels (test_labels_file, test_labels, nodes_unlabeled_names);

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

  nodes_labeled.nodes =
     (unlabeled_node_t *) malloc (nodes_labeled.size * sizeof (unlabeled_node_t));


  // read the edge information (between labeled nodes and the features)
  fprintf (stderr, "reading labeled edges\n");
  read_edges (to_edges_file, edges_labeled.edges);


  // read the edge information (between unlabeled nodes and the features)
  fprintf (stderr, "reading unlabeled edges\n");
  read_edges (from_edges_file, edges_unlabeled.edges);

  // read names of feature nodes, store them in nodes_feature_names
  fprintf (stderr, "reading feature names\n");
  read_feature_names(feature_names_file);

  // initialization..
  // put 0.5 and 0.5 to the feature and test (unlabeled) nodes
  fprintf (stderr, "initializing...\n");
  initialize_nodes (nodes_unlabeled.nodes, nodes_unlabeled.size);
  initialize_nodes (nodes_feature.nodes, nodes_feature.size);

  system("mkdir detailed_output");

  for (int i=0; i < MAX_ITERATIONS; i++) {
    fprintf (stderr, "Iteration %d\n", i);

if (i!=0) {
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

}    alpha *= discount_f;

    unsigned int size = nodes_unlabeled.size;
    unsigned int correct = number_correct(nodes_unlabeled.nodes, size);
    printf ("Accuracy: %d / %d : %f\n", correct, size, (correct+0.0)/size);

    //Output details in detailed_output/i.out


    std::stringstream details_file;
    if(i < 10)
      details_file << "detailed_output/0" << i << ".out";
    else
      details_file << "detailed_output/" << i << ".out";
    FILE *details;
    
    details = fopen((details_file.str()).c_str(), "w");
    fprintf(details, "Iteration %d\n", i);
    fprintf(details, "--Unlabeled Nodes--\n");

    fprintf(details, "ID\tName\tValue\t\tClass\tActual\n");
    for(int node_id = 0; node_id < nodes_unlabeled.size; node_id++) {
      fprintf(details, "%d\t%s\t%f\t", 
	                                node_id+1,
	                                nodes_unlabeled_names[node_id].node_name,
	                                (nodes_unlabeled.nodes[node_id]).old_values[1]); 
      if((nodes_unlabeled.nodes[node_id]).old_values[0] < (nodes_unlabeled.nodes[node_id]).old_values[1]){
	fprintf(details, "1\t");
      }
      else{
	fprintf(details, "0\t");
      }
      fprintf(details, "%d\n", test_labels[node_id]);
    }
    fprintf (details, "Accuracy: %d / %d : %f\n\n", correct, size, (correct+0.0)/size);

    fprintf(details, "--Labeled Nodes--\n");

    fprintf(details, "ID\tName\tClass\n");
    for(int node_id = 0; node_id < nodes_labeled.size; node_id++) {
      fprintf(details, "%d\t%s\t%d\n", 
	                                node_id+1,
	                                nodes_labeled_names[node_id].node_name,
	                                train_labels[node_id]); 
    }
    
    fprintf(details, "\n--Feature Nodes--\n");
    fprintf(details, "ID\tName\tValue\n");
    for(int node_id = 0; node_id < nodes_feature.size; node_id++) {
      fprintf(details, "%d\t%s\t%f\n",
	                                node_id+1,
	                                nodes_feature_names[node_id].node_name,
	                                nodes_feature.nodes[node_id].old_values[1]);
    }
    fclose(details);
  }

  // output the class probabilities 
  // this is basically unnecessary in detailed_output, but it's still here to 
  // make the output backwards compatible
  // this writes the final iteration's data to whatever the -out argument was
  output_labels (nodes_unlabeled.nodes, nodes_unlabeled.size, test_labels);

  // prevent memory leaks
  free(nodes_labeled_names); free(nodes_unlabeled_names); free(nodes_feature_names);
  free(edges_labeled.edges); free(edges_unlabeled.edges);
  free(test_labels); free(train_labels);
  for(int i = 0; i < nodes_labeled.size; i++){
    free(nodes_labeled.nodes[i].new_values); free(nodes_labeled.nodes[i].old_values);
  }
  for(int i = 0; i < nodes_unlabeled.size; i++){
    free(nodes_unlabeled.nodes[i].new_values); free(nodes_unlabeled.nodes[i].old_values);
  }
  free(nodes_labeled.nodes); free(nodes_unlabeled.nodes); free(nodes_feature.nodes);
}

// used in accuracy calculations
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


// prints to -out file
// format: (for each unlabeled object)
// [probability that class is 0] [probability that class is 1] ...
void output_labels (unlabeled_node_t *nodes, unsigned int size, short *test_labels) {
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
  printf ("\nFinal accuracy: %d / %d : %f\n",
                   correct, size, (correct+0.0)/size);
}


// initially both class probabilities are equal for unlabeled
// and feature nodes
void initialize_nodes (unlabeled_node_t *nodes, unsigned int size) {
  unsigned int i;
  //fprintf(stderr, "%d\n", size);
  for (i=0; i < size; i++) {
   for (int j=0; j < n_class; j++) {
    nodes[i].old_values[j] = 1.0 / n_class;
    nodes[i].new_values[j] = 0.0;
    nodes[i].wasCorrect = true;
   }
  }
}


void read_labels (char *filename, short *labels, node_name_t *names) {
  //fprintf(stderr, "in read_labels\n");
  FILE *fp;
  fp = fopen (filename, "r");
  int count = 0;
  int count2 = 0;
  short int label;
  //fprintf(stderr, "declared everything!\n");
  while ((fscanf(fp, "%hd %s\n", &label, names[count2].node_name) != EOF)) {
    //fprintf(stderr, "begin-loop\n");
    //fprintf(stderr, "Name: %s\n", name);
    if (label > n_class) {
      n_class = label;
    }
    labels[count++] = label;
    //fprintf(stderr, "we've set label!\n");
    //fprintf(stderr, "Name in array: %s\n", names[count2].node_name);
    //fprintf(stderr, "we've set name!\n");
    count2++;
    //fprintf(stderr, "end-loop... ");
  }
  //fprintf(stderr, "\nout of loop\n");
  fclose (fp);
}


void read_edges (char *filename, edge_t *edges) {
  FILE *fp;
  unsigned int feat_id, node_id, count = 0;
  float weight;
  fp = fopen (filename, "r");
  //fprintf(stderr, "in read_edges\n");
  while ((fscanf(fp, "%d %d %f\n", &feat_id, &node_id, &weight)) != EOF) {
    //fprintf(stderr, "in loop\n");
    edges[count].ids[0] = feat_id-1;
    edges[count].ids[1] = node_id-1;
    edges[count].weight = weight;
    count++;
  }

  fclose (fp);
}

void read_feature_names(char *filename){
  FILE *fp;
  fp = fopen(filename, "r");
  unsigned int count = 0;
  while((fscanf(fp, "%s\n", nodes_feature_names[count].node_name)) != EOF){count++;}
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

// multiply the old_values in the "from" nodes with the
// edge weights and put as the new_values of the "to" nodes
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
    else if (strcmp(argv[argi], "-featurenames") == 0) {
      if (argc <= argi + 1) goto usage;
      feature_names_file = strdup(argv[argi+1]);
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
  fprintf(stderr, "Incorrect command line!!!\nYou need: -testlabels, -trainlabels, -fromedges, -toedges, -featurenames, -out, -d\n");
  exit(1);
}

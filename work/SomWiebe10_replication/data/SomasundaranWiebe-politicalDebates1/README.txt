README

This distribution contains the data used in our publication “Recognizing Stances in Ideological On-line Debates.” (NAACL HLT 2010 Workshop on Computational Approaches to Analysis and Generation of Emotion in Text).


====================================================================

Citation Information 

When using this data set, the following citation should be used: 

@InProceedings{somasundaran-wiebe:2010:EMOTION,
  author    = {Somasundaran, Swapna  and  Wiebe, Janyce},
  title     = {Recognizing Stances in Ideological On-Line Debates},
  booktitle = {Proceedings of the NAACL HLT 2010 Workshop on Computational Approaches to Analysis and Generation of Emotion in Text},
  month     = {June},
  year      = {2010},
  address   = {Los Angeles, CA},
  publisher = {Association for Computational Linguistics},
  pages     = {116--124},
  url       = {http://www.aclweb.org/anthology/W10-0214}
}



====================================================================

Data Format:

There are 6 directories in this distribution, one for each ideological debate domain.  
Each ideological debate consists of many individual debates that were downloaded from various debating websites. 
The stances in the individual debates map on to the overall stances in the debate domain. (This mapping between the individual debate stances and the domain-level stance was performed manually)  
Please refer to the publication for further details. 


Each file within the directories is a debate post. 
Within each file, there are three lines that start with "#" preceeding the post content. These  provide label information for the post. These are:
-"stance":  this provides the domain-level label for the post (domain-level stance that the post supports). 
-"originalTopic":  this is the topic of the individual debate from which the given post is extracted 
-"originalStanceText":  this is the original stance text from the individual debate 




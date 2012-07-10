
#ifndef __PDL_H

/* These are kept automaticallu in sync with pdl.h during perl build */


/*****************************************************************************/
/*** This section of .h file generated automatically - don't edit manually ***/

/* Data types/sizes [must be in order of complexity] */

enum pdl_datatypes { PDL_B, PDL_S, PDL_US, PDL_L, PDL_LL, PDL_F, PDL_D };

/* Define the pdl data types */

typedef unsigned char              PDL_Byte;
typedef short              PDL_Short;
typedef unsigned short              PDL_Ushort;
typedef int              PDL_Long;
typedef long              PDL_LongLong;
typedef float              PDL_Float;
typedef double              PDL_Double;


/*****************************************************************************/


#define PDL_U PDL_US
#define PDL_Q PDL_LL



#endif

/*
   Define a simple pdl C data structure which maps onto passed
   piddles for passing with callext().

   Note it is up to the user at the perl level to get the datatype
   right. Anything more sophisticated probably ought to go through
   PP anyway (which is fairly trivial).
*/

struct pdlsimple {
   int    datatype;  /* whether byte/int/float etc. */
   void  *data;      /* Generic pointer to the data block */
   int    nvals;     /* Number of data values */
   PDL_Long   *dims; /* Array of data dimensions */
   int    ndims;     /* Number of data dimensions */
};

typedef struct pdlsimple pdlsimple;


*******
Cylinder-based approximation of 3D objects
*******
#. Introduction


* Task description 
The  first  task is  to  import  a  3Dgeometry  from  an  STLfile.  This  volume  should  then  be approximated  by  cylinders.  All  these  cylinders  need  to  be  parallel.  They  are  defined  to  be parallel  to  the  y-axis  of  the  given  geometry.  Furthermore,  the  shape  can  be  defined  as  an addition  and  a  subtraction  of  cylinders.  In  the  following,  the  added  cylinders  will  be  called green, and the subtracted cylinders will be called red. The approximation needs to lie entirely inside  the  original  volume,  as  this  volume  should  model  a  construction  space  for  a transmission system. Therefore, it needs to be guaranteed that a point is inside the original volume  if  it  is  inside  the  approximation.  The  aim  is  to  approximate  the  shape  with  as  few cylinders as possible while approximating the main features of the geometry well. To evaluate the quality of the approximation, also the volume should be computed and compared to the original volume. The code is tested using multiple different STL-files.
For a quick introduction to using Cylinder-based approximation of 3D objects, please refer to the :doc:`tutorial`.


Citing Cylinder-based approximation of 3D objects
==============

If you want to cite Cylinder-based approximation of 3D objects in a scholarly work, there are two ways to do it.

- If you are using the library for your work, for the sake of reproducibility, please cite the version you used by retrieving the appropriate DOI and citation information from Zenodo:

.. image:: https://zenodo.org/badge/
   :target:

- If you wish to cite Cylinder-based approximation of 3D objects for its design, motivation etc., please cite the poster
  published at TUM 2021. [#]_

.. [#]



  



.

.. toctree::
    :caption: Getting Started
    :maxdepth: 2

    install



.. toctree::
    :caption: 2D Approximation
    :maxdepth: 2

    2D_approximation

.. toctree::
    :caption: 3D Approximation
    :maxdepth: 2

    3D_approximation



.. toctree::
    :caption: STL Import
    :maxdepth: 2

    stl_import


.. toctree::
    :caption: Visualization
    :maxdepth: 2

    visualization





.. toctree::
    :caption: Reference
    :maxdepth: 1

  

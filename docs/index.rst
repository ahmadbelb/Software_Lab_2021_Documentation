*******
Cylinder-based approximation of 3D objects
*******


Introduction 
^^^^^^^^
The automotive industry faces increasingly strict regulations concerning fleet CO<sub>2</sub>  and pollutant emissions, which require innovative drive systems. To meet
these requirements, a fleet containing a mix of conventional, hybrid and purely electric vehicles seems to be one likely answer. To handle the space challenges that the adding of electrical components produce, transmission synthesis tools have been developed. The industry successfully applies them to synthesize transmissions for purely electric, conventional and hybrid powertrains. A full evaluation of the transmission concept, however, requires design drafts. Therefore,
automatizing the transmission design process is the content of current research, focusing on a fast generation of design drafts for multiple transmission topologies found by the transmission synthesis.


For the computer-aided optimization of engineering designs, 3D-objects may be
approximated for later computational efficiency reasons. For instance, it may be
beneficial to inner-approximate objects by coaxial cylinders. This task's goal is a
model that uses few cylinders while approximating the main features of the object

Task description  
~~~~~~~~

The first task is to import a 3D geometry from an STL file. This volume should then be approximated by cylinders. All these cylinders need to be parallel. They are defined to be parallel to the y-axis of the given geometry. Furthermore, the shape can be defined as an addition and a subtraction of cylinders. In the following, the added cylinders will be called green, and the subtracted cylinders will be called red. The approximation needs to lie entirely inside the original volume, as this volume should model a construction space for a transmission system. Therefore, it needs to be guaranteed that a point is inside the original volume if it is inside the approximation. The aim is to approximate the shape with as few cylinders as possible while approximating the main features of the geometry well. To evaluate the quality of the approximation, also the volume should be computed and compared to the original volume. The code is tested using multiple different STL-files. 

Motivation 
~~~~~~~~

The reason for this cylinder-approximation is to test a method that makes an inside-outside test simpler. Using this approximation, it is easy to determine whether a point lies inside the geometry. If this point lies in any of the green cylinders but in none of the red cylinders, it lies inside the geometry. For the test of each cylinder, only the y-value must be compared to the y-range of that cylinder, as they are parallel to the y-axis. Then, the distance of the point in the x-z-plane to the center of the circle needs to be compared to the radius. In practice, the squared distance will be compared to the squared radius to avoid costly square roots. All in all, the approximation of geometries by cylinders leads to a very fast inside-outside test. 

Literature review
~~~~~~~~

Previous works directly related to the approximation of a geometry by parallel cylinders were not found. However, some indirectly related packing methods were interesting and although they were not implemented, they contributed to the understanding of the problem and to generate ideas for possible solutions.  

 

Random Circle Packing [1]:  The source code fills a rectangle with tangent circles. In a given boundary, the coordinates of centers are allocated successively in a random process. The radius of each circle grows until it encounters another circle or the boundary.   

 

Several attempts were made to improve the code and to make it more adaptable, such as allowing the movement of the centers and the possibility to be applied in any type of polygon (boundary). Nonetheless, it was no longer used in the project because it required a lot of circles and the randomness implied long running times.  



 .. image:: img/Fig1.png
   :alt: Figure 1 Circle Packing 
   :align: center
   
   Figure 1: Circle Packing 




Collins and Stephenson Circle Packing [2]: It consists of a configuration of circles with a specified pattern of tangencies defined in a given triangulation. This method comprises a system of nonlinear equations to find the radii, resulting in a complex mathematical problem. 

 

The random circle packing and the circle packing by Collins and Stepheson inspired the idea of tackling the 3D problem by solving a set of 2D circle packing problems. Those two methods are mostly focused on tangent circles. By contrast, this work is based on intersecting circles to avoid undefined spaces inside the approximated 3D object. 

 

Another idea was, to approach this topic by formulating a general optimization problem. The objective function would be the area of the approximation, which should be maximized. The design variables would be the number of red and green cylinders and the respective positions and radii. The constraint would be, that the approximation lies entirely inside the given geometry. This problem definition would lead to a nonlinear, even non-smooth, discrete optimization problem. When looking at some literature [3],[4], it became clear, that this forms an extremely difficult optimization problem. Standard solution methods would not be possible for this situation. It would also be very questionable if a global optimum could be found using this general formulation. Therefore, in the following, a heuristic approach is described, that solves the problem of 3D approximation by cylinders. 



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
    :maxdepth: 2

    Reference

  

Installation instructions
^^^^^^^^^^^^^^^^^^^^^^^^^


Running the code 
~~~~
The simplest way to use *Cylinder-based approximation of 3D objects* is through running the main file  
This can be achieved by executing the following command::

    cylinder_approximation_3D.m


Algorithm 
^^^^^^^^

The main idea of the algorithm is to reduce the approximation of a 3D geometry by cylinders to an approximation of a 2D-polygon by circles. This is possible, because the task is to use only cylinders which are parallel to the y-axis. Therefore, any cut of the cylinder-approximation which is perpendicular to the y-axis can be regarded as a combination of circles. Moreover, these circles resulting from cutting the geometry are constant in a certain range. Therefore, the first step is to approximate a 2D-polygon by circles. This can then be used to define one layer of cylinders. 

In the following sections, the algorithm for the cylinder approximation will be described. Several parameters will be specified, which need to be chosen for the algorithm and which influence the performance. An overview of those parameters will be given at the end of this chapter. 


Results 
^^^^^^^^


Conclusions  
^^^^^^^^
There is sufficient evidence to prove that the final version of the complete algorithm works well with various STL files, which results in a good approximation of only up to a 2% error. The final approximation of the different STL files outputs the required results, and fulfills all of the project objectives, which were to successfully read an STL file, implement an algorithm to identify significant edges in the cross-section area, efficiently remove and reuse cylinders, comparison of volume approximation with the original geometry volume, and lastly to implement it on different STL files. All in all, a combination of different parts of the algorithm accomplishes the desired tasks. 


Outlook 
^^^^^^^^
There are several possible measures that could improve the algorithm of the cylinder-approximation. 

 

As a first idea, better use of the 2D-polygons in the different sections could be made. For example, common edges of neighboring slices could be identified. Then, the same red and green cylinders could be placed at those edges in both sections. By that, the reuse of cylinders in different sections is more effective. 

 

Secondly, the input could be enhanced. If the input wasn’t only an STL-file, but also consisted of any cylinders which are used in the design process, round geometries could be represented better. In the current algorithm, any cylinder of the original model is transformed into a triangle-mesh. By that, corners are introduced. These will in turn be approximated by some new cylinders. In all these steps, information about the original area is lost. So, these new cylinders can never correctly represent the original cylinder and will always cover a smaller area. 

 

Thirdly, the parameters which are needed in the code could be tuned to certain kinds of geometries. Different geometries require different parameters to be approximated most effectively. Therefore, experience and knowledge with some similar geometries would make it possible to choose better parameters. 

 

Lastly, changing the problem definition slightly could also lead to better results.  

An idea would be to not only add or subtract cylinders. In addition, intersections of 2 or 3 cylinders could be included as a new possibility to represent the geometry. This would enable a more accurate representation of sharp corners. The inside-outside-test for this new approach would only be slightly more complex. 

Moreover, not using parallel cylinders but parallel pieces of cones would also open many more possibilities. That would mean, the radius would not be constant over a certain range of y-values but would vary linearly. So, the test, whether a point lies inside the cone, would not be much more difficult. These varying radii would enable an easier representation of tilted triangles. 

The *Cylinder-based approximation of 3D objects* package is structured as collection of submodules:

  - librosa

    - :ref:`2D_approximation <2D_approximation>`
        Functions for estimating tempo and detecting beat events.

    - :ref:`librosa.core <core>`
        Core functionality includes functions to load audio from disk, compute various
        spectrogram representations, and a variety of commonly used tools for
        music analysis.  For convenience, all functionality in this submodule is
        directly accessible from the top-level `librosa.*` namespace.
        
    - :ref:`librosa.decompose <decompose>`
        Functions for harmonic-percussive source separation (HPSS) and generic
        spectrogram decomposition using matrix decomposition methods implemented in
        *scikit-learn*.

    - :ref:`librosa.display <display>`
        Visualization and display routines using `matplotlib`.  

    - :ref:`librosa.effects <effects>`
        Time-domain audio processing, such as pitch shifting and time stretching.
        This submodule also provides time-domain wrappers for the `decompose`
        submodule.

    - :ref:`librosa.feature <feature>`
        Feature extraction and manipulation.  This includes low-level feature
        extraction, such as chromagrams, Mel spectrogram, MFCC, and various other
        spectral and rhythmic features.  Also provided are feature manipulation
        methods, such as delta features and memory embedding.

    - :ref:`librosa.filters <filters>`
        Filter-bank generation (chroma, pseudo-CQT, CQT, etc.).  These are primarily
        internal functions used by other parts of *librosa*.

    - :ref:`librosa.onset <onset>`
        Onset detection and onset strength computation.

    - :ref:`librosa.segment <segment>`
        Functions useful for structural segmentation, such as recurrence matrix
        construction, time-lag representation, and sequentially constrained
        clustering.

    - :ref:`librosa.sequence <sequence>`
        Functions for sequential modeling.  Various forms of Viterbi decoding,
        and helper functions for constructing transition matrices.

    - :ref:`librosa.util <util>`
        Helper utilities (normalization, padding, centering, etc.)


.. _quickstart:

Quickstart
~~~~~~~~~~
Before diving into the details, we'll walk through a brief example program

.. code-block:: python
    :linenos:

    # Beat tracking example
    import librosa

    # 1. Get the file path to an included audio example
    filename = librosa.example('nutcracker')


    # 2. Load the audio as a waveform `y`
    #    Store the sampling rate as `sr`
    y, sr = librosa.load(filename)

    # 3. Run the default beat tracker
    tempo, beat_frames = librosa.beat.beat_track(y=y, sr=sr)

    print('Estimated tempo: {:.2f} beats per minute'.format(tempo))

    # 4. Convert the frame indices of beat events into timestamps
    beat_times = librosa.frames_to_time(beat_frames, sr=sr)


The first step of the program::

    filename = librosa.example('nutcracker')

gets the path to an audio example file included with *librosa*.  After this step,
``filename`` will be a string variable containing the path to the example audio file.

The second step::

    y, sr = librosa.load(filename)
    
loads and decodes the audio as a :term:`time series` ``y``, represented as a one-dimensional
NumPy floating point array.  The variable `sr` contains the :term:`sampling rate` of
``y``, that is, the number of samples per second of audio.  By default, all audio is
mixed to mono and resampled to 22050 Hz at load time.  This behavior can be overridden
by supplying additional arguments to `librosa.load`.

Next, we run the beat tracker::

    tempo, beat_frames = librosa.beat.beat_track(y=y, sr=sr)

The output of the beat tracker is an estimate of the tempo (in beats per minute), 
and an array of frame numbers corresponding to detected beat events.

:term:`Frames <frame>` here correspond to short windows of the signal (``y``), each 
separated by ``hop_length = 512`` samples.  *librosa* uses centered frames, so 
that the *k*\ th frame is centered around sample ``k * hop_length``.

The next operation converts the frame numbers ``beat_frames`` into timings::

    beat_times = librosa.frames_to_time(beat_frames, sr=sr)

Now, ``beat_times`` will be an array of timestamps (in seconds) corresponding to
detected beat events.

The contents of ``beat_times`` should look something like this::

    7.43
    8.29
    9.218
    10.124
    ...


Advanced usage
~~~~~~~~~~~~~~

Here we'll cover a more advanced example, integrating harmonic-percussive separation,
multiple spectral features, and beat-synchronous feature aggregation.

.. code-block:: python
    :linenos:

    # Feature extraction example
    import numpy as np
    import librosa

    # Load the example clip
    y, sr = librosa.load(librosa.ex('nutcracker'))

    # Set the hop length; at 22050 Hz, 512 samples ~= 23ms
    hop_length = 512

    # Separate harmonics and percussives into two waveforms
    y_harmonic, y_percussive = librosa.effects.hpss(y)

    # Beat track on the percussive signal
    tempo, beat_frames = librosa.beat.beat_track(y=y_percussive, 
                                                 sr=sr)

    # Compute MFCC features from the raw signal
    mfcc = librosa.feature.mfcc(y=y, sr=sr, hop_length=hop_length, n_mfcc=13)

    # And the first-order differences (delta features)
    mfcc_delta = librosa.feature.delta(mfcc)

    # Stack and synchronize between beat events
    # This time, we'll use the mean value (default) instead of median
    beat_mfcc_delta = librosa.util.sync(np.vstack([mfcc, mfcc_delta]),
                                        beat_frames)

    # Compute chroma features from the harmonic signal
    chromagram = librosa.feature.chroma_cqt(y=y_harmonic, 
                                            sr=sr)

    # Aggregate chroma features between beat events
    # We'll use the median value of each feature between beat frames
    beat_chroma = librosa.util.sync(chromagram, 
                                    beat_frames,
                                    aggregate=np.median)

    # Finally, stack all beat-synchronous features together
    beat_features = np.vstack([beat_chroma, beat_mfcc_delta])


This example builds on tools we've already covered in the :ref:`quickstart example
<quickstart>`, so here we'll focus just on the new parts.

The first difference is the use of the :ref:`effects module <effects>` for time-series
harmonic-percussive separation::

    y_harmonic, y_percussive = librosa.effects.hpss(y)

The result of this line is that the time series ``y`` has been separated into two time
series, containing the harmonic (tonal) and percussive (transient) portions of the
signal.  Each of ``y_harmonic`` and ``y_percussive`` have the same shape and duration 
as ``y``.

The motivation for this kind of operation is two-fold: first, percussive elements
tend to be stronger indicators of rhythmic content, and can help provide more stable
beat tracking results; second, percussive elements can pollute tonal feature
representations (such as chroma) by contributing energy across all frequency bands, so
we'd be better off without them.

Next, we introduce the :ref:`feature module <feature>` and extract the Mel-frequency
cepstral coefficients from the raw signal ``y``::

    mfcc = librosa.feature.mfcc(y=y, sr=sr, hop_length=hop_length, n_mfcc=13)

The output of this function is the matrix ``mfcc``, which is a `numpy.ndarray` of
shape ``(n_mfcc, T)`` (where ``T`` denotes the track duration in :term:`frames <frame>`).
Note that we use the same ``hop_length`` here as in the beat tracker, so the detected ``beat_frames`` 
values correspond to columns of ``mfcc``.

The first type of feature manipulation we introduce is ``delta``, which computes
(smoothed) first-order differences among columns of its input::

    mfcc_delta = librosa.feature.delta(mfcc)

The resulting matrix ``mfcc_delta`` has the same shape as the input ``mfcc``.

The second type of feature manipulation is ``sync``, which aggregates columns of its
input between sample indices (e.g., beat frames)::

    beat_mfcc_delta = librosa.util.sync(np.vstack([mfcc, mfcc_delta]),
                                        beat_frames)

Here, we've vertically stacked the ``mfcc`` and ``mfcc_delta`` matrices together.  The
result of this operation is a matrix ``beat_mfcc_delta`` with the same number of rows
as its input, but the number of columns depends on ``beat_frames``.  Each column 
``beat_mfcc_delta[:, k]`` will be the *average* of input columns between
``beat_frames[k]`` and ``beat_frames[k+1]``.  (``beat_frames`` will be expanded to
span the full range ``[0, T]`` so that all data is accounted for.)

Next, we compute a chromagram using just the harmonic component::

    chromagram = librosa.feature.chroma_cqt(y=y_harmonic, 
                                            sr=sr)

After this line, ``chromagram`` will be a `numpy.ndarray` of shape ``(12, T)``, and 
each row corresponds to a pitch class (e.g., *C*, *C#*, etc.).  Each column of 
``chromagram`` is normalized by its peak value, though this behavior can be overridden 
by setting the ``norm`` parameter.

Once we have the chromagram and list of beat frames, we again synchronize the chroma 
between beat events::

    beat_chroma = librosa.util.sync(chromagram, 
                                    beat_frames,
                                    aggregate=np.median)

This time, we've replaced the default aggregate operation (*average*, as used above
for MFCCs) with the *median*.  In general, any statistical summarization function can
be supplied here, including ``np.max()``, ``np.min()``, ``np.std()``, etc.

Finally, the all features are vertically stacked again::

    beat_features = np.vstack([beat_chroma, beat_mfcc_delta])

resulting in a feature matrix ``beat_features`` of shape
``(12 + 13 + 13, # beat intervals)``.


More examples
~~~~~~~~~~~~~

More example scripts are provided in the :ref:`advanced examples <advanced>` section.

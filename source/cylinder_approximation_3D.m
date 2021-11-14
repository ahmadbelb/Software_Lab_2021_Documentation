% An stl_file is approximated by parallel cylinders (parallel to the y-axis)
% the cylinders must not lie outside of the initial geometry
%
% first, y_values are chosen, where geometry is cut.
% second, new stl-files are defined for every section in between the cuts.
% third, maximum allowable 2D-polygon is defined for each section
% fourth, cylinders are created, using a 2D-algorithm with circles and
% reusing cylinders, whenever possible
 %
    % *List of Functions*:
    %             * :meth:`stlReadFirst`
    %             * :meth:`disconnect`
    %             * :meth:`stopAllMotors`
    %             * :meth:`beep`
    %             * :meth:`playTone`
    %             * :meth:`stopTone`
    %             * :meth:`tonePlayed`
    %             * :meth:`setProperties`
    %
    %
    % High-level class to work with physical bricks.
    %
    % This is the 'central' class (from user's view) when working with this toolbox. It
    % delivers a convenient interface for creating a connection to the brick and sending
    % commands to it. An EV3-object creates 4 Motor- and 4 Sensor-objects, one for each port.
    %
    %
    % Notes:
    %     * Creating multiple EV3 objects and connecting them to different physical bricks has not
    %       been thoroughly tested yet, but seems to work on a first glance.
    %     * When an input argument of a method is marked as optional, the argument needs to be
    %       'announced' by a preceding 2nd argument, which is a string containing the name of the argument.
    %       For example, Motor.setProperties may be given a power-parameter. The syntax would be as
    %       follows: *brickObject.motorA.setProperties('power', 50);*
    %
    %
    %
    % Attributes:
    %     motorA (Motor): Motor-object interfacing port A. See also :class:`Motor`.
    %     motorB (Motor): Motor-object interfacing port B. See also :class:`Motor`.
    %     motorC (Motor): Motor-object interfacing port C. See also :class:`Motor`.
    %     motorD (Motor): Motor-object interfacing port D. See also :class:`Motor`.
    %     sensor1 (Sensor): Motor-object interfacing port 1. See also :class:`Sensor`.
    %     sensor2 (Sensor): Motor-object interfacing port 2. See also :class:`Sensor`.
    %     sensor3 (Sensor): Motor-object interfacing port 3. See also :class:`Sensor`.
    %     sensor4 (Sensor): Motor-object interfacing port 4. See also :class:`Sensor`.
    %     debug (numeric in {0,1,2}): Debug mode. *[WRITABLE]*
    %
    %         - 0: Debug turned off
    %         - 1: Debug turned on for EV3-object -> enables feedback in the console about what firmware-commands have been called when using a method
    %         - 2: Low-level-Debug turned on -> each packet sent and received is printed to the console
    %
    %     batteryMode (string in {'Percentage', 'Voltage'}): Mode for reading battery charge. See also :attr:`batteryValue`. *[WRITABLE]*
    %     batteryValue (numeric): Current battery charge. Depending on batteryMode, the reading is either in percentage or voltage. See also :attr:`batteryMode`. *[READ-ONLY]*
    %     stlReadFirst() (bool): True if virtual brick-object is connected to physical one. *[READ-ONLY]*
    %
    % ::
    %
    %     Example:
    %         # This example expects a motor at port A and a (random) sensor at port 1
    %          brick = EV3();
    %          brick.connect('usb');
    %          motorA = brick.motorA;
    %          motorA.setProperties('power', 50, 'limitValue', 720);
    %          motorA.start();
    %          motorA.waitFor();
    %          disp(brick.sensor1.value);
    %          brick.beep();
    %          delete brick;
    %
clc; clear; close all;
profile off;
% delete(gcp('nocreate'));
% parpool('local');
warning('off','MATLAB:polyshape:boolOperationFailed');
warning('off','MATLAB:polyshape:repairedBySimplify');
warning('off','MATLAB:polyshape:boundary3Points');
% profile on;


% [v, f, n, name] = stlReadFirst("Baumraum example complex.stl");
 % stlReadFirst EV3-object and its Motors and Sensors to physical brick.
            %
            % Arguments:
            %     connectionType (string in {'bt', 'usb'}): Connection type
            %     serPort (string in {'/dev/rfcomm1', '/dev/rfcomm2', ...}): Path to serial port
            %         (necessary if connectionType is 'bt'). *[OPTIONAL]*
            %     beep (bool): If true, EV3 beeps if connection has been established. *[OPTIONAL]*
            %
            %
            % ::
            %
            %     Example:
            %          % Setup bluetooth connection via com-port 0
            %          brick = EV3();
            %          brick.connect('bt', 'serPort', '/dev/rfcomm0');
            %          % Setup usb connection, beep when connection has been established
            %          brick = EV3();
            %          brick.connect('usb', 'beep', 'on', );
            %
            % See also ISCONNECTED / :attr:`isConnected`
% stlWrite('neubauraum.stl',f,v);
% stl_file = "neubauraum.stl";
stl_file = "Combined Shape.stl";
[F,V,N] = stlread(stl_file);
disp("Number of faces in stl-file: "+string(size(F,1)));
if size(F,1) <= 6088%280
    %%
    % Parameters which influence the approximation:
    % Parameters for create_sections_initial:
    number_of_sections = 10; % defines maximum thickness of every section
    % by setting thickness > (max(y)-min(y))/number_of_sections
    area_percentage_parallel = 0.05; % If a part of the goemetry with an
    % area of more than this value is parallel to the y-plane, then the
    % corresponding y-value will be included as a position for a cut.
    ends_offset_fraction = 0.2; % If there is no 2D-polygon at the ends of
    % the geometry, which is parallel to the y-plane, than the geometry is
    % cut at a certain offset. This offset is the maximum thickness delta
    % times this fraction.

    % Parameters for rewriteY_values:
    maximal_area_difference_ratio = 0.97; % If the ratio of intersection/union
    % of 2 polygons is smaller or equal to that value, than they are
    % regarded as very different and the corresponding cut remains.

    % Parameters for create_cylinders/create_circles:
    number_circles_per_section = 40; % maximum number of circles, that are
    % defined at every 2D-polygon
    red_radius_factor = 20; % Relative radius of red cylinders, which are
    % subtracted from the geometry. The higher, the more accurate in
    % theory, but there may be some numerical difficulties

    % Further parameters, that can be set in the functions:
    % -Some tolerances in create_sections_initial and define_2D_polygons
    % -accuracy_factor in remove_circles_proximity
    % -area criteria in remove_circles

    %%
    % Start of the actual approximation steps:
    % Initial slicing
    [mesh_list, y_values, F, V, N] = create_sections_initial(F,V,N,number_of_sections,area_percentage_parallel,ends_offset_fraction);

    [polygon_list, y_values] = define_2D_polygons(mesh_list, y_values);

    [new_y_values] = rewriteY_values(polygon_list, y_values, maximal_area_difference_ratio);

    % Adapted slicing
    [mesh_list, new_y_values] = create_sections(F,V,N,new_y_values);

    [polygon_list, new_y_values] = define_2D_polygons(mesh_list, new_y_values);

    [cylinders,cylinders_red] = create_cylinders(polygon_list, new_y_values, number_circles_per_section, red_radius_factor);
    plot_cylinders(cylinders,cylinders_red,new_y_values);
%     axis off
%     plot_STL(V,F,"none");
    axis equal;
    view([1 1 1]);
else
    disp("Too large 3D object, too many triangles");
end


% disp("Total number of green cylinders: "+string(length(cylinders{1,3})));
% disp("Total number of red   cylinders: "+string(length(cylinders_red{1,3})));
% profile off;
% profile viewer;

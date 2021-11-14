========
Examples
========

.. code-block:: matlab

	% This example expects a motor at port A and a (random) sensor at port 1 
	b = EV3(); 
	b.connect('usb'); 
	ma = b.motorA; 
	ma.setProperties('power', 50, 'limitValue', 720); 
	ma.start(); 
	% fun
	ma.waitFor(); 
	disp(b.sensor1.value); 
	b.beep(); 
	b.delete(); 

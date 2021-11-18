classdef Runge_Kutta_method
    %RUNGE_KUTTA_METHOD  Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
       Initial_Value;
        Delta_T;
        final_time;
    end
    
    methods
        function obj = Runge_Kutta_method (Initial_Value,Delta_T,final_time)
            %RUNGE_KUTTA_METHOD  Construct an instance of this class
            %   Detailed explanation goes here
            obj.Initial_Value = Initial_Value;
            obj.Delta_T = Delta_T;
            obj.final_time = final_time;
        end
        
        function y = ExplicitEuler(obj)
            global rhs_pdot;
            
            y = [];
            %Initialize the vectors
            y(1) = obj.Initial_Value;
            %Initialize Counter
            cnt = 1;
            %Start Solution Loop
            for time = 0.:obj.Delta_T:(obj.final_time-obj.Delta_T)
                  cnt = cnt + 1;
                  %Calculate next value of function
                   y(cnt) = y(cnt-1) + obj.Delta_T*rhs_pdot(y(cnt-1));
                  %Increment time
            end
        end
    end
    methods (Static)
        function y = ExplicitEulers(Initial_Value,Delta_T,final_time)
            for k = 1:length(Initial_Value)
                global rhs_pdot;
                
                y = [];
                %Initialize the vectors
                y(1) = Initial_Value(k);
                %Initialize Counter
                cnt = 1;
                %Start Solution Loop
                for time = 0.:Delta_T(k):(final_time-Delta_T(k))
                      cnt = cnt + 1;
                      %Calculate next value of function
                       y(cnt) = y(cnt-1) + Delta_T(k)*rhs_pdot(y(cnt-1));
                      %Increment time
                end
            end 

        end
    end
end


classdef CombustionChamber
    %OXIDIZERTANK This class handles hybrid rocket oxidizer tanks.
   
    properties
        n_ports
        port_initial_diameter
        grain_diameter
        grain_length
    end
    
    methods
        %setters to ensure proper type
        function obj=set.n_ports(obj,port_number)
            assert(strcmp(class(port_number),'double')==1 && mod(n_ports,1)==0, 'The number of ports must be an integer')
            obj.n_ports=port_number;
        end
        function obj=set.port_initial_diameter(obj,d_init)
            assert(strcmp(class(d_init),'double')==1, 'The initial port diameter must be a real number')
            obj.port_initial_diameter=d_init;
        end
        function obj=set.grain_diameter(obj,d_grain)
            assert(strcmp(class(d_grain),'double')==1, 'The grain diameter must be input as a real number')
            obj.grain_diameter=d_grain;
        end
        function obj=set.grain_length(obj,l_grain)
            assert(strcmp(class(l_grain),'double')==1, 'The grain length must be input as a real number')
            obj.grain_length=l_grain;
        end
    end
    
end
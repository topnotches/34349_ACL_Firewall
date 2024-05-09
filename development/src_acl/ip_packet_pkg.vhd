library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package data_if_pkg is
    type data_if is record
        x : std_logic_vector(NOC_ADDRESS_WIDTH - 1 downto 0);
        y : std_logic_vector(NOC_ADDRESS_WIDTH - 1 downto 0);
    end record;

    function init_data_if(x_val, y_val : natural) return data_if;

    function slv_to_data_if(slv : std_logic_vector) return data_if;

    function data_if_to_slv(d_if : data_if) return std_logic_vector;

end package data_if_pkg;

package body data_if_pkg is

    function init_data_if(x_val, y_val : natural) return data_if is
        variable init_data                 : data_if;
    begin
        init_data.x := std_logic_vector(to_unsigned(x_val, NOC_ADDRESS_WIDTH));
        init_data.y := std_logic_vector(to_unsigned(y_val, NOC_ADDRESS_WIDTH));
        return init_data;
    end function init_data_if;

    function slv_to_data_if(slv : std_logic_vector) return data_if is
        variable d_if               : data_if;
    begin
        d_if.x := slv(slv'left downto slv'left - d_if.x'length + 1);
        d_if.y := slv(slv'left - d_if.x'length downto 0);
        return d_if;
    end slv_to_data_if;

    function data_if_to_slv(d_if : data_if) return std_logic_vector is
        variable slv_result          : std_logic_vector(d_if.x'length + d_if.y'length - 1 downto 0);
    begin
        slv_result := d_if.x & d_if.y;
        return slv_result;
    end data_if_to_slv;

end package body data_if_pkg;
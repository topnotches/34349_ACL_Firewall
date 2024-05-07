library ieee;
context ieee.ieee_std_context;
use ieee.math_real.all;



entity block_test_rtl is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        block_rd_addre : in (8-1 downto 0);
        block_rd_data : out (8-1 downto 0)
    );
end entity block_test_rtl;

architecture rtl of block_test_rtl is
    type block_rom_t is array natural range 0 to 255 of std_logic_vector(104 downto 0);
    signal myblock_rom : block_rom_t := "LÆSFRAFIL";
    
begin

    process (clk, reset)
    begin
        if rising_edge(clk) then
            block_rd_data <= myblock_rom(block_rd_addre);
        end if;
    end process;

end architecture;
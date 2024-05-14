library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_arith.ALL;

entity fifo_tb is
end fifo_tb;

architecture Behavioral of fifo_tb is

    constant clk_period : time := 10 ns;
    constant RAM_width  : integer := 16;
    constant RAM_depth  : integer := 64;
       
    signal clk          : std_logic;
    signal reset        : std_logic;
        
    -- Write ports
    signal write_enable : std_logic;
    signal write_data   : std_logic_vector(RAM_width - 1 downto 0) := (others => '0');
        
    -- Read ports
    -- Read valid is asserted when there is data to be read in the buffer.
    signal read_enable  : std_logic;
    signal read_valid   : std_logic;
    signal read_data    : std_logic_vector(RAM_width - 1 downto 0) := (others => '0');
        
    -- Flags
    -- These are set when the buffer is empty, almost empty, full, almost full.
    signal empty        : std_logic;
    signal almost_empty : std_logic;
    signal full         : std_logic;
    signal almost_full  : std_logic;
    signal fill_count   : integer range RAM_DEPTH - 1 downto 0;

begin

    UUT : entity work.fifo(rtl)
    
    generic map(
        RAM_width       =>  RAM_width,
        RAM_depth       =>  RAM_depth
        )
 
    port map(
        
        clk             =>  clk,
        reset           =>  reset,
        
        write_enable    =>  write_enable,
        write_data      =>  write_data,
        
        read_enable     =>  read_enable,
        read_valid      =>  read_valid,
        read_data       =>  read_data,
        
        empty           => empty,
        almost_empty    => almost_empty,
        full            => full,
        almost_full     => almost_full,
        fill_count      => fill_count
        );


    -- Clock
    clk_process : process
        begin
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end process;
        
        
    -- Stimulus
    stimulus_process : process
    begin
    
    -- Reset the fifo by setting reset high for 1 clock cycle.
    reset <= '1';
    wait for clk_period;
    reset <= '0';
    wait for clk_period*3;
    
    -- Write 10 values to the fifo.
    write_enable <= '1';
    read_enable <= '0';
    for i in 1 to 10 loop
        write_data <= conv_std_logic_vector(i, RAM_width);
        wait for clk_period;
    end loop;
    
    -- Read 5 values from the fifo by setting read_enable high and cycling the clock 5 times.
    write_enable <= '0';
    read_enable <= '1';
    wait for clk_period*5;
    
    -- Read and write for 5 clock cycles.
    write_enable <= '1';
    read_enable <= '1';
    wait for clk_period*5;
    
    -- Stop writing and reading.
    write_enable <= '0';
    read_enable <= '0';
    
    -- Wait statement to suspend the process.
    wait;
    end process;

end Behavioral;

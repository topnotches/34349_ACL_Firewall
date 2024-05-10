
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity buffer is
    -- RAM width is the number of bits in each memory slot.
    -- RAM depth is the length of the buffer.
    -- One slot is reserved for indicating if the buffer is full so
    -- the capacity of the buffer is RAM_depth - 1.
    Generic (
        RAM_width   : natural;
        RAM_depth   : natural
        );
       
    Port (
        clk         : in std_logic;
        reset       : in std_logic
        
        -- Write ports
        write_enable: in std_logic;
        write_data  : in std_logic_vector(RAM_width - 1 downto 0);
        
        -- Read ports
        -- Read valid is asserted when there is data to be read in the buffer.
        read_enable : in std_logic;
        read_valid  : out std_logic;
        read_data   : out std_logic_vector(RAM_width - 1 downto 0);
        
        -- Flags
        -- These are set when the buffer is empty, almost empty, full, almost full.
        empty       : out std_logic;
        almost_empty: out std_logic;
        full        : out std_logic;
        almost_full : out std_logic
         );
end buffer;

architecture rtl of buffer is
    -- Declarative region
    
    -- This is the RAM.
    type ram_type is array(0 to RAM_depth - 1) of std_logic_vector(write_data'range);
    signal ram      : ram_type;
    
    -- Here we have the internal flags and the counter signals.
    subtype index_type is integer range RAM_depth downto 0;
    signal head     : index_type;
    signal tail     : index_type;
    
    signal empty_int: std_logic;
    signal full_int : std_logic;
    
    -- fill_count_int is used internally to keep tabs on how many elements
    -- there are in the FIFO.
    signal fill_count_int : integer range RAM_DEPTH - 1 downto 0;
    
    -- This is a procedure for adding one to the index and
    -- wrapping around when it reaches the end.
    procedure increment(signal index : inout index_type) is
    begin
        -- This is the wrap around.
        if index = index_type'high then
            index <= index_type'low;
        -- And here we increment.
        else
            index <= index + 1;
        end if;
    end procedure;

begin  
    
    -- Concurrent statements.
    -- Copy internal signals to output
    empty <= empty_int;
    full <= full_int;
    fill_count <= fill_count_int;
 
    -- Set the flags
    empty_int <= '1' when fill_count_int = 0 else '0';
    almost_empty <= '1' when fill_count_int <= 1 else '0';
    full_int <= '1' when fill_count_int >= RAM_DEPTH - 1 else '0';
    almost_full <= '1' when fill_count_int >= RAM_DEPTH - 2 else '0';
    
    -- Update the head pointer.
    head_process    : process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                head <= '0';
            else
                if write_enable = '1' then and full_int = '0' then
                    increment(head);
                end if;
            end if;
        end if;
    end process;

    -- Update the tail pointer.
    tail_process    : process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                tail <= '0';
                read_valid <= '0';
            else
                read_valid <= '0';
            
                if read_enable = '1' and empty_int = '0' then
                    increment(tail);
                    read_valid <= '1';
                end if;
                
            end if;
       end if;
    end process;   
    
    -- Write to and read from the RAM.
    RAM_process     : process(clk)
    begin
        if rising_edge(clk) then
            ram(head) <= write_data;
            read_data <= ram(tail);
        end if;
    end process;
    
    -- Update the fill count.
    count_process : process(head, tail)
    begin
        if head < tail then
            fill_count_int <= head - tail + RAM_depth;
        else
            fill_count_int <= head - tail;
        end if;
  end process;
    
end rtl;

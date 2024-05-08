library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.acl_defs_pkg.all;

entity hash_table_rtl is
  port
  (
    pil_clk : in std_logic;
    pil_rst : in std_logic;

    pilv8_hash_table_rd_addr : in std_logic_vector(ACL_HASH_LENGTH - 1 downto 0);

    pilv8_hash_table_we_addr : in std_logic_vector(ACL_HASH_LENGTH - 1 downto 0);
    pil_hash_wr_en           : in std_logic;

    pilv128_hash_wr_value : std_logic_vector(ACL_HASH_TABLE_ADDRESS_LENGTH - 1 downto 0);
    polv128_hash_rd_value : std_logic_vector(ACL_HASH_TABLE_ADDRESS_LENGTH - 1 downto 0)
  );
end entity hash_table_rtl;

architecture rtl of hash_table_rtl is
  type hash_table_memory_t is array integer (0 to ((2 ** ACL_HASH_LENGTH) - 1)) of std_logic_vector(ACL_HASH_TABLE_M9K_LENGTH - 1 downto 0);
  signal sarr256lv32_hash_table_memory_3 : hash_table_memory_t                         := (others => (others => '0')); -- MSW
  signal sarr256lv32_hash_table_memory_2 : hash_table_memory_t                         := (others => (others => '0')); -- AMSW
  signal sarr256lv32_hash_table_memory_1 : hash_table_memory_t                         := (others => (others => '0')); -- ALSW
  signal sarr256lv32_hash_table_memory_0 : hash_table_memory_t                         := (others => (others => '0')); -- LSW
  signal slv32_hash_table_rd_data_3      : std_logic_vector(ACL_HASH_TABLE_M9K_LENGTH) := (others => '0');
  signal slv32_hash_table_rd_data_2      : std_logic_vector(ACL_HASH_TABLE_M9K_LENGTH) := (others => '0');
  signal slv32_hash_table_rd_data_1      : std_logic_vector(ACL_HASH_TABLE_M9K_LENGTH) := (others => '0');
  signal slv32_hash_table_rd_data_0      : std_logic_vector(ACL_HASH_TABLE_M9K_LENGTH) := (others => '0');

  signal slv32_hash_table_wr_data_3 : std_logic_vector(ACL_HASH_TABLE_M9K_LENGTH) := (others => '0');
  signal slv32_hash_table_wr_data_2 : std_logic_vector(ACL_HASH_TABLE_M9K_LENGTH) := (others => '0');
  signal slv32_hash_table_wr_data_1 : std_logic_vector(ACL_HASH_TABLE_M9K_LENGTH) := (others => '0');
  signal slv32_hash_table_wr_data_0 : std_logic_vector(ACL_HASH_TABLE_M9K_LENGTH) := (others => '0');
begin
  slv32_hash_table_wr_data_3 <= pilv128_hash_wr_value(ACL_HASH_TABLE_M9K_LENGTH * 4 - 1 downto ACL_HASH_TABLE_M9K_LENGTH * 3);
  slv32_hash_table_wr_data_2 <= pilv128_hash_wr_value(ACL_HASH_TABLE_M9K_LENGTH * 3 - 1 downto ACL_HASH_TABLE_M9K_LENGTH * 2);
  slv32_hash_table_wr_data_1 <= pilv128_hash_wr_value(ACL_HASH_TABLE_M9K_LENGTH * 2 - 1 downto ACL_HASH_TABLE_M9K_LENGTH * 1);
  slv32_hash_table_wr_data_0 <= pilv128_hash_wr_value(ACL_HASH_TABLE_M9K_LENGTH * 1 - 1 downto 0);

  polv128_hash_value <= slv32_hash_table_rd_data_3 &
    slv32_hash_table_rd_data_2 &
    slv32_hash_table_rd_data_1 &
    slv32_hash_table_rd_data_0;

  process (pil_clk, pil_hash_wr_en)
  begin
    if rising_edge(pil_clk) then
      if (pil_hash_wr_en = '1') then

        sarr256lv128_hash_table_memory_3(to_integer(unsigned(pilv8_hash_table_wr_addr))) <= slv32_hash_table_wr_data_3;
        sarr256lv128_hash_table_memory_2(to_integer(unsigned(pilv8_hash_table_wr_addr))) <= slv32_hash_table_wr_data_2;
        sarr256lv128_hash_table_memory_1(to_integer(unsigned(pilv8_hash_table_wr_addr))) <= slv32_hash_table_wr_data_1;
        sarr256lv128_hash_table_memory_0(to_integer(unsigned(pilv8_hash_table_wr_addr))) <= slv32_hash_table_wr_data_0;

      end if;
      slv32_hash_table_rd_data_3 <= sarr256lv128_hash_table_memory_3(to_integer(unsigned(pilv8_hash_table_rd_addr)));
      slv32_hash_table_rd_data_2 <= sarr256lv128_hash_table_memory_2(to_integer(unsigned(pilv8_hash_table_rd_addr)));
      slv32_hash_table_rd_data_1 <= sarr256lv128_hash_table_memory_1(to_integer(unsigned(pilv8_hash_table_rd_addr)));
      slv32_hash_table_rd_data_0 <= sarr256lv128_hash_table_memory_0(to_integer(unsigned(pilv8_hash_table_rd_addr)));
    end if;
  end process;
end architecture;
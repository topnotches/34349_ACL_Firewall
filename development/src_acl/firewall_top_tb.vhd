library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity firewall_top_tb is

end entity firewall_top_tb;

architecture rtl of firewall_top_tb is
  signal sl_clk        : std_logic                    := '0';
  signal sl_rst        : std_logic                    := '1';
  signal slv8_gmii_rxd : std_logic_vector(7 downto 0) := (others => '0');
  signal sl_gmii_rx_en : std_logic                    := '0';
  signal slv8_gmii_txd : std_logic_vector(7 downto 0) := (others => '0');
  signal sl_gmii_tx_en : std_logic                    := '0';
  signal si_counter    : natural range 0 to 1023      := 0;

  function <name> (<params>) return <type> is
  begin
    
  end function;
begin

  UUT_FIREWALL_TOP : entity work.firewall_top_rtl(rtl)
    port map
    (
      pil_clk => sl_clk,
      pil_rst => sl_rst,
      -- stats

      -- GMII in
      pilv8_gmii_rxd => slv8_gmii_rxd,
      pil_gmii_rx_en => sl_gmii_rx_en,
      -- GMII out
      polv8_gmii_txd => slv8_gmii_txd,
      pol_gmii_tx_en => sl_gmii_tx_en
    );

  process (sl_clk)
  begin
    if rising_edge(sl_clk) then
      if (sl_rst = '1') then
        sl_clk        <= '0';
        sl_rst        <= '1';
        slv8_gmii_rxd <= (others => '0');
        sl_gmii_rx_en <= '0';
        slv8_gmii_txd <= (others => '0');
        sl_gmii_tx_en <= '0';
        si_counter    <= 0;
      else

        si_counter <= si_counter + 1;

      end if;
    end if;
  end process;
  sl_clk <= not sl_clk after 1 ns;
  sl_rst <= '0' after 50 ns;
end architecture;
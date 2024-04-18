library IEEE;
use IEEE.std_logic_1164.all;

entity gmii_if is
  -- Define the record type for GMII interface
  type gmii_if is record
    -- Clock signal
    clk : in std_logic;

    -- Reset signal
    rst : in std_logic;

    -- Transmit Enable
    tx_en : out std_logic;

    -- Transmit Data
    tx_data : out std_logic_vector(7 downto 0);

    -- Transmit Data Valid
    tx_valid : out std_logic;

    -- Receive Data
    rx_data : in std_logic_vector(7 downto 0);

    -- Receive Data Valid
    rx_valid : in std_logic;

    -- Receive Error
    rx_error : in std_logic;

    -- Collision Detected
    collision : in std_logic;

  end record gmii_if;
end entity gmii_if;

architecture Behavioral of GMII_if is
begin
  -- No behavior defined here as it's just a record definition
end architecture Behavioral;
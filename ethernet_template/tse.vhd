-- megafunction wizard: %Triple Speed Ethernet v10.1%
-- GENERATION: XML

-- ============================================================
-- Megafunction Name(s):
-- 			altera_tse_pcs_pma
-- ============================================================
-- Generated by Triple Speed Ethernet 10.1 [Altera, IP Toolbench 1.3.0 Build 197]
-- ************************************************************
-- THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
-- ************************************************************
-- Copyright (C) 1991-2011 Altera Corporation
-- Any megafunction design, and related net list (encrypted or decrypted),
-- support information, device programming or simulation file, and any other
-- associated documentation or information provided by Altera or a partner
-- under Altera's Megafunction Partnership Program may be used only to
-- program PLD devices (but not masked PLD devices) from Altera.  Any other
-- use of such megafunction design, net list, support information, device
-- programming or simulation file, or any other related documentation or
-- information is prohibited for any other purpose, including, but not
-- limited to modification, reverse engineering, de-compiling, or use with
-- any other silicon devices, unless such use is explicitly licensed under
-- a separate agreement with Altera or a megafunction partner.  Title to
-- the intellectual property, including patents, copyrights, trademarks,
-- trade secrets, or maskworks, embodied in any such megafunction design,
-- net list, support information, device programming or simulation file, or
-- any other related documentation or information provided by Altera or a
-- megafunction partner, remains with Altera, the megafunction partner, or
-- their respective licensors.  No other licenses, including any licenses
-- needed under any third party's intellectual property, are provided herein.

library IEEE;
use IEEE.std_logic_1164.all;

ENTITY tse IS
	PORT (
		gmii_rx_d	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		gmii_rx_dv	: OUT STD_LOGIC;
		gmii_rx_err	: OUT STD_LOGIC;
		tx_clk	: OUT STD_LOGIC;
		rx_clk	: OUT STD_LOGIC;
		led_an	: OUT STD_LOGIC;
		led_disp_err	: OUT STD_LOGIC;
		led_char_err	: OUT STD_LOGIC;
		led_link	: OUT STD_LOGIC;
		rx_recovclkout	: OUT STD_LOGIC;
		readdata	: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		waitrequest	: OUT STD_LOGIC;
		txp	: OUT STD_LOGIC;
		gmii_tx_d	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		gmii_tx_en	: IN STD_LOGIC;
		gmii_tx_err	: IN STD_LOGIC;
		reset_tx_clk	: IN STD_LOGIC;
		reset_rx_clk	: IN STD_LOGIC;
		address	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		read	: IN STD_LOGIC;
		writedata	: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		write	: IN STD_LOGIC;
		clk	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		rxp	: IN STD_LOGIC;
		ref_clk	: IN STD_LOGIC
	);
END tse;

ARCHITECTURE SYN OF tse IS


	COMPONENT altera_tse_pcs_pma
	GENERIC (
		PHY_IDENTIFIER	: STD_LOGIC_VECTOR := X"00000000";
		DEV_VERSION	: STD_LOGIC_VECTOR := X"0a01";
		ENABLE_SGMII	: NATURAL;
		SYNCHRONIZER_DEPTH	: NATURAL;
		DEVICE_FAMILY	: STRING;
		EXPORT_PWRDN	: NATURAL;
		TRANSCEIVER_OPTION	: NATURAL;
		ENABLE_ALT_RECONFIG	: NATURAL
	);
	PORT (
		gmii_rx_d	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		gmii_rx_dv	: OUT STD_LOGIC;
		gmii_rx_err	: OUT STD_LOGIC;
		tx_clk	: OUT STD_LOGIC;
		rx_clk	: OUT STD_LOGIC;
		led_an	: OUT STD_LOGIC;
		led_disp_err	: OUT STD_LOGIC;
		led_char_err	: OUT STD_LOGIC;
		led_link	: OUT STD_LOGIC;
		rx_recovclkout	: OUT STD_LOGIC;
		readdata	: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		waitrequest	: OUT STD_LOGIC;
		txp	: OUT STD_LOGIC;
		gmii_tx_d	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		gmii_tx_en	: IN STD_LOGIC;
		gmii_tx_err	: IN STD_LOGIC;
		reset_tx_clk	: IN STD_LOGIC;
		reset_rx_clk	: IN STD_LOGIC;
		address	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		read	: IN STD_LOGIC;
		writedata	: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		write	: IN STD_LOGIC;
		clk	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		rxp	: IN STD_LOGIC;
		ref_clk	: IN STD_LOGIC
	);

	END COMPONENT;

BEGIN

	altera_tse_pcs_pma_inst : altera_tse_pcs_pma
	GENERIC MAP (
		PHY_IDENTIFIER => X"00000000",
		DEV_VERSION => X"0a01",
		ENABLE_SGMII => 0,
		SYNCHRONIZER_DEPTH => 4,
		DEVICE_FAMILY => "STRATIXIV",
		EXPORT_PWRDN => 0,
		TRANSCEIVER_OPTION => 1,
		ENABLE_ALT_RECONFIG => 0
	)
	PORT MAP (
		gmii_rx_d  =>  gmii_rx_d,
		gmii_rx_dv  =>  gmii_rx_dv,
		gmii_rx_err  =>  gmii_rx_err,
		gmii_tx_d  =>  gmii_tx_d,
		gmii_tx_en  =>  gmii_tx_en,
		gmii_tx_err  =>  gmii_tx_err,
		tx_clk  =>  tx_clk,
		rx_clk  =>  rx_clk,
		reset_tx_clk  =>  reset_tx_clk,
		reset_rx_clk  =>  reset_rx_clk,
		led_an  =>  led_an,
		led_disp_err  =>  led_disp_err,
		led_char_err  =>  led_char_err,
		led_link  =>  led_link,
		rx_recovclkout  =>  rx_recovclkout,
		address  =>  address,
		readdata  =>  readdata,
		read  =>  read,
		writedata  =>  writedata,
		write  =>  write,
		waitrequest  =>  waitrequest,
		clk  =>  clk,
		reset  =>  reset,
		txp  =>  txp,
		rxp  =>  rxp,
		ref_clk  =>  ref_clk
	);


END SYN;


-- =========================================================
-- Triple Speed Ethernet Wizard Data
-- ===============================
-- DO NOT EDIT FOLLOWING DATA
-- @Altera, IP Toolbench@
-- Warning: If you modify this section, Triple Speed Ethernet Wizard may not be able to reproduce your chosen configuration.
-- 
-- Retrieval info: <?xml version="1.0"?>
-- Retrieval info: <MEGACORE title="Triple Speed Ethernet MegaCore Function"  version="10.1"  build="197"  iptb_version="1.3.0 Build 197"  format_version="120" >
-- Retrieval info:  <NETLIST_SECTION class="altera.ipbu.flowbase.netlist.model.TSEMVCModel"  active_core="altera_tse_pcs_pma" >
-- Retrieval info:   <STATIC_SECTION>
-- Retrieval info:    <PRIVATES>
-- Retrieval info:     <NAMESPACE name = "parameterization">
-- Retrieval info:      <PRIVATE name = "atlanticSinkClockRate" value="0"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "atlanticSinkClockSource" value="unassigned"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "atlanticSourceClockRate" value="0"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "atlanticSourceClockSource" value="unassigned"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "avalonSlaveClockRate" value="0"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "avalonSlaveClockSource" value="unassigned"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "avalonStNeighbours" value="unassigned=unassigned"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "channel_count" value="1"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "core_variation" value="PCS_ONLY"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "core_version" value="2561"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "crc32dwidth" value="8"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "crc32gendelay" value="6"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "crc32s1l2_extern" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "cust_version" value="0"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "dataBitsPerSymbol" value="8"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "dev_version" value="2561"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "deviceFamily" value="STRATIXIV"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "deviceFamilyName" value="Stratix IV"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "eg_addr" value="11"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "eg_fifo" value="2048"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "ena_hash" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_alt_reconfig" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_clk_sharing" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_ena" value="8"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_fifoless" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_gmii_loopback" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_hd_logic" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_mac_flow_ctrl" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_mac_txaddr_set" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_mac_vlan" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_maclite" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_magic_detect" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_multi_channel" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_pkt_class" value="1"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_pma" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_reg_sharing" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_sgmii" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_shift16" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_sup_addr" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enable_use_internal_fifo" value="1"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "export_calblkclk" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "export_pwrdn" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "ext_stat_cnt_ena" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "gigeAdvanceMode" value="1"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "ifGMII" value="MII_GMII"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "ifPCSuseEmbeddedSerdes" value="1"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "ing_addr" value="11"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "ing_fifo" value="2048"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "insert_ta" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "maclite_gige" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "max_channels" value="1"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "mdio_clk_div" value="40"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "phy_identifier" value="0"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "ramType" value="AUTO"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "sopcSystemTopLevelName" value="system"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "starting_channel_number" value="0"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "stat_cnt_ena" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "timingAdapterName" value="timingAdapter"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "toolContext" value="STANDALONE"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "transceiver_type" value="LVDS_IO"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "uiEgFIFOSize" value="2048 x 8 Bits"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "uiHostClockFrequency" value="0"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "uiIngFIFOSize" value="2048 x 8 Bits"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "uiMACFIFO" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "uiMACOptions" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "uiMDIOFreq" value="0.0 MHz"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "uiMIIInterfaceOptions" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "uiPCSInterface" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "uiPCSInterfaceOptions" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "useLvds" value="1"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "useMAC" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "useMDIO" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "usePCS" value="1"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "use_sync_reset" value="1"  type="BOOLEAN"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "simgen_enable">
-- Retrieval info:      <PRIVATE name = "language" value="VHDL"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enabled" value="0"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "gb_enabled" value="0"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "testbench">
-- Retrieval info:      <PRIVATE name = "variation_name" value="tse"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "project_name" value="system"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "output_name" value="tse"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "tool_context" value="STANDALONE"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "constraint_file_generator">
-- Retrieval info:      <PRIVATE name = "variation_name" value="tse"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "instance_name" value="tse"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "output_name" value="tse"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "modelsim_script_generator">
-- Retrieval info:      <PRIVATE name = "variation_name" value="tse"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "instance_name" value="tse"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "plugin_worker" value="1"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "europa_executor">
-- Retrieval info:      <PRIVATE name = "plugin_worker" value="0"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "simgen">
-- Retrieval info:      <PRIVATE name = "use_alt_top" value="0"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "filename" value="tse.vho"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "modelsim_wave_script_plugin">
-- Retrieval info:      <PRIVATE name = "plugin_worker" value="1"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "output_name" value="tse"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "nativelink">
-- Retrieval info:      <PRIVATE name = "plugin_worker" value="1"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "language" value="VHDL"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "output_name" value="tse"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "variation_name" value="tse"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "top_level_name" value="tse"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "greybox">
-- Retrieval info:      <PRIVATE name = "filename" value="tse_syn.v"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "serializer"/>
-- Retrieval info:    </PRIVATES>
-- Retrieval info:    <FILES/>
-- Retrieval info:    <PORTS/>
-- Retrieval info:    <LIBRARIES/>
-- Retrieval info:   </STATIC_SECTION>
-- Retrieval info:  </NETLIST_SECTION>
-- Retrieval info: </MEGACORE>
-- =========================================================

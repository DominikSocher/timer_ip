-----------------------------------------------------------------------------
--Company: TEIS
--Engineer: Dominik Socher
--Created Date: Monday, February 15th 2021
-----------------------------------------------------------------------------
--File: c:\Users\Dominik\Documents\TEIS\HW_SW_Kurs\Case_3\TIMER_HW_IP.vhd
--Project: c:\Users\Dominik\Documents\TEIS\HW_SW_Kurs\Case_3
--Target Device: 10M50DAF484C7G
--Tool version: Quartus 18.1 and ModelSim 10.5b
--Testbench file:
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--Copyright (c) 2021 TEIS
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--HISTORY:
--Date          By     Comments
------------    ---    ------------------------------------------------------
--
-----------------------------------------------------------------------------
--Description:
--        top nivau of hardware timer consists of
--          -hardware function
--          -bus interface to comunicate with avalon bus
--        
-----------------------------------------------------------------------------
--  
-----------------------------------------------------------------------------
--verified with the DE10-Lite board 
-----------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

--Bus interface
ENTITY TIMER_HW_IP IS
    PORT (
        reset_n : IN std_logic;                       -- reset active low
        clk     : IN std_logic;                       -- system clock
        cs_n    : IN std_logic;                       -- chip select active low
        addr    : IN std_logic_vector (1 DOWNTO 0);   -- Address bus
        wirte_n : IN std_logic;                       -- Write enabel active low
        read_n  : IN std_logic;                       -- Read enabel active low
        din     : IN std_logic_vector (31 DOWNTO 0);  -- data bus in
        dout    : OUT std_logic_vector (31 DOWNTO 0); -- data bus out
        ledr    : OUT std_logic_vector (7 DOWNTO 0)   -- control leds
    );
END ENTITY;

ARCHITECTURE timer_rtl OF TIMER_HW_IP IS

--============================================================================
--              REGISTER
--============================================================================
SIGNAL data_reg_s    : std_logic_vector (31 DOWNTO 0); -- Data register 32 bit
SIGNAL control_reg_s : std_logic_vector (1 DOWNTO 0);  -- Control register 2 bit
--===========================================================================
--              HARDWARE FUNCTION
--===========================================================================
    COMPONENT timer_top
        PORT (
            clk           : IN std_logic;                         -- system clock
            reset_n       : IN std_logic;                         -- reset active low
            control_timer : IN std_logic_vector (1 DOWNTO 0);     -- control register timer
            timer_data    : INOUT std_logic_vector (31 DOWNTO 0)  -- timer data output
        );
    END COMPONENT;

BEGIN

--===========================================================================
--              BUS INTERFACE PROTOCOL
--===========================================================================
    bus_register_write_process : PROCESS (clk, reset_n) 
    BEGIN
        IF reset_n = '0' THEN
            control_reg_s <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN 
            IF cs_n = '0' AND wirte_n = '0' AND addr = "01" THEN   
                --CPU wirtes to control register
                control_reg_s (1 DOWNTO 0) <= din(31 DOWNTO 30);
            ELSE
                NULL;
            END IF;
        END IF;
    END PROCESS bus_register_write_process;

    bus_register_read_process : PROCESS (cs_n, read_n, addr)
    BEGIN
        IF cs_n = '0' AND read_n = '0' AND  addr = "00" THEN
            -- timer read
            dout <= data_reg_s;
        ELSE
            dout <= (OTHERS => 'X');
        END IF;
    END PROCESS bus_register_read_process;
--===========================================================================
--              INSTANCIATE HARDWARE FUNCTION
--===========================================================================
    timer_function : timer_top
    PORT MAP (
        clk           => clk,           -- system clock
        reset_n       => reset_n,       -- reset active low
        control_timer => control_reg_s, -- control register timer
        timer_data    => data_reg_s     -- timer data output
    );
--===========================================================================
--              OUTPUT DRIVER
--===========================================================================
    ledr <= data_reg_s (31 DOWNTO 24);

END timer_rtl;
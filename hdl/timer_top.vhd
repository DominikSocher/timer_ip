-----------------------------------------------------------------------------
--Company: TEIS
--Engineer: Dominik Socher
--Created Date: Monday, February 15th 2021
-----------------------------------------------------------------------------
--File: c:\Users\Dominik\Documents\TEIS\HW_SW_Kurs\Case_3\timer_top.vhd
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
--        Hardware timer function
--         control register =
--                          00 timer stop
--                          01 timer reset
--                          10 timer start
-----------------------------------------------------------------------------
--  
-----------------------------------------------------------------------------
--verified with the DE10-Lite board 
-----------------------------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY timer_top IS
    PORT (
        clk           : IN std_logic;                         -- system clock
        reset_n       : IN std_logic;                         -- reset active low
        control_timer : IN std_logic_vector (1 DOWNTO 0);     -- control register timer
        timer_data    : INOUT std_logic_vector (31 DOWNTO 0)  -- timer data output
    );
END timer_top;

ARCHITECTURE timer_top_rtl OF timer_top IS

BEGIN

--===========================================================================
--              HARDWARE FUNCTION
--===========================================================================
    hw_function_process : PROCESS (clk, reset_n) 
    BEGIN
        IF reset_n = '0' THEN
            timer_data <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            CASE control_timer IS
                WHEN "10" =>
                    --timer start
                    timer_data <= timer_data + 1;
                WHEN "00" =>
                    --timer stop
                    timer_data <= timer_data;
                WHEN "01" =>
                    --timer reset
                    timer_data <= (OTHERS => '0');
                WHEN OTHERS =>
                    NULL;
            END CASE;
        END IF;
    END PROCESS hw_function_process;
END timer_top_rtl;
	component fp_add is
		port (
			aclr   : in  std_logic                     := 'X';             -- aclr
			ax     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- ax
			ay     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- ay
			clk    : in  std_logic                     := 'X';             -- clk
			ena    : in  std_logic                     := 'X';             -- ena
			result : out std_logic_vector(31 downto 0)                     -- result
		);
	end component fp_add;

	u0 : component fp_add
		port map (
			aclr   => CONNECTED_TO_aclr,   --   aclr.aclr
			ax     => CONNECTED_TO_ax,     --     ax.ax
			ay     => CONNECTED_TO_ay,     --     ay.ay
			clk    => CONNECTED_TO_clk,    --    clk.clk
			ena    => CONNECTED_TO_ena,    --    ena.ena
			result => CONNECTED_TO_result  -- result.result
		);


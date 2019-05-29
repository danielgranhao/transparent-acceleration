	component fp_mult is
		port (
			aclr   : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- aclr
			ay     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- ay
			az     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- az
			result : out std_logic_vector(31 downto 0)                     -- result
		);
	end component fp_mult;

	u0 : component fp_mult
		port map (
			aclr   => CONNECTED_TO_aclr,   --   aclr.aclr
			ay     => CONNECTED_TO_ay,     --     ay.ay
			az     => CONNECTED_TO_az,     --     az.az
			result => CONNECTED_TO_result  -- result.result
		);


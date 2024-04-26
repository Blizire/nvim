return {

  -- may have to remove this, if it interferes with the the other
  -- plugins that rely on luasnip as a dep.

	"L3MON4D3/LuaSnip",
	-- follow latest release.
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  dependencies = {
    { "rafamadriz/friendly-snippets" },
  },
}

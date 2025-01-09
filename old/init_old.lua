local o = vim.opt

vim.o.title = true

vim.o.titlestring = "Neovim"

o.number = true

vim.g.terminal_emulator='powershell'

vim.opt.shell = "powershell.exe"

vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"

vim.o.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"

vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"

vim.o.shellquote = ""

vim.o.shellxquote = ""


	local config_path = vim.fn.stdpath('config')
	vim.notify(config_path, vim.log.levels.INFO)


	-- Function to switch to German language
		local function switch_to_german()
		    os.execute(config_path .. "\\SetLanguageGerman.exe")
		   --	    vim.notify("Switched to German layout", vim.log.levels.INFO)
		end
	  
        -- Function to switch to English language
	  local function switch_to_english()
	    os.execute(config_path .. "\\SetLanguageEnglish.exe")
	    vim.notify("Switched to English layout", vim.log.levels.INFO)
	  end

	local function on_focus_lost()
 	    --vim.notify("Neovim has lost focus!", vim.log.levels.WARN)
	    switch_to_german()
        end


	local function on_focus_gained()
	    --vim.notify("Neovim has gained focus!", vim.log.levels.INFO)
	    local mode = vim.api.nvim_get_mode().mode

	    --vim.notify("pring op.mode" .. dump( mode ), vim.log.levels.INFO)
            if mode:match("[nv]") then 
	    	switch_to_english()
	    end
	
        end

	
       --local function on_terminal_focused()
	  --  print("Terminal Focused")
	  --  on_focus_lost()
	--end

	--local function on_terminal_unfocused()
	  --  print("Terminal Unfocused")
	  -- on_focus_gained()
	--end

--	vim.api.nvim_create_autocmd("TermEnter", {
--	    callback = on_terminal_focused,
--	})

--	vim.api.nvim_create_autocmd("TermLeave", {
--	    callback = on_terminal_unfocused,
--	})

 
	vim.api.nvim_create_autocmd("ModeChanged", {
	    pattern = "*",
	    callback = function(args)

  
	      vim.notify("ModeChanged event triggered", vim.log.levels.DEBUG)
      
	      local old_mode , new_mode = args.match:match("^(%w+):(%w+)$")
	      
	     -- vim.notify("Args: " ..  dump(args), vim.log.levels.DEBUG)
	     -- vim.notify("match: " ..  tostring(args.match), vim.log.levels.DEBUG)
	     vim.notify("Old Mode: " .. tostring(old_mode), vim.log.levels.DEBUG)
	     vim.notify("New Mode: " .. tostring(new_mode), vim.log.levels.DEBUG)
	  
	      if not old_mode or not new_mode then
	       -- vim.notify("old_mode or new_mode is nil", vim.log.levels.WARN)
		return
	      end
		
	      if new_mode:match("^[vn]") and not old_mode:match("^[vn]") then
	       -- vim.notify("Entering Visual/Select mode", vim.log.levels.INFO)
		switch_to_english()
	      end

	  
	      if old_mode:match("^[vn]") and not new_mode:match("^[vn]") then
	       -- vim.notify("Leaving Insert mode", vim.log.levels.INFO)
		switch_to_german()
	      end
	    end,
	  })
  

	vim.api.nvim_create_autocmd("FocusGained", {
	    callback = on_focus_gained,
	})

	vim.api.nvim_create_autocmd("FocusLost", {
	    callback = on_focus_lost,
	})




	-- **New Autocmds**

	-- 1. Switch to English when Neovim starts
	vim.api.nvim_create_autocmd("VimEnter", {
	    pattern = "*" ,
	    callback = function()
	       -- vim.notify("Neovim started, switching to English layout", vim.log.levels.INFO)
		switch_to_english()
	    end,
	})

	-- 2. Switch to German when Neovim is about to exit
	vim.api.nvim_create_autocmd("VimLeavePre", {
	    pattern = "*",
	    callback = function()
	       -- vim.notify("Neovim exiting, switching to German layout", vim.log.levels.INFO)
		switch_to_german()
	    end,
	})





	  function dump(o)
	    if type(o) == 'table' then
	       local s = '{ '
	       for k,v in pairs(o) do
		  if type(k) ~= 'number' then k = '"'..k..'"' end
		  s = s .. '['..k..'] = ' .. dump(v) .. ','
	       end
	       return s .. '} '
	    else
	       return tostring(o)
	    end
	 end



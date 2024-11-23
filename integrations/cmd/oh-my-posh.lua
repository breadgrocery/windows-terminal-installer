load(io.popen('oh-my-posh init cmd --config "' .. os.getenv("POSH_THEMES_PATH") .. '/montys.omp.json"'):read("*a"))()

# ===========================================================
# INSTRUÇÕES
# ===========================================================
# no PS ADMNISTRADOR digite e excute os comandos: 
# Get-ExecutionPolicy 
# Verifique a política atual se NÃO for restricted, ok, se for restrita então
# Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
# Mudará a política para: 'RemoteSigned:' permite scripts locais e scripts da internet apenas se assinados por um editor confiável e '-Scope CurrentUser:' aplica apenas ao seu usuário, sem precisar de permissão de administrador para todo o sistema
# code $PROFILE  
# mude o usuário da função código 'function code {' conforme instruções da última função ao final do código 
# copie e cole todos os códigos deste arquivo
# ao salvar o arquivo, selecione 'salvar como', no 'tipo' selecione 'Todo tipo de arquivo' e nome do arquivo 'Microsoft.PowerShell_profile.ps1' e no campo "Codificação" selecione "UTF-8 com BOM"
# no PS digite . $PROFILE 
# teste digitando z+space+tab
# aparecerá menu de "snippets"
# se der erro de $PROFILE, faça os 4 passos abaixo:
# 1) No PowerShell, digite: Rename-Item -Path "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -NewName "Microsoft.VSCode_profile.ps1"
# 2) No PowerShell, digite: $PROFILE 
# 3) No PowerShell, recarregue: . $PROFILE
# 4) teste digitando z+space+tab, aparecerá menu de "snippets"

function z {
    param(
        [string]$comando
    )

    switch ($comando) {	

# ===========================================================
# NAVEGAÇÃO POWER SHELL
# ===========================================================
		"nav_buscar_por_nome" { Get-ChildItem -Filter "*documen*" -File -Recurse }
		"nav_desktop" { Set-Location ~/Desktop }
		"nav_downloads" { Set-Location ~/Downloads }		
		"nav_home" { Set-Location ~ }
		"nav_listar" { Get-ChildItem }
		"nav_listar_ocultos" { Get-ChildItem -Force }
		"nav_listar_recursivo" { Get-ChildItem -Recurse }
		"nav_listar_so_pastas" { Get-ChildItem -Directory }
		"nav_listar_so_arquivos" { Get-ChildItem -File }
		"nav_onde_estou?" { pwd }
		"nav_volta_1_diretorio" { Set-Location .. }
		"nav_volta_2_diretorios" { Set-Location ..\.. }
		"nav_volta_desktop" { Set-Location ~/Desktop }
		"nav_volta_home" { Set-Location ~ }

# ===========================================================
# CONFIGURAÇÕES DO SISTEMA
# ===========================================================
		"sys_bateria" { Get-WmiObject Win32_Battery | Format-Table Caption, EstimatedChargeRemaining }
		"sys_bluetooth" { Get-WmiObject Win32_PnPEntity | Where-Object {$_.PNPClass -eq "Bluetooth"} | Format-Table Caption }
		"sys_diagnostico_bluetooth" {
			Write-Host "`n=== DIAGNOSTICO COMPLETO BLUETOOTH ===" -ForegroundColor Cyan
			
			# 1. Hardware
			Write-Host "`n1. Dispositivos Bluetooth no hardware:" -ForegroundColor Yellow
			$btDevices = Get-PnpDevice | Where-Object {$_.FriendlyName -like "*bluetooth*" -or $_.Class -eq "Bluetooth"}
			if ($btDevices) {
				$btDevices | Format-Table FriendlyName, Status, Class -AutoSize
			} else {
				Write-Host "NENHUM dispositivo Bluetooth encontrado!" -ForegroundColor Red
			}
			
			# 2. Servicos
			Write-Host "`n2. Servicos Bluetooth:" -ForegroundColor Yellow
			$btServices = Get-Service | Where-Object {$_.Name -like "*bluetooth*"}
			if ($btServices) {
				$btServices | Format-Table Name, Status, StartType -AutoSize
			} else {
				Write-Host "NENHUM servico Bluetooth encontrado!" -ForegroundColor Red
			}
			
			# 3. Adaptadores de rede
			Write-Host "`n3. Adaptadores de rede (possiveis dispositivos Bluetooth):" -ForegroundColor Yellow
			Get-PnpDevice | Where-Object {$_.Class -eq "Net"} | Select-Object FriendlyName, Status | Format-Table -AutoSize
			
			# 4. Dispositivos ocultos
			Write-Host "`n4. Dispositivos ocultos (desabilitados):" -ForegroundColor Yellow
			Get-PnpDevice -PresentOnly | Where-Object {$_.Class -eq "Bluetooth" -or $_.FriendlyName -like "*bluetooth*"} | Format-Table FriendlyName, Status
			
			Write-Host "`n=== FIM DIAGNOSTICO ===" -ForegroundColor Cyan
			Write-Host "`nSe nao apareceu NENHUM dispositivo Bluetooth, seu PC nao tem hardware Bluetooth." -ForegroundColor Magenta
		}
		"sys_bios" { Get-WmiObject Win32_BIOS | Select-Object -ExpandProperty SMBIOSBIOSVersion }
		"sys_cpu" { Get-WmiObject Win32_Processor | Format-Table Name, MaxClockSpeed, NumberOfCores -AutoSize }
		"sys_chrome_modo_debug" { cmd /c start chrome --remote-debugging-port=9222 --user-data-dir=C:\temp\chrome_debug }
		"sys_discoinfo" { Get-WmiObject Win32_DiskDrive | Format-Table DeviceID, Caption, @{Label="Size(GB)";Expression={[math]::round($_.Size/1GB,2)}}, MediaType }
		"sys_discos" { Get-PSDrive -PSProvider FileSystem | Select-Object -ExpandProperty Name }
		"sys_disco_espaco" { Get-PSDrive -PSProvider FileSystem | Format-Table Name, @{Label="Used(GB)";Expression={[math]::round($_.Used/1GB,2)}}, @{Label="Free(GB)";Expression={[math]::round($_.Free/1GB,2)}} }
		"sys_edge_modo_debug" { cmd /c start msedge --remote-debugging-port=9222 --user-data-dir=C:\temp\edge_debug }
		"sys_edge_encerar_processos" { Get-Process msedge -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue }
		"sys_edge_ouvindo_porta" { netstat -an | findstr 9222 }
		"sys_edge_verificacao" { Get-Process msedge -ErrorAction SilentlyContinue }
		"sys_gpu" { Get-WmiObject Win32_VideoController | Format-Table Caption, @{Label="RAM(MB)";Expression={[math]::round($_.AdapterRAM/1MB,2)}} }
		"sys_impressoras" { Get-WmiObject Win32_Printer | Format-Table Name }
		"sys_ip" { ipconfig }
		"sys_ip_geral" { ipconfig /all }
		"sys_memoria_slots" { Get-WmiObject Win32_PhysicalMemory | Select-Object -ExpandProperty DeviceLocator }
		"sys_memorias" { Get-WmiObject Win32_PhysicalMemory | Format-Table Capacity, Speed, FormFactor }
		"sys_modelo_pc" { Get-WmiObject Win32_ComputerSystem | Select-Object -ExpandProperty Model }
		"sys_placa_mae" { Get-WmiObject Win32_BaseBoard | Format-Table Manufacturer, Product, Version, SerialNumber -AutoSize }
		"sys_particoes" { Get-WmiObject Win32_DiskPartition | Select-Object -ExpandProperty DeviceID }
		"sys_programas_instalados" { Get-WmiObject Win32_Product | Format-Table Name, Version }
		"sys_rede" { Get-WmiObject Win32_NetworkAdapter | Where-Object {$_.MACAddress} | Format-Table Name, MACAddress }
		"sys_sistema_operacional" { Get-WmiObject Win32_OperatingSystem | Format-Table Caption, Version, OSArchitecture }
		"sys_abre_snippet_notepad" { notepad $PROFILE }
		"sys_abre_snippet_vscode" { code $PROFILE }
		"sys_atualizar_snippet" { . $PROFILE }
		"sys_som" { Get-WmiObject Win32_SoundDevice | Format-Table Caption }
		"sys_usb" { Get-WmiObject Win32_PnPSignedDriver | Format-Table DeviceName }
		"sys_usuarios" { Get-LocalUser | Format-Table Name, Enabled }

# ===========================================================
# EXTENSÕES DO VS CODE POR LINGUAGEM/FERRAMENTA
# ===========================================================

		"exten_git" {
			Write-Host ""
			Write-Host "Instalando extensoes GIT para VS Code..."
			Write-Host ""

			$extensoes = @(
				"donjayamanne.githistory",
				"eamodio.gitlens",
				"mhutchie.git-graph",                  # Visualização gráfica do Git
				"codezombiech.gitignore"               # Templates .gitignore
			)

			$instaladas = code --list-extensions

			foreach ($ext in $extensoes) {
				if ($instaladas -notcontains $ext) {
					Write-Host "Instalando $ext..."
					code --install-extension $ext
				} else {
					Write-Host "$ext ja instalada"
				}
			}
		
			Write-Host ""
			Write-Host "Instalacao concluida!"
			Write-Host ""
		}

		"exten_c" {
			Write-Host ""
			Write-Host "Instalando extensões para LINGUAGEM C/C++ no VS Code..."
			Write-Host ""

			$extensoes = @(
				"jeff-hykin.better-cpp-syntax",
				"ms-vscode.cpptools",
				"ms-vscode.cpptools-extension-pack",
				"ms-vscode.cmake-tools",
				"llvm-vs-code-extensions.vscode-clangd",
				"xaver.clang-format",
				"vadimcn.vscode-lldb",
				"twxs.cmake",
				"ms-vscode.makefile-tools",
				"cschlosser.doxdocgen"
			)

			$instaladas = code --list-extensions

			foreach ($ext in $extensoes) {
				if ($instaladas -notcontains $ext) {
					Write-Host "Instalando $ext..."
					code --install-extension $ext
				} else {
					Write-Host "$ext ja instalada"
				}
			}
		
			Write-Host ""
			Write-Host "Instalacao concluida!"
			Write-Host ""
		}

		"exten_python" {
			Write-Host ""
			Write-Host "Instalando extensões PYTHON + SQL para VS Code..."
			Write-Host ""

			$extensoes = @(
				"ms-python.python",
				"ms-python.vscode-pylance",
				"ms-python.debugpy",
				"ms-toolsai.jupyter",
				"ms-toolsai.datawrangler",
				"njpwerner.autodocstring",
				"kevinrose.vsc-python-indent",
				"coenraads.bracket-pair-colorizer-2",
				"christian-kohler.path-intellisense",
				"littlefoxteam.vscode-python-test-adapter",
				"ms-python.black-formatter",
				"ms-python.isort",
				"ms-python.flake8",
				"ms-python.vscode-python-envs",      # Gerenciamento de ambientes virtuais
				"VisualStudioExptTeam.vscodeintellicode", # AI IntelliCode
				"bierner.markdown-preview-github-styles", # Markdown GitHub style
				"gruntfuggly.todo-tree"              # Gerenciamento de TODO comments 
			)

			$instaladas = code --list-extensions

			foreach ($ext in $extensoes) {
				if ($instaladas -notcontains $ext) {
					Write-Host "Instalando $ext..."
					code --install-extension $ext
				} else {
					Write-Host "$ext ja instalada"
				}
			}

			Write-Host ""
			Write-Host "Instalacao concluida!"
			Write-Host ""
		}

		"exten_sql" {
			Write-Host ""
			Write-Host "Instalando extensões SQL para VS Code..."
			Write-Host ""

			$extensoes = @(
				"mssql.mssql",
				"mtxr.sqltools",
				"cweijan.vscode-database-client2",
				"inferrinizard.prettier-sql-vscode",  # Formatação SQL
				"benodie.sqlite-viewer",               # Visualizador SQLite
				"qwtel.sqlite-viewer"                 # Alternativa SQLite
			)

			$instaladas = code --list-extensions

			foreach ($ext in $extensoes) {
				if ($instaladas -notcontains $ext) {
					Write-Host "Instalando $ext..."
					code --install-extension $ext
				} else {
					Write-Host "$ext ja instalada"
				}
			}

			Write-Host ""
			Write-Host "Instalacao concluida!"
			Write-Host ""
		}

		"exten_rust" {
			Write-Host ""
			Write-Host "Instalando extensões RUST para VS Code..."
			Write-Host ""

			$extensoes = @(
				"rust-lang.rust-analyzer",
				"vadimcn.vscode-lldb",
				"serayuzgur.crates",
				"tamasfe.even-better-toml",
				"fill-labs.dependi",
				"dustypomerleau.rust-snippets",
				"panicbit.cargo"                   # Comandos Cargo no VSCode
			)

			$instaladas = code --list-extensions

			foreach ($ext in $extensoes) {
				if ($instaladas -notcontains $ext) {
					Write-Host "Instalando $ext..."
					code --install-extension $ext
				} else {
					Write-Host "$ext ja instalada"
				}
			}

			Write-Host ""
			Write-Host "Instalacao concluida!"
			Write-Host ""
		}

		"exten_geral" {
			Write-Host ""
			Write-Host "Instalando extensões GERAIS para VS Code..."
			Write-Host ""

			$extensoes = @(
				"mads-hartmann.bash-ide-vscode",
				"ritwickdey.liveserver",
				"ms-vsliveshare.vsliveshare",
				"yzhang.markdown-all-in-one",
				"ms-ceintl.vscode-language-pack-pt-BR",
				"ms-vscode.powershell",
				"ms-vscode-remote.remote-ssh",
				"ms-vscode-remote.remote-ssh-edit",
				"ms-vscode-remote.remote-explorer",
				"ms-vscode-remote.remote-wsl",
				"foxundermoon.shell-format",
				"alexcvzz.vscode-sqlite",
				"rangav.vscode-thunder-client",
				"grapecity.gc-excelviewer",
				"mechatroner.rainbow-csv"
			)

			$instaladas = code --list-extensions

			foreach ($ext in $extensoes) {
				if ($instaladas -notcontains $ext) {
					Write-Host "Instalando $ext..."
					code --install-extension $ext
				} else {
					Write-Host "$ext ja instalada"
				}
			}
		
			Write-Host ""
			Write-Host "Instalacao concluida!"
			Write-Host ""
		}

		"exten_todas" {
			Write-Host ""
			Write-Host "Instalando TODAS as extensoes do VS Code..."
			Write-Host ""

			$extensoes = @(
				# Git
				"donjayamanne.githistory",
				"eamodio.gitlens",
				# C/C++
				"jeff-hykin.better-cpp-syntax",
				"ms-vscode.cpptools",
				"ms-vscode.cpptools-extension-pack",
				"ms-vscode.cmake-tools",
				"llvm-vs-code-extensions.vscode-clangd",
				"xaver.clang-format",
				"vadimcn.vscode-lldb",
				"twxs.cmake",
				"ms-vscode.makefile-tools",
				"cschlosser.doxdocgen",
				# Python
				"ms-python.python",
				"ms-python.vscode-pylance",
				"ms-python.debugpy",
				"ms-toolsai.jupyter",
				"ms-toolsai.datawrangler",
				"njpwerner.autodocstring",
				"kevinrose.vsc-python-indent",
				"coenraads.bracket-pair-colorizer-2",
				"christian-kohler.path-intellisense",
				"littlefoxteam.vscode-python-test-adapter",
				"ms-python.black-formatter",
				"ms-python.isort",
				"ms-python.flake8",
				# SQL
				"mssql.mssql",
				"mtxr.sqltools",
				"cweijan.vscode-database-client2",
				# Geral
				"mads-hartmann.bash-ide-vscode",
				"ritwickdey.liveserver",
				"ms-vsliveshare.vsliveshare",
				"yzhang.markdown-all-in-one",
				"ms-ceintl.vscode-language-pack-pt-BR",
				"ms-vscode.powershell",
				"ms-vscode-remote.remote-ssh",
				"ms-vscode-remote.remote-ssh-edit",
				"ms-vscode-remote.remote-explorer",
				"ms-vscode-remote.remote-wsl",
				"foxundermoon.shell-format",
				"alexcvzz.vscode-sqlite",
				"rangav.vscode-thunder-client",
				"grapecity.gc-excelviewer",
				"mechatroner.rainbow-csv"
			)

			$instaladas = code --list-extensions

			foreach ($ext in $extensoes) {
				if ($instaladas -notcontains $ext) {
					Write-Host "Instalando $ext..."
					code --install-extension $ext
				} else {
					Write-Host "$ext ja instalada"
				}
			}
		
			Write-Host ""
			Write-Host "Instalacao concluida!"
			Write-Host ""
		}

# ===========================================================
# COLA POWER SHELL
# ===========================================================
		"cola_vscode" {
				Write-Host ""
				Write-Host "=== COMANDOS VSCODE ==="
				Write-Host "cd nome-da-pasta                  # entrar na pasta"
				Write-Host "cd ..                             # voltar pasta"
				Write-Host "cd ..\..                          # voltar duas ou mais pastas"
				Write-Host "cd ~                              # Ir para a pasta do usuário (home)"
				Write-Host ".\nome_do_arquivo                 # Ir para a pasta do usuário (home)"
				Write-Host "!!                                # executar comando anterior"
				Write-Host "pwd                               # ver onde está"
				Write-Host "ls                                # lista arquivos e pastas"
				Write-Host "ls -Force                         # mostra ocultos"
				Write-Host "ls -Directory                     # listar somente pastas"
				Write-Host "ls -File                          # listar somente arquivos"
				Write-Host "ls -Recurse                       # lista tudo (subpastas)"
				Write-Host "Invoke-Item                       # abrir arquivo ou pasta"
				Write-Host "ls C:\Users *documen* -File -Recurse       # pesquisa por arquivos com trecho %documen%"
		}

# ===========================================================
# COLA GIT
# ===========================================================
		"cola_git" {
			Write-Host ""
			Write-Host "=== COMANDOS GIT ==="
			Write-Host ""
			Write-Host "--- CONFIGURAÇÃO ---"
			Write-Host "git config user.name 'nome'              # configurar nome"
			Write-Host "git config user.email 'email'            # configurar email"
			Write-Host "git config --global user.email 'email'   # configurar global"
			Write-Host "git config credential.helper store       # salvar credenciais"
			Write-Host "git config --unset credential.helper     # remover credencial local"
			Write-Host "git config --global --unset credential.helper  # remover global"
			Write-Host "git remote -v                            # ver repositórios remotos"
			Write-Host ""
			Write-Host "--- INÍCIO / CLONE ---"
			Write-Host "git init                                 # iniciar repositório"
			Write-Host "git init --bare                          # criar repositório central"
			Write-Host "git clone URL                            # clonar repositório"
			Write-Host "git remote add origin URL                # conectar repositório remoto"
			Write-Host ""
			Write-Host "--- STATUS / ADICIONAR ---"
			Write-Host "git status                               # status do projeto"
			Write-Host "git status --ignored                     # status incluindo ignorados"
			Write-Host "git add arquivo                          # adicionar arquivo"
			Write-Host "git add .                                # adicionar todos"
			Write-Host "git rm arquivo                           # remover arquivo do Git"
			Write-Host "git mv antigo novo                       # renomear arquivo"
			Write-Host ""
			Write-Host "--- COMMIT ---"
			Write-Host "git commit -m 'mensagem'                 # commitar"
			Write-Host "git commit --amend -m 'nova'             # corrigir último commit"
			Write-Host ""
			Write-Host "--- LOG ---"
			Write-Host "git log                                  # todos commits"
			Write-Host "git log -2                               # últimos 2 commits"
			Write-Host "git log --oneline                        # resumido"
			Write-Host "git log --author='nome'                  # por autor"
			Write-Host "git log --before='2022-10-05'            # anteriores a data"
			Write-Host "git log --after='2022-10-05'             # posteriores a data"
			Write-Host ""
			Write-Host "--- DIFF / RESTORE / RESET ---"
			Write-Host "git diff                                 # diferenças antes do add"
			Write-Host "git diff --staged                        # diferenças depois do add"
			Write-Host "git diff commit1..commit2                # diferenças entre commits"
			Write-Host "git restore --staged arquivo             # voltar arquivo do staged"
			Write-Host "git checkout -- arquivo                  # voltar arquivo (antes do add)"
			Write-Host "git checkout HEAD -- arquivo             # voltar arquivo (após add)"
			Write-Host "git checkout HEAD -- .                   # voltar TODOS (após add)"
			Write-Host "git reset HEAD --hard                    # resetar para último commit"
			Write-Host "git reset HEAD~1 --hard                  # excluir último commit"
			Write-Host "git reset HEAD~1                         # voltar commit sem excluir"
			Write-Host "git revert IDcommit                      # reverter commit específico"
			Write-Host ""
			Write-Host "--- BRANCH ---"
			Write-Host "git branch                               # listar branches"
			Write-Host "git branch nome                          # criar branch"
			Write-Host "git branch -d nome                       # deletar branch"
			Write-Host "git branch -D nome                       # deletar forçado"
			Write-Host "git checkout nome                        # mudar para branch"
			Write-Host "git checkout -b nome                     # criar e mudar"
			Write-Host "git merge nome                           # mesclar branch ao master"
			Write-Host "git merge --no-ff nome                   # merge com histórico"
			Write-Host "git switch -c nome                       # criar branch (novo comando)"
			Write-Host ""
			Write-Host "--- REMOTO (PUSH/PULL/FETCH) ---"
			Write-Host "git push                                 # enviar alterações"
			Write-Host "git push -u origin master                # enviar e conectar"
			Write-Host "git push origin v1.0                     # enviar tag"
			Write-Host "git pull                                 # puxar e mesclar"
			Write-Host "git pull origin master                   # puxar da branch master"
			Write-Host "git fetch                                # baixar sem mesclar"
			Write-Host "git rebase                               # mesclar após fetch"
			Write-Host ""
			Write-Host "--- STASH ---"
			Write-Host "git stash                                # guardar alterações"
			Write-Host "git stash pop                            # recuperar alterações"
			Write-Host ""
			Write-Host "--- TAG ---"
			Write-Host "git tag                                  # ver tags"
			Write-Host "git tag v1.0                             # criar tag"
			Write-Host "git checkout tag v1.0                    # ir para tag"
			Write-Host ""
			Write-Host "--- .GITIGNORE ---"
			Write-Host ".gitignore                               # arquivo de ignorados"
			Write-Host "# *.mp3                                  # ignora todos mp3"
			Write-Host "# **/pasta                               # ignora pasta inteira"
			Write-Host ""
			Write-Host "--- PROBLEMAS COMUNS ---"
			Write-Host "git checkout -b branch-salvamento        # resolver HEAD detached"
			Write-Host "git branch acerto 'hash'                 # corrigir Detached Head"
			Write-Host "git fetch origin pull/3/head:correcao    # testar pull request"
			Write-Host ""
			Write-Host "=== GITHUB ==="
			Write-Host "git remote add origin URL                # conectar ao GitHub"
			Write-Host "git push -u origin master                # primeiro push"
			Write-Host "git pull origin master                   # puxar do GitHub"
			Write-Host ""
			Write-Host "=== TAGS MARKDOWN ==="
			Write-Host "# Título H1"
			Write-Host "## Título H2"
			Write-Host "**negrito**"
			Write-Host "_itálico_"
			Write-Host "[texto](url)"
			Write-Host "![alt](imagem.png)"
			Write-Host "- [ ] tarefa pendente"
			Write-Host "- [x] tarefa concluída"
			Write-Host "aspas simples tripla"
			Write-Host ""
		}

# ===========================================================
# API TEST - SERVIÇOS PÚBLICOS PARA TESTES HTTP
# ===========================================================
		"cola_api_test" {
				Write-Host ""
				Write-Host "=== SERVIÇOS PÚBLICOS PARA TESTES DE API HTTP ==="
				Write-Host ""
				Write-Host "--- HTTPBIN (https://httpbin.org) ---"
				Write-Host "/get                           # Requisição GET com parâmetros"
				Write-Host "/headers                      # Mostra os headers enviados"
				Write-Host "/ip                           # Retorna seu IP público"
				Write-Host "/user-agent                   # Mostra seu User-Agent"
				Write-Host "/status/404                   # Retorna erro 404"
				Write-Host "/status/500                   # Retorna erro 500"
				Write-Host "/delay/3                      # Espera 3 segundos antes de responder"
				Write-Host "/anything                     # Ecoa qualquer requisição"
				Write-Host "/base64/SGVsbG8gV29ybGQ=      # Decodifica Base64"
				Write-Host ""
				Write-Host "--- JSONPLACEHOLDER (https://jsonplaceholder.typicode.com) ---"
				Write-Host "/posts/1                      # Post com ID 1"
				Write-Host "/posts                        # Todos os posts"
				Write-Host "/comments/1                   # Comentário com ID 1"
				Write-Host "/users/1                      # Usuário com ID 1"
				Write-Host "/todos/1                      # Tarefa com ID 1"
				Write-Host "/albums/1/photos              # Fotos do álbum 1"
				Write-Host ""
				Write-Host "--- REQRES (https://reqres.in) ---"
				Write-Host "/api/users/2                  # Usuário com ID 2"
				Write-Host "/api/users?page=2             # Paginação de usuários"
				Write-Host "/api/users/23                 # Usuário inexistente (404)"
				Write-Host "/api/unknown/2                # Recurso desconhecido"
				Write-Host "/api/register                 # Teste de registro (POST)"
				Write-Host "/api/login                    # Teste de login (POST)"
				Write-Host "/api/users/2?delay=3          # Atraso de 3 segundos"
				Write-Host ""
				Write-Host "--- MOCKY (https://mocky.io) ---"
				Write-Host "# Crie respostas personalizadas:"
				Write-Host "1. Acesse https://mocky.io"
				Write-Host "2. Cole seu JSON de resposta"
				Write-Host "3. Clique em 'Generate my HTTP response'"
				Write-Host "4. Use a URL gerada no seu código"
				Write-Host ""
				Write-Host "--- BEECEPTOR (https://beeceptor.com) ---"
				Write-Host "# Simule qualquer API:"
				Write-Host "1. Acesse https://beeceptor.com"
				Write-Host "2. Crie um endpoint (ex: minha-api)"
				Write-Host "3. Use: https://minha-api.free.beeceptor.com"
				Write-Host "4. Veja as requisições recebidas no dashboard"
				Write-Host ""
				Write-Host "--- EXEMPLOS DE TESTE COM CURL ---"
				Write-Host "curl https://httpbin.org/ip"
				Write-Host "curl https://jsonplaceholder.typicode.com/posts/1"
				Write-Host "curl https://reqres.in/api/users/2"
				Write-Host ""
				Write-Host "--- TESTANDO COM RUST (projeto rs05_cliente_http) ---"
				Write-Host "cargo run"
				Write-Host "# Digite: https://httpbin.org/ip"
				Write-Host "# Digite: https://jsonplaceholder.typicode.com/posts/1"
				Write-Host ""
		}

# ===========================================================
# GIT E GITHUB
# ===========================================================
		"git_status" { git status }
		"git_add" { git add . }
		"git_commit" { 
			$msg = Read-Host "Mensagem do commit"
			git commit -m "$msg"
		}
		"git_push" { git push }
		"git_pull" { git pull }
		"git_log" { git log --oneline -10 }
		"git_branch" { git branch }
		"git_checkout" { 
			$branch = Read-Host "Nome da branch"
			git checkout $branch
		}
		"git_diff" { git diff }
		"git_stash" { git stash }
		"git_stash_pop" { git stash pop }
		"git_init" { git init }
		"git_log_oneline" { git log --oneline }
		"git_log_author" { 
			$autor = Read-Host "Nome do autor"
			git log --author="$autor"
		}
		"git_log_before" { 
			$data = Read-Host "Data (YYYY-MM-DD)"
			git log --before="$data"
		}
		"git_log_after" { 
			$data = Read-Host "Data (YYYY-MM-DD)"
			git log --after="$data"
		}
		"git_restore_staged" { 
			$arquivo = Read-Host "Nome do arquivo"
			git restore --staged $arquivo
		}
		"git_reset_hard" { git reset HEAD --hard }
		"git_reset_soft" { 
			$qtde = Read-Host "Quantos commits voltar (ex: 1,2,3...)"
			git reset HEAD~$qtde
		}
		"git_amend" { 
			$msg = Read-Host "Nova mensagem do commit"
			git commit --amend -m "$msg"
		}
		"git_revert" { 
			$id = Read-Host "ID do commit"
			git revert $id
		}
		"git_branch_D" { 
			$branch = Read-Host "Nome da branch para deletar FORCADO"
			git branch -D $branch
		}
		"git_merge" { 
			$branch = Read-Host "Nome da branch para merge"
			git merge $branch
		}
		"git_checkout_b" { 
			$branch = Read-Host "Nome da nova branch"
			git checkout -b $branch
		}
		"git_clone" { 
			$url = Read-Host "URL do repositório"
			git clone $url
		}
		"git_remote_v" { git remote -v }
		"git_remote_add" { 
			$url = Read-Host "URL do repositório"
			git remote add origin $url
		}
		"git_push_u" { git push -u origin master }
		"git_pull_origin" { git pull origin master }
		"git_fetch" { git fetch }
		"git_rebase" { git rebase }
		"git_tag" { git tag }
		"git_tag_v" { 
			$versao = Read-Host "Versão (ex: v1.0)"
			git tag $versao
		}
		"git_tag_push" { 
			$versao = Read-Host "Versão (ex: v1.0)"
			git push origin $versao
		}
		"git_checkout_tag" { 
			$tag = Read-Host "Nome da tag"
			git checkout $tag
		}
		"git_switch_c" { 
			$branch = Read-Host "Nome do branch a partir da tag"
			git switch -c $branch
		}
		"git_checkout_detached_fix" { 
			Write-Host "Criando branch para salvar commits perdidos..." -ForegroundColor Yellow
			git checkout -b branch-salvamento
			git checkout master
			git merge --no-ff branch-salvamento
			Write-Host "Branch branch-salvamento criada. Delete se não precisar: git branch -d branch-salvamento" -ForegroundColor Green
		}
		"git_checkout_head" { git checkout HEAD -- . }
		"git_checkout_head_arquivo" { 
			$arquivo = Read-Host "Nome do arquivo"
			git checkout HEAD -- $arquivo
		}
		"git_config_user" {
			Write-Host "1 - Marcus-Vinicius-Dev (pessoal)"
			Write-Host "2 - Marcus-Vinicius-C-S (trabalho)"
			$opcao = Read-Host "Escolha 1 ou 2"
			if ($opcao -eq "1") {
				git config user.name "Marcus-Vinicius-Dev"
				git config user.email "marcus.vini.dev@gmail.com"
			} elseif ($opcao -eq "2") {
				git config user.name "Marcus-Vinicius-C-S"
				git config user.email "ciapdivtectic@gmail.com"
			}
		}
		"git_config_global" {
			$email = Read-Host "Email global"
			git config --global user.email "$email"
		}
		"git_credential_store" { git config credential.helper store }
		"git_credential_unset" { git config --unset credential.helper }
		"git_credential_unset_global" { git config --global --unset credential.helper }
		"git_ignore_criar" { New-Item -Path ".gitignore" -ItemType File }
		"git_status_ignore" { git status --ignored }
		"git_mv" {
			$antigo = Read-Host "Nome atual do arquivo"
			$novo = Read-Host "Novo nome"
			git mv $antigo $novo
		}
		"git_rm" {
			$arquivo = Read-Host "Arquivo para remover"
			git rm $arquivo
		}

# ===========================================================
# PYTHON
# ===========================================================

		"py_verificar_python" {
		Write-Host "`n=== VERIFICAÇÃO DO AMBIENTE PYTHON ===" -ForegroundColor Cyan
		
		# Python
		Write-Host "`nPython version:" -ForegroundColor Yellow
		python --version 2>&1
		
		# Pip
		Write-Host "`nPip version:" -ForegroundColor Yellow
		pip --version
		
		# Pacotes importantes
		Write-Host "`nPacotes instalados (principais):" -ForegroundColor Yellow
		pip list | findstr -i "pandas pyodbc sqlalchemy dotenv numpy"
		
		# PATH do Python
		Write-Host "`nLocalização do Python:" -ForegroundColor Yellow
		where.exe python
		
		Write-Host "`n=== FIM ===" -ForegroundColor Cyan
		}

		"py_instalar_python" {

		Write-Host ""
		Write-Host "=== INSTALACAO DO AMBIENTE PYTHON ==="
		Write-Host ""

		# Instalar Python via winget (recomendado)
		Write-Host "Instalando Python..."
		winget install Python.Python.3.12

		# Atualizar pip
		Write-Host "Atualizando pip..."
		python -m pip install --upgrade pip

		# Instalar bibliotecas essenciais
		Write-Host "Instalando pacotes Python..."
		pip install pyodbc pandas SQLAlchemy python-dotenv
		pip install pandas sqlalchemy pyodbc

		# Instalar driver ODBC
		Write-Host "Instalando ODBC Driver 18..."
		Start-BitsTransfer -Source "https://go.microsoft.com/fwlink/?linkid=2249006" -Destination "$env:TEMP\msodbcsql.msi"
		Start-Process -Wait -FilePath msiexec -ArgumentList "/i `"$env:TEMP\msodbcsql.msi`" /quiet IACCEPTMSODBCSQLLICENSETERMS=YES"

		# Instalar Selenium
		Write-Host "Instalando pacotes Python..."
		pip install selenium

		# Instalar ferramentas para Web Scraping
		Write-Host "Instalando pacotes para Web Scraping..."
		python -m pip install openpyxl

		# Instalar requirements se existir
		if (Test-Path "requirements.txt") {
			Write-Host "Instalando requirements.txt..."
			pip install -r requirements.txt
		}

		Write-Host ""
		Write-Host "=== INSTALACAO CONCLUIDA ==="
		Write-Host ""
		}

		"py_venv_criar" { 
			Write-Host "Criando ambiente virtual .venv..." -ForegroundColor Yellow
			python -m venv .venv
			Write-Host "Ambiente criado! Para ativar:" -ForegroundColor Green
			Write-Host ".\.venv\Scripts\Activate" -ForegroundColor Cyan
		}

		"py_venv_ativar" { 
			if (Test-Path ".\.venv\Scripts\Activate") {
				.\.venv\Scripts\Activate
				Write-Host "Ambiente .venv ATIVADO!" -ForegroundColor Green
				Write-Host "Para desativar: deactivate" -ForegroundColor Yellow
			} else {
				Write-Host "Pasta .venv NAO encontrada! Crie com: z py_venv_criar" -ForegroundColor Red
			}
		}

		"py_requirements_instalar" { 
			if (Test-Path "requirements.txt") {
				Write-Host "Instalando pacotes do requirements.txt..." -ForegroundColor Yellow
				pip install -r requirements.txt
			} else {
				Write-Host "Arquivo requirements.txt NAO encontrado!" -ForegroundColor Red
			}
		}

		"py_requirements_congelar" { 
			Write-Host "Gerando requirements.txt com pacotes atuais..." -ForegroundColor Yellow
			pip freeze > requirements.txt
			Write-Host "Arquivo requirements.txt CRIADO!" -ForegroundColor Green
		}

		"py_requirements_baixar" { 
			Write-Host "Instalando requirements.txt com pacotes necessários ao projeto..." -ForegroundColor Yellow
			pip install -r requirements.txt
			Write-Host "Arquivo requirements.txt BAIXADOS!" -ForegroundColor Green
		}

# ===========================================================
# RUST
# ===========================================================

		"rs_instalar_completo" {
			Write-Host "`n=== INSTALACAO COMPLETA DO RUST ===" -ForegroundColor Cyan
			
			# 1) Instalar Rust
			Write-Host "`n1. Instalando Rust..." -ForegroundColor Yellow
			winget install Rustlang.Rustup
			
			# 2) Instalar Build Tools C++
			Write-Host "`n2. Instalando Ferramentas de Build do C++..." -ForegroundColor Yellow
			winget install --id Microsoft.VisualStudio.2022.BuildTools --override "--passive --wait --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended"
			
			# 3) Adicionar ao PATH
			Write-Host "`n3. Adicionando Rust ao PATH..." -ForegroundColor Yellow
			[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Users\vinic\.cargo\bin", [EnvironmentVariableTarget]::User)
			
			# 4) Verificar instalação
			Write-Host "`n4. Verificando instalacao..." -ForegroundColor Yellow
			rustc --version
			cargo --version
			
			Write-Host "`n=== INSTALACAO CONCLUIDA ===" -ForegroundColor Green
			Write-Host "Reinicie o terminal para aplicar o PATH!" -ForegroundColor Magenta
		}

		"rs_novo_projeto" {
			$nomeProjeto = Read-Host "Nome do projeto (sem números no início)"
			Write-Host "`nCriando projeto Rust: $nomeProjeto" -ForegroundColor Yellow
			cargo new $nomeProjeto --bin
			Write-Host "Projeto criado! Acesse com: cd $nomeProjeto" -ForegroundColor Green
		}

		"rs_abrir_cargo_toml" {
			if (Test-Path "Cargo.toml") {
				notepad Cargo.toml
			} else {
				Write-Host "Arquivo Cargo.toml nao encontrado!" -ForegroundColor Red
				Write-Host "Execute 'rs_novo_projeto' primeiro ou 'cd' para pasta com projeto Rust" -ForegroundColor Yellow
			}
		}

		"rs_abrir_main" {
			if (Test-Path "src/main.rs") {
				notepad src/main.rs
			} else {
				Write-Host "Arquivo src/main.rs nao encontrado!" -ForegroundColor Red
				Write-Host "Execute 'rs_novo_projeto' primeiro ou 'cd' para pasta com projeto Rust" -ForegroundColor Yellow
			}
		}

		"rs_instal" {
		Write-Host "`n Instalando Rust:" -ForegroundColor Yellow
		winget install Rustlang.Rustup
		}	
		
		"rs_path" {
		Write-Host "`n adicionar a pasta do Rust ao PATH apenas para esta janela:" -ForegroundColor Yellow
		$env:Path = "C:\Users\vinic\.cargo\bin;$env:Path"
		}		

		"rs_principal" {
		Write-Host "`n Arquivo Principal:" -ForegroundColor Yellow
		notepad src/main.rs
		}

		"rs_verifica_install" {
		Write-Host "`n Instalação Rust:" -ForegroundColor Yellow
		rustc --version
		cargo --version	
		}

	"rs_criar_gitignore" {
	if (-not (Test-Path ".gitignore")) {
		@"
/target/
Cargo.lock
*.rs.bk
*.pdb
*.exe
"@ | Out-File -FilePath ".gitignore" -Encoding UTF8
		Write-Host "Arquivo .gitignore criado!" -ForegroundColor Green
	} else {
		Write-Host ".gitignore ja existe!" -ForegroundColor Yellow
		notepad .gitignore
	}
}

		"rs_executar" { cargo run }
		"rs_construir" { cargo build }
		"rs_construir_release" { cargo build --release }
		"rs_testar" { cargo test }
		"rs_documentar" { cargo doc --open }
		"rs_limpar" { cargo clean }
		"rs_atualizar_deps" { cargo update }
		"rs_adicionar_dependencia" {
			$crate = Read-Host "Nome da crate (ex: serde, tokio, rand)"
			Write-Host "Adicionando $crate as dependencias..." -ForegroundColor Yellow
			cargo add $crate
		}
		"rs_verificar" { cargo check }
		"rs_formatar" { cargo fmt }
		"rs_analisar" { cargo clippy }

		"rs_help" {
			Write-Host ""
			Write-Host "=== COMANDOS RUST DISPONIVEIS ==="
			Write-Host ""
			Write-Host "--- INSTALACAO ---"
			Write-Host "rs_instalar_completo     # Instala Rust + Build Tools C++"
			Write-Host "rs_verifica_install      # Verifica versoes instaladas"
			Write-Host "rs_path                  # Adiciona Rust ao PATH (temporario)"
			Write-Host ""
			Write-Host "--- PROJETOS ---"
			Write-Host "rs_novo_projeto          # Cria novo projeto binario"
			Write-Host "rs_hello_world_io        # Cria projeto Hello World com I/O"
			Write-Host "rs_abrir_cargo_toml      # Abre Cargo.toml no notepad"
			Write-Host "rs_abrir_main            # Abre src/main.rs no notepad"
			Write-Host "rs_criar_gitignore       # Cria .gitignore padrao Rust"
			Write-Host ""
			Write-Host "--- EXECUCAO ---"
			Write-Host "rs_executar              # cargo run"
			Write-Host "rs_construir             # cargo build"
			Write-Host "rs_construir_release     # cargo build --release"
			Write-Host "rs_testar                # cargo test"
			Write-Host "rs_documentar            # cargo doc --open"
			Write-Host "rs_limpar                # cargo clean"
			Write-Host ""
			Write-Host "--- MANUTENCAO ---"
			Write-Host "rs_atualizar_deps        # cargo update"
			Write-Host "rs_adicionar_dependencia # cargo add <crate>"
			Write-Host "rs_verificar             # cargo check"
			Write-Host "rs_formatar              # cargo fmt"
			Write-Host "rs_analisar              # cargo clippy"
			Write-Host ""
		}
# ===========================================================
# HELP
# ===========================================================
		"help" {
				Write-Host ""
				Write-Host "=== USE SNIPPETS ==="
				Write-Host "NA LINHA DE COMANDO DESTE TERMINAL DIGITE:"
				Write-Host "z + space + tab"
				Write-Host "uma lista de comandos aparecerá"
				Write-Host ""
				Write-Host "=== ARQUIVO DE SNIPPETS ==="
				Write-Host "DIGITE notepad $PROFILE"
				Write-Host ""
		}

		default {
				Write-Host "Comando nao reconhecido. Use: z help"
		}
    }
}

# ===========================================================
# AUTOCOMPLETE
# ===========================================================
Register-ArgumentCompleter -CommandName z -ParameterName comando -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete)

    $comandos = @(
		# Navegação
		"nav_buscar_por_nome","nav_desktop","nav_downloads","nav_home","nav_listar","nav_listar_ocultos","nav_listar_so_pastas","nav_listar_so_arquivos",
		"nav_listar_recursivo","nav_volta_1_diretorio","nav_volta_2_diretorios","nav_volta_desktop","nav_volta_home","nav_onde_estou?",
		# Sistema
		"sys_bateria","sys_bios","sys_bluetooth","sys_diagnostico_bluetooth","sys_chrome_modo_debug","sys_cpu","sys_disco_espaco","sys_discoinfo",
		"sys_discos","sys_edge_modo_debug","sys_edge_encerar_processos","sys_edge_ouvindo_porta","sys_edge_verificacao","sys_gpu","sys_impressoras",
		"sys_ip","sys_ip_geral","sys_memoria_slots","sys_memorias","sys_modelo_pc","sys_particoes","sys_placa_mae","sys_programas_instalados",
		"sys_rede","sys_sistema_operacional","sys_som","sys_usb","sys_usuarios","sys_abre_snippet_notepad","sys_abre_snippet_vscode","sys_atualizar_snippet",
		# Extensões
		"exten_git","exten_c","exten_python","exten_sql","exten_rust","exten_geral","exten_todas",
		# Colas
		"cola_api_test","cola_vscode","cola_git",
		# Git
		"git_status","git_add","git_commit","git_push","git_pull","git_log","git_branch","git_checkout","git_diff","git_stash","git_stash_pop","git_init",
		"git_log_oneline","git_log_author","git_log_before","git_log_after","git_restore_staged","git_reset_hard","git_reset_soft","git_amend","git_revert",
		"git_branch_D","git_merge","git_checkout_b","git_clone","git_remote_v","git_remote_add","git_push_u","git_pull_origin","git_fetch","git_rebase",
		"git_tag","git_tag_v","git_tag_push","git_checkout_tag","git_switch_c","git_checkout_detached_fix","git_checkout_head","git_checkout_head_arquivo",
		"git_config_user","git_config_global","git_credential_store","git_credential_unset","git_credential_unset_global","git_ignore_criar","git_status_ignore","git_mv","git_rm",
		# Python
		"py_verificar_python","py_instalar_python","py_venv_criar","py_venv_ativar","py_requirements_instalar","py_requirements_congelar","py_requirements_baixar",
		# Rust
		"rs_instalar_completo","rs_novo_projeto","rs_abrir_cargo_toml","rs_abrir_main","rs_instal","rs_path","rs_principal","rs_verifica_install","rs_criar_gitignore",
		"rs_executar","rs_construir","rs_construir_release","rs_testar","rs_documentar","rs_limpar","rs_atualizar_deps","rs_adicionar_dependencia","rs_verificar",
		"rs_formatar","rs_analisar","rs_help",
		# Help
		"help"
	)

    $comandos | Where-Object { $_ -like "$wordToComplete*" } |
    ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

# ===========================================================
# MENU COM TAB
# ===========================================================
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# ===========================================================
# MENSAGEM quando abre o terminal
# ===========================================================
Write-Host "Perfil PowerShell carregado!" -ForegroundColor Green 

# ===========================================================
# ENDEREÇO onde o VSCode pesquisa o arquivo com snippets
# ===========================================================
function code {
    # mude o caminho do usuário: 
	# C:\Users\vinic\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd
	# C:\Users\marcus.silva05\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd
    & "C:\Users\vinic\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd" @args
}
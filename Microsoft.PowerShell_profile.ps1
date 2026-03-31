# ===== INSTRUÇÕES =====
# no PS ADMNISTRADOR digite e excute os comandos: 
# Get-ExecutionPolicy 
# Verifique a política atual se NÃO for restricted, ok, se for restrita então
# Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
# Mudará a política para: 'RemoteSigned:' permite scripts locais e scripts da internet apenas se assinados por um editor confiável e '-Scope CurrentUser:' aplica apenas ao seu usuário, sem precisar de permissão de administrador para todo o sistema
# code $PROFILE  
# mude o usuário da função código 'function code {' conforme instruções da última função ao final do código
# copie e cole todos os códigos deste arquivo
# ao salvar o arquivo, selecione 'salvar como', no 'tipo' selecione 'Todo tipo de arquivo' e nome do arquivo 'Microsoft.PowerShell_profile.ps1'
# no PS digite . $PROFILE 
# teste digitando z+space+tab
# aparecerá menu de "snippets"
# 

function z {
    param(
        [string]$comando
    )

    switch ($comando) {		

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
        "sys_bateria" { Get-WmiObject Win32_Battery | Format-Table Caption, EstimatedChargeRemaining }
        "sys_bluetooth" { Get-WmiObject Win32_PnPEntity | Where-Object {$_.PNPClass -eq "Bluetooth"} | Format-Table Caption }
        "sys_bios" { Get-WmiObject Win32_BIOS | Select-Object -ExpandProperty SMBIOSBIOSVersion }
        "sys_cpu" { Get-WmiObject Win32_Processor | Format-Table Name, MaxClockSpeed, NumberOfCores -AutoSize }
		"sys_discoinfo" { Get-WmiObject Win32_DiskDrive | Format-Table DeviceID, Caption, @{Label="Size(GB)";Expression={[math]::round($_.Size/1GB,2)}}, MediaType }
        "sys_discos" { Get-PSDrive -PSProvider FileSystem | Select-Object -ExpandProperty Name }
        "sys_disco_espaco" { Get-PSDrive -PSProvider FileSystem | Format-Table Name, @{Label="Used(GB)";Expression={[math]::round($_.Used/1GB,2)}}, @{Label="Free(GB)";Expression={[math]::round($_.Free/1GB,2)}} }
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

	# ===== EXTENSÕES =====
	"instal_extens_inic" {

	    Write-Host ""
	    Write-Host "Instalando extensoes do VS Code..."
	    Write-Host ""

	    $extensoes = @(
	        "mads-hartmann.bash-ide-vscode",
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
	        "donjayamanne.githistory",
	        "eamodio.gitlens",
	        "ritwickdey.liveserver",
	        "ms-vsliveshare.vsliveshare",
	        "yzhang.markdown-all-in-one",
	        "ms-ceintl.vscode-language-pack-pt-BR",
	        "ms-vscode.powershell",
	        "ms-python.python",
	        "ms-python.vscode-pylance",
	        "ms-python.debugpy",
	        "ms-vscode-remote.remote-ssh",
	        "ms-vscode-remote.remote-ssh-edit",
	        "ms-vscode-remote.remote-explorer",
	        "ms-vscode-remote.remote-wsl",
	        "foxundermoon.shell-format",
	        "alexcvzz.vscode-sqlite",
	        "mssql.mssql",
	        "rangav.vscode-thunder-client"
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

	"instal_extens_py_sql" {

	    Write-Host ""
	    Write-Host "Instalando extensoes Python + SQL..."
 	    Write-Host ""

	    $extensoes = @(
	        "ms-python.python",
	        "ms-python.vscode-pylance",
	        "mssql.mssql",
	        "mtxr.sqltools",
	        "ms-toolsai.jupyter",
	        "ms-toolsai.datawrangler",
	        "njpwerner.autodocstring",
	        "kevinrose.vsc-python-indent",
	        "njpwerner.autodocstring",
	        "coenraads.bracket-pair-colorizer-2",
	        "christian-kohler.path-intellisense",
	        "littlefoxteam.vscode-python-test-adapter",
	        "ms-python.black-formatter",
	        "ms-python.isort",
	        "ms-python.flake8",
	        "ms-python.debugpy",
	        "cweijan.vscode-database-client2",
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

		# ===== COMANDOS =====
        "comandos_vscode" {
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

        # ===== HELP =====
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

# AUTOCOMPLETE
Register-ArgumentCompleter -CommandName z -ParameterName comando -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete)

    $comandos = @(
        "comandos_vscode","help","nav_buscar_por_nome","nav_desktop","nav_downloads","nav_home","nav_listar","nav_listar_ocultos",
		"nav_listar_so_pastas","nav_listar_so_arquivos","nav_listar_recursivo","nav_volta_1_diretorio","nav_volta_2_diretorios",
		"nav_volta_desktop","nav_volta_home","sys_bateria","sys_bios","sys_bluetooth","sys_cpu","sys_disco_espaco","sys_discoinfo",
		"sys_discos","sys_gpu","sys_impressoras","sys_ip","sys_ip_geral","sys_memoria_slots","sys_memorias","sys_modelo_pc",
		"nav_onde_estou?","sys_particoes","sys_placa_mae","sys_programas_instalados","sys_rede","sys_sistema_operacional",
		"sys_abre_snippet_notepad","sys_abre_snippet_vscode","sys_atualizar_snippet","sys_bateria","sys_bios","sys_bluetooth",
		"sys_som","sys_usb","sys_usuarios","instal_extens_inic","instal_extens_py_sql"
    )

    $comandos | Where-Object { $_ -like "$wordToComplete*" } |
    ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

# MENU COM TAB
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# MENSAGEM quando abre o terrminal
Write-Host "Perfil PowerShell carregado!" -ForegroundColor Green 

function code {
    & "C:\Users\XXX\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd" @args #mudar o caminho do usuário onde está com XXX C:\Users\XXX\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd
          #MUDE XXX ACIMA usando notepad $PROFILE
			   		️
}

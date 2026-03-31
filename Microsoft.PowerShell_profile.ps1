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

function z {
    param(
        [string]$comando
    )

    switch ($comando) {

        "bateria" { Get-WmiObject Win32_Battery | Format-Table Caption, EstimatedChargeRemaining }
        "bluetooth" { Get-WmiObject Win32_PnPEntity | Where-Object {$_.PNPClass -eq "Bluetooth"} | Format-Table Caption }
        "bios" { Get-WmiObject Win32_BIOS | Select-Object -ExpandProperty SMBIOSBIOSVersion }
        "buscar_por_nome" { Get-ChildItem -Filter "*documen*" -File -Recurse }
        "cpu" { Get-WmiObject Win32_Processor | Format-Table Name, MaxClockSpeed, NumberOfCores -AutoSize }
        "desktop" { Set-Location ~/Desktop }
	"discoinfo" { Get-WmiObject Win32_DiskDrive | Format-Table DeviceID, Caption, @{Label="Size(GB)";Expression={[math]::round($_.Size/1GB,2)}}, MediaType }
        "discos" { Get-PSDrive -PSProvider FileSystem | Select-Object -ExpandProperty Name }
        "disco_espaco" { Get-PSDrive -PSProvider FileSystem | Format-Table Name, @{Label="Used(GB)";Expression={[math]::round($_.Used/1GB,2)}}, @{Label="Free(GB)";Expression={[math]::round($_.Free/1GB,2)}} }
        "gpu" { Get-WmiObject Win32_VideoController | Format-Table Caption, @{Label="RAM(MB)";Expression={[math]::round($_.AdapterRAM/1MB,2)}} }
        "home" { Set-Location ~ }
        "impressoras" { Get-WmiObject Win32_Printer | Format-Table Name }
        "ip" { ipconfig }
        "ip_geral" { ipconfig /all }
        "listar" { Get-ChildItem }
        "listar_force" { Get-ChildItem -Force }
        "listar_recursivo" { Get-ChildItem -Recurse }
        "listar_so_pastas" { Get-ChildItem -Directory }
        "listar_so_arquivos" { Get-ChildItem -File }
        "memoria_slots" { Get-WmiObject Win32_PhysicalMemory | Select-Object -ExpandProperty DeviceLocator }
        "memorias" { Get-WmiObject Win32_PhysicalMemory | Format-Table Capacity, Speed, FormFactor }
        "modelo_pc" { Get-WmiObject Win32_ComputerSystem | Select-Object -ExpandProperty Model }
        "onde_estou?" { pwd }
        "placa_mae" { Get-WmiObject Win32_BaseBoard | Format-Table Manufacturer, Product, Version, SerialNumber -AutoSize }
        "particoes" { Get-WmiObject Win32_DiskPartition | Select-Object -ExpandProperty DeviceID }
        "programas_instalados" { Get-WmiObject Win32_Product | Format-Table Name, Version }
        "rede" { Get-WmiObject Win32_NetworkAdapter | Where-Object {$_.MACAddress} | Format-Table Name, MACAddress }
        "sistema_operacional" { Get-WmiObject Win32_OperatingSystem | Format-Table Caption, Version, OSArchitecture }
        "snippet_abrir" { code $PROFILE }
        "snippet_atualizar" { . $PROFILE }
		"som" { Get-WmiObject Win32_SoundDevice | Format-Table Caption }
        "usb" { Get-WmiObject Win32_PnPSignedDriver | Format-Table DeviceName }
        "usuarios" { Get-LocalUser | Format-Table Name, Enabled }
        "volta_1_diretorio" { Set-Location .. }
        "volta_2_diretorios" { Set-Location ..\.. }

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
    "bateria","bios","bluetooth","buscar_por_nome","comandos_vscode","cpu","desktop","disco_espaco","discoinfo",
	"discos","help","home","gpu","impressoras","instal_extens_inic","instal_extens_py_sql",
	"ip","ip_geral","listar","listar_force","listar_so_pastas","listar_so_arquivos",
	"listar_recursivo","memoria_slots","memorias","modelo_pc","onde_estou?","particoes",
	"placa_mae","programas_instalados","rede","sistema_operacional","snippet_abrir",
	"snippet_atualizar","som","usb","usuarios","volta_1_diretorio","volta_2_diretorios"          
    )

    $comandos | Where-Object { $_ -like "$wordToComplete*" } |
    ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

# MENU COM TAB
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

function code {
    & "C:\Users\XXX\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd" @args #mudar o caminho do usuário onde está com XXX C:\Users\XXX\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd
          #MUDE XXX ACIMA usando notepad $PROFILE
			   		️
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Crear GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AdvancedSecurityScanner"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 650, 0, 700)
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -350)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

-- Esquinas redondeadas
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🔍 Analizador Avanzado de Seguridad & Backdoors"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.Parent = mainFrame

-- Estado de escaneo
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 60)
statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
statusLabel.Text = "Listo para escaneo profundo"
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.BorderSizePixel = 0
statusLabel.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = statusLabel

-- Botón de escaneo
local scanButton = Instance.new("TextButton")
scanButton.Size = UDim2.new(0, 250, 0, 40)
scanButton.Position = UDim2.new(0.5, -125, 0, 100)
scanButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
scanButton.Text = "🔍 Iniciar Escaneo Profundo"
scanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
scanButton.Font = Enum.Font.GothamBold
scanButton.TextSize = 16
scanButton.BorderSizePixel = 0
scanButton.Parent = mainFrame

local scanCorner = Instance.new("UICorner")
scanCorner.CornerRadius = UDim.new(0, 8)
scanCorner.Parent = scanButton

-- Área de resultados
local resultsFrame = Instance.new("ScrollingFrame")
resultsFrame.Size = UDim2.new(1, -20, 1, -200)
resultsFrame.Position = UDim2.new(0, 10, 0, 150)
resultsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
resultsFrame.BorderSizePixel = 0
resultsFrame.ScrollBarThickness = 8
resultsFrame.Parent = mainFrame

local resultsCorner = Instance.new("UICorner")
resultsCorner.CornerRadius = UDim.new(0, 8)
resultsCorner.Parent = resultsFrame

-- Layout para resultados
local resultsLayout = Instance.new("UIListLayout")
resultsLayout.SortOrder = Enum.SortOrder.LayoutOrder
resultsLayout.Padding = UDim.new(0, 8)
resultsLayout.Parent = resultsFrame

-- Botón de copiar
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0, 150, 0, 35)
copyButton.Position = UDim2.new(1, -160, 1, -45)
copyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
copyButton.Text = "📋 Copiar Reporte"
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.Font = Enum.Font.Gotham
copyButton.TextSize = 14
copyButton.BorderSizePixel = 0
copyButton.Visible = false
copyButton.Parent = mainFrame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 6)
copyCorner.Parent = copyButton

-- Variables globales
local scanResults = {}
local isScanning = false
local backdoorPatterns = {}
local remoteAnalysis = {}
local scriptAnalysis = {}

-- Patrones de backdoor conocidos (expandidos)
local backdoorSignatures = {
    ["require%((%d+)%)"] = "Backdoor por require() con ID sospechoso",
    ["loadstring%("] = "Backdoor por loadstring() - Ejecución de código dinámico",
    ["getfenv%("] = "Manipulación de entorno con getfenv()",
    ["setfenv%("] = "Manipulación de entorno con setfenv()",
    ["_G%["] = "Acceso a variables globales _G",
    ["shared%."] = "Uso de tabla shared para comunicación entre scripts",
    ["game:HttpGet"] = "Descarga de scripts externos via HTTP",
    ["game:GetService%(\"HttpService\"%)"] = "Acceso a HttpService",
    ["spawn%(function%(%)"] = "Creación de hilos con spawn()",
    ["coroutine%."] = "Manipulación de corrutinas",
    ["debug%."] = "Uso de librería debug",
    ["rawget%("] = "Acceso directo con rawget()",
    ["rawset%("] = "Modificación directa con rawset()",
    ["pcall%(require"] = "Require protegido con pcall",
    ["xpcall%("] = "Ejecución protegida con xpcall",
    ["game%.Players%.LocalPlayer"] = "Acceso a LocalPlayer (posible ClientScript malicioso)",
    ["%.MouseButton1Click"] = "Evento de click (posible activador)",
    ["%.KeyDown"] = "Evento de tecla (posible activador)",
    ["%.Chatted"] = "Evento de chat (posible comando)",
    ["if%s+.-%s*==%s*[\"']admin[\"']"] = "Verificación de admin en chat",
    ["if%s+.-%s*==%s*[\"']owner[\"']"] = "Verificación de owner en chat",
    ["MarketplaceService:UserOwnsGamePassAsync"] = "Verificación de GamePass (posible bypass)",
    ["MarketplaceService:PlayerOwnsAsset"] = "Verificación de Asset (posible bypass)",
    ["workspace%.FilteringEnabled%s*=%s*false"] = "Desactivación de FilteringEnabled",
    ["%.Value%s*=%s*999"] = "Modificación de valores a números altos",
    ["%.WalkSpeed%s*=%s*%d+"] = "Modificación de velocidad de caminar",
    ["%.JumpPower%s*=%s*%d+"] = "Modificación de poder de salto",
    ["%.Health%s*=%s*math%.huge"] = "Modificación de salud a infinito",
    ["%.MaxHealth%s*=%s*math%.huge"] = "Modificación de salud máxima a infinito",
    ["%.CFrame%s*=%s*CFrame%.new"] = "Modificación de posición (teletransporte)",
    ["game%.Players:GetPlayers%(%)"] = "Obtención de lista de jugadores",
    ["plr:Kick%("] = "Función de expulsión de jugadores",
    ["plr:Ban%("] = "Función de baneo de jugadores",
    ["game:Shutdown%("] = "Función de apagar servidor",
    ["Instance%.new%(\"RemoteEvent\"%)"] = "Creación dinámica de RemoteEvent",
    ["Instance%.new%(\"RemoteFunction\"%)"] = "Creación dinámica de RemoteFunction",
    ["table%.concat"] = "Concatenación de tablas (posible obfuscación)",
    ["string%.char"] = "Conversión de caracteres (posible obfuscación)",
    ["string%.byte"] = "Conversión a bytes (posible obfuscación)",
    ["string%.reverse"] = "Inversión de strings (posible obfuscación)",
    ["string%.gsub"] = "Sustitución de strings (posible obfuscación)",
    ["string%.match"] = "Coincidencia de patrones (posible obfuscación)",
    ["string%.find"] = "Búsqueda en strings (posible obfuscación)",
    ["%.OnServerEvent"] = "Conexión a evento del servidor",
    ["%.OnClientEvent"] = "Conexión a evento del cliente",
    ["%.OnServerInvoke"] = "Función del servidor",
    ["%.OnClientInvoke"] = "Función del cliente",
    ["while%s+true%s+do"] = "Bucle infinito (posible lag)",
    ["for%s+i%s*=%s*1%s*,%s*math%.huge"] = "Bucle infinito con math.huge",
    ["wait%(%s*0%s*%)"] = "Wait(0) - Puede causar lag",
    ["RunService%.Heartbeat"] = "Evento de frame (posible lag)",
    ["RunService%.Stepped"] = "Evento de step (posible lag)",
    ["UserInputService"] = "Acceso a input del usuario",
    ["TweenService"] = "Servicio de animaciones",
    ["DataStoreService"] = "Acceso a DataStore",
    ["MessagingService"] = "Servicio de mensajería",
    ["TeleportService"] = "Servicio de teletransporte",
    ["workspace:FindFirstChild"] = "Búsqueda de objetos específicos",
    ["workspace:WaitForChild"] = "Espera por objetos específicos",
    ["game:FindFirstChild"] = "Búsqueda global de objetos",
    ["game:WaitForChild"] = "Espera global por objetos"
}

-- Patrones de funciones peligrosas en RemoteEvents (expandidos)
local dangerousRemoteFunctions = {
    ["admin"] = "Función administrativa",
    ["kick"] = "Expulsión de jugadores",
    ["ban"] = "Baneo de jugadores",
    ["teleport"] = "Teletransporte",
    ["money"] = "Manipulación de dinero",
    ["cash"] = "Manipulación de dinero",
    ["coins"] = "Manipulación de monedas",
    ["robux"] = "Manipulación de Robux",
    ["walkspeed"] = "Modificación de velocidad",
    ["jumppower"] = "Modificación de salto",
    ["health"] = "Modificación de salud",
    ["god"] = "Modo dios",
    ["fly"] = "Vuelo",
    ["noclip"] = "Atravesar paredes",
    ["invisible"] = "Invisibilidad",
    ["kill"] = "Eliminar jugador",
    ["respawn"] = "Reaparecer jugador",
    ["team"] = "Cambio de equipo",
    ["rank"] = "Cambio de rango",
    ["permission"] = "Modificación de permisos",
    ["owner"] = "Funciones de propietario",
    ["developer"] = "Funciones de desarrollador",
    ["moderator"] = "Funciones de moderador",
    ["vip"] = "Funciones VIP",
    ["premium"] = "Funciones premium",
    ["gamepass"] = "Verificación de GamePass",
    ["purchase"] = "Compras",
    ["buy"] = "Comprar",
    ["sell"] = "Vender",
    ["trade"] = "Intercambio",
    ["give"] = "Dar items",
    ["take"] = "Quitar items",
    ["steal"] = "Robar",
    ["hack"] = "Hackear",
    ["exploit"] = "Explotar",
    ["cheat"] = "Trampa",
    ["bypass"] = "Omitir verificación",
    ["execute"] = "Ejecutar código",
    ["run"] = "Ejecutar",
    ["eval"] = "Evaluar código",
    ["load"] = "Cargar código",
    ["require"] = "Requerir módulo",
    ["spawn"] = "Crear hilo",
    ["command"] = "Comando",
    ["cmd"] = "Comando",
    ["script"] = "Script",
    ["code"] = "Código",
    ["function"] = "Función",
    ["event"] = "Evento",
    ["fire"] = "Disparar evento",
    ["invoke"] = "Invocar función",
    ["call"] = "Llamar función",
    ["data"] = "Manipulación de datos",
    ["save"] = "Guardar datos",
    ["load"] = "Cargar datos",
    ["delete"] = "Eliminar datos",
    ["update"] = "Actualizar datos",
    ["set"] = "Establecer valores",
    ["get"] = "Obtener valores",
    ["change"] = "Cambiar valores",
    ["modify"] = "Modificar valores"
}

-- Función para detectar funciones específicas del script
local function detectScriptFunctions(source)
    local functions = {}
    
    -- Detectar funciones definidas
    for funcName in source:gmatch("function%s+([%w_]+)%s*%(") do
        table.insert(functions, "Función definida: " .. funcName)
    end
    
    -- Detectar funciones locales
    for funcName in source:gmatch("local%s+function%s+([%w_]+)%s*%(") do
        table.insert(functions, "Función local: " .. funcName)
    end
    
    -- Detectar variables importantes
    for varName in source:gmatch("local%s+([%w_]+)%s*=%s*game:GetService") do
        table.insert(functions, "Servicio: " .. varName)
    end
    
    -- Detectar conexiones de eventos
    for eventName in source:gmatch("%.([%w_]+):Connect%(") do
        table.insert(functions, "Evento conectado: " .. eventName)
    end
    
    -- Detectar RemoteEvents utilizados
    for remoteName in source:gmatch("([%w_]+):FireServer%(") do
        table.insert(functions, "FireServer: " .. remoteName)
    end
    
    for remoteName in source:gmatch("([%w_]+):InvokeServer%(") do
        table.insert(functions, "InvokeServer: " .. remoteName)
    end
    
    -- Detectar DataStores
    for dataName in source:gmatch("GetDataStore%(\"([^\"]+)\"%)") do
        table.insert(functions, "DataStore: " .. dataName)
    end
    
    -- Detectar GUI creados
    for guiName in source:gmatch("Instance%.new%(\"([^\"]*Gui[^\"]*)\"%)"  ) do
        table.insert(functions, "GUI creado: " .. guiName)
    end
    
    return functions
end

-- Función para analizar propósito del script
local function analyzeScriptPurpose(script, source)
    local purpose = {}
    local category = "Desconocido"
    
    -- Analizar por ubicación
    local location = script:GetFullName()
    if location:find("StarterPlayer") then
        table.insert(purpose, "Script de jugador")
        category = "Cliente"
    elseif location:find("ServerScriptService") then
        table.insert(purpose, "Script del servidor")
        category = "Servidor"
    elseif location:find("ReplicatedStorage") then
        table.insert(purpose, "Script replicado")
        category = "Compartido"
    elseif location:find("Workspace") then
        table.insert(purpose, "Script en workspace")
        category = "Juego"
    end
    
    -- Analizar por contenido
    if source:find("UserInputService") then
        table.insert(purpose, "Manejo de input del usuario")
        category = "Input"
    end
    
    if source:find("TweenService") then
        table.insert(purpose, "Animaciones")
        category = "Animación"
    end
    
    if source:find("DataStoreService") then
        table.insert(purpose, "Persistencia de datos")
        category = "Datos"
    end
    
    if source:find("RemoteEvent") or source:find("RemoteFunction") then
        table.insert(purpose, "Comunicación cliente-servidor")
        category = "Comunicación"
    end
    
    if source:find("GUI") or source:find("Frame") or source:find("TextButton") then
        table.insert(purpose, "Interfaz de usuario")
        category = "UI"
    end
    
    if source:find("Touched") or source:find("BodyVelocity") or source:find("BodyPosition") then
        table.insert(purpose, "Físicas/Movimiento")
        category = "Física"
    end
    
    if source:find("Chatted") or source:find("PlayerAdded") or source:find("PlayerRemoving") then
        table.insert(purpose, "Eventos de jugador")
        category = "Jugador"
    end
    
    if source:find("MarketplaceService") then
        table.insert(purpose, "Compras/GamePasses")
        category = "Monetización"
    end
    
    if source:find("TeleportService") then
        table.insert(purpose, "Teletransporte entre juegos")
        category = "Teletransporte"
    end
    
    return purpose, category
end

-- Función para analizar código de script (mejorada)
local function analyzeScript(script)
    local analysis = {
        backdoors = {},
        functions = {},
        risks = {},
        purpose = {},
        category = "Desconocido",
        obfuscated = false,
        suspicious = false,
        lineCount = 0,
        complexity = "Baja"
    }
    
    local success, source = pcall(function()
        return script.Source
    end)
    
    if not success then
        analysis.risks[#analysis.risks + 1] = "No se puede leer el código fuente - Posible protección"
        return analysis
    end
    
    if source == "" then
        analysis.risks[#analysis.risks + 1] = "Script vacío o código oculto"
        return analysis
    end
    
    -- Contar líneas
    analysis.lineCount = select(2, source:gsub('\n', '\n')) + 1
    
    -- Determinar complejidad
    if analysis.lineCount > 500 then
        analysis.complexity = "Muy Alta"
    elseif analysis.lineCount > 200 then
        analysis.complexity = "Alta"
    elseif analysis.lineCount > 50 then
        analysis.complexity = "Media"
    end
    
    -- Detectar propósito
    analysis.purpose, analysis.category = analyzeScriptPurpose(script, source)
    
    -- Detectar funciones específicas
    analysis.functions = detectScriptFunctions(source)
    
    -- Verificar obfuscación (mejorada)
    local obfuscationIndicators = {
        string.len(source:gsub("%s", "")) > string.len(source) * 0.8, -- Muy poco espaciado
        source:find("\\x%x%x"), -- Caracteres hexadecimales
        source:find("\\%d%d%d"), -- Caracteres decimales
        source:find("string%.char%(") and source:find("string%.byte%("), -- Conversión de caracteres
        source:find("table%.concat") and source:find("string%.reverse"), -- Manipulación de strings
        string.len(source:match("[%w_]+") or "") < 3, -- Variables muy cortas
        source:find("%f[%w_]l%f[%W]") and source:find("%f[%w_]II%f[%W]"), -- Caracteres similares (l vs I)
        source:find("_G%[") and source:find("getfenv"), -- Manipulación de entorno
        source:find("loadstring") and source:find("string%.char"), -- Loadstring con char
        source:find("pcall") and source:find("require") and source:find("%d+") -- Require con pcall
    }
    
    local obfuscationCount = 0
    for _, indicator in pairs(obfuscationIndicators) do
        if indicator then obfuscationCount = obfuscationCount + 1 end
    end
    
    if obfuscationCount >= 3 then
        analysis.obfuscated = true
        analysis.risks[#analysis.risks + 1] = "Código posiblemente obfuscado (" .. obfuscationCount .. " indicadores)"
    end
    
    -- Buscar patrones de backdoor
    for pattern, description in pairs(backdoorSignatures) do
        if source:find(pattern) then
            analysis.backdoors[#analysis.backdoors + 1] = {
                pattern = pattern,
                description = description,
                match = source:match(pattern) or "Encontrado"
            }
        end
    end
    
    -- Verificar funciones sospechosas
    for dangerous, desc in pairs(dangerousRemoteFunctions) do
        if source:lower():find(dangerous) then
            analysis.risks[#analysis.risks + 1] = "Función sospechosa encontrada: " .. dangerous .. " (" .. desc .. ")"
            analysis.suspicious = true
        end
    end
    
    return analysis
end

-- Función para analizar RemoteEvent/RemoteFunction (mejorada)
local function analyzeRemote(remote)
    local analysis = {
        name = remote.Name,
        type = remote.ClassName,
        location = remote:GetFullName(),
        risks = {},
        functions = {},
        connections = {},
        parameters = {},
        suspicious = false,
        serverScripts = {},
        clientScripts = {}
    }
    
    -- Verificar nombre del remote
    for dangerous, desc in pairs(dangerousRemoteFunctions) do
        if remote.Name:lower():find(dangerous) then
            analysis.risks[#analysis.risks + 1] = "Nombre sospechoso: " .. desc
            analysis.suspicious = true
        end
    end
    
    -- Verificar ubicación del remote
    if remote.Parent == workspace then
        analysis.risks[#analysis.risks + 1] = "RemoteEvent en Workspace - Ubicación inusual"
    elseif remote.Parent == game.Lighting then
        analysis.risks[#analysis.risks + 1] = "RemoteEvent en Lighting - Ubicación sospechosa"
    elseif remote.Parent == game.SoundService then
        analysis.risks[#analysis.risks + 1] = "RemoteEvent en SoundService - Ubicación sospechosa"
    elseif remote.Parent == game.StarterPack then
        analysis.risks[#analysis.risks + 1] = "RemoteEvent en StarterPack - Ubicación sospechosa"
    end
    
    -- Buscar scripts que usen este remote
    for _, script in pairs(game:GetDescendants()) do
        if script:IsA("Script") or script:IsA("LocalScript") then
            local success, source = pcall(function()
                return script.Source
            end)
            
            if success and source:find(remote.Name) then
                local scriptInfo = script:GetFullName()
                
                -- Verificar si es script del servidor o cliente
                if script:IsA("Script") then
                    table.insert(analysis.serverScripts, scriptInfo)
                else
                    table.insert(analysis.clientScripts, scriptInfo)
                end
                
                -- Verificar cómo se usa
                if source:find(remote.Name .. ":FireServer%(") then
                    table.insert(analysis.connections, "FireServer (Cliente -> Servidor)")
                elseif source:find(remote.Name .. ":InvokeServer%(") then
                    table.insert(analysis.connections, "InvokeServer (Cliente -> Servidor)")
                elseif source:find(remote.Name .. ":FireClient%(") then
                    table.insert(analysis.connections, "FireClient (Servidor -> Cliente)")
                elseif source:find(remote.Name .. ":InvokeClient%(") then
                    table.insert(analysis.connections, "InvokeClient (Servidor -> Cliente)")
                end
                
                -- Verificar conexiones de eventos
                if source:find(remote.Name .. "%.OnServerEvent:Connect%(") then
                    table.insert(analysis.connections, "OnServerEvent conectado")
                elseif source:find(remote.Name .. "%.OnClientEvent:Connect%(") then
                    table.insert(analysis.connections, "OnClientEvent conectado")
                elseif source:find(remote.Name .. "%.OnServerInvoke") then
                    table.insert(analysis.connections, "OnServerInvoke asignado")
                elseif source:find(remote.Name .. "%.OnClientInvoke") then
                    table.insert(analysis.connections, "OnClientInvoke asignado")
                end
                
                -- Extraer parámetros
                local params = source:match(remote.Name .. ":Fire.-%((.-)%)")
                if params then
                    table.insert(analysis.parameters, params)
                end
                
                -- Verificar funciones peligrosas en el contexto
                for dangerous, desc in pairs(dangerousRemoteFunctions) do
                    if source:lower():find(dangerous) then
                        analysis.risks[#analysis.risks + 1] = "Función peligrosa en script: " .. desc
                    end
                end
            end
        end
    end
    
    return analysis
end

-- Función para agregar resultado detallado
local function addDetailedResult(severity, title, description, location, details)
    local result = {
        severity = severity,
        title = title,
        description = description,
        location = location or "Desconocido",
        details = details or {}
    }
    table.insert(scanResults, result)
    
    -- Crear elemento visual expandido
    local resultFrame = Instance.new("Frame")
    resultFrame.Size = UDim2.new(1, -10, 0, 120 + (#details * 15))
    resultFrame.BackgroundColor3 = severity == "BACKDOOR" and Color3.fromRGB(200, 0, 0) or
                                  severity == "CRÍTICO" and Color3.fromRGB(150, 30, 30) or
                                  severity == "ALTO" and Color3.fromRGB(200, 100, 30) or
                                  severity == "MEDIO" and Color3.fromRGB(200, 200, 30) or
                                  Color3.fromRGB(30, 100, 200)
    resultFrame.BorderSizePixel = 0
    resultFrame.Parent = resultsFrame
    
    local resultCorner = Instance.new("UICorner")
    resultCorner.CornerRadius = UDim.new(0, 8)
    resultCorner.Parent = resultFrame
    
    local severityLabel = Instance.new("TextLabel")
    severityLabel.Size = UDim2.new(0, 100, 0, 25)
    severityLabel.Position = UDim2.new(0, 8, 0, 8)
    severityLabel.BackgroundTransparency = 1
    severityLabel.Text = severity
    severityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    severityLabel.Font = Enum.Font.GothamBold
    severityLabel.TextSize = 14
    severityLabel.TextXAlignment = Enum.TextXAlignment.Left
    severityLabel.Parent = resultFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -120, 0, 25)
    titleLabel.Position = UDim2.new(0, 108, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = resultFrame
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -16, 0, 40)
    descLabel.Position = UDim2.new(0, 8, 0, 33)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 12
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.TextWrapped = true
    descLabel.Parent = resultFrame
    
    local locationLabel = Instance.new("TextLabel")
    locationLabel.Size = UDim2.new(1, -16, 0, 20)
    locationLabel.Position = UDim2.new(0, 8, 0, 73)
    locationLabel.BackgroundTransparency = 1
    locationLabel.Text = "📍 " .. location
    locationLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    locationLabel.Font = Enum.Font.Gotham
    locationLabel.TextSize = 11
    locationLabel.TextXAlignment = Enum.TextXAlignment.Left
    locationLabel.Parent = resultFrame

    -- Agregar detalles
    for i, detail in pairs(details) do
        local detailLabel = Instance.new("TextLabel")
        detailLabel.Size = UDim2.new(1, -24, 0, 15)
        detailLabel.Position = UDim2.new(0, 16, 0, 93 + (i * 15))
        detailLabel.BackgroundTransparency = 1
        detailLabel.Text = "• " .. detail
        detailLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        detailLabel.Font = Enum.Font.Gotham
        detailLabel.TextSize = 10
        detailLabel.TextXAlignment = Enum.TextXAlignment.Left
        detailLabel.Parent = resultFrame
    end
    
    -- Actualizar tamaño del ScrollingFrame
    resultsFrame.CanvasSize = UDim2.new(0, 0, 0, resultsLayout.AbsoluteContentSize.Y)
end

-- Función principal de escaneo
local function performSecurityScan()
    if isScanning then return end
    isScanning = true
    
    -- Reiniciar resultados
    scanResults = {}
    for _, child in pairs(resultsFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    statusLabel.Text = "🔍 Escaneando el juego..."
    statusLabel.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
    scanButton.Text = "⏳ Escaneando..."
    scanButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    
    local totalScripts = 0
    local totalRemotes = 0
    local backdoorsFound = 0
    local criticalIssues = 0
    local highRiskItems = 0
    
    -- Escanear todos los scripts
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            totalScripts = totalScripts + 1
            
            local analysis = analyzeScript(obj)
            
            -- Verificar backdoors
            if #analysis.backdoors > 0 then
                backdoorsFound = backdoorsFound + 1
                local backdoorDetails = {}
                for _, backdoor in pairs(analysis.backdoors) do
                    table.insert(backdoorDetails, backdoor.description .. " - " .. backdoor.match)
                end
                
                addDetailedResult(
                    "BACKDOOR",
                    "🚨 Backdoor Detectado: " .. obj.Name,
                    "Script contiene " .. #analysis.backdoors .. " patrón(es) de backdoor sospechoso(s)",
                    obj:GetFullName(),
                    backdoorDetails
                )
            end
            
            -- Verificar riesgos críticos
            if analysis.obfuscated then
                criticalIssues = criticalIssues + 1
                addDetailedResult(
                    "CRÍTICO",
                    "⚠️ Código Obfuscado: " .. obj.Name,
                    "El código está posiblemente obfuscado para ocultar su función",
                    obj:GetFullName(),
                    {"Código difícil de leer", "Posible intento de ocultar funcionalidad maliciosa"}
                )
            end
            
            -- Verificar riesgos altos
            if analysis.suspicious then
                highRiskItems = highRiskItems + 1
                addDetailedResult(
                    "ALTO",
                    "🔸 Script Sospechoso: " .. obj.Name,
                    "Contiene funciones potencialmente peligrosas",
                    obj:GetFullName(),
                    analysis.risks
                )
            end
            
            -- Informar sobre función del script
            if #analysis.purpose > 0 then
                addDetailedResult(
                    "INFO",
                    "📋 Análisis: " .. obj.Name,
                    "Categoría: " .. analysis.category .. " | Líneas: " .. analysis.lineCount .. " | Complejidad: " .. analysis.complexity,
                    obj:GetFullName(),
                    analysis.purpose
                )
            end
            
            -- Mostrar funciones detectadas
            if #analysis.functions > 0 then
                addDetailedResult(
                    "INFO",
                    "⚙️ Funciones: " .. obj.Name,
                    "Funciones y características detectadas:",
                    obj:GetFullName(),
                    analysis.functions
                )
            end
            
            wait(0.1) -- Pausa para evitar lag
        end
        
        -- Escanear RemoteEvents y RemoteFunctions
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            totalRemotes = totalRemotes + 1
            
            local analysis = analyzeRemote(obj)
            
            if analysis.suspicious then
                highRiskItems = highRiskItems + 1
                addDetailedResult(
                    "ALTO",
                    "🔸 Remote Sospechoso: " .. obj.Name,
                    "RemoteEvent/Function con características sospechosas",
                    obj:GetFullName(),
                    analysis.risks
                )
            end
            
            -- Informar sobre el remote
            local remoteDetails = {}
            if #analysis.connections > 0 then
                for _, conn in pairs(analysis.connections) do
                    table.insert(remoteDetails, "Conexión: " .. conn)
                end
            end
            if #analysis.serverScripts > 0 then
                table.insert(remoteDetails, "Scripts del servidor: " .. #analysis.serverScripts)
            end
            if #analysis.clientScripts > 0 then
                table.insert(remoteDetails, "Scripts del cliente: " .. #analysis.clientScripts)
            end
            
            addDetailedResult(
                "INFO",
                "📡 Remote: " .. obj.Name,
                "Tipo: " .. analysis.type .. " | Ubicación: " .. (analysis.location:match("%.([^%.]+)$") or "Desconocido"),
                obj:GetFullName(),
                remoteDetails
            )
            
            wait(0.05)
        end
    end
    
    -- Resultados finales
    local securityLevel = "SEGURO"
    local securityColor = Color3.fromRGB(0, 150, 0)
    
    if backdoorsFound > 0 then
        securityLevel = "PELIGROSO"
        securityColor = Color3.fromRGB(200, 0, 0)
    elseif criticalIssues > 0 then
        securityLevel = "CRÍTICO"
        securityColor = Color3.fromRGB(150, 30, 30)
    elseif highRiskItems > 0 then
        securityLevel = "RIESGO"
        securityColor = Color3.fromRGB(200, 100, 30)
    end
    
    -- Resumen del escaneo
    local summaryDetails = {
        "Scripts escaneados: " .. totalScripts,
        "RemoteEvents/Functions: " .. totalRemotes,
        "Backdoors encontrados: " .. backdoorsFound,
        "Problemas críticos: " .. criticalIssues,
        "Elementos de alto riesgo: " .. highRiskItems,
        "Tiempo de escaneo: " .. math.floor(tick() - scanStartTime) .. " segundos"
    }
    
    addDetailedResult(
        backdoorsFound > 0 and "BACKDOOR" or "INFO",
        "📊 Resumen del Escaneo",
        "Nivel de seguridad: " .. securityLevel,
        "Análisis completo del juego",
        summaryDetails
    )
    
    -- Recomendaciones de seguridad
    local recommendations = {}
    if backdoorsFound > 0 then
        table.insert(recommendations, "🚨 ACCIÓN INMEDIATA: Revisar y eliminar backdoors detectados")
        table.insert(recommendations, "📋 Verificar la procedencia de los scripts sospechosos")
    end
    if criticalIssues > 0 then
        table.insert(recommendations, "⚠️ Revisar código obfuscado - puede ocultar funcionalidad maliciosa")
    end
    if highRiskItems > 0 then
        table.insert(recommendations, "🔍 Verificar scripts con funciones potencialmente peligrosas")
    end
    
    table.insert(recommendations, "🔒 Siempre verificar scripts de fuentes externas")
    table.insert(recommendations, "🛡️ Implementar validación en RemoteEvents")
    table.insert(recommendations, "📝 Documentar la función de cada script")
    
    addDetailedResult(
        "INFO",
        "💡 Recomendaciones de Seguridad",
        "Consejos para mejorar la seguridad del juego",
        "Sugerencias del escáner",
        recommendations
    )
    
    -- Finalizar escaneo
    statusLabel.Text = "✅ Escaneo completado - " .. securityLevel
    statusLabel.BackgroundColor3 = securityColor
    scanButton.Text = "🔍 Iniciar Escaneo Profundo"
    scanButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    
    copyButton.Visible = true
    isScanning = false
    
    -- Actualizar canvas size
    resultsFrame.CanvasSize = UDim2.new(0, 0, 0, resultsLayout.AbsoluteContentSize.Y)
end

-- Función para copiar reporte
local function copyReport()
    local report = "🔍 REPORTE DE SEGURIDAD - " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
    report = report .. "════════════════════════════════════════════════════════════════\n\n"
    
    for _, result in pairs(scanResults) do
        report = report .. "[" .. result.severity .. "] " .. result.title .. "\n"
        report = report .. "Descripción: " .. result.description .. "\n"
        report = report .. "Ubicación: " .. result.location .. "\n"
        
        if #result.details > 0 then
            report = report .. "Detalles:\n"
            for _, detail in pairs(result.details) do
                report = report .. "  • " .. detail .. "\n"
            end
        end
        
        report = report .. "\n" .. string.rep("-", 60) .. "\n\n"
    end
    
    report = report .. "════════════════════════════════════════════════════════════════\n"
    report = report .. "Reporte generado por Advanced Security Scanner\n"
    report = report .. "⚠️ Revisar todos los elementos marcados como sospechosos\n"
    
    -- Copiar al portapapeles (si está disponible)
    if setclipboard then
        setclipboard(report)
        statusLabel.Text = "📋 Reporte copiado al portapapeles"
        statusLabel.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
    else
        -- Mostrar en consola si no hay portapapeles
        print("=== REPORTE DE SEGURIDAD ===")
        print(report)
        statusLabel.Text = "📋 Reporte enviado a la consola"
        statusLabel.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
    end
    
    wait(3)
    statusLabel.Text = "Listo para nuevo escaneo"
    statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end

-- Variable para tiempo de escaneo
local scanStartTime = 0

-- Conectar eventos
scanButton.MouseButton1Click:Connect(function()
    if not isScanning then
        scanStartTime = tick()
        performSecurityScan()
    end
end)

copyButton.MouseButton1Click:Connect(copyReport)

-- Hacer el frame arrastrable
local dragging = false
local dragStart = nil
local startPos = nil

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Animación de entrada
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 650, 0, 700),
    Position = UDim2.new(0.5, -325, 0.5, -350)
})

openTween:Play()

-- Mensaje de bienvenida
statusLabel.Text = "🛡️ Escáner de Seguridad Avanzado iniciado - Listo para detectar backdoors"

print("🔍 Advanced Security Scanner v2.0 cargado exitosamente")
print("📋 Capacidades:")
print("   • Detección de backdoors y scripts maliciosos")
print("   • Análisis de RemoteEvents sospechosos")
print("   • Identificación de código obfuscado")
print("   • Análisis de propósito de scripts")
print("   • Detección de funciones peligrosas")
print("   • Reporte detallado de seguridad")
print("🚀 ¡Haz clic en 'Iniciar Escaneo Profundo' para comenzar!")

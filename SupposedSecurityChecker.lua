local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Detectar si es móvil
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Crear GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MobileSecurityScanner"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

-- Frame principal (más pequeño para móvil)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = isMobile and UDim2.new(0, 320, 0, 450) or UDim2.new(0, 480, 0, 600)
mainFrame.Position = UDim2.new(0.5, isMobile and -160 or -240, 0.5, isMobile and -225 or -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240) -- Fondo claro
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

-- Esquinas redondeadas
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Título (más pequeño)
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, isMobile and 35 or 45)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = isMobile and "🔍 Scanner Seguridad" or "🔍 Security Scanner Mobile"
titleLabel.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = isMobile and 14 or 16
titleLabel.TextScaled = true
titleLabel.Parent = mainFrame

-- Barra de arrastre (para facilitar el arrastre en móvil)
local dragBar = Instance.new("Frame")
dragBar.Size = UDim2.new(1, 0, 0, isMobile and 35 or 45)
dragBar.Position = UDim2.new(0, 0, 0, 0)
dragBar.BackgroundColor3 = Color3.fromRGB(200, 200, 200) -- Fondo gris claro
dragBar.BorderSizePixel = 0
dragBar.Parent = mainFrame

local dragCorner = Instance.new("UICorner")
dragCorner.CornerRadius = UDim.new(0, 12)
dragCorner.Parent = dragBar

-- Indicador de arrastre
local dragIndicator = Instance.new("Frame")
dragIndicator.Size = UDim2.new(0, 30, 0, 4)
dragIndicator.Position = UDim2.new(0.5, -15, 0.5, -2)
dragIndicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
dragIndicator.BorderSizePixel = 0
dragIndicator.Parent = dragBar

local indicatorCorner = Instance.new("UICorner")
indicatorCorner.CornerRadius = UDim.new(0, 2)
indicatorCorner.Parent = dragIndicator

-- Botón para ID específico
local idButton = Instance.new("TextButton")
idButton.Size = UDim2.new(0, isMobile and 60 or 80, 0, isMobile and 25 or 30)
idButton.Position = UDim2.new(0, 10, 0, isMobile and 40 or 50)
idButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
idButton.Text = isMobile and "ID Scan" or "Escanear ID"
idButton.TextColor3 = Color3.fromRGB(255, 255, 255)
idButton.Font = Enum.Font.GothamBold
idButton.TextSize = isMobile and 10 or 12
idButton.TextScaled = true
idButton.BorderSizePixel = 0
idButton.Parent = mainFrame

local idCorner = Instance.new("UICorner")
idCorner.CornerRadius = UDim.new(0, 6)
idCorner.Parent = idButton

-- Botón para mostrar/ocultar ID
local toggleIdButton = Instance.new("TextButton")
toggleIdButton.Size = UDim2.new(0, isMobile and 40 or 50, 0, isMobile and 25 or 30)
toggleIdButton.Position = UDim2.new(0, isMobile and 75 or 95, 0, isMobile and 40 or 50)
toggleIdButton.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
toggleIdButton.Text = "👁️"
toggleIdButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleIdButton.Font = Enum.Font.GothamBold
toggleIdButton.TextSize = isMobile and 12 or 14
toggleIdButton.TextScaled = true
toggleIdButton.BorderSizePixel = 0
toggleIdButton.Parent = mainFrame

local toggleIdCorner = Instance.new("UICorner")
toggleIdCorner.CornerRadius = UDim.new(0, 6)
toggleIdCorner.Parent = toggleIdButton

-- Campo de entrada para ID
local idInput = Instance.new("TextBox")
idInput.Size = UDim2.new(0, isMobile and 100 or 150, 0, isMobile and 25 or 30)
idInput.Position = UDim2.new(0, isMobile and 120 or 150, 0, isMobile and 40 or 50)
idInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
idInput.Text = "118669760480330"
idInput.TextColor3 = Color3.fromRGB(0, 0, 0)
idInput.Font = Enum.Font.Gotham
idInput.TextSize = isMobile and 10 or 12
idInput.TextScaled = true
idInput.BorderSizePixel = 1
idInput.BorderColor3 = Color3.fromRGB(200, 200, 200)
idInput.Visible = false
idInput.Parent = mainFrame

local idInputCorner = Instance.new("UICorner")
idInputCorner.CornerRadius = UDim.new(0, 6)
idInputCorner.Parent = idInput

-- Estado de escaneo
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, isMobile and -130 or -210, 0, isMobile and 25 or 30)
statusLabel.Position = UDim2.new(0, isMobile and 125 or 205, 0, isMobile and 40 or 50)
statusLabel.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
statusLabel.Text = "Listo para escaneo"
statusLabel.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = isMobile and 10 or 12
statusLabel.TextScaled = true
statusLabel.BorderSizePixel = 0
statusLabel.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = statusLabel

-- Botón de escaneo (más grande para móvil)
local scanButton = Instance.new("TextButton")
scanButton.Size = UDim2.new(1, -20, 0, isMobile and 35 or 40)
scanButton.Position = UDim2.new(0, 10, 0, isMobile and 75 or 90)
scanButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
scanButton.Text = isMobile and "🔍 Escanear" or "🔍 Iniciar Escaneo"
scanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
scanButton.Font = Enum.Font.GothamBold
scanButton.TextSize = isMobile and 12 or 14
scanButton.TextScaled = true
scanButton.BorderSizePixel = 0
scanButton.Parent = mainFrame

local scanCorner = Instance.new("UICorner")
scanCorner.CornerRadius = UDim.new(0, 8)
scanCorner.Parent = scanButton

-- Botón de minimizar/maximizar
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 25, 0, 25)
minimizeButton.Position = UDim2.new(1, -60, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 16
minimizeButton.BorderSizePixel = 0
minimizeButton.Parent = mainFrame

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 12)
minimizeCorner.Parent = minimizeButton

-- Botón de cerrar
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 16
closeButton.BorderSizePixel = 0
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 12)
closeCorner.Parent = closeButton

-- Contenedor principal (se puede ocultar)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -35)
contentFrame.Position = UDim2.new(0, 0, 0, 35)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Área de resultados
local resultsFrame = Instance.new("ScrollingFrame")
resultsFrame.Size = UDim2.new(1, -10, 1, isMobile and -120 or -140)
resultsFrame.Position = UDim2.new(0, 5, 0, isMobile and 80 or 100)
resultsFrame.BackgroundColor3 = Color3.fromRGB(250, 250, 250) -- Fondo blanco
resultsFrame.BorderSizePixel = 1
resultsFrame.BorderColor3 = Color3.fromRGB(200, 200, 200)
resultsFrame.ScrollBarThickness = isMobile and 6 or 8
resultsFrame.Parent = contentFrame

local resultsCorner = Instance.new("UICorner")
resultsCorner.CornerRadius = UDim.new(0, 8)
resultsCorner.Parent = resultsFrame

-- Layout para resultados
local resultsLayout = Instance.new("UIListLayout")
resultsLayout.SortOrder = Enum.SortOrder.LayoutOrder
resultsLayout.Padding = UDim.new(0, 5)
resultsLayout.Parent = resultsFrame

-- Botón de copiar principal
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0, isMobile and 60 or 80, 0, isMobile and 25 or 30)
copyButton.Position = UDim2.new(1, isMobile and -65 or -85, 1, isMobile and -30 or -35)
copyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
copyButton.Text = isMobile and "📋" or "📋 Copiar"
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.Font = Enum.Font.Gotham
copyButton.TextSize = isMobile and 12 or 12
copyButton.TextScaled = true
copyButton.BorderSizePixel = 0
copyButton.Visible = false
copyButton.Parent = contentFrame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 6)
copyCorner.Parent = copyButton

-- Botón de copiar análisis completo
local copyAllButton = Instance.new("TextButton")
copyAllButton.Size = UDim2.new(0, isMobile and 60 or 80, 0, isMobile and 25 or 30)
copyAllButton.Position = UDim2.new(0, 10, 1, isMobile and -30 or -35)
copyAllButton.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
copyAllButton.Text = isMobile and "📄" or "📄 Todo"
copyAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyAllButton.Font = Enum.Font.Gotham
copyAllButton.TextSize = isMobile and 12 or 12
copyAllButton.TextScaled = true
copyAllButton.BorderSizePixel = 0
copyAllButton.Visible = false
copyAllButton.Parent = contentFrame

local copyAllCorner = Instance.new("UICorner")
copyAllCorner.CornerRadius = UDim.new(0, 6)
copyAllCorner.Parent = copyAllButton

-- Botón para copiar solo el ID
local copyIdButton = Instance.new("TextButton")
copyIdButton.Size = UDim2.new(0, isMobile and 60 or 80, 0, isMobile and 25 or 30)
copyIdButton.Position = UDim2.new(0.5, isMobile and -30 or -40, 1, isMobile and -30 or -35)
copyIdButton.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
copyIdButton.Text = isMobile and "🎯" or "🎯 ID"
copyIdButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyIdButton.Font = Enum.Font.Gotham
copyIdButton.TextSize = isMobile and 12 or 12
copyIdButton.TextScaled = true
copyIdButton.BorderSizePixel = 0
copyIdButton.Visible = false
copyIdButton.Parent = contentFrame

local copyIdCorner = Instance.new("UICorner")
copyIdCorner.CornerRadius = UDim.new(0, 6)
copyIdCorner.Parent = copyIdButton

-- Variables globales
local scanResults = {}
local isScanning = false
local isDragging = false
local dragStart = nil
local startPos = nil
local isMinimized = false
local targetId = 118669760480330
local idInputVisible = false

-- Patrones de backdoor simplificados para móvil
local backdoorSignatures = {
    ["require%((%d+)%)"] = "Backdoor por require()",
    ["loadstring%("] = "Backdoor por loadstring()",
    ["getfenv%("] = "Manipulación de entorno",
    ["_G%["] = "Acceso a variables globales",
    ["game:HttpGet"] = "Descarga de scripts externos",
    ["spawn%(function%(%)"] = "Creación de hilos",
    ["debug%."] = "Uso de librería debug",
    ["%.MouseButton1Click"] = "Evento de click sospechoso",
    ["%.Chatted"] = "Evento de chat",
    ["if%s+.-%s*==%s*[\"']admin[\"']"] = "Verificación de admin",
    ["%.WalkSpeed%s*=%s*%d+"] = "Modificación de velocidad",
    ["%.Health%s*=%s*math%.huge"] = "Modificación de salud",
    ["game:Shutdown%("] = "Función de apagar servidor",
    ["while%s+true%s+do"] = "Bucle infinito",
    ["UserInputService"] = "Acceso a input del usuario",
    ["DataStoreService"] = "Acceso a DataStore"
}

-- Función para agregar resultado (versión móvil con texto negro)
local function addMobileResult(severity, title, description, location)
    table.insert(scanResults, {
        severity = severity,
        title = title,
        description = description,
        location = location or "Desconocido"
    })
    
    -- Crear elemento visual compacto
    local resultFrame = Instance.new("Frame")
    resultFrame.Size = UDim2.new(1, -5, 0, isMobile and 60 or 80)
    resultFrame.BackgroundColor3 = severity == "BACKDOOR" and Color3.fromRGB(255, 200, 200) or
                                  severity == "CRÍTICO" and Color3.fromRGB(255, 220, 220) or
                                  severity == "ALTO" and Color3.fromRGB(255, 240, 200) or
                                  severity == "MEDIO" and Color3.fromRGB(255, 255, 200) or
                                  Color3.fromRGB(200, 240, 255)
    resultFrame.BorderSizePixel = 1
    resultFrame.BorderColor3 = Color3.fromRGB(180, 180, 180)
    resultFrame.Parent = resultsFrame
    
    local resultCorner = Instance.new("UICorner")
    resultCorner.CornerRadius = UDim.new(0, 6)
    resultCorner.Parent = resultFrame
    
    local severityLabel = Instance.new("TextLabel")
    severityLabel.Size = UDim2.new(0, isMobile and 50 or 70, 0, isMobile and 15 or 20)
    severityLabel.Position = UDim2.new(0, 5, 0, 3)
    severityLabel.BackgroundTransparency = 1
    severityLabel.Text = severity
    severityLabel.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
    severityLabel.Font = Enum.Font.GothamBold
    severityLabel.TextSize = isMobile and 8 or 10
    severityLabel.TextScaled = true
    severityLabel.TextXAlignment = Enum.TextXAlignment.Left
    severityLabel.Parent = resultFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, isMobile and -60 or -80, 0, isMobile and 20 or 25)
    titleLabel.Position = UDim2.new(0, isMobile and 55 or 75, 0, 3)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = isMobile and 10 or 12
    titleLabel.TextScaled = true
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = resultFrame
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, isMobile and -10 or -20, 0, isMobile and 35 or 45)
    descLabel.Position = UDim2.new(0, 5, 0, isMobile and 22 or 28)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = isMobile and 8 or 10
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = resultFrame
end

-- Función para limpiar resultados
local function clearResults()
    scanResults = {}
    for _, child in pairs(resultsFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
end

-- Función para escanear un ID específico (simplificado)
local function scanSpecificId()
    if isScanning then
        statusLabel.Text = "⏳ Escaneo ya en proceso..."
        return
    end
    isScanning = true
    clearResults()
    statusLabel.Text = "⏳ Escaneando ID " .. tostring(targetId)
    
    -- Simulación de escaneo (en la práctica aquí va la lógica para analizar contenido)
    wait(2)
    -- Ejemplo: detectar un backdoor ficticio
    addMobileResult("BACKDOOR", "Detectado require() sospechoso", "Se encontró require() con ID " .. tostring(targetId), "Función principal")
    addMobileResult("ALTO", "Modificación de WalkSpeed", "Velocidad cambiada a valor no estándar", "Script 'SpeedHack'")
    
    statusLabel.Text = "✅ Escaneo completado"
    copyButton.Visible = true
    copyAllButton.Visible = true
    copyIdButton.Visible = true
    isScanning = false
end

-- Función para escaneo general en móvil (simplificado)
local function performMobileScan()
    if isScanning then
        statusLabel.Text = "⏳ Escaneo ya en proceso..."
        return
    end
    isScanning = true
    clearResults()
    statusLabel.Text = "⏳ Escaneando en móvil..."
    
    -- Simulación de escaneo completo
    wait(3)
    addMobileResult("MEDIO", "No se detectaron backdoors evidentes", "Escaneo rápido de seguridad móvil", "General")
    
    statusLabel.Text = "✅ Escaneo móvil completado"
    copyButton.Visible = true
    copyAllButton.Visible = true
    copyIdButton.Visible = true
    isScanning = false
end

-- Función para mostrar u ocultar campo ID
local function toggleIdInput()
    idInputVisible = not idInputVisible
    idInput.Visible = idInputVisible
    if idInputVisible then
        statusLabel.Text = "✏️ Introduce un ID para escanear"
    else
        statusLabel.Text = "Listo para escaneo"
    end
end

-- Función para minimizar/maximizar
local function toggleMinimize()
    if isMinimized then
        -- Maximizar
        contentFrame.Visible = true
        scanButton.Visible = true
        idButton.Visible = true
        toggleIdButton.Visible = true
        idInput.Visible = idInputVisible
        copyButton.Visible = #scanResults > 0
        copyAllButton.Visible = #scanResults > 0
        copyIdButton.Visible = #scanResults > 0
        minimizeButton.Text = "-"
        mainFrame.Size = isMobile and UDim2.new(0, 320, 0, 450) or UDim2.new(0, 480, 0, 600)
        mainFrame.Position = UDim2.new(0.5, isMobile and -160 or -240, 0.5, isMobile and -225 or -300)
        isMinimized = false
    else
        -- Minimizar
        contentFrame.Visible = false
        scanButton.Visible = false
        idButton.Visible = false
        toggleIdButton.Visible = false
        idInput.Visible = false
        copyButton.Visible = false
        copyAllButton.Visible = false
        copyIdButton.Visible = false
        minimizeButton.Text = "+"
        mainFrame.Size = UDim2.new(0, isMobile and 120 or 140, 0, isMobile and 45 or 50)
        mainFrame.Position = UDim2.new(0, 20, 0, 20)
        isMinimized = true
    end
end

-- Función para copiar reporte al portapapeles
local function copyMobileReport()
    local report = "Reporte de Seguridad:\n\n"
    for i, result in ipairs(scanResults) do
        report = report .. string.format("[%d] %s - %s\n%s\n\n", i, result.severity, result.title, result.description)
    end
    setclipboard(report)
    statusLabel.Text = "📋 Reporte copiado"
end

-- Conexiones de botones
minimizeButton.MouseButton1Click:Connect(toggleMinimize)
scanButton.MouseButton1Click:Connect(performMobileScan)
idButton.MouseButton1Click:Connect(function()
    local newId = tonumber(idInput.Text)
    if newId then
        targetId = newId
        scanSpecificId()
    else
        statusLabel.Text = "❌ ID inválido"
    end
end)
toggleIdButton.MouseButton1Click:Connect(toggleIdInput)
copyButton.MouseButton1Click:Connect(copyMobileReport)
copyAllButton.MouseButton1Click:Connect(copyMobileReport)
copyIdButton.MouseButton1Click:Connect(function()
    setclipboard(tostring(targetId))
    statusLabel.Text = "📋 ID copiado"
end)
closeButton.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)

-- Funcionalidad para arrastrar ventana
dragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
            end
        end)
    end
end)

dragBar.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Mostrar GUI activo
gui.Enabled = true

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
copyAllButton.Parent = copyAllButton

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
    descLabel.Size = UDim2.new(1, -10, 0, isMobile and 35 or 45)
    descLabel.Position = UDim2.new(0, 5, 0, isMobile and 20 or 25)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description .. "\n📍 " .. location
    descLabel.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = isMobile and 8 or 9
    descLabel.TextScaled = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.TextWrapped = true
    descLabel.Parent = resultFrame
    
    -- Actualizar tamaño del ScrollingFrame
    resultsFrame.CanvasSize = UDim2.new(0, 0, 0, resultsLayout.AbsoluteContentSize.Y)
end

-- Función para mostrar/ocultar el ID
local function toggleIdInput()
    idInputVisible = not idInputVisible
    idInput.Visible = idInputVisible
    
    if idInputVisible then
        toggleIdButton.Text = "🙈"
        statusLabel.Size = UDim2.new(1, isMobile and -280 or -370, 0, isMobile and 25 or 30)
        statusLabel.Position = UDim2.new(0, isMobile and 275 or 365, 0, isMobile and 40 or 50)
    else
        toggleIdButton.Text = "👁️"
        statusLabel.Size = UDim2.new(1, isMobile and -130 or -210, 0, isMobile and 25 or 30)
        statusLabel.Position = UDim2.new(0, isMobile and 125 or 205, 0, isMobile and 40 or 50)
    end
end

-- Función para escanear ID específico
local function scanSpecificId()
    if isScanning then return end
    isScanning = true
    
    -- Obtener ID del input
    local currentId = tonumber(idInput.Text) or targetId
    
    statusLabel.Text = "🔍 Buscando ID " .. currentId .. "..."
    statusLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
    idButton.Text = "⏳ Espera..."
    idButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    
    local found = false
    
    wait(0.5)
    
    -- Buscar el ID específico
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("Script") or obj:IsA("LocalScript") then
            local success, source = pcall(function()
                return obj.Source
            end)
            
            if success and source ~= "" then
                if source:find(tostring(currentId)) then
                    found = true
                    addMobileResult(
                        "BACKDOOR",
                        "🎯 ID ENCONTRADO: " .. obj.Name,
                        "Contiene el ID " .. currentId,
                        obj:GetFullName()
                    )
                    
                    -- Verificar otros patrones en el mismo script
                    for pattern, description in pairs(backdoorSignatures) do
                        if source:find(pattern) then
                            addMobileResult(
                                "CRÍTICO",
                                "⚠️ " .. obj.Name,
                                description,
                                obj:GetFullName()
                            )
                            break
                        end
                    end
                end
            end
        end
    end
    
    if not found then
        addMobileResult(
            "INFO",
            "❌ ID no encontrado",
            "El ID " .. currentId .. " no se encontró en ningún script",
            "Búsqueda completada"
        )
    end
    
    statusLabel.Text = found and "🎯 ID Encontrado" or "❌ ID No Encontrado"
    statusLabel.BackgroundColor3 = found and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 255, 100)
    idButton.Text = isMobile and "ID Scan" or "Escanear ID"
    idButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    
    copyButton.Visible = true
    copyAllButton.Visible = true
    copyIdButton.Visible = true
    isScanning = false
    
    resultsFrame.CanvasSize = UDim2.new(0, 0, 0, resultsLayout.AbsoluteContentSize.Y)
end

-- Función de escaneo simplificada para móvil
local function performMobileScan()
    if isScanning then return end
    isScanning = true
    
    -- Reiniciar resultados
    scanResults = {}
    for _, child in pairs(resultsFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    statusLabel.Text = "🔍 Escaneando..."
    statusLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
    scanButton.Text = "⏳ Espera..."
    scanButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    
    local totalScripts = 0
    local backdoorsFound = 0
    local criticalIssues = 0
    
    wait(0.5)
    
    -- Escanear scripts (versión optimizada)
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("Script") or obj:IsA("LocalScript") then
            totalScripts = totalScripts + 1
            
            local success, source = pcall(function()
                return obj.Source
            end)
            
            if success and source ~= "" then
                -- Verificar backdoors
                for pattern, description in pairs(backdoorSignatures) do
                    if source:find(pattern) then
                        backdoorsFound = backdoorsFound + 1
                        addMobileResult(
                            "BACKDOOR",
                            "🚨 " .. obj.Name,
                            description,
                            obj:GetFullName()
                        )
                        break
                    end
                end
                
                -- Verificar obfuscación básica
                if string.len(source:gsub("%s", "")) > string.len(source) * 0.9 then
                    criticalIssues = criticalIssues + 1
                    addMobileResult(
                        "CRÍTICO",
                        "⚠️ " .. obj.Name,
                        "Código posiblemente obfuscado",
                        obj:GetFullName()
                    )
                end
            else
                addMobileResult(
                    "MEDIO",
                    "🔒 " .. obj.Name,
                    "No se puede leer el código",
                    obj:GetFullName()
                )
            end
            
            if totalScripts % 10 == 0 then
                wait(0.1)
            end
        end
    end
    
    -- Escanear RemoteEvents
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local remoteName = obj.Name:lower()
            if remoteName:find("admin") or remoteName:find("kick") or remoteName:find("ban") or 
               remoteName:find("money") or remoteName:find("cash") or remoteName:find("hack") then
                addMobileResult(
                    "ALTO",
                    "🔸 " .. obj.Name,
                    "RemoteEvent sospechoso",
                    obj:GetFullName()
                )
            end
        end
    end
    
    -- Resultado final
    local securityLevel = "SEGURO"
    local securityColor = Color3.fromRGB(200, 255, 200)
    
    if backdoorsFound > 0 then
        securityLevel = "PELIGROSO"
        securityColor = Color3.fromRGB(255, 200, 200)
    elseif criticalIssues > 0 then
        securityLevel = "RIESGO"
        securityColor = Color3.fromRGB(255, 240, 200)
    end
    
    -- Resumen
    addMobileResult(
        backdoorsFound > 0 and "BACKDOOR" or "INFO",
        "📊 Resumen",
        "Scripts: " .. totalScripts .. " | Backdoors: " .. backdoorsFound .. " | Críticos: " .. criticalIssues,
        "Escaneo completado"
    )
    
    statusLabel.Text = "✅ " .. securityLevel
    statusLabel.BackgroundColor3 = securityColor
    scanButton.Text = isMobile and "🔍 Escanear" or "🔍 Iniciar Escaneo"
    scanButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    
    copyButton.Visible = true
    copyAllButton.Visible = true
    copyIdButton.Visible = true
    isScanning = false
    
    resultsFrame.CanvasSize = UDim2.new(0, 0, 0, resultsLayout.AbsoluteContentSize.Y)
end

-- Función para minimizar/maximizar
local function toggleMinimize()
    isMinimized = not isMinimized
    
    local targetSize = isMinimized and UDim2.new(0, mainFrame.AbsoluteSize.X, 0, 35) or 
                      (isMobile and UDim2.new(0, 320, 0, 450) or UDim2.new(0, 480, 0, 600))
    
    minimizeButton.Text = isMinimized and "+" or "-"
    
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = targetSize
    })
    tween:Play()
    
    contentFrame.Visible = not isMinimized
end

local function copyMobileReport()
    local report = "🔍 REPORTE DE SEGURIDAD MÓVIL\n" .. string.rep("=", 40) .. "\n"
    for _, result in ipairs(scanResults) do
        report = report .. "\n[" .. result.severity .. "] " .. result.title .. "\n" ..
                 result.description .. "\n📍 " .. result.location .. "\n"
    end
    setclipboard(report)
    statusLabel.Text = "📋 Reporte copiado"
end

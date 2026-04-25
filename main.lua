local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name:find("Ersultan") then v:Destroy() end
end

local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "Ersultan_V6"
Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local isMobile = UserInputService.TouchEnabled
-- Сделали размер более компактным, чтобы не было пустого места
local mainSize = isMobile and UDim2.new(0, 480, 0, 260) or UDim2.new(0, 520, 0, 300)
local mainPos = UDim2.new(0.5, -mainSize.X.Offset/2, 0.5, -mainSize.Y.Offset/2)

local Main = Instance.new("Frame", Screen)
Main.Name = "MainFrame"
Main.Size = mainSize
Main.Position = mainPos
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- САЙДБАР (Сделали чуть уже)
local SideBar = Instance.new("Frame", Main)
SideBar.Size = UDim2.new(0, 60, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
SideBar.BorderSizePixel = 0
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 12)

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -75, 1, -10)
Content.Position = UDim2.new(0, 75, 0, 5)
Content.BackgroundTransparency = 1

-- 1. СПИСОК СКРИПТОВ (РАБОЧИЙ)
local ScriptList = Instance.new("ScrollingFrame", Content)
ScriptList.Size = UDim2.new(0.3, 0, 0.75, 0)
ScriptList.Position = UDim2.new(0, 0, 0, 5)
ScriptList.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ScriptList.BorderSizePixel = 0
ScriptList.CanvasSize = UDim2.new(0, 0, 0, 0)
ScriptList.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", ScriptList)

local UIList = Instance.new("UIListLayout", ScriptList)
UIList.Padding = UDim.new(0, 5)
Instance.new("UIPadding", ScriptList).PaddingTop = UDim.new(0, 5)

-- 2. ПОЛЕ ВВОДА (Плотное прилегание)
local Editor = Instance.new("TextBox", Content)
Editor.Size = UDim2.new(0.68, 0, 0.75, 0)
Editor.Position = UDim2.new(0.32, 0, 0, 5)
Editor.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Editor.Text = ""
Editor.PlaceholderText = " Вставь скрипт..."
Editor.TextColor3 = Color3.new(1, 1, 1)
Editor.MultiLine = true
Editor.ClearTextOnFocus = false
Editor.TextXAlignment = "Left"
Editor.TextYAlignment = "Top"
Editor.TextWrapped = true
Instance.new("UICorner", Editor)
Instance.new("UIPadding", Editor).PaddingLeft = UDim.new(0, 8)

-- ФУНКЦИЯ СОЗДАНИЯ СЛОТА
local slotCount = 0
local function AddSlot(name, code)
    slotCount = slotCount + 1
    local btn = Instance.new("TextButton", ScriptList)
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = name or "Slot " .. slotCount
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    Instance.new("UICorner", btn)
    
    local savedCode = code or ""
    
    btn.MouseButton1Click:Connect(function()
        Editor.Text = savedCode
    end)
    
    -- Сохранение текста в слот при изменении в редакторе (опционально)
    Editor.FocusLost:Connect(function()
        if Editor.Text ~= "" then savedCode = Editor.Text end
    end)
end

-- НИЖНИЕ КНОПКИ
local function CreateBtn(txt, col, xPos, xSize)
    local b = Instance.new("TextButton", Content)
    b.Text = txt; b.BackgroundColor3 = col
    b.Size = UDim2.new(xSize, -5, 0, isMobile and 40 or 32)
    b.Position = UDim2.new(xPos, 0, 0.82, 5)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = isMobile and 14 or 12
    Instance.new("UICorner", b)
    return b
end

local ExecBtn = CreateBtn("EXECUTE", Color3.fromRGB(0, 170, 255), 0, 0.4)
local ClearBtn = CreateBtn("CLEAR", Color3.fromRGB(50, 50, 50), 0.4, 0.3)
local SlotBtn = CreateBtn("NEW SLOT", Color3.fromRGB(30, 100, 200), 0.7, 0.3)

-- КНОПКИ УПРАВЛЕНИЯ
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 25, 0, 25); Close.Position = UDim2.new(1, -30, 0, 5)
Close.Text = "X"; Close.BackgroundColor3 = Color3.fromRGB(180, 0, 0); Close.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Close)

local Min = Instance.new("TextButton", Main)
Min.Size = UDim2.new(0, 25, 0, 25); Min.Position = UDim2.new(1, -60, 0, 5)
Min.Text = "-"; Min.BackgroundColor3 = Color3.fromRGB(40, 40, 40); Min.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Min)

-- [ ЛОГИКА КНОПОК ]
SlotBtn.MouseButton1Click:Connect(function()
    AddSlot(nil, Editor.Text) -- Создает слот с текущим текстом из редактора
end)

ClearBtn.MouseButton1Click:Connect(function() Editor.Text = "" end)

ExecBtn.MouseButton1Click:Connect(function()
    local f, e = loadstring(Editor.Text)
    if f then pcall(f) else warn("Err: "..e) end
end)

local minSize = UDim2.new(0, 100, 0, 35)
local minimized = false
Min.MouseButton1Click:Connect(function()
    minimized = not minimized
    Content.Visible = not minimized
    SideBar.Visible = not minimized
    Main:TweenSize(minimized and minSize or mainSize, "Out", "Quad", 0.2, true)
end)

-- Добавим один слот по умолчанию
AddSlot("Main Slot", "-- Привет! Напиши код и нажми New Slot")

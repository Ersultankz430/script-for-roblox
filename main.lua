-- [[ EXECUTOR BY ERSULTANKZ430 V4.1 - FINAL BUILD ]]
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local isMobile = UserInputService.TouchEnabled
local baseSize = isMobile and UDim2.new(0, 450, 0, 300) or UDim2.new(0, 650, 0, 450)
local minSize = UDim2.new(0, 45, 0, 45)

-- База данни за слотовете
local SlotData = {}
local CurrentSlotID = nil
local slotCounter = 0

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Ersultankz_V4_Final"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -baseSize.X.Offset/2, 0.5, -baseSize.Y.Offset/2)
MainFrame.Size = baseSize
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- [[ HEADER / ЗАГЛАВИЕ ]]
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0.03, 0, 0, 0)
Title.Text = "Executor By Ersultankz430 v4"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.Code
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(0.85, 0, 0.07, 0)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(0.93, 0, 0.07, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Parent = Header

-- [[ EDITOR / РЕДАКТОР ]]
local CodeBox = Instance.new("TextBox")
CodeBox.Size = UDim2.new(0.68, 0, 0.68, 0)
CodeBox.Position = UDim2.new(0.03, 0, 0.13, 0)
CodeBox.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
CodeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
CodeBox.Text = ""
CodeBox.PlaceholderText = "-- Избери слот или създай нов..."
CodeBox.MultiLine = true
CodeBox.ClearTextOnFocus = false
CodeBox.TextXAlignment = Enum.TextXAlignment.Left
CodeBox.TextYAlignment = Enum.TextYAlignment.Top
CodeBox.Font = Enum.Font.Code
CodeBox.TextSize = 14
CodeBox.Parent = MainFrame

-- Автоматично записване на промените в текущия слот
CodeBox:GetPropertyChangedSignal("Text"):Connect(function()
    if CurrentSlotID then
        SlotData[CurrentSlotID] = CodeBox.Text
    end
end)

-- [[ SLOTS HUB / СПИСЪК СЪС СКРИПТОВЕ ]]
local ListFrame = Instance.new("ScrollingFrame")
ListFrame.Size = UDim2.new(0.24, 0, 0.68, 0)
ListFrame.Position = UDim2.new(0.73, 0, 0.13, 0)
ListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ListFrame.BorderSizePixel = 0
ListFrame.ScrollBarThickness = 3
ListFrame.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = ListFrame
ListLayout.Padding = UDim.new(0, 5)

-- [[ NAVIGATION BUTTONS / БУТОНИ ]]
local ExecBtn = Instance.new("TextButton")
ExecBtn.Size = UDim2.new(0.22, 0, 0, 40)
ExecBtn.Position = UDim2.new(0.03, 0, 0.85, 0)
ExecBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
ExecBtn.Text = "EXECUTE"
ExecBtn.TextColor3 = Color3.new(1,1,1)
ExecBtn.Font = Enum.Font.SourceSansBold
ExecBtn.Parent = MainFrame

local ClearBtn = Instance.new("TextButton") -- ВЪРНАТ БУТОН
ClearBtn.Size = UDim2.new(0.22, 0, 0, 40)
ClearBtn.Position = UDim2.new(0.26, 0, 0.85, 0)
ClearBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
ClearBtn.Text = "CLEAR"
ClearBtn.TextColor3 = Color3.new(1,1,1)
ClearBtn.Font = Enum.Font.SourceSansBold
ClearBtn.Parent = MainFrame

local AddSlotBtn = Instance.new("TextButton")
AddSlotBtn.Size = UDim2.new(0.22, 0, 0, 40)
AddSlotBtn.Position = UDim2.new(0.49, 0, 0.85, 0)
AddSlotBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
AddSlotBtn.Text = "NEW SLOT"
AddSlotBtn.TextColor3 = Color3.new(1,1,1)
AddSlotBtn.Font = Enum.Font.SourceSansBold
AddSlotBtn.Parent = MainFrame

-- [[ LOGIC / ФУНКЦИОНАЛНОСТ ]]

local function createSlot(initialText)
    slotCounter = slotCounter + 1
    local id = "Slot_" .. slotCounter
    SlotData[id] = initialText or ""
    
    local SlotBtn = Instance.new("TextButton")
    SlotBtn.Size = UDim2.new(1, -5, 0, 35)
    SlotBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SlotBtn.Text = "Script " .. slotCounter
    SlotBtn.TextColor3 = Color3.new(1,1,1)
    SlotBtn.Font = Enum.Font.Code
    SlotBtn.Parent = ListFrame
    
    local DelBtn = Instance.new("TextButton")
    DelBtn.Size = UDim2.new(0, 25, 0, 25)
    DelBtn.Position = UDim2.new(1, -30, 0, 5)
    DelBtn.Text = "X"
    DelBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    DelBtn.TextColor3 = Color3.new(1,1,1)
    DelBtn.Parent = SlotBtn

    -- Избор на слот
    SlotBtn.MouseButton1Click:Connect(function()
        CurrentSlotID = id
        CodeBox.Text = SlotData[id]
        
        -- Визуална индикация за активен слот
        for _, v in pairs(ListFrame:GetChildren()) do
            if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(40, 40, 40) end
        end
        SlotBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    end)

    -- Изтриване на слот
    DelBtn.MouseButton1Click:Connect(function()
        SlotData[id] = nil
        if CurrentSlotID == id then
            CurrentSlotID = nil
            CodeBox.Text = ""
        end
        SlotBtn:Destroy()
    end)
    
    -- Автоматично избиране на новосъздадения слот
    SlotBtn:MouseButton1Click()
end

-- Бутон CLEAR
ClearBtn.MouseButton1Click:Connect(function()
    CodeBox.Text = "" -- Тъй като има PropertyChangedSignal, това веднага ще изчисти и данните в SlotData
end)

AddSlotBtn.MouseButton1Click:Connect(function()
    createSlot("")
end)

ExecBtn.MouseButton1Click:Connect(function()
    local f, e = loadstring(CodeBox.Text)
    if f then task.spawn(f) else warn("Execution Error: "..tostring(e)) end
end)

-- Свиване / Минимизиране
local isMin = false
MinBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    local goalSize = isMin and minSize or baseSize
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = goalSize}):Play()
    
    for _, v in pairs(MainFrame:GetChildren()) do
        if v ~= Header and v ~= UICorner then v.Visible = not isMin end
    end
    Title.Visible = not isMin
    MinBtn.Text = isMin and "+" or "-"
end)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Инициализация с един празен слот
createSlot("-- Welcome to Executor By Ersultankz430 v4")

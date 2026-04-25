local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name:find("Ersultan") then v:Destroy() end
end

local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "Ersultan_V8_Final"
Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local isMobile = UserInputService.TouchEnabled
local mainSize = isMobile and UDim2.new(0, 480, 0, 260) or UDim2.new(0, 520, 0, 300)
local mainPos = UDim2.new(0.5, -mainSize.X.Offset/2, 0.5, -mainSize.Y.Offset/2)

-- [ СИСТЕМА ПЕРЕМЕЩЕНИЯ ]
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local Main = Instance.new("Frame", Screen)
Main.Size = mainSize; Main.Position = mainPos; Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0; Main.ClipsDescendants = true; Main.Active = true; MakeDraggable(Main)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local SideBar = Instance.new("Frame", Main)
SideBar.Size = UDim2.new(0, 60, 1, 0); SideBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22); SideBar.BorderSizePixel = 0
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 12)

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -75, 1, -20); Content.Position = UDim2.new(0, 75, 0, 10); Content.BackgroundTransparency = 1

local ScriptList = Instance.new("ScrollingFrame", Content)
ScriptList.Size = UDim2.new(0, 140, 0.78, 0); ScriptList.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ScriptList.AutomaticCanvasSize = "Y"; ScriptList.ScrollBarThickness = 2; ScriptList.BorderSizePixel = 0
Instance.new("UICorner", ScriptList)
local UIList = Instance.new("UIListLayout", ScriptList); UIList.Padding = UDim.new(0, 5)
Instance.new("UIPadding", ScriptList).PaddingLeft = UDim.new(0, 5); Instance.new("UIPadding", ScriptList).PaddingTop = UDim.new(0, 5)

-- [ РЕДАКТОР ]
local Editor = Instance.new("TextBox", Content)
Editor.Size = UDim2.new(1, -150, 0.78, 0); Editor.Position = UDim2.new(0, 150, 0, 0)
Editor.BackgroundColor3 = Color3.fromRGB(5, 5, 5); Editor.Text = ""
Editor.PlaceholderText = "EXECUTOR BY ERSULTANKZ430 V8.0"
Editor.PlaceholderColor3 = Color3.fromRGB(80, 80, 80)
Editor.TextColor3 = Color3.new(1, 1, 1); Editor.TextSize = 14
Editor.MultiLine = true; Editor.TextWrapped = true; Editor.ClearTextOnFocus = false
Editor.TextXAlignment = "Left"; Editor.TextYAlignment = "Top"; Editor.Font = Enum.Font.Code
Instance.new("UICorner", Editor); Instance.new("UIPadding", Editor).PaddingLeft = UDim.new(0, 10); Instance.new("UIPadding", Editor).PaddingTop = UDim.new(0, 10)

-- [ КНОПКИ СВЕРНУТЬ/ЗАКРЫТЬ ]
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 22, 0, 22); Close.Position = UDim2.new(1, -27, 0, 5); Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(180, 0, 0); Close.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", Close)
Close.MouseButton1Click:Connect(function() Screen:Destroy() end)

local Min = Instance.new("TextButton", Main)
Min.Size = UDim2.new(0, 22, 0, 22); Min.Position = UDim2.new(1, -54, 0, 5); Min.Text = "-"
Min.BackgroundColor3 = Color3.fromRGB(40, 40, 40); Min.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", Min)

-- [ ИСПРАВЛЕННАЯ ФУНКЦИЯ СЛОТОВ ]
local slotCount = 0
local function AddSlot(name, textToSave)
    slotCount = slotCount + 1
    local codeSnapshot = textToSave -- Фиксируем текст именно для этого слота
    
    local btn = Instance.new("TextButton", ScriptList)
    btn.Size = UDim2.new(0.92, 0, 0, 35); btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Text = name or "Slot " .. slotCount; btn.TextColor3 = Color3.new(1, 1, 1); btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        Editor.Text = codeSnapshot -- При нажатии вставляем сохраненную копию
    end)
end

local function CreateBtn(txt, col, xPos, xSize)
    local b = Instance.new("TextButton", Content)
    b.Text = txt; b.BackgroundColor3 = col; b.Size = UDim2.new(xSize, -5, 0, 35)
    b.Position = UDim2.new(xPos, 0, 0.82, 0); b.Font = Enum.Font.GothamBold; b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    return b
end

local ExecBtn = CreateBtn("EXECUTE", Color3.fromRGB(0, 170, 255), 0, 0.3)
local ClearBtn = CreateBtn("CLEAR", Color3.fromRGB(50, 50, 50), 0.3, 0.25)
local SlotBtn = CreateBtn("NEW SLOT", Color3.fromRGB(30, 100, 200), 0.55, 0.25)
local ColorBtn = CreateBtn("COLOR", Color3.fromRGB(120, 50, 180), 0.8, 0.2)

-- [ ЛОГИКА ]
ClearBtn.MouseButton1Click:Connect(function() Editor.Text = "" end)
ExecBtn.MouseButton1Click:Connect(function()
    local f, e = loadstring(Editor.Text); if f then pcall(f) else warn(e) end
end)

-- ГЛАВНОЕ ИСПРАВЛЕНИЕ ТУТ:
SlotBtn.MouseButton1Click:Connect(function()
    local textToRecord = Editor.Text -- Сначала берем текст
    AddSlot(nil, textToRecord)       -- Потом создаем слот с этим текстом
    Editor.Text = ""                 -- В конце очищаем
end)

ColorBtn.MouseButton1Click:Connect(function()
    local c = Color3.fromHSV(math.random(), 0.7, 0.9)
    ExecBtn.BackgroundColor3 = c; ClearBtn.BackgroundColor3 = c
    SlotBtn.BackgroundColor3 = c; ColorBtn.BackgroundColor3 = c
end)

local minimized = false
Min.MouseButton1Click:Connect(function()
    minimized = not minimized
    Content.Visible = not minimized; SideBar.Visible = not minimized
    Main:TweenSize(minimized and UDim2.new(0, 110, 0, 35) or mainSize, "Out", "Quad", 0.3, true)
end)

AddSlot("Main Slot", "-- Ersultan V9 Final")

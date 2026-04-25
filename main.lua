local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Очистка старых версий
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name:find("Ersultan") then v:Destroy() end
end

local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "Ersultan_V8_Official"
Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local isMobile = UserInputService.TouchEnabled
local mainSize = isMobile and UDim2.new(0, 400, 0, 250) or UDim2.new(0, 500, 0, 300)
local mainPos = UDim2.new(0.5, -mainSize.X.Offset/2, 0.5, -mainSize.Y.Offset/2)

-- [ ПЕРЕМЕЩЕНИЕ ]
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

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -20, 1, -20); Content.Position = UDim2.new(0, 10, 0, 10); Content.BackgroundTransparency = 1

-- [ РЕДАКТОР ]
local Editor = Instance.new("TextBox", Content)
Editor.Size = UDim2.new(1, 0, 0.75, 0)
Editor.BackgroundColor3 = Color3.fromRGB(5, 5, 5); Editor.Text = ""
-- ЗАМЕНА ТЕКСТА И ВЕРСИИ:
Editor.PlaceholderText = "EXECUTOR BY ERSULTANKZ430 V8.0"
Editor.PlaceholderColor3 = Color3.fromRGB(80, 80, 80)
Editor.TextColor3 = Color3.new(1, 1, 1); Editor.TextSize = 14
Editor.MultiLine = true; Editor.TextWrapped = true; Editor.ClearTextOnFocus = false
Editor.TextXAlignment = "Left"; Editor.TextYAlignment = "Top"; Editor.Font = Enum.Font.Code
Instance.new("UICorner", Editor); Instance.new("UIPadding", Editor).PaddingLeft = UDim.new(0, 12); Instance.new("UIPadding", Editor).PaddingTop = UDim.new(0, 12)

-- [ КНОПКИ СВЕРНУТЬ/ЗАКРЫТЬ ]
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 24, 0, 24); Close.Position = UDim2.new(1, -30, 0, 6); Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(180, 0, 0); Close.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", Close)
Close.MouseButton1Click:Connect(function() Screen:Destroy() end)

local Min = Instance.new("TextButton", Main)
Min.Size = UDim2.new(0, 24, 0, 24); Min.Position = UDim2.new(1, -60, 0, 6); Min.Text = "-"
Min.BackgroundColor3 = Color3.fromRGB(40, 40, 40); Min.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", Min)

-- [ КНОПКИ ДЕЙСТВИЯ ]
local function CreateBtn(txt, col, xPos, xSize)
    local b = Instance.new("TextButton", Content)
    b.Text = txt; b.BackgroundColor3 = col; b.Size = UDim2.new(xSize, -10, 0, 40)
    b.Position = UDim2.new(xPos, 0, 0.8, 0); b.Font = Enum.Font.GothamBold; b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    return b
end

local ExecBtn = CreateBtn("EXECUTE", Color3.fromRGB(0, 170, 255), 0, 0.5)
local ClearBtn = CreateBtn("CLEAR", Color3.fromRGB(50, 50, 50), 0.5, 0.5)

-- [ ЛОГИКА ]
ClearBtn.MouseButton1Click:Connect(function() Editor.Text = "" end)
ExecBtn.MouseButton1Click:Connect(function()
    local f, e = loadstring(Editor.Text); if f then pcall(f) else warn(e) end
end)

local minimized = false
Min.MouseButton1Click:Connect(function()
    minimized = not minimized
    Content.Visible = not minimized
    Main:TweenSize(minimized and UDim2.new(0, 120, 0, 36) or mainSize, "Out", "Quad", 0.3, true)
end)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")

local GUI_NAME = "Global Chat"

pcall(function()
	if CoreGui:FindFirstChild(GUI_NAME) then
		CoreGui[GUI_NAME]:Destroy()
	end
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
end)

local LocalPlayer = Players.LocalPlayer


local chatGuiv1 = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Frame = Instance.new("Frame")
local messageInput = Instance.new("TextBox")
local UICorner = Instance.new("UICorner")
local UIPadding = Instance.new("UIPadding")
local messageContainer = Instance.new("ScrollingFrame")
local Header = Instance.new("Frame")
local closeButton = Instance.new("TextButton")
local minimizeButton = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local UIDragDetector = Instance.new("UIDragDetector")
local UIListLayout = Instance.new("UIListLayout")

chatGuiv1.Name = GUI_NAME
chatGuiv1.Parent = CoreGui
chatGuiv1.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Parent = chatGuiv1
MainFrame.BackgroundTransparency = 1
MainFrame.Position = UDim2.new(0.03, 0, 0.17, 0)
MainFrame.Size = UDim2.new(0.23, 0, 0.3, 0)

Frame.Parent = MainFrame
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.fromRGB(33,33,33)
Frame.BackgroundTransparency = 0.2
Frame.Position = UDim2.new(0.5,0,0.57,0)
Frame.Size = UDim2.new(1,0,0.86,0)

messageInput.Parent = Frame
messageInput.AnchorPoint = Vector2.new(0.5,0.5)
messageInput.BackgroundColor3 = Color3.fromRGB(255,255,255)
messageInput.BorderSizePixel = 0
messageInput.Position = UDim2.new(0.5,0,0.9,0)
messageInput.Size = UDim2.new(0.97,0,0.13,0)
messageInput.PlaceholderText = "Click here to chat..."
messageInput.Text = ""
messageInput.TextColor3 = Color3.fromRGB(0,0,0)
messageInput.TextScaled = true
messageInput.TextWrapped = true

UICorner.Parent = messageInput
UIPadding.Parent = messageInput
UIPadding.PaddingBottom = UDim.new(0.2,0)
UIPadding.PaddingTop = UDim.new(0.2,0)

messageContainer.Parent = Frame
messageContainer.Active = true
messageContainer.BackgroundColor3 = Color3.fromRGB(13,13,13)
messageContainer.BackgroundTransparency = 0.2
messageContainer.BorderSizePixel = 0
messageContainer.Position = UDim2.new(0.02,0,0.03,0)
messageContainer.Size = UDim2.new(0.97,0,0.75,0)
messageContainer.CanvasSize = UDim2.new(0,0,0,0)
messageContainer.ScrollBarImageTransparency = 0.3

UIListLayout.Parent = messageContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0,4)

Header.Parent = MainFrame
Header.AnchorPoint = Vector2.new(0.5,0.5)
Header.BackgroundColor3 = Color3.fromRGB(13,13,13)
Header.Position = UDim2.new(0.5,0,0.07,0)
Header.Size = UDim2.new(1,0,0.14,0)

closeButton.Parent = Header
closeButton.AnchorPoint = Vector2.new(0.5,0.5)
closeButton.BackgroundColor3 = Color3.fromRGB(48,48,48)
closeButton.Position = UDim2.new(0.92,0,0.5,0)
closeButton.Size = UDim2.new(0.1,0,0.7,0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255,255,255)

minimizeButton.Parent = Header
minimizeButton.AnchorPoint = Vector2.new(0.5,0.5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(48,48,48)
minimizeButton.Position = UDim2.new(0.79,0,0.5,0)
minimizeButton.Size = UDim2.new(0.1,0,0.7,0)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255,255,255)

TextLabel.Parent = Header
TextLabel.AnchorPoint = Vector2.new(0,0.5)
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0.04,0,0.5,0)
TextLabel.Size = UDim2.new(0.52,0,0.6,0)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.Text = "Global chat v1.0"
TextLabel.TextColor3 = Color3.fromRGB(255,255,255)
TextLabel.TextScaled = true
TextLabel.TextWrapped = true

UIDragDetector.Parent = MainFrame
UIDragDetector.BoundingUI = Header

local messageIndex = 0

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	messageContainer.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y)
	messageContainer.CanvasPosition = Vector2.new(0, math.max(0, UIListLayout.AbsoluteContentSize.Y - messageContainer.AbsoluteWindowSize.Y))
end)

local function SendMessage(text)
	local DefaultChat = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
	local SayRequest = DefaultChat and DefaultChat:FindFirstChild("SayMessageRequest")

	if SayRequest then
		SayRequest:FireServer(text, "All")
	else
		local TCS = game:GetService("TextChatService")
		if TCS.ChatInputBarConfiguration.TargetTextChannel then
			TCS.ChatInputBarConfiguration.TargetTextChannel:SendAsync(text)
		end
	end
end

messageInput.FocusLost:Connect(function(enter)
	if enter and messageInput.Text ~= "" then
		SendMessage(messageInput.Text)
		messageInput.Text = ""
	end
end)

local function CreateMessageLabel(player, messageTxt)
	print(messageTxt)
	messageIndex += 1

	local message = Instance.new("TextLabel")
	message.Parent = messageContainer
	message.BackgroundTransparency = 1
	message.Size = UDim2.new(1,-6,0,24)
	message.Font = Enum.Font.SourceSans
	message.TextColor3 = Color3.fromRGB(255,255,255)
	message.TextScaled = true
	message.TextWrapped = true
	message.TextXAlignment = Enum.TextXAlignment.Left
	message.RichText = true
	message.LayoutOrder = messageIndex

	local statsText = "[?]"
	local nameColor = "#FFFFFF"
	local pName = "Sistema"

	if player then
		pName = player.Name
		statsText = string.format("[%sd]", player.AccountAge or 0)
		if player.TeamColor then
			local c = player.TeamColor.Color
			nameColor = string.format("#%02x%02x%02x", c.R*255, c.G*255, c.B*255)
		end
	else
		nameColor = "#FFFF00"
	end

	message.Text = string.format('<font color="#AAAAAA">%s</font> <font color="%s">[%s]:</font> %s', statsText, nameColor, pName, messageTxt)

	local messages = {}
	for _, child in ipairs(messageContainer:GetChildren()) do
		if child:IsA("TextLabel") then
			table.insert(messages, child)
		end
	end

	if #messages > 10 then
		table.sort(messages, function(a,b)
			return a.LayoutOrder < b.LayoutOrder
		end)
		messages[1]:Destroy()
	end
end

local function SetupListener()
	local ChatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
	if ChatEvents and ChatEvents:FindFirstChild("OnMessageDoneFiltering") then
		ChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(data)
			local player = Players:FindFirstChild(data.FromSpeaker)
			CreateMessageLabel(player, data.Message)
		end)
	else
		local function onChat(plr)
			plr.Chatted:Connect(function(msg)
				CreateMessageLabel(plr, msg)
			end)
		end
		for _, plr in pairs(Players:GetPlayers()) do
			onChat(plr)
		end
		Players.PlayerAdded:Connect(onChat)
	end
end

SetupListener()

local minimized = false

minimizeButton.Activated:Connect(function()
	minimized = not minimized
	minimizeButton.Text = minimized and "+" or "-"
	Frame.Visible = not Frame.Visible
end)

closeButton.Activated:Connect(function()
	chatGuiv1:Destroy()
end)

StarterGui:SetCore("SendNotification", {
	Title = "Welcome",
	Text = "Script originally created by Tonicosta\nEnhanced by GusRed - improved responsiveness and overall performance",
	Duration = 5
})
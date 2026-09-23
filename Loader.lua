--[[ 🔑 AUTO FARM HUB — LOADER (ไฟล์นี้แจกลูกค้าได้ ไม่มีสคริปต์จริงอยู่ข้างใน) ]]
local API       = "https://autofarm-key.susidfudiek.workers.dev"
local CONTACT   = "ซื้อ key ติดต่อ: youbroke_myheart
 / JaMal"
local SAVE_FILE = "AutoFarmHub_key.txt"
 
local Players     = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player      = Players.LocalPlayer
 
-- รหัสเครื่อง (ใช้ผูก key กับเครื่องแรกที่ใช้)
local function getHwid()
    local ok, id = pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
    if ok and id and id ~= "" then return id end
    ok, id = pcall(function() return gethwid() end)
    return (ok and id) and tostring(id) or "unknown"
end
 
-- ส่ง key ไปตรวจ → ถ้าผ่านจะได้สคริปต์จริงกลับมาแล้วรันเลย
local function tryKey(key)
    key = (key or ""):gsub("%s", ""):upper()
    if key == "" then return false, "กรุณาใส่ key" end
    local url = ("%s/script?key=%s&hwid=%s"):format(API, HttpService:UrlEncode(key), HttpService:UrlEncode(getHwid()))
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if not ok or type(res) ~= "string" then return false, "เชื่อมต่อเซิร์ฟเวอร์ไม่ได้" end
    if res:sub(1, 4) == "ERR:" then return false, res:sub(5) end
    local fn = loadstring(res)
    if not fn then return false, "โหลดสคริปต์ไม่สำเร็จ" end
    pcall(function() if writefile then writefile(SAVE_FILE, key) end end)
    task.spawn(fn)
    return true
end
 
-- เคยใส่ key ถูกแล้ว → เข้าเลยไม่ต้องกรอกใหม่
local saved
pcall(function() if isfile and isfile(SAVE_FILE) then saved = readfile(SAVE_FILE) end end)
if saved and saved ~= "" and tryKey(saved) then return end
 
-- ================= หน้าต่างกรอก key =================
local C = {
    Bg = Color3.fromRGB(14, 12, 20), Item = Color3.fromRGB(36, 33, 50), Stroke = Color3.fromRGB(50, 46, 68),
    Accent = Color3.fromRGB(150, 95, 255), Red = Color3.fromRGB(230, 90, 110),
    Text = Color3.fromRGB(240, 238, 248), Sub = Color3.fromRGB(150, 145, 170),
}
local function new(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props) do o[k] = v end
    o.Parent = parent
    return o
end
local function corner(p, r) new("UICorner", { CornerRadius = UDim.new(0, r) }, p) end
 
local pg = player:WaitForChild("PlayerGui")
local old = pg:FindFirstChild("AutoFarmKeyUI")
if old then old:Destroy() end
local gui = new("ScreenGui", { Name = "AutoFarmKeyUI", ResetOnSpawn = false }, pg)
 
local main = new("Frame", { Size = UDim2.new(0, 360, 0, 250), Position = UDim2.new(0.5, -180, 0.5, -125),
    BackgroundColor3 = C.Bg, BorderSizePixel = 0 }, gui)
corner(main, 12)
new("UIStroke", { Color = C.Stroke }, main)
 
new("TextLabel", { Size = UDim2.new(1, -50, 0, 40), Position = UDim2.new(0, 16, 0, 6), BackgroundTransparency = 1,
    RichText = true, Text = '<font color="#965FFF"><b>◆</b></font>  <b>Auto Farm Hub</b> | Key System',
    TextColor3 = C.Text, Font = Enum.Font.GothamBold, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left }, main)
 
local close = new("TextButton", { Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -38, 0, 10),
    BackgroundTransparency = 1, Text = "✕", TextColor3 = C.Text, Font = Enum.Font.GothamBold, TextSize = 16 }, main)
close.MouseButton1Click:Connect(function() gui:Destroy() end)
 
new("TextLabel", { Size = UDim2.new(1, -32, 0, 18), Position = UDim2.new(0, 16, 0, 46), BackgroundTransparency = 1,
    Text = CONTACT, TextColor3 = C.Sub, Font = Enum.Font.GothamMedium, TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd }, main)
 
local box = new("TextBox", { Size = UDim2.new(1, -32, 0, 38), Position = UDim2.new(0, 16, 0, 76),
    BackgroundColor3 = C.Item, Text = "", PlaceholderText = "ใส่ key เช่น AF-XXXX-XXXX-XXXX",
    PlaceholderColor3 = C.Sub, TextColor3 = C.Text, Font = Enum.Font.GothamBold, TextSize = 14,
    ClearTextOnFocus = false }, main)
corner(box, 8)
local boxStroke = new("UIStroke", { Color = C.Accent, Transparency = 1 }, box)
box.Focused:Connect(function() boxStroke.Transparency = 0 end)
box.FocusLost:Connect(function() boxStroke.Transparency = 1 end)
 
local confirm = new("TextButton", { Size = UDim2.new(1, -32, 0, 38), Position = UDim2.new(0, 16, 0, 124),
    BackgroundColor3 = C.Accent, Text = "ยืนยัน key", TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold, TextSize = 14, AutoButtonColor = true }, main)
corner(confirm, 8)
 
local status = new("TextLabel", { Size = UDim2.new(1, -32, 0, 34), Position = UDim2.new(0, 16, 0, 168),
    BackgroundTransparency = 1, Text = "", TextColor3 = C.Red, Font = Enum.Font.GothamMedium, TextSize = 13,
    TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left }, main)
 
local hwidBtn = new("TextButton", { Size = UDim2.new(1, -32, 0, 30), Position = UDim2.new(0, 16, 1, -40),
    BackgroundColor3 = C.Item, Text = "📋 คัดลอกรหัสเครื่อง (ส่งให้ผู้ขายตอนขอรีเซ็ต)", TextColor3 = C.Sub,
    Font = Enum.Font.GothamMedium, TextSize = 12 }, main)
corner(hwidBtn, 8)
hwidBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(getHwid())
        status.TextColor3, status.Text = C.Accent, "คัดลอกรหัสเครื่องแล้ว"
    else
        status.TextColor3, status.Text = C.Text, "รหัสเครื่อง: " .. getHwid()
    end
end)
 
local busy = false
local function submit()
    if busy then return end
    busy = true
    confirm.Text = "กำลังตรวจสอบ..."
    status.Text = ""
    local ok, err = tryKey(box.Text)
    if ok then
        gui:Destroy()
    else
        status.TextColor3, status.Text = C.Red, "❌ " .. (err or "ผิดพลาด")
        confirm.Text = "ยืนยัน key"
    end
    busy = false
end
confirm.MouseButton1Click:Connect(submit)
box.FocusLost:Connect(function(enter) if enter then submit() end end)
 

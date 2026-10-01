local DEBUG = false -- true: печатает в консоль, что скрипт нашёл в окне трейда
local COUNT_STACKS = false -- true: умножать цену на жёлтый счётчик количества в слоте (только для суммы в углу)

-- Имя оружия (маленькими буквами) = цена (supremevalues.com/mm2/godlies)
local VALUES = {
    -- Tier 4
    ["traveler's gun"]=5200, ["evergun"]=3450, ["evergreen"]=2625, ["constellation"]=2600,
    ["alienbeam"]=1950, ["turkey"]=1950, ["vampire's gun"]=1900, ["darkshot"]=1800,
    ["raygun"]=1800, ["darksword"]=1775, ["blossom"]=1360, ["sakura"]=1350,
    ["sunrise"]=1075, ["bauble"]=675, ["snowcannon"]=675, ["soul"]=670,
    ["spirit"]=660, ["sunset"]=650, ["rainbow gun"]=420, ["flora"]=410,
    ["rainbow"]=410, ["xenoknife"]=405, ["xenoshot"]=405, ["bloom"]=400,
    -- Tier 3
    ["heart wand"]=340, ["blizzard"]=305, ["snowstorm"]=305, ["ocean"]=275,
    ["waves"]=270, ["flowerwood gun"]=250, ["flowerwood"]=245, ["snow dagger"]=175,
    ["watergun"]=160, ["icecream"]=155, ["treat"]=155, ["sweet"]=150,
    ["borealis"]=145, ["australis"]=140, ["bat"]=125, ["beachy"]=90,
    ["sands"]=90, ["pearlshine"]=80, ["candy"]=80, ["pearl"]=75,
    ["ornament"]=70, ["heartblade"]=65,
    -- Tier 2
    ["phantom"]=35, ["red luger"]=35, ["spectre"]=35, ["candleflame"]=33,
    ["darkbringer"]=33, ["elderwood blade"]=33, ["elderwood revolver"]=33,
    ["iceblaster"]=33, ["makeshift"]=33, ["lightbringer"]=32, ["sugar"]=32,
    ["green luger"]=23,
    -- Tier 1
    ["hallowgun"]=20, ["nightblade"]=20, ["shark"]=20, ["icebeam"]=18,
    ["luger"]=18, ["plasmabeam"]=18, ["swirly gun"]=18, ["battleaxe ii"]=17,
    ["blaster"]=17, ["ginger luger"]=17, ["pixel"]=17, ["gemstone"]=15,
    ["iceflake"]=15, ["old glory"]=15, ["plasmablade"]=15, ["slasher"]=15,
    ["vampire's edge"]=15, ["cookiecane"]=13, ["deathshard"]=13, ["eternalcane"]=13,
    ["gingerblade"]=13, ["jinglegun"]=13, ["lugercane"]=13, ["minty"]=13,
    ["nebula"]=13, ["virtual"]=13, ["battleaxe"]=12, ["gingermint"]=12,
    ["swirly blade"]=12, ["chill"]=10, ["clockwork"]=10, ["fang"]=10,
    ["frostsaber"]=10, ["heat"]=10, ["spider"]=10, ["tides"]=10,
    -- Tier 0
    ["bioblade"]=8, ["eternal iii"]=8, ["eternal iv"]=8, ["hallow's blade"]=8,
    ["hallow's edge"]=8, ["handsaw"]=8, ["boneblade"]=7, ["eternal"]=7,
    ["eternal ii"]=7, ["frostbite"]=7, ["ghostblade"]=7, ["ice dragon"]=7,
    ["ice shard"]=7, ["prismatic"]=7, ["pumpking"]=7, ["saw"]=7, ["xmas"]=7,
    ["eggblade"]=5, ["flames"]=5, ["snowflake"]=5, ["winter's edge"]=5,
    ["peppermint"]=4, ["cookieblade"]=3, ["blue seer"]=3, ["purple seer"]=3,
    ["red seer"]=3, ["seer"]=3, ["orange seer"]=2, ["yellow seer"]=2,
}

-- Заголовки секций трейда (английский исходник и русский вариант)
local MINE_KEYS   = {"your offer", "ВАШЕ ПРЕДЛОЖЕНИЕ"}
local THEIRS_KEYS = {"their offer", "ИХ ПРЕДЛОЖЕНИЕ"}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

local function origText(l)
    return l:GetAttribute("orig") or l.Text
end

-- Элемент реально виден на экране
local function shown(o)
    local p = o
    while p and p ~= pg do
        if p:IsA("GuiObject") and not p.Visible then return false end
        if p:IsA("ScreenGui") and not p.Enabled then return false end
        p = p.Parent
    end
    return true
end

local function hasKey(label, keys)
    local t = origText(label)
    local tl = t:lower()
    for _, k in ipairs(keys) do
        if t:find(k, 1, true) or tl:find(k, 1, true) then return true end
    end
    return false
end

local function findHeader(keys)
    for _, d in ipairs(pg:GetDescendants()) do
        if d:IsA("TextLabel") and d.Name ~= "ValueTag" and hasKey(d, keys) and shown(d) then
            return d
        end
    end
end

-- Секция = самый большой родитель заголовка, который не содержит второй заголовок
local function sectionOf(h, other)
    local box = h
    while box.Parent and box.Parent ~= pg and not other:IsDescendantOf(box.Parent) do
        box = box.Parent
    end
    return box
end

local function offerValue(box)
    local total = 0
    for _, d in ipairs(box:GetDescendants()) do
        if d:IsA("TextLabel") and d.Name ~= "ValueTag" then
            local v = VALUES[d.Text:lower()]
            if v and shown(d) then total += v end
        end
    end
    return total
end

-- Ник собеседника в трейде написан в скобках: (Nick)
local function findNick(box)
    for _, d in ipairs(box:GetDescendants()) do
        if d:IsA("TextLabel") and d.Name ~= "ValueTag" then
            local t = origText(d)
            if t:match("^%(.+%)$") then return d end
        end
    end
end

-- Дописывает текст к подписи, не затирая оригинал
local function tag(label, extra)
    local o = origText(label)
    label:SetAttribute("orig", o)
    local new = o .. " " .. extra
    if label.Text ~= new then label.Text = new end
end

-- Интерфейс скрипта
local gui = Instance.new("ScreenGui")
gui.Name = "TradeCalc"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = (gethui and gethui()) or pg

local result = Instance.new("TextLabel")
result.Size = UDim2.new(0, 280, 0, 36)
result.Position = UDim2.new(0.5, -140, 0, 4)
result.BackgroundTransparency = 0.3
result.BackgroundColor3 = Color3.new(0, 0, 0)
result.TextColor3 = Color3.new(1, 1, 1)
result.TextScaled = true
result.Font = Enum.Font.GothamBold
result.Visible = false
result.Parent = gui

-- Надпись "Запущен": 5 секунд, потом плавно исчезает
local started = Instance.new("TextLabel")
started.Size = UDim2.new(0, 300, 0, 50)
started.Position = UDim2.new(0.5, -150, 0.4, 0)
started.BackgroundTransparency = 1
started.Text = "Запущен"
started.TextColor3 = Color3.fromRGB(80, 255, 80)
started.TextStrokeTransparency = 0.5
started.TextScaled = true
started.Font = Enum.Font.GothamBold
started.Parent = gui

task.spawn(function()
    task.wait(5)
    local tw = TweenService:Create(started, TweenInfo.new(1),
        {TextTransparency = 1, TextStrokeTransparency = 1})
    tw:Play()
    tw.Completed:Wait()
    started:Destroy()
end)

-- Цена над каждым годли (профиль, инвентарь, трейд)
task.spawn(function()
    while task.wait(1.5) do
        for _, d in ipairs(pg:GetDescendants()) do
            if d:IsA("TextLabel") and d.Name ~= "ValueTag" then
                local v = VALUES[d.Text:lower()]
                if v then
                    local t = d:FindFirstChild("ValueTag")
                    if not t then
                        t = Instance.new("TextLabel")
                        t.Name = "ValueTag"
                        t.Size = UDim2.new(1, 0, 1, 0)
                        t.Position = UDim2.new(0, 0, -1, 0)
                        t.BackgroundTransparency = 1
                        t.TextColor3 = Color3.fromRGB(120, 255, 170)
                        t.TextStrokeTransparency = 0.3
                        t.TextScaled = true
                        t.Font = Enum.Font.GothamBold
                        t.ZIndex = d.ZIndex + 5
                        t.Parent = d
                    end
                    local txt = v .. " вал."
                    if t.Text ~= txt then t.Text = txt end
                end
            end
        end
    end
end)

-- Сумма всех годли в профиле/инвентаре (в правом нижнем углу)
local inTrade = false

local function qtyOf(label)
    local root = label.Parent
    if not root then return 1 end
    for _, d in ipairs(root:GetChildren()) do
        if d:IsA("TextLabel") and d.Name ~= "ValueTag" and d ~= label then
            local n = d.Text:match("^[xX]?%s*(%d+)$")
            if n and shown(d) then return tonumber(n) end
        end
    end
    return 1
end

local totalLbl = Instance.new("TextLabel")
totalLbl.Size = UDim2.new(0, 300, 0, 34)
totalLbl.Position = UDim2.new(1, -310, 1, -44)
totalLbl.BackgroundTransparency = 0.3
totalLbl.BackgroundColor3 = Color3.new(0, 0, 0)
totalLbl.TextColor3 = Color3.fromRGB(255, 220, 60)
totalLbl.TextScaled = true
totalLbl.Font = Enum.Font.GothamBold
totalLbl.Visible = false
totalLbl.Parent = gui

task.spawn(function()
    local lastDbg = ""
    while task.wait(2) do
        local bestSum, bestCnt, bestGui = 0, 0, nil
        if not inTrade then
            for _, sg in ipairs(pg:GetChildren()) do
                if sg:IsA("ScreenGui") and sg.Enabled then
                    local sum, cnt, vis = 0, 0, false
                    for _, d in ipairs(sg:GetDescendants()) do
                        if d:IsA("TextLabel") and d.Name ~= "ValueTag" then
                            local v = VALUES[d.Text:lower()]
                            if v then
                                sum += v * (COUNT_STACKS and qtyOf(d) or 1)
                                cnt += 1
                                if not vis and shown(d) then vis = true end
                            end
                        end
                    end
                    -- показываем, только если окно реально открыто (видны предметы)
                    if vis and sum > bestSum then
                        bestSum, bestCnt, bestGui = sum, cnt, sg
                    end
                end
            end
        end
        if bestGui then
            totalLbl.Text = "Годли всего: " .. bestSum .. " вал. (" .. bestCnt .. " шт.)"
            totalLbl.Visible = true
            if DEBUG and lastDbg ~= bestGui.Name then
                lastDbg = bestGui.Name
                print("TOTAL from ScreenGui:", bestGui.Name, bestSum, bestCnt)
            end
        else
            totalLbl.Visible = false
        end
    end
end)

local printed = false
while task.wait(0.5) do
    local hm = findHeader(MINE_KEYS)
    local ht = findHeader(THEIRS_KEYS)
    inTrade = (hm and ht) and true or false
    if hm and ht then
        local mb, tb = sectionOf(hm, ht), sectionOf(ht, hm)
        local myV, thV = offerValue(mb), offerValue(tb)

        if DEBUG and not printed then
            printed = true
            print("MINE:", mb:GetFullName(), "THEIRS:", tb:GetFullName())
            for _, d in ipairs(tb:GetDescendants()) do
                if d:IsA("TextLabel") then
                    print(d:GetFullName(), "| Text:", d.Text, "| Content:", d.ContentText)
                end
            end
        end

        tag(hm, "[" .. myV .. " вал.]")
        local nick = findNick(tb)
        if nick then
            tag(nick, "[" .. thV .. " вал.]")
        else
            tag(ht, "[" .. thV .. " вал.]")
        end

        result.Visible = true
        if thV > myV then
            result.Text = "WIN +" .. (thV - myV) .. " (" .. myV .. " / " .. thV .. ")"
            result.TextColor3 = Color3.fromRGB(80, 255, 80)
        elseif thV < myV then
            result.Text = "LOSE -" .. (myV - thV) .. " (" .. myV .. " / " .. thV .. ")"
            result.TextColor3 = Color3.fromRGB(255, 80, 80)
        else
            result.Text = "EVEN (" .. myV .. " / " .. thV .. ")"
            result.TextColor3 = Color3.new(1, 1, 1)
        end
    else
        result.Visible = false
        printed = false
    end
end

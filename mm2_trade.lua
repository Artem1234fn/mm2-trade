local DEBUG = false -- true: выведет структуру трейд-окна в консоль

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

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

local function offerValue(frame)
    local total = 0
    if not frame then return total end
    for _, d in ipairs(frame:GetDescendants()) do
        if d:IsA("TextLabel") then
            local v = VALUES[d.Text:lower()]
            if v then total += v end
        end
    end
    return total
end

local function findByName(root, name)
    for _, d in ipairs(root:GetDescendants()) do
        if d.Name == name then return d end
    end
end

-- Дописывает " [число]" к нику, не затирая оригинал
local function tag(label, value)
    if not label then return end
    local orig = label:GetAttribute("orig") or label.Text
    label:SetAttribute("orig", orig)
    label.Text = orig .. " [" .. value .. " вал.]"
end

local function findNameLabel(root, nick)
    for _, d in ipairs(root:GetDescendants()) do
        if d:IsA("TextLabel") then
            local t = (d:GetAttribute("orig") or d.Text):lower()
            if t:find(nick:lower(), 1, true) then return d end
        end
    end
end

-- Плашка WIN / LOSE
local gui = Instance.new("ScreenGui")
gui.Name = "TradeCalc"
gui.ResetOnSpawn = false
gui.Parent = (gethui and gethui()) or pg
local result = Instance.new("TextLabel")
result.Size = UDim2.new(0, 260, 0, 40)
result.Position = UDim2.new(0.5, -130, 0, 10)
result.BackgroundTransparency = 0.3
result.BackgroundColor3 = Color3.new(0, 0, 0)
result.TextColor3 = Color3.new(1, 1, 1)
result.TextScaled = true
result.Visible = false
result.Parent = gui

-- Надпись "Запущен": 5 секунд на экране, потом плавно исчезает
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
    local tw = game:GetService("TweenService"):Create(
        started,
        TweenInfo.new(1),
        {TextTransparency = 1, TextStrokeTransparency = 1}
    )
    tw:Play()
    tw.Completed:Wait()
    started:Destroy()
end)

local printed = false
while task.wait(0.5) do
    local trade = pg:FindFirstChild("TradeGUI", true)
    if trade and trade.Enabled ~= false then
        if DEBUG and not printed then
            printed = true
            for _, d in ipairs(trade:GetDescendants()) do
                print(d:GetFullName(), d.ClassName, d:IsA("TextLabel") and d.Text or "")
            end
        end
        local mine   = findByName(trade, "YourOffer")
        local theirs = findByName(trade, "TheirOffer")
        local myV, thV = offerValue(mine), offerValue(theirs)

        tag(findNameLabel(mine or trade, lp.Name) or findNameLabel(mine or trade, lp.DisplayName), myV)
        -- ник партнёра: берём подпись над его оффером
        if theirs then
            for _, d in ipairs(theirs.Parent:GetDescendants()) do
                if d:IsA("TextLabel") and d.Text:lower():find("offer") == nil and d.Text ~= "" and not VALUES[d.Text:lower()] and (d.Name:lower():find("name") or d.Name:lower():find("user")) then
                    tag(d, thV)
                    break
                end
            end
        end

        result.Visible = true
        if thV > myV then
            result.Text = "WIN (+" .. (thV - myV) .. ")"
            result.TextColor3 = Color3.fromRGB(80, 255, 80)
        elseif thV < myV then
            result.Text = "LOSE (-" .. (myV - thV) .. ")"
            result.TextColor3 = Color3.fromRGB(255, 80, 80)
        else
            result.Text = "EVEN"
            result.TextColor3 = Color3.new(1, 1, 1)
        end
    else
        result.Visible = false
        printed = false
    end
end

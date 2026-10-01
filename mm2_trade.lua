local DEBUG = false -- true: печатает в консоль, что скрипт нашёл в окне трейда
local COUNT_STACKS = false -- true: умножать цену на жёлтый счётчик количества в слоте (только для суммы в углу)

-- Имя оружия (маленькими буквами) = цена (supremevalues.com/mm2/godlies)
local VALUES = {
    -- Годли (Tier 0-4)
    ["amerilaser"]=22, ["traveler's gun"]=5200, ["evergun"]=3450, ["evergreen"]=2625,
    ["constellation"]=2600, ["alienbeam"]=1950, ["turkey"]=1950, ["vampire's gun"]=1900,
    ["darkshot"]=1800, ["raygun"]=1800, ["darksword"]=1775, ["blossom"]=1360,
    ["sakura"]=1350, ["sunrise"]=1075, ["bauble"]=675, ["snowcannon"]=675,
    ["soul"]=670, ["spirit"]=660, ["sunset"]=650, ["rainbow gun"]=420,
    ["flora"]=410, ["rainbow"]=410, ["xenoknife"]=405, ["xenoshot"]=405,
    ["bloom"]=400, ["heart wand"]=340, ["blizzard"]=305, ["snowstorm"]=305,
    ["ocean"]=275, ["waves"]=270, ["flowerwood gun"]=250, ["flowerwood"]=245,
    ["snow dagger"]=175, ["watergun"]=160, ["icecream"]=155, ["treat"]=155,
    ["sweet"]=150, ["borealis"]=145, ["australis"]=140, ["bat"]=125,
    ["beachy"]=90, ["sands"]=90, ["pearlshine"]=80, ["candy"]=80,
    ["pearl"]=75, ["ornament"]=70, ["heartblade"]=65, ["phantom"]=35,
    ["red luger"]=35, ["spectre"]=35, ["candleflame"]=33, ["darkbringer"]=33,
    ["elderwood blade"]=33, ["elderwood revolver"]=33, ["iceblaster"]=33, ["makeshift"]=35,
    ["lightbringer"]=32, ["sugar"]=32, ["green luger"]=23, ["hallowgun"]=20,
    ["nightblade"]=20, ["shark"]=20, ["icebeam"]=18, ["luger"]=18,
    ["plasmabeam"]=18, ["swirly gun"]=18, ["battleaxe ii"]=17, ["blaster"]=17,
    ["ginger luger"]=17, ["pixel"]=17, ["gemstone"]=15, ["iceflake"]=15,
    ["old glory"]=15, ["plasmablade"]=15, ["slasher"]=15, ["vampire's edge"]=15,
    ["cookiecane"]=13, ["deathshard"]=13, ["eternalcane"]=13, ["gingerblade"]=13,
    ["jinglegun"]=13, ["lugercane"]=13, ["minty"]=13, ["nebula"]=13,
    ["virtual"]=13, ["battleaxe"]=12, ["gingermint"]=12, ["swirly blade"]=12,
    ["chill"]=10, ["clockwork"]=10, ["fang"]=10, ["frostsaber"]=10,
    ["heat"]=10, ["spider"]=10, ["tides"]=10, ["bioblade"]=8,
    ["eternal iii"]=8, ["eternal iv"]=8, ["hallow's blade"]=8, ["hallow's edge"]=8,
    ["handsaw"]=8, ["boneblade"]=7, ["eternal"]=7, ["eternal ii"]=7,
    ["frostbite"]=7, ["ghostblade"]=7, ["ice dragon"]=7, ["ice shard"]=7,
    ["prismatic"]=7, ["pumpking"]=7, ["saw"]=7, ["xmas"]=7,
    ["eggblade"]=5, ["flames"]=5, ["winter's edge"]=5, ["peppermint"]=4,
    ["cookieblade"]=3, ["blue seer"]=3, ["purple seer"]=3, ["red seer"]=3,
    ["seer"]=3, ["orange seer"]=2, ["yellow seer"]=2,
    -- Chroma
    ["c. traveler's gun"]=145000, ["chroma traveler's gun"]=145000, ["chroma evergun"]=56000, ["chroma evergreen"]=42000,
    ["chroma bauble"]=31000, ["c. constellation"]=29000, ["chroma constellation"]=29000, ["c. vampire's gun"]=29000,
    ["chroma vampire's gun"]=29000, ["chroma alienbeam"]=24000, ["chroma raygun"]=14250, ["chroma sunrise"]=10750,
    ["chroma snowcannon"]=7750, ["chroma sunset"]=7750, ["chroma blizzard"]=5500, ["chroma snowstorm"]=4250,
    ["chroma heart wand"]=4000, ["chroma watergun"]=2350, ["chroma snow dagger"]=2350, ["chroma ornament"]=1825,
    ["chroma treat"]=1775, ["chroma icecream"]=1750, ["chroma sweet"]=1725, ["chroma sands"]=1200,
    ["chroma beachy"]=1150, ["chroma darkbringer"]=65, ["chroma lightbringer"]=60, ["chroma luger"]=50,
    ["chroma candleflame"]=40, ["chroma laser"]=40, ["c. elderwood blade"]=37, ["chroma elderwood blade"]=37,
    ["chroma deathshard"]=35, ["chroma swirly gun"]=35, ["chroma cookiecane"]=32, ["chroma fang"]=32,
    ["chroma gemstone"]=32, ["chroma shark"]=32, ["chroma slasher"]=32, ["chroma heat"]=28,
    ["chroma seer"]=28, ["chroma gingerblade"]=27, ["chroma tides"]=27, ["chroma saw"]=23,
    ["chroma boneblade"]=22, ["chroma fire bat"]=3, ["chroma fire bear"]=3, ["chroma fire bunny"]=3,
    ["chroma fire cat"]=3, ["chroma fire dog"]=3, ["chroma fire fox"]=3, ["chroma fire pig"]=3,
    -- Ancient
    ["gingerscope"]=15750, ["traveler's axe"]=8000, ["celestial"]=2250, ["vampire's axe"]=1600,
    ["harvester"]=250, ["icepiercer"]=160, ["icebreaker"]=65, ["batwing"]=42,
    ["elderwood scythe"]=38, ["swirly axe"]=38, ["hallowscythe"]=30, ["logchopper"]=18,
    ["icewing"]=13,
    -- Legendary
    ["latte"]=140, ["spectral"]=50, ["traveler"]=50, ["aurora"]=45,
    ["vampire"]=45, ["beach"]=35, ["cotton candy"]=35, ["jd"]=28,
    ["golden"]=10, ["shadow"]=10, ["arctic"]=10, ["bunnies"]=8,
    ["cavern"]=7, ["broken"]=7, ["icedriller"]=5, ["nightsky"]=5,
    ["ginger"]=5, ["red scratch"]=4, ["witched"]=3, ["blue elite"]=3,
    ["green elite"]=3, ["santa's magic"]=3, ["santa's spirit"]=3, ["blue scratch"]=2,
    ["icecracker"]=1, ["red fire"]=1, ["chromatic"]=4, ["cursed"]=4,
    ["emerald"]=4, ["energized"]=4, ["frozen"]=4, ["predator"]=4,
    ["ripper"]=4, ["rupture"]=4, ["tree"]=4, ["web"]=4,
    ["green fire"]=4, ["aquarium"]=3, ["frostfade"]=3, ["midnight"]=3,
    ["palms"]=3, ["sparkle"]=3, ["bubbles"]=2, ["cupid"]=2,
    ["overseer"]=4, ["rune"]=4, ["universe"]=4, ["viper"]=4,
    ["fade"]=4, ["fusion"]=4, ["plasmite"]=4, ["shiny"]=4,
    ["splash"]=4, ["elite"]=3,
    -- Uncommon
    ["bones"]=210, ["brains"]=135, ["zombified"]=120, ["gingerbread"]=85,
    ["sweater"]=60, ["snowflake"]=55, ["branches"]=50, ["mummy (2017)"]=25,
    ["skulls"]=15, ["void"]=12, ["wrap"]=12, ["ghost"]=10,
    ["steel"]=8, ["gothic"]=7, ["zombie"]=10, ["snowman"]=25,
    ["hazard"]=5, ["lantern"]=3, ["webs"]=3, ["zombie (2023)"]=3,
    ["potion (2017)"]=3, ["tree (2021)"]=2, ["meltdown"]=2, ["pumpkin pie"]=2,
    ["lights"]=2, ["mummy"]=4, ["potion"]=2, ["cookie"]=1,
    ["moonlight"]=1, ["holly"]=1, ["moons"]=1, ["wolf"]=1,
    ["nutcracker"]=4, ["snowy"]=4, ["wrapped"]=30, ["gifted"]=4,
    ["pool noodle"]=1, ["mistletoe"]=3, ["gingerheart"]=2, ["love"]=2,
    ["rose"]=2, ["fireplace"]=1, ["forest"]=1, ["marble"]=1,
    ["melon"]=1, ["frosty"]=1, ["stockings"]=3, ["brains (2022)"]=3,
    ["carrot"]=4, ["clown"]=3, ["fall camo"]=3, ["floatie"]=3,
    ["monster"]=3, ["moons (2024)"]=3, ["painted"]=3, ["witchbrew"]=3,
    ["wraiths"]=3, ["stars"]=3, ["tree (2017)"]=3, ["checkers"]=3,
    ["decorated"]=3, ["eclipse"]=3, ["eyes"]=3, ["future"]=3,
    ["glowy"]=3, ["lava"]=3, ["meadow"]=3, ["night"]=3,
    ["polar bear"]=3, ["pool"]=3, ["popsicle"]=3, ["pumpkin (2025)"]=3,
    ["soda"]=3, ["treats"]=3, ["canes"]=3, ["floral"]=10,
    ["neopolitan"]=3, ["snowman (2023)"]=3, ["turtles"]=3, ["ghostly"]=2,
    ["ghosts"]=3, ["portal"]=2, ["pumpkin"]=2, ["donut"]=2,
    ["abduction"]=2, ["jellyfish"]=2, ["leaves"]=2, ["ornaments"]=2,
    ["paws"]=2, ["pumpkin patch"]=2, ["retro"]=2, ["snowman (2024)"]=2,
    ["starry"]=22, ["turtle"]=2, ["witch's brew"]=2, ["wreaths"]=2,
    -- Common
    ["doge"]=4, ["sketch"]=4, ["aburite"]=4, ["biogun"]=4,
    ["blue"]=4, ["bluesteel"]=4,
    -- Rare
    ["cane"]=525, ["dungeon"]=130, ["darkknife"]=70, ["silent night"]=50,
    ["swirl"]=20, ["watcher"]=20, ["magma"]=13, ["snowflakes"]=30,
    ["cowboy"]=10, ["laser"]=10, ["phaser"]=10, ["prince"]=10,
    ["ghostfire"]=10, ["ghastly"]=7, ["toxic"]=5, ["wraith"]=5,
    ["icicles"]=3, ["jack"]=3, ["snakebite"]=3, ["candy swirl"]=2,
    ["sun"]=2, ["bats"]=240, ["green marble"]=2, ["orange marble"]=2,
    ["darkgun"]=1, ["nuke"]=3, ["tree (2023)"]=3, ["bio"]=3,
    ["curse"]=3, ["frostflame"]=3, ["gingercookie"]=3, ["hologram"]=3,
    ["pop art"]=3, ["spearmint"]=3, ["xeno"]=3, ["pier"]=3,
    ["sunny"]=3, ["tropical"]=3, ["pine"]=85, ["rb knife"]=3,
    ["ice camo"]=2, ["logcutter"]=2, ["molten"]=2, ["kraken"]=2,
    ["ritual"]=2, ["snowglobe"]=2, ["heartbreak"]=2, ["neon"]=3,
    ["robot"]=2, ["sharky"]=2, ["sleigh"]=2, ["spring"]=2,
    ["yummy"]=2, ["gifts"]=95, ["ribbons"]=2, ["butterflies"]=1,
    ["heart"]=1, ["damp"]=1, ["nether"]=1, ["spitfire"]=1,
    ["storm"]=1, ["etched"]=1,
    -- Uncommon (дополнение)
    ["black"]=4, ["abstract"]=4, ["ace"]=4, ["bacon"]=4,
    ["galactic"]=4, ["galaxy"]=4, ["hacker"]=4, ["imbued"]=4,
    ["irevolver"]=4, ["korblox"]=4, ["krypto"]=4, ["musical"]=4,
    ["nightfire"]=4, ["nova"]=4, ["purple"]=4, ["space"]=4,
    ["spectrum"]=4, ["squire"]=4, ["vortex"]=4, ["deep sea"]=3,
    ["coal"]=15, ["moon"]=3, ["love (2023)"]=3, ["scarf"]=3,
    ["candied"]=3, ["cracks"]=3, ["darkness"]=3, ["fragile"]=2,
    ["gift bag"]=3, ["toy"]=2, ["trees"]=2, ["aliens"]=1,
    ["ghosts (2023)"]=1, ["pumpkin (2023)"]=1, ["vines"]=2, ["cat"]=1,
    ["ribbon"]=1, ["santa (2023)"]=1, ["penguin"]=1, ["reindeer"]=1,
    -- Vintage
    ["blood"]=8, ["america"]=7, ["splitter"]=3,
    -- Legendary (дополнение)
    ["nightstar"]=4,
    -- Common
    ["glitch1"]=65, ["glitch2"]=35, ["ghoulish"]=90, ["mummified"]=35,
    ["frosted"]=30, ["sparkle9"]=30, ["webbed"]=25, ["candycorn (2017)"]=25,
    ["ecto"]=25, ["elf (2018)"]=20, ["slimy"]=20, ["sparkle10"]=20,
    ["sparkle8"]=20, ["sparkle7"]=18, ["rip"]=17, ["elf"]=15,
    ["candy corn (2019)"]=12, ["pumpkin (2019)"]=12, ["prism"]=12, ["sparkle6"]=12,
    ["combat ii"]=10, ["sparkle4"]=10, ["skool"]=8, ["sparkle5"]=8,
    ["tailslide"]=7, ["alex"]=4, ["corl"]=4, ["denis"]=4,
    ["euro"]=4, ["ollie"]=4, ["sidewinder"]=4, ["sketchy"]=4,
    ["sub"]=4, ["apocalypse"]=4, ["bats (2020)"]=3, ["infected"]=4,
    ["ghosty"]=3, ["sparkle1"]=3, ["sparkle2"]=3, ["sparkle3"]=3,
    ["asteroid"]=2, ["grind"]=2, ["indy"]=2, ["slashed"]=1,
    ["grave"]=1, ["haunted"]=2, ["slime"]=1, ["2015"]=4,
    ["bunny"]=4, ["choco"]=4, ["egg"]=4, ["goo"]=4,
    ["hearts"]=4, ["ornament1"]=4, ["ornament2"]=4, ["passion"]=4,
    ["patrick"]=4, ["reptile"]=4, ["roses"]=4, ["santa"]=4,
    ["sweetheart"]=4, ["tulip"]=4, ["valentine"]=4, ["witch"]=4,
    ["hunter"]=3, ["tnl"]=3, ["candle"]=3, ["candy corn"]=3,
    ["carved"]=3, ["elf (2017)"]=3, ["present"]=3, ["present (2023)"]=3,
    ["santa (2018)"]=3, ["stickers"]=3, ["wavy"]=3, ["candles"]=3,
    ["carrots"]=3, ["cats"]=3, ["chick"]=3, ["clownfish"]=3,
    ["gifts (2024)"]=3, ["haunted (2025)"]=3, ["hot chocolate"]=3, ["igloo"]=3,
    ["ufos"]=3, ["giftwrap"]=2, ["eyeball"]=2, ["balloons"]=2,
    ["bells"]=2, ["cherries"]=2, ["coconut"]=2, ["dolphins"]=2,
    ["duckies"]=2, ["elf (2023)"]=2, ["fall"]=2, ["ghosts (2024)"]=2,
    ["hearts (2026)"]=2, ["plaid"]=2, ["sand"]=2, ["sandy"]=2,
    ["skyline"]=2, ["snowball"]=2, ["snowfall"]=2, ["spider (2023)"]=2,
    ["starfish"]=2, ["stockings (2024)"]=2, ["strawberries"]=2, ["striped"]=2,
    ["tourist"]=2, ["wood"]=2, ["xbox"]=2, ["8bit"]=1,
    ["aqua"]=1, ["big kill"]=1, ["bit"]=1, ["bleached"]=1,
    ["borders"]=1, ["brown"]=1, ["cardboard"]=1, ["cherry"]=1,
    ["clan"]=1, ["cold"]=1, ["combat"]=1, ["copper"]=1,
    ["eco"]=1, ["engraved"]=1, ["fallout"]=1, ["green"]=1,
    ["hardened"]=1, ["hl2"]=1, ["ice"]=1, ["infiltrator"]=1,
    ["iron"]=1, ["juice"]=1, ["leaf"]=1, ["linked"]=1,
    ["log"]=1, ["lovely"]=1, ["news"]=1, ["oily"]=1,
    ["orange"]=1, ["pea"]=1, ["shaded"]=1, ["slate"]=1,
    ["splat"]=1, ["splatter"]=1, ["stainless"]=1, ["star"]=1,
    ["static"]=1, ["whiteout"]=1, ["yellow"]=1,
    -- Unique
    ["corrupt"]=350,
}

-- Цена по названию (суффиксы "(Gun)" и "(Knife)" игнорируются)
local function valueOf(text)
    local s = text:lower()
    local v = VALUES[s]
    if v then return v end
    s = s:gsub("%s*%(gun%)$", ""):gsub("%s*%(knife%)$", "")
    return VALUES[s]
end

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
            local v = valueOf(d.Text)
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

-- Общие переменные для меток над предметами и суммы в углу
local SHOW_UNKNOWN = false -- true: предметы без цены в таблице помечаются "?" и считаются в углу
local inTrade = false
local invGui = nil   -- окно инвентаря/профиля, которое сейчас считаем
local sig = {}       -- "подпись" названий предметов: Name|Parent.Name

local function sigOf(d)
    return d.Name .. "|" .. (d.Parent and d.Parent.Name or "")
end

local function looksLikeName(d)
    return d.Text ~= "" and not d.Text:match("^[%d%s%p]+$")
end

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

local function makeTag(d)
    local t = Instance.new("TextLabel")
    t.Name = "ValueTag"
    t.Size = UDim2.new(1, 0, 1, 0)
    t.Position = UDim2.new(0, 0, -1, 0)
    t.BackgroundTransparency = 1
    t.TextStrokeTransparency = 0.3
    t.TextScaled = true
    t.Font = Enum.Font.GothamBold
    t.ZIndex = d.ZIndex + 5
    t.Parent = d
    return t
end

-- Цена над каждым годли (профиль, инвентарь, трейд)
task.spawn(function()
    while task.wait(1.5) do
        for _, d in ipairs(pg:GetDescendants()) do
            if d:IsA("TextLabel") and d.Name ~= "ValueTag" then
                local v = valueOf(d.Text)
                if v then
                    local t = d:FindFirstChild("ValueTag") or makeTag(d)
                    t.TextColor3 = Color3.fromRGB(120, 255, 170)
                    local txt = v .. " вал."
                    if t.Text ~= txt then t.Text = txt end
                elseif SHOW_UNKNOWN and invGui and looksLikeName(d)
                    and sig[sigOf(d)] and d:IsDescendantOf(invGui) then
                    local t = d:FindFirstChild("ValueTag") or makeTag(d)
                    t.TextColor3 = Color3.fromRGB(255, 160, 60)
                    if t.Text ~= "? вал." then t.Text = "? вал." end
                end
            end
        end
    end
end)

-- Сумма всех годли в профиле/инвентаре (в правом нижнем углу).
-- Копится по вкладкам: открой "Сезон 1", "Классический", "Праздник"... и сумма вырастет.
local totalLbl = Instance.new("TextLabel")
totalLbl.Size = UDim2.new(0, 340, 0, 34)
totalLbl.Position = UDim2.new(1, -350, 1, -44)
totalLbl.BackgroundTransparency = 0.3
totalLbl.BackgroundColor3 = Color3.new(0, 0, 0)
totalLbl.TextColor3 = Color3.fromRGB(255, 220, 60)
totalLbl.TextScaled = true
totalLbl.Font = Enum.Font.GothamBold
totalLbl.Visible = false
totalLbl.Parent = gui

task.spawn(function()
    local seen, unknown = {}, {}
    local lastGui, empty = nil, 0
    while task.wait(2) do
        local best, bestCnt = nil, 0
        if inTrade then
            totalLbl.Visible = false
        else
            for _, sg in ipairs(pg:GetChildren()) do
                if sg:IsA("ScreenGui") and sg.Enabled then
                    local cnt, vis = 0, false
                    for _, d in ipairs(sg:GetDescendants()) do
                        if d:IsA("TextLabel") and d.Name ~= "ValueTag" and valueOf(d.Text) then
                            cnt += 1
                            if not vis and shown(d) then vis = true end
                        end
                    end
                    if vis and cnt > bestCnt then best, bestCnt = sg, cnt end
                end
            end

            if best then
                empty = 0
                if best ~= lastGui then
                    seen, unknown = {}, {}
                    table.clear(sig)
                    lastGui = best
                end
                invGui = best
                for _, d in ipairs(best:GetDescendants()) do
                    if d:IsA("TextLabel") and d.Name ~= "ValueTag" then
                        local key = d.Text:lower()
                        local v = valueOf(d.Text)
                        if v then
                            sig[sigOf(d)] = true
                            local q = COUNT_STACKS and qtyOf(d) or 1
                            if not seen[key] or q > seen[key].q then seen[key] = {v = v, q = q} end
                        end
                    end
                end
                for _, d in ipairs(SHOW_UNKNOWN and best:GetDescendants() or {}) do
                    if d:IsA("TextLabel") and d.Name ~= "ValueTag" and not valueOf(d.Text)
                        and looksLikeName(d) and sig[sigOf(d)] and not unknown[d.Text] then
                        unknown[d.Text] = true
                        print("Нет цены в таблице:", d.Text)
                    end
                end

                local sum, cnt, unk = 0, 0, 0
                for _, e in pairs(seen) do sum += e.v * e.q; cnt += e.q end
                for _ in pairs(unknown) do unk += 1 end
                local txt = "Годли всего: " .. sum .. " вал. (" .. cnt .. " шт.)"
                if unk > 0 then txt = txt .. " +" .. unk .. " без цены" end
                totalLbl.Text = txt
                totalLbl.Visible = true
            else
                -- окно закрыто: сбрасываем накопленное только после нескольких пустых проверок
                empty += 1
                if empty >= 3 then
                    seen, unknown, lastGui, invGui = {}, {}, nil, nil
                    table.clear(sig)
                end
                totalLbl.Visible = false
            end
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

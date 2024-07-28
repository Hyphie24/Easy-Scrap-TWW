local filters = {}
local EasyScrap = EasyScrap
local NOT = '|cFFFF0000not|r'
local IS = '|cFF00FF00is|r'
local f


local invTypes = {}
invTypes['INVTYPE_RANGED'] = INVTYPE_RANGED
invTypes['INVTYPE_THROWN'] = INVTYPE_THROWN
invTypes['INVTYPE_ROBE'] = INVTYPE_ROBE
invTypes['INVTYPE_CHEST'] = INVTYPE_CHEST
invTypes['INVTYPE_WEAPONMAINHAND'] = INVTYPE_WEAPONMAINHAND
invTypes['INVTYPE_NECK'] = INVTYPE_NECK
invTypes['INVTYPE_QUIVER'] = INVTYPE_QUIVER
invTypes['INVTYPE_WEAPONMAINHAND_PET'] = INVTYPE_WEAPONMAINHAND_PET
invTypes['INVTYPE_RANGEDRIGHT'] = INVTYPE_RANGEDRIGHT
invTypes['INVTYPE_2HWEAPON'] = INVTYPE_2HWEAPON
invTypes['INVTYPE_HOLDABLE'] = INVTYPE_HOLDABLE
invTypes['INVTYPE_WEAPONOFFHAND'] = INVTYPE_WEAPONOFFHAND
invTypes['INVTYPE_SHIELD'] = INVTYPE_SHIELD
invTypes['INVTYPE_BAG'] = INVTYPE_BAG
invTypes['INVTYPE_TRINKET'] = INVTYPE_TRINKET
invTypes['INVTYPE_WAIST'] = INVTYPE_WAIST
invTypes['INVTYPE_HEAD'] = INVTYPE_HEAD
invTypes['INVTYPE_WEAPON'] = INVTYPE_WEAPON
invTypes['INVTYPE_NON_EQUIP'] = INVTYPE_NON_EQUIP
invTypes['INVTYPE_LEGS'] = INVTYPE_LEGS
invTypes['INVTYPE_RELIC'] = INVTYPE_RELIC
invTypes['INVTYPE_TABARD'] = INVTYPE_TABARD
invTypes['INVTYPE_FEET'] = INVTYPE_FEET
invTypes['INVTYPE_SHOULDER'] = INVTYPE_SHOULDER
invTypes['INVTYPE_CLOAK'] = INVTYPE_CLOAK
invTypes['INVTYPE_WRIST'] = INVTYPE_WRIST
invTypes['INVTYPE_HAND'] = INVTYPE_HAND
invTypes['INVTYPE_FINGER'] = INVTYPE_FINGER
invTypes['INVTYPE_BODY'] = INVTYPE_BODY


local function createFilterFrame(filterName, height)
    local f = CreateFrame('Frame', nil, EasyScrapEditFilterContentFrame)
    f:SetSize(f:GetParent():GetWidth()-14, height)
    
    f.deleteButton = CreateFrame('Button', nil, f, 'UIPanelCloseButton')
    f.deleteButton:SetPoint('TOPRIGHT', 2, 4)
    f.deleteButton:SetScale(0.7, 0.7)  
    f.deleteButton:SetScript('OnClick', function(self) EasyScrap.editFilterFrame.deleteRuleEntry(self.ruleID) end)   
    
    local header = CreateFrame('Frame', nil, f)
    header:SetSize(f:GetWidth(), 18)
    header:SetPoint('TOP')

    header.text = header:CreateFontString()
    header.text:SetFontObject("GameFontNormal")
    header.text:SetText(filterName)
    header.text:SetPoint('CENTER', f, 'TOP', 0, 0)
    local r,g,b = header.text:GetTextColor()
    
    f.bodyText = f:CreateFontString()
    f.bodyText:SetFontObject("GameFontNormalSmall")
    f.bodyText:SetPoint('TOPLEFT', 8, -12)
    f.bodyText:SetTextColor(1, 1, 1)
    f.bodyText:SetJustifyH("LEFT")
    
    local lines = {}  
    lines.tl = f:CreateTexture(nil, 'BACKGROUND')
    lines.tl:SetColorTexture(r,g,b, 0.8)
    lines.tl:SetPoint('TOPLEFT', f, 'TOPLEFT', 2, 1)
    lines.tl:SetPoint('BOTTOMRIGHT', header.text, 'LEFT', -2, 0)

    lines.tr = f:CreateTexture(nil, 'BACKGROUND')
    lines.tr:SetColorTexture(r,g,b, 0.8)
    lines.tr:SetPoint('TOPRIGHT', f, 'TOPRIGHT', -2, 1)
    lines.tr:SetPoint('BOTTOMLEFT', header.text, 'RIGHT', 2, 0)
    
    lines.l = f:CreateTexture(nil, 'BACKGROUND')
    lines.l:SetColorTexture(r,g,b, 0.8)
    lines.l:SetPoint('TOPLEFT', lines.tl, 'TOPLEFT', 0, 0) 
    lines.l:SetPoint('BOTTOMRIGHT', f, 'BOTTOMLEFT', 1, 0) 
 
    lines.r = f:CreateTexture(nil, 'BACKGROUND')
    lines.r:SetColorTexture(r,g,b, 0.8)
    lines.r:SetPoint('TOPRIGHT', lines.tr, 'TOPRIGHT', 0, 0) 
    lines.r:SetPoint('BOTTOMLEFT', f, 'BOTTOMRIGHT', -1, 0) 
    
    lines.b = f:CreateTexture(nil, 'BACKGROUND')
    lines.b:SetColorTexture(r,g,b, 0.8)
    lines.b:SetPoint('TOPLEFT', lines.l, 'BOTTOMLEFT', 0, 1) 
    lines.b:SetPoint('BOTTOMRIGHT', lines.r, 'BOTTOMRIGHT', 0, 0) 

    return f
end


--[[---------------------------------------------------------------------------------------------------------------------------------------
ITEMLEVEL
--]]---------------------------------------------------------------------------------------------------------------------------------------
filters['itemLevel'] = {}
filters['itemLevel'].menuText = 'Item Level'
filters['itemLevel'].data = {0, 999}
filters['itemLevel'].filterMessage = 'Item level is not in range of 0 to 999'

f = createFilterFrame('Item Level', 54)
f.bodyText:SetText('Minimum item level:')
f.bodyText:SetPoint('TOPLEFT', 8, -14)
f.bodyText2 = f:CreateFontString()
f.bodyText2:SetFontObject("GameFontNormalSmall")
f.bodyText2:SetPoint('TOPLEFT', 8, -36)
f.bodyText2:SetTextColor(1, 1, 1)
f.bodyText2:SetText("Maximum item level: ")
f.bodyText2:SetJustifyH("LEFT")

f.customData = {}
f.customData[1] = CreateFrame('EditBox', 'ar2', f, 'EasyScrapEditBoxTemplate')
f.customData[1]:SetPoint('LEFT', f.bodyText, 'LEFT', 120, 0)
f.customData[1]:SetMaxLetters(3)
f.customData[1]:SetNumeric(true)

f.customData[2] = CreateFrame('EditBox', 'ar1', f, 'EasyScrapEditBoxTemplate')
f.customData[2]:SetPoint('LEFT', f.bodyText2, 'LEFT', 120, 0)
f.customData[2]:SetMaxLetters(3)
f.customData[2]:SetNumeric(true)

function f:populateData(data)
    self.customData[1]:SetText(tostring(data[1]))
    self.customData[2]:SetText(tostring(data[2]))
end

function f:saveData(customFilterIndex)
    local minLevel = tonumber(self.customData[1]:GetText())
    if not minLevel then minLevel = 0 DEFAULT_CHAT_FRAME:AddMessage('Easy Scrap: No minimum item level found, defaulted to 0.') end
    local maxLevel = tonumber(self.customData[2]:GetText())
    if not maxLevel then maxLevel = 999 DEFAULT_CHAT_FRAME:AddMessage('Easy Scrap: No maximum item level found, defaulted to 999.') end
    EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[1] = minLevel
    EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[2] = maxLevel
end

filters['itemLevel'].frame = f

filters['itemLevel'].filterFunction = function(itemIndex, filterIndex)
    local item = EasyScrap.scrappableItems[itemIndex]
    local filterData = EasyScrap.saveData.customFilters[EasyScrap.activeFilterID].rules[filterIndex].data

    local isMatch = (item.itemLevel >= filterData[1] and item.itemLevel <= filterData[2])
    if not isMatch then filters['itemLevel'].filterMessage = 'Item level is not in range of '..filterData[1]..' to '..filterData[2]..'.' end
    return isMatch
end


--[[---------------------------------------------------------------------------------------------------------------------------------------
ITEM VENDOR VALUE
--]]---------------------------------------------------------------------------------------------------------------------------------------
filters['sellPrice'] = {}
filters['sellPrice'].menuText = 'Sell Price'
filters['sellPrice'].data = {0, 999999}
filters['sellPrice'].filterMessage = 'sell price is not within range.'

f = createFilterFrame('Sell Price', 54)
f.bodyText:SetText('Minimum sell price:')
f.bodyText:SetPoint('TOPLEFT', 8, -14)
f.bodyText2 = f:CreateFontString()
f.bodyText2:SetFontObject("GameFontNormalSmall")
f.bodyText2:SetPoint('TOPLEFT', 8, -36)
f.bodyText2:SetTextColor(1, 1, 1)
f.bodyText2:SetText("Maximum sell price: ")
f.bodyText2:SetJustifyH("LEFT")


local function getCoins(money)
	local gold = math.floor(money / (COPPER_PER_SILVER * SILVER_PER_GOLD))
	local silver = math.floor((money - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER)
	local copper = money % COPPER_PER_SILVER
	return gold, silver, copper
end

local function createSellValue(g,s,c)
    local gold = g * (COPPER_PER_SILVER * SILVER_PER_GOLD)
    local silver = s * (COPPER_PER_SILVER)
    local copper = c
    return gold+silver+copper
end

f.customData = {}
f.customData[1] = CreateFrame('EditBox', nil, f, 'EasyScrapEditBoxTemplate')
f.customData[1]:SetPoint('LEFT', f.bodyText, 'LEFT', 112, 0)
f.customData[1]:SetWidth(20)
f.customData[1]:SetMaxLetters(2)
f.customData[1]:SetNumeric(true)
f.customData[1].t = f.customData[1]:CreateTexture(nil, 'ARTWORK')
f.customData[1].t:SetTexture([[Interface\MoneyFrame\UI-MoneyIcons]])
f.customData[1].t:SetTexCoord(0,0.25,0,1)
f.customData[1].t:SetSize(12, 12)
f.customData[1].t:SetPoint('RIGHT', 15, 0)

f.customData[2] = CreateFrame('EditBox', nil, f, 'EasyScrapEditBoxTemplate')
f.customData[2]:SetPoint('LEFT', f.customData[1], 'RIGHT', 24, 0)
f.customData[2]:SetMaxLetters(2)
f.customData[2]:SetWidth(20)
f.customData[2]:SetNumeric(true)
f.customData[2].t = f.customData[2]:CreateTexture(nil, 'ARTWORK')
f.customData[2].t:SetTexture([[Interface\MoneyFrame\UI-MoneyIcons]])
f.customData[2].t:SetTexCoord(0.25,0.5,0,1)
f.customData[2].t:SetSize(12, 12)
f.customData[2].t:SetPoint('RIGHT', 15, 0)

f.customData[3] = CreateFrame('EditBox', nil, f, 'EasyScrapEditBoxTemplate')
f.customData[3]:SetPoint('LEFT', f.customData[2], 'RIGHT', 24, 0)
f.customData[3]:SetMaxLetters(2)
f.customData[3]:SetWidth(20)
f.customData[3]:SetNumeric(true)
f.customData[3].t = f.customData[3]:CreateTexture(nil, 'ARTWORK')
f.customData[3].t:SetTexture([[Interface\MoneyFrame\UI-MoneyIcons]])
f.customData[3].t:SetTexCoord(0.5,0.75,0,1)
f.customData[3].t:SetSize(12, 12)
f.customData[3].t:SetPoint('RIGHT', 15, 0)

f.customData[4] = CreateFrame('EditBox', nil, f, 'EasyScrapEditBoxTemplate')
f.customData[4]:SetPoint('LEFT', f.bodyText2, 'LEFT', 112, 0)
f.customData[4]:SetMaxLetters(2)
f.customData[4]:SetWidth(20)
f.customData[4]:SetNumeric(true)
f.customData[4].t = f.customData[4]:CreateTexture(nil, 'ARTWORK')
f.customData[4].t:SetTexture([[Interface\MoneyFrame\UI-MoneyIcons]])
f.customData[4].t:SetTexCoord(0,0.25,0,1)
f.customData[4].t:SetSize(12, 12)
f.customData[4].t:SetPoint('RIGHT', 15, 0)

f.customData[5] = CreateFrame('EditBox', nil, f, 'EasyScrapEditBoxTemplate')
f.customData[5]:SetPoint('LEFT', f.customData[4], 'RIGHT', 24, 0)
f.customData[5]:SetMaxLetters(2)
f.customData[5]:SetWidth(20)
f.customData[5]:SetNumeric(true)
f.customData[5].t = f.customData[5]:CreateTexture(nil, 'ARTWORK')
f.customData[5].t:SetTexture([[Interface\MoneyFrame\UI-MoneyIcons]])
f.customData[5].t:SetTexCoord(0.25,0.5,0,1)
f.customData[5].t:SetSize(12, 12)
f.customData[5].t:SetPoint('RIGHT', 15, 0)

f.customData[6] = CreateFrame('EditBox', nil, f, 'EasyScrapEditBoxTemplate')
f.customData[6]:SetPoint('LEFT', f.customData[5], 'RIGHT', 24, 0)
f.customData[6]:SetMaxLetters(2)
f.customData[6]:SetWidth(20)
f.customData[6]:SetNumeric(true)
f.customData[6].t = f.customData[6]:CreateTexture(nil, 'ARTWORK')
f.customData[6].t:SetTexture([[Interface\MoneyFrame\UI-MoneyIcons]])
f.customData[6].t:SetTexCoord(0.5,0.75,0,1)
f.customData[6].t:SetSize(12, 12)
f.customData[6].t:SetPoint('RIGHT', 15, 0)


function f:populateData(data)
    local g,s,c = getCoins(data[1])
    self.customData[1]:SetText(g)
    self.customData[2]:SetText(s)
    self.customData[3]:SetText(c)
    g,s,c = getCoins(data[2])
    self.customData[4]:SetText(g)
    self.customData[5]:SetText(s)
    self.customData[6]:SetText(c)
end

function f:saveData(customFilterIndex)
    local g = tonumber(self.customData[1]:GetText())
    if not g then g = 0 end
    local s = tonumber(self.customData[2]:GetText())
    if not s then s = 0 end
    local c = tonumber(self.customData[3]:GetText())
    if not c then c = 0 end
    local d1 = createSellValue(g,s,c)

    g = tonumber(self.customData[4]:GetText())
    if not g then g = 0 end
    s = tonumber(self.customData[5]:GetText())
    if not s then s = 0 end
    c = tonumber(self.customData[6]:GetText())
    if not c then c = 0 end
    local d2 = createSellValue(g,s,c)
    if d2 < d1 then d2 = d1 end
    
    EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[1] = d1
    EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[2] = d2
end

filters['sellPrice'].frame = f

filters['sellPrice'].filterFunction = function(itemIndex, filterIndex)
    local item = EasyScrap.scrappableItems[itemIndex]
    local filterData = EasyScrap.saveData.customFilters[EasyScrap.activeFilterID].rules[filterIndex].data

    return (item.itemSellPrice >= filterData[1] and item.itemSellPrice <= filterData[2])
end

--[[---------------------------------------------------------------------------------------------------------------------------------------
ITEMNAME
--]]---------------------------------------------------------------------------------------------------------------------------------------
filters['itemName'] = {}
filters['itemName'].menuText = 'Item Name'
filters['itemName'].data = {'?'}
filters['itemName'].filterMessage = 'Item name does not contain text.'

f = createFilterFrame('Item Name', 32)
f.bodyText:SetText('Item name contains text:')
f.bodyText:SetPoint('TOPLEFT', 8, -14)

f.customData = {}
f.customData[1] = CreateFrame('EditBox', 'ar2', f, 'EasyScrapEditBoxTemplate')
f.customData[1]:SetPoint('LEFT', f.bodyText, 'RIGHT', 8, 0)
f.customData[1]:SetMaxLetters(22)
f.customData[1]:SetWidth(96)

function f:populateData(data)
    self.customData[1]:SetText(data[1])
end

function f:saveData(customFilterIndex)
    EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[1] = self.customData[1]:GetText()
end

filters['itemName'].frame = f

filters['itemName'].filterFunction = function(itemIndex, filterIndex)
    local item = EasyScrap.scrappableItems[itemIndex]
    local filterData = EasyScrap.saveData.customFilters[EasyScrap.activeFilterID].rules[filterIndex].data

    local matchResult = string.find(string.lower(item.itemName), string.lower(filterData[1]))
    if not matchResult then filters['itemName'].filterMessage = 'item name does not contain text "'..filterData[1]..'".' end
    return matchResult
end

--[[---------------------------------------------------------------------------------------------------------------------------------------
AZERITE GEAR
--]]---------------------------------------------------------------------------------------------------------------------------------------
filters['azeriteArmor'] = {}
filters['azeriteArmor'].menuText = 'Azerite Armor'
filters['azeriteArmor'].data = {[1] = true, [2] = false}
filters['azeriteArmor'].filterMessage = 'item is ??? Azerite armor'

f = createFilterFrame('Azerite Armor', 50)
f.checkButtons = {}
f.checkButtons[1] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[1]:SetPoint('TOPLEFT', 8, -8)
f.checkButtons[1].text:SetText('Show only Azerite Armor items.')
f.checkButtons[2] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[2]:SetPoint('TOPLEFT', 8, -28)
f.checkButtons[2].text:SetText('Hide all Azerite Armor items.')

f.checkButtons[1]:HookScript('OnClick', function(self) filters['azeriteArmor'].frame.checkButtons[2]:SetChecked(not self:GetChecked()) end)
f.checkButtons[2]:HookScript('OnClick', function(self) filters['azeriteArmor'].frame.checkButtons[1]:SetChecked(not self:GetChecked()) end)

function f:populateData(data)
    self.checkButtons[1]:SetChecked(data[1])
    self.checkButtons[2]:SetChecked(data[2])
end

function f:saveData(customFilterIndex)
    EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[1] = self.checkButtons[1]:GetChecked()
    EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[2] = self.checkButtons[2]:GetChecked()
end

filters['azeriteArmor'].frame = f

filters['azeriteArmor'].filterFunction = function(itemIndex, filterIndex)
    local item = EasyScrap.scrappableItems[itemIndex]
    local filterData = EasyScrap.saveData.customFilters[EasyScrap.activeFilterID].rules[filterIndex].data

    if filterData[1] then       
        local isMatch = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(item.itemLink)
        if not isMatch then filters['azeriteArmor'].filterMessage = 'item is not Azerite Armor.' end
        return isMatch
    else
        local isMatch = not C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(item.itemLink)
        if not isMatch then filters['azeriteArmor'].filterMessage = 'item is Azerite Armor.' end
        return isMatch
    end
end

--[[---------------------------------------------------------------------------------------------------------------------------------------
ITEM QUALITY
--]]---------------------------------------------------------------------------------------------------------------------------------------
filters['itemQuality'] = {}
filters['itemQuality'].menuText = 'Item Quality'
filters['itemQuality'].data = {[1] = true, [2] = true, [3] = true, [4] = true}
filters['itemQuality'].filterMessage = 'Item quality is not selected.'

f = createFilterFrame('Item Quality', 50)
f.checkButtons = {}
f.checkButtons[1] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[1]:SetPoint('TOPLEFT', 8, -8)
f.checkButtons[1].text:SetText(ITEM_QUALITY_COLORS[1].hex..'['..ITEM_QUALITY1_DESC..']|r')
f.checkButtons[2] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[2]:SetPoint('TOPLEFT', 128, -8)
f.checkButtons[2].text:SetText(ITEM_QUALITY_COLORS[2].hex..'['..ITEM_QUALITY2_DESC..']|r')
f.checkButtons[3] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[3]:SetPoint('TOPLEFT', 8, -28)
f.checkButtons[3].text:SetText(ITEM_QUALITY_COLORS[3].hex..'['..ITEM_QUALITY3_DESC..']|r')
f.checkButtons[4] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[4]:SetPoint('TOPLEFT', 128, -28)
f.checkButtons[4].text:SetText(ITEM_QUALITY_COLORS[4].hex..'['..ITEM_QUALITY4_DESC..']|r')

function f:populateData(data)
    self.checkButtons[1]:SetChecked(data[1])
    self.checkButtons[2]:SetChecked(data[2])
    self.checkButtons[3]:SetChecked(data[3])
    self.checkButtons[4]:SetChecked(data[4])
end

function f:saveData(customFilterIndex)
    for k, v in pairs(self.checkButtons) do
        EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[k] = v:GetChecked()
    end
end

filters['itemQuality'].frame = f

filters['itemQuality'].filterFunction = function(itemIndex, filterIndex)
    local item = EasyScrap.scrappableItems[itemIndex]
    local filterData = EasyScrap.saveData.customFilters[EasyScrap.activeFilterID].rules[filterIndex].data

    local isMatch = filterData[item.itemQuality]
    if not isMatch then filters['itemQuality'].filterMessage = 'item quality is not one of selected in filer.' end
    return isMatch
end

--[[---------------------------------------------------------------------------------------------------------------------------------------
ITEM BIND TYPE
--]]---------------------------------------------------------------------------------------------------------------------------------------
filters['bindType'] = {}
filters['bindType'].menuText = 'Bind Type'
filters['bindType'].data = {[1] = true, [2] = true, [4] = true}
filters['bindType'].filterMessage = 'Item bind type is not one of selected bind types.'

f = createFilterFrame('Bind Type', 70)
f.checkButtons = {}
f.checkButtons[1] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[1]:SetPoint('TOPLEFT', 8, -8)
f.checkButtons[1].text:SetText(ITEM_BIND_ON_EQUIP)
f.checkButtons[2] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[2]:SetPoint('TOPLEFT', 8, -28)
f.checkButtons[2].text:SetText(ITEM_SOULBOUND)
f.checkButtons[3] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[3]:SetPoint('TOPLEFT', 8, -48)
f.checkButtons[3].text:SetText(ITEM_BIND_QUEST)

function f:populateData(data)
    self.checkButtons[1]:SetChecked(data[2]) --bop
    self.checkButtons[2]:SetChecked(data[1]) --boe
    self.checkButtons[3]:SetChecked(data[4]) --quest
end

function f:saveData(customFilterIndex)
    EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[2] = self.checkButtons[1]:GetChecked() --bop
    EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[1] = self.checkButtons[2]:GetChecked() --boe
    EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[4] = self.checkButtons[3]:GetChecked() --quest
end

filters['bindType'].frame = f

--1 = BOP/SOULBOUND
--2 = BOE
--4 = QUESTITEM
local btT = {ITEM_SOULBOUND, ITEM_BIND_ON_EQUIP, ITEM_BIND_ON_USE, ITEM_BIND_QUEST}

filters['bindType'].filterFunction = function(itemIndex, filterIndex)
    local item = EasyScrap.scrappableItems[itemIndex]
    local filterData = EasyScrap.saveData.customFilters[EasyScrap.activeFilterID].rules[filterIndex].data
    local isMatch
    if item.bindType == 2 then
        --Silly that you can't find soulbound state without reading tooltip
        EasyScrap.tooltipReader:ClearLines()      
        EasyScrap.tooltipReader:SetBagItem(item.bag, item.slot)
        local lines = EasyScrap.tooltipReader:NumLines()
        if lines > 5 then lines = 5 end
        local isBoE = true
        for i = 1, lines do
           local text = _G["EasyScrapTooltipReaderTextLeft"..i]:GetText()                  
           if text == ITEM_SOULBOUND then
              isBoE = false
           end
        end
        
        if isBoE then
            isMatch = filterData[2]
            if not isMatch then filters['bindType'].filterMessage = 'item bind type is '..ITEM_BIND_ON_EQUIP end
            return isMatch
        else
            isMatch = filterData[1]
            if not isMatch then filters['bindType'].filterMessage = 'item bind type is '..ITEM_SOULBOUND end
            return isMatch           
        end
    else
        isMatch = filterData[item.bindType]
		local bindTypeMessage = btT[item.bindType] or "unknown"

		filters['bindType'].filterMessage = 'item bind type is '..bindTypeMessage        return isMatch       
    end
end

--[[---------------------------------------------------------------------------------------------------------------------------------------
ARMOR TYPE
--]]---------------------------------------------------------------------------------------------------------------------------------------
filters['armorType'] = {}
filters['armorType'].menuText = 'Armor Type'
filters['armorType'].data = {[Enum.ItemArmorSubclass.Cloth] = true, [Enum.ItemArmorSubclass.Leather] = true, [Enum.ItemArmorSubclass.Mail] = true, [Enum.ItemArmorSubclass.Plate] = true, [Enum.ItemArmorSubclass.Shield] = true, [Enum.ItemArmorSubclass.Generic] = true}
filters['armorType'].filterMessage = 'Item is not one of selected armor types.'

f = createFilterFrame('Armor Type', 72)
f.checkButtons = {}
f.checkButtons[1] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[1]:SetPoint('TOPLEFT', 8, -8)
f.checkButtons[1].text:SetText(GetItemSubClassInfo(Enum.ItemClass.Armor, Enum.ItemArmorSubclass.Cloth))
f.checkButtons[2] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[2]:SetPoint('TOPLEFT', 128, -8)
f.checkButtons[2].text:SetText(GetItemSubClassInfo(Enum.ItemClass.Armor, Enum.ItemArmorSubclass.Leather))
f.checkButtons[3] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[3]:SetPoint('TOPLEFT', 8, -28)
f.checkButtons[3].text:SetText(GetItemSubClassInfo(Enum.ItemClass.Armor, Enum.ItemArmorSubclass.Mail))
f.checkButtons[4] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[4]:SetPoint('TOPLEFT', 128, -28)
f.checkButtons[4].text:SetText(GetItemSubClassInfo(Enum.ItemClass.Armor, Enum.ItemArmorSubclass.Plate))
f.checkButtons[5] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[5]:SetPoint('TOPLEFT', 8, -48)
f.checkButtons[5].text:SetText(GetItemSubClassInfo(Enum.ItemClass.Armor, Enum.ItemArmorSubclass.Shield))
f.checkButtons[6] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[6]:SetPoint('TOPLEFT', 128, -48)
f.checkButtons[6].text:SetText(GetItemSubClassInfo(Enum.ItemClass.Armor, Enum.ItemArmorSubclass.Generic))

function f:populateData(data)
    self.checkButtons[1]:SetChecked(data[Enum.ItemArmorSubclass.Cloth])
    self.checkButtons[2]:SetChecked(data[Enum.ItemArmorSubclass.Leather])
    self.checkButtons[3]:SetChecked(data[Enum.ItemArmorSubclass.Mail])
    self.checkButtons[4]:SetChecked(data[Enum.ItemArmorSubclass.Plate])
    self.checkButtons[5]:SetChecked(data[Enum.ItemArmorSubclass.Shield])
    self.checkButtons[6]:SetChecked(data[Enum.ItemArmorSubclass.Generic])
end

function f:saveData(customFilterIndex)
    EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[Enum.ItemArmorSubclass.Cloth] = self.checkButtons[1]:GetChecked()
    EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[Enum.ItemArmorSubclass.Leather] = self.checkButtons[2]:GetChecked()
    EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[Enum.ItemArmorSubclass.Mail] = self.checkButtons[3]:GetChecked()
    EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[Enum.ItemArmorSubclass.Plate] = self.checkButtons[4]:GetChecked()
    EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[Enum.ItemArmorSubclass.Shield] = self.checkButtons[5]:GetChecked()
    EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[Enum.ItemArmorSubclass.Generic] = self.checkButtons[6]:GetChecked()
end

filters['armorType'].frame = f

filters['armorType'].filterFunction = function(itemIndex, filterIndex)
    local item = EasyScrap.scrappableItems[itemIndex]
    local filterData = EasyScrap.saveData.customFilters[EasyScrap.activeFilterID].rules[filterIndex].data
    
    if item.itemClassID == Enum.ItemClass.Armor then
        local isMatch = filterData[item.itemSubClassID]
        if isMatch then
            return true
        else
            filters['armorType'].filterMessage = 'armor type is '..GetItemSubClassInfo(Enum.ItemClass.Armor, item.itemSubClassID)       
        end
    else
        return true
    end
end

--[[---------------------------------------------------------------------------------------------------------------------------------------
WEAPON TYPE
[LE_ITEM_CLASS_WEAPON]
[Enum.ItemWeaponSubclass.Axe1H]
[Enum.ItemWeaponSubclass.Axe2H]
[Enum.ItemWeaponSubclass.Bows]
[Enum.ItemWeaponSubclass.Guns]
[Enum.ItemWeaponSubclass.Mace1H]
[Enum.ItemWeaponSubclass.Mace2H]
[Enum.ItemWeaponSubclass.Polearm]
[Enum.ItemWeaponSubclass.Sword1H]
[Enum.ItemWeaponSubclass.Sword2H]
[Enum.ItemWeaponSubclass.Warglaive]
[Enum.ItemWeaponSubclass.Staff]
[LE_ITEM_WEAPON_BEARCLAW]
[LE_ITEM_WEAPON_CATCLAW]
[Enum.ItemWeaponSubclass.Unarmed]
[LE_ITEM_WEAPON_GENERIC]
[Enum.ItemWeaponSubclass.Dagger]
[LE_ITEM_WEAPON_THROWN]
[Enum.ItemWeaponSubclass.Crossbows]
[Enum.ItemWeaponSubclass.Wand]
[LE_ITEM_WEAPON_FISHINGPOLE]
NUM_LE_ITEM_WEAPONS
--]]---------------------------------------------------------------------------------------------------------------------------------------
filters['weaponType'] = {}
filters['weaponType'].menuText = 'Weapon Type'
filters['weaponType'].data = {
[Enum.ItemWeaponSubclass.Axe1H] = true, --
[Enum.ItemWeaponSubclass.Axe2H] = true,--
[Enum.ItemWeaponSubclass.Bows] = true, --
[Enum.ItemWeaponSubclass.Guns] = true, --
[Enum.ItemWeaponSubclass.Mace1H] = true, --
[Enum.ItemWeaponSubclass.Mace2H] = true, --
[Enum.ItemWeaponSubclass.Polearm] = true, --
[Enum.ItemWeaponSubclass.Sword1H] = true, --
[Enum.ItemWeaponSubclass.Sword2H] = true, --
[Enum.ItemWeaponSubclass.Warglaive] = true,
[Enum.ItemWeaponSubclass.Staff] = true, --
--[LE_ITEM_WEAPON_BEARCLAW] = true,
--[LE_ITEM_WEAPON_CATCLAW] = true,
[Enum.ItemWeaponSubclass.Unarmed] = true, --
--[LE_ITEM_WEAPON_GENERIC] = true,
[Enum.ItemWeaponSubclass.Dagger] = true, --
--[LE_ITEM_WEAPON_THROWN] = true,
[Enum.ItemWeaponSubclass.Crossbow] = true, --
[Enum.ItemWeaponSubclass.Wand] = true, --
--[LE_ITEM_WEAPON_FISHINGPOLE] = true,
}
filters['weaponType'].filterMessage = 'Item is not one of selected weapon types.'

f = createFilterFrame('Weapon Type', 308)
f.checkButtons = {}
f.checkButtons[Enum.ItemWeaponSubclass.Axe1H] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[Enum.ItemWeaponSubclass.Axe1H]:SetPoint('TOPLEFT', 8, -8)
f.checkButtons[Enum.ItemWeaponSubclass.Axe1H].text:SetText(GetItemSubClassInfo(Enum.ItemClass.Weapon, Enum.ItemWeaponSubclass.Axe1H))
f.checkButtons[Enum.ItemWeaponSubclass.Axe2H] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[Enum.ItemWeaponSubclass.Axe2H]:SetPoint('TOPLEFT', 8, -28)
f.checkButtons[Enum.ItemWeaponSubclass.Axe2H].text:SetText(GetItemSubClassInfo(Enum.ItemClass.Weapon, Enum.ItemWeaponSubclass.Axe2H))

f.checkButtons[Enum.ItemWeaponSubclass.Sword1H] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[Enum.ItemWeaponSubclass.Sword1H]:SetPoint('TOPLEFT', 8, -48)
f.checkButtons[Enum.ItemWeaponSubclass.Sword1H].text:SetText(GetItemSubClassInfo(Enum.ItemClass.Weapon, Enum.ItemWeaponSubclass.Sword1H))
f.checkButtons[Enum.ItemWeaponSubclass.Sword2H] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[Enum.ItemWeaponSubclass.Sword2H]:SetPoint('TOPLEFT', 8, -68)
f.checkButtons[Enum.ItemWeaponSubclass.Sword2H].text:SetText(GetItemSubClassInfo(Enum.ItemClass.Weapon, Enum.ItemWeaponSubclass.Sword2H))

f.checkButtons[Enum.ItemWeaponSubclass.Mace1H] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[Enum.ItemWeaponSubclass.Mace1H]:SetPoint('TOPLEFT', 8, -88)
f.checkButtons[Enum.ItemWeaponSubclass.Mace1H].text:SetText(GetItemSubClassInfo(Enum.ItemClass.Weapon, Enum.ItemWeaponSubclass.Mace1H))
f.checkButtons[Enum.ItemWeaponSubclass.Mace2H] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[Enum.ItemWeaponSubclass.Mace2H]:SetPoint('TOPLEFT', 8, -108)
f.checkButtons[Enum.ItemWeaponSubclass.Mace2H].text:SetText(GetItemSubClassInfo(Enum.ItemClass.Weapon, Enum.ItemWeaponSubclass.Mace2H))

f.checkButtons[Enum.ItemWeaponSubclass.Dagger] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[Enum.ItemWeaponSubclass.Dagger]:SetPoint('TOPLEFT', 8, -128)
f.checkButtons[Enum.ItemWeaponSubclass.Dagger].text:SetText(GetItemSubClassInfo(Enum.ItemClass.Weapon, Enum.ItemWeaponSubclass.Dagger))
f.checkButtons[Enum.ItemWeaponSubclass.Unarmed] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[Enum.ItemWeaponSubclass.Unarmed]:SetPoint('TOPLEFT', 8, -148)
f.checkButtons[Enum.ItemWeaponSubclass.Unarmed].text:SetText(GetItemSubClassInfo(Enum.ItemClass.Weapon, Enum.ItemWeaponSubclass.Unarmed))

f.checkButtons[Enum.ItemWeaponSubclass.Polearm] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[Enum.ItemWeaponSubclass.Polearm]:SetPoint('TOPLEFT', 8, -168)
f.checkButtons[Enum.ItemWeaponSubclass.Polearm].text:SetText(GetItemSubClassInfo(Enum.ItemClass.Weapon, Enum.ItemWeaponSubclass.Polearm))
f.checkButtons[Enum.ItemWeaponSubclass.Staff] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[Enum.ItemWeaponSubclass.Staff]:SetPoint('TOPLEFT', 8, -188)
f.checkButtons[Enum.ItemWeaponSubclass.Staff].text:SetText(GetItemSubClassInfo(Enum.ItemClass.Weapon, Enum.ItemWeaponSubclass.Staff))

f.checkButtons[Enum.ItemWeaponSubclass.Bows] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[Enum.ItemWeaponSubclass.Bows]:SetPoint('TOPLEFT', 8, -208)
f.checkButtons[Enum.ItemWeaponSubclass.Bows].text:SetText(GetItemSubClassInfo(Enum.ItemClass.Weapon, Enum.ItemWeaponSubclass.Bows))
f.checkButtons[Enum.ItemWeaponSubclass.Crossbow] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[Enum.ItemWeaponSubclass.Crossbow]:SetPoint('TOPLEFT', 8, -228)
f.checkButtons[Enum.ItemWeaponSubclass.Crossbow].text:SetText(GetItemSubClassInfo(Enum.ItemClass.Weapon, Enum.ItemWeaponSubclass.Crossbow))

f.checkButtons[Enum.ItemWeaponSubclass.Guns] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[Enum.ItemWeaponSubclass.Guns]:SetPoint('TOPLEFT', 8, -248)
f.checkButtons[Enum.ItemWeaponSubclass.Guns].text:SetText(GetItemSubClassInfo(Enum.ItemClass.Weapon, Enum.ItemWeaponSubclass.Guns))
f.checkButtons[Enum.ItemWeaponSubclass.Wand] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[Enum.ItemWeaponSubclass.Wand]:SetPoint('TOPLEFT', 8, -268)
f.checkButtons[Enum.ItemWeaponSubclass.Wand].text:SetText(GetItemSubClassInfo(Enum.ItemClass.Weapon, Enum.ItemWeaponSubclass.Wand))

f.checkButtons[Enum.ItemWeaponSubclass.Warglaive] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[Enum.ItemWeaponSubclass.Warglaive]:SetPoint('TOPLEFT', 8, -288)
f.checkButtons[Enum.ItemWeaponSubclass.Warglaive].text:SetText(GetItemSubClassInfo(Enum.ItemClass.Weapon, Enum.ItemWeaponSubclass.Warglaive))


function f:populateData(fData)
    for k,v in pairs(filters['weaponType'].data) do
        self.checkButtons[k]:SetChecked(fData[k])
    end
end

function f:saveData(customFilterIndex)
    for k,v in pairs(filters['weaponType'].data) do
        EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[k] = self.checkButtons[k]:GetChecked()
    end
end

filters['weaponType'].frame = f

filters['weaponType'].filterFunction = function(itemIndex, filterIndex)
    local item = EasyScrap.scrappableItems[itemIndex]
    local filterData = EasyScrap.saveData.customFilters[EasyScrap.activeFilterID].rules[filterIndex].data
    
    if item.itemClassID == Enum.ItemClass.Weapon then
        local isMatch = filterData[item.itemSubClassID]
        if isMatch then
            return true
        else
            filters['weaponType'].filterMessage = 'weapon type is '..GetItemSubClassInfo(Enum.ItemClass.Weapon, item.itemSubClassID)       
        end
    else
        return true
    end
end

--[[---------------------------------------------------------------------------------------------------------------------------------------
ITEM TYPE
--]]---------------------------------------------------------------------------------------------------------------------------------------
filters['itemType'] = {}
filters['itemType'].menuText = 'Item Type'
filters['itemType'].data = {[Enum.ItemClass.Armor] = true, [Enum.ItemClass.Weapon] = true}
filters['itemType'].filterMessage = 'item type is not one of selected item types.'

f = createFilterFrame('Item Type', 30)
f.checkButtons = {}
f.checkButtons[1] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[1]:SetPoint('TOPLEFT', 8, -8)
f.checkButtons[1].text:SetText('Armor')
f.checkButtons[2] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[2]:SetPoint('TOPLEFT', 128, -8)
f.checkButtons[2].text:SetText('Weapon')

function f:populateData(data)
    self.checkButtons[1]:SetChecked(data[Enum.ItemClass.Armor])
    self.checkButtons[2]:SetChecked(data[Enum.ItemClass.Weapon])
end

function f:saveData(customFilterIndex)
    EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[Enum.ItemClass.Armor] = self.checkButtons[1]:GetChecked()
    EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[Enum.ItemClass.Weapon] = self.checkButtons[2]:GetChecked()
end

filters['itemType'].frame = f

filters['itemType'].filterFunction = function(itemIndex, filterIndex)
    local item = EasyScrap.scrappableItems[itemIndex]
    local filterData = EasyScrap.saveData.customFilters[EasyScrap.activeFilterID].rules[filterIndex].data
    
    return filterData[item.itemClassID]
end

--[[---------------------------------------------------------------------------------------------------------------------------------------
BONUS STATS
--]]---------------------------------------------------------------------------------------------------------------------------------------
filters['bonusStats'] = {}
filters['bonusStats'].menuText = 'Bonus Stats'
filters['bonusStats'].data = {
['40'] = true, --Avoidance 
['43'] = true, --Indestructible
--['1808'] = true, --Socket 
['42'] = true, --Speed
['41'] = true --Leech
}
filters['bonusStats'].filterMessage = 'item does not have one of selected bonus stats.'

f = createFilterFrame('Bonus Stats', 92)
f.checkButtons = {}
f.checkButtons['40'] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons['40']:SetPoint('TOPLEFT', 8, -8)
f.checkButtons['40'].text:SetText('Avoidance')
f.checkButtons['43'] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons['43']:SetPoint('TOPLEFT', 8, -28)
f.checkButtons['43'].text:SetText('Indestructible')
f.checkButtons['41'] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons['41']:SetPoint('TOPLEFT', 8, -48)
f.checkButtons['41'].text:SetText('Leech')
--f.checkButtons['1808'] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
--f.checkButtons['1808']:SetPoint('TOPLEFT', 8, -68)
--f.checkButtons['1808'].text:SetText('Socket')
f.checkButtons['42'] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons['42']:SetPoint('TOPLEFT', 8, -68)
f.checkButtons['42'].text:SetText('Speed')


function f:populateData(data)
    for k,v in pairs(filters['bonusStats'].data) do
        self.checkButtons[k]:SetChecked(data[k])
    end
end

function f:saveData(customFilterIndex)
    for k,v in pairs(filters['bonusStats'].data) do
        EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[k] = self.checkButtons[k]:GetChecked()
    end
end

filters['bonusStats'].frame = f

filters['bonusStats'].filterFunction = function(itemIndex, filterIndex)
    local item = EasyScrap.scrappableItems[itemIndex]
    local filterData = EasyScrap.saveData.customFilters[EasyScrap.activeFilterID].rules[filterIndex].data
    
    local tempString, unknown1, unknown2, unknown3 = strmatch(item.itemLink, "item:[-%d]-:[-%d]-:[-%d]-:[-%d]-:[-%d]-:[-%d]-:[-%d]-:[-%d]-:[-%d]-:[-%d]-:[-%d]-:[-%d]-:[-%d]-:([-:%d]+):([-%d]-):([-%d]-):([-%d]-)|")
    local bonusIDs = {}
    local upgradeValue
    if tempString then
        if upgradeTypeID and upgradeTypeID ~= "" then
           upgradeValue = tempString:match("[-:%d]+:([-%d]+)")
           bonusIDs = {strsplit(":", tempString:match("([-:%d]+):"))}
        else
           bonusIDs = {strsplit(":", tempString)}
        end
        --4775 bonus ID = azerite power ID 13 active
        for k,v in pairs(bonusIDs) do if v == '4775' or v == '' then table.remove(bonusIDs, k) break end end
    end
    
    local enabledCount = 0
    for k,v in pairs(filterData) do
        if v then enabledCount = enabledCount + 1 end
    end
    
    if enabledCount >= 1 then
        for k,v in pairs(bonusIDs) do
            if filterData[v] then return true end
        end   
        filters['bonusStats'].filterMessage = 'item does not have one of selected bonus stats.'
        return false
    else
        for k,v in pairs(bonusIDs) do
            if filterData[v] ~= nil then return false end
        end
        filters['bonusStats'].filterMessage = 'item has a bonus stat.'
        return true
    end
end

--[[---------------------------------------------------------------------------------------------------------------------------------------
ITEM SLOT
--]]---------------------------------------------------------------------------------------------------------------------------------------
filters['itemSlot'] = {}
filters['itemSlot'].menuText = 'Item Slot'
filters['itemSlot'].data = {
    ['INVTYPE_HEAD'] = true, 
    ['INVTYPE_NECK'] = true, 
    ['INVTYPE_SHOULDER'] = true, 
    ['INVTYPE_CLOAK'] = true, 
    ['INVTYPE_CHEST'] = true, 
    ['INVTYPE_WRIST'] = true, 
    ['INVTYPE_HAND'] = true, 
    ['INVTYPE_WAIST'] = true, 
    ['INVTYPE_LEGS'] = true, 
    ['INVTYPE_FEET'] = true, 
    ['INVTYPE_FINGER'] = true, 
    ['INVTYPE_TRINKET'] = true,
}
filters['itemSlot'].filterMessage = 'item slot is not one of selected item slots.'

local itt = {
    'INVTYPE_HEAD', 
    'INVTYPE_NECK', 
    'INVTYPE_SHOULDER', 
    'INVTYPE_CLOAK', 
    'INVTYPE_CHEST', 
    'INVTYPE_WRIST',
    'INVTYPE_HAND', 
    'INVTYPE_WAIST',
    'INVTYPE_LEGS',
    'INVTYPE_FEET',
    'INVTYPE_FINGER',
    'INVTYPE_TRINKET'
}

f = createFilterFrame('Item Slot', 132)
f.checkButtons = {}
for i = 1, #itt do
    f.checkButtons[itt[i]] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
    f.checkButtons[itt[i]].text:SetText(invTypes[itt[i]]) 
    if i < 7 then
        f.checkButtons[itt[i]]:SetPoint('TOPLEFT', 8, -8-((i-1)*20))
    else
        f.checkButtons[itt[i]]:SetPoint('TOPLEFT', 118, -8-((i-7)*20))
    end
end

function f:populateData(data)
    for k,v in pairs(filters['itemSlot'].data) do
        self.checkButtons[k]:SetChecked(data[k])
    end
end

function f:saveData(customFilterIndex)
    for k,v in pairs(filters['itemSlot'].data) do
        EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[k] = self.checkButtons[k]:GetChecked()
    end
end

filters['itemSlot'].frame = f

filters['itemSlot'].filterFunction = function(itemIndex, filterIndex)
    local item = EasyScrap.scrappableItems[itemIndex]
    local filterData = EasyScrap.saveData.customFilters[EasyScrap.activeFilterID].rules[filterIndex].data
    
    if filterData[item.itemEquipLoc] or (item.itemEquipLoc == 'INVTYPE_ROBE' and filterData['INVTYPE_CHEST']) then 
        return true
    else
        if invTypes[item.itemEquipLoc] then
            filters['itemSlot'].filterMessage = 'item slot is '..invTypes[item.itemEquipLoc]
        else
            filters['itemSlot'].filterMessage = 'item slot is unknown.'
        end
        return false
    end
end

--[[---------------------------------------------------------------------------------------------------------------------------------------
ITEM IN WARDROBE
--]]---------------------------------------------------------------------------------------------------------------------------------------
filters['equipmentSet'] = {}
filters['equipmentSet'].menuText = 'Equipment Set'
filters['equipmentSet'].filterMessage = 'item is used in one or more equipment sets.'


f = createFilterFrame('Equipment Set', 32)
f.bodyText:SetText('Item is not used in an equipment set.')
filters['equipmentSet'].frame = f

filters['equipmentSet'].filterFunction = function(itemIndex)
    return not EasyScrap:itemInWardrobeSet(EasyScrap.scrappableItems[itemIndex].itemID, EasyScrap.scrappableItems[itemIndex].bag, EasyScrap.scrappableItems[itemIndex].slot)
end


--[[---------------------------------------------------------------------------------------------------------------------------------------
DUPLICATES
--]]---------------------------------------------------------------------------------------------------------------------------------------
filters['duplicates'] = {}
filters['duplicates'].menuText = 'Duplicates'
filters['duplicates'].filterMessage = 'item is not a duplicate.'


f = createFilterFrame('Duplicates', 32)
f.bodyText:SetText('Only show duplicate items.')
filters['duplicates'].frame = f

filters['duplicates'].filterFunction = function(itemIndex)
    local item = EasyScrap.scrappableItems[itemIndex]
    
    local i = 0
    for k,v in pairs(EasyScrap.scrappableItems) do
        if v.itemID == item.itemID then i = i + 1 end
        if i > 1 then return true end
    end
    return false
end

--[[---------------------------------------------------------------------------------------------------------------------------------------
TRANSMOG NOT KNOWN
--]]---------------------------------------------------------------------------------------------------------------------------------------
filters['transmogKnown'] = {}
filters['transmogKnown'].menuText = 'Transmog'
filters['transmogKnown'].filterMessage = 'you don\'t have this appearance in your collection.'

f = createFilterFrame('Transmog', 32)
f.bodyText:SetText('Item appearance is in your collection.')
filters['transmogKnown'].frame = f

filters['transmogKnown'].filterFunction = function(itemIndex, filterIndex)
    local item = EasyScrap.scrappableItems[itemIndex]
    local filterData = EasyScrap.saveData.customFilters[EasyScrap.activeFilterID].rules[filterIndex].data
    
    --If player has CanIMogIt we can use that
    if CanIMogIt and CanIMogIt.PlayerKnowsTransmog then
        if CanIMogIt:PlayerKnowsTransmog(item.itemLink) then --If this is false or nil for some reason we'll fallback to our own stuff
            return true
        end
    end
 
    if C_TransmogCollection.PlayerHasTransmog(item.itemID) then
        return true
    end
    
    local z = C_TransmogCollection.GetItemInfo(item.itemLink)
    if not z then
        if item.itemClassID == Enum.ItemClass.Weapon or (item.itemClassID == Enum.ItemClass.Armor and (item.itemSubClassID == Enum.ItemArmorSubclass.Cloth or item.itemSubClassID == Enum.ItemArmorSubclass.Leather or item.itemSubClassID == Enum.ItemArmorSubclass.Mail or item.itemSubClassID == Enum.ItemArmorSubclass.Plate or item.itemSubClassID == Enum.ItemArmorSubclass.Shield)) then 
            --DEFAULT_CHAT_FRAME:AddMessage('Easy Scrap: Failed to obtain transmog information for item '..item.itemLink..'. Item will be ignored, please check it manually.')
            filters['transmogKnown'].filterMessage = 'unable to determine if appearance is known.\nThis happens for some items, please check it manually.'
            return false
        else
            return true 
        end
    end

    local sources = C_TransmogCollection.GetAppearanceSources(z)
    if sources then
        for k,v in pairs(sources) do
           if v.isCollected then return true end
        end
    end
    filters['transmogKnown'].filterMessage = 'you don\'t have this appearance in your collection.'
    return false
end

--[[---------------------------------------------------------------------------------------------------------------------------------------
BAGS FILTER
--]]---------------------------------------------------------------------------------------------------------------------------------------
filters['bags'] = {}
filters['bags'].menuText = 'Bags'
filters['bags'].data = {[0] = true, [1] = true, [2] = true, [3] = true, [4] = true} --bag 0, 1, 2, 3, 4
filters['bags'].filterMessage = 'Item was not found in one of the selected bags.'

f = createFilterFrame(filters['bags'].menuText, 70)
f.checkButtons = {}
f.checkButtons[0] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[0]:SetPoint('TOPLEFT', 8, -8)
--f.checkButtons[0].text:SetText(GetBagName(0))
f.checkButtons[0].text:SetText('Backpack')
f.checkButtons[1] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[1]:SetPoint('TOPLEFT', 128, -8)
f.checkButtons[1].text:SetText('Bag #1')
f.checkButtons[2] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[2]:SetPoint('TOPLEFT', 8, -28)
f.checkButtons[2].text:SetText('Bag #2')
f.checkButtons[3] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[3]:SetPoint('TOPLEFT', 128, -28)
f.checkButtons[3].text:SetText('Bag #3')
f.checkButtons[4] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[4]:SetPoint('TOPLEFT', 8, -48)
f.checkButtons[4].text:SetText('Bag #4')
function f:populateData(data)
    self.checkButtons[0]:SetChecked(data[0])
    self.checkButtons[1]:SetChecked(data[1])
    self.checkButtons[2]:SetChecked(data[2])
    self.checkButtons[3]:SetChecked(data[3])
    self.checkButtons[4]:SetChecked(data[4])
end

function f:saveData(customFilterIndex)
    EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[0] = self.checkButtons[0]:GetChecked()
    EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[1] = self.checkButtons[1]:GetChecked()
    EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[2] = self.checkButtons[2]:GetChecked()
    EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[3] = self.checkButtons[3]:GetChecked()
    EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[4] = self.checkButtons[4]:GetChecked()
end

filters['bags'].frame = f

filters['bags'].filterFunction = function(itemIndex, filterIndex)
    local item = EasyScrap.scrappableItems[itemIndex]
    local filterData = EasyScrap.saveData.customFilters[EasyScrap.activeFilterID].rules[filterIndex].data
    
    local filterMatch = filterData[item.bag]
    if not filterMatch then filters['bags'].filterMessage = 'item is in bag#'..item.bag end
    return filterMatch
end

--[[---------------------------------------------------------------------------------------------------------------------------------------
BENTHIC NOT KNOWN
--]]---------------------------------------------------------------------------------------------------------------------------------------
filters['benthicArmor'] = {}
filters['benthicArmor'].menuText = 'Benthic Armor'
filters['benthicArmor'].data = {[1] = true, [2] = false}
filters['benthicArmor'].filterMessage = 'item is or is not Benthic Armor.'

f = createFilterFrame('Benthic Armor', 50)
f.checkButtons = {}
f.checkButtons[1] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[1]:SetPoint('TOPLEFT', 8, -8)
f.checkButtons[1].text:SetText('Show only Benthic Armor items.')
f.checkButtons[2] = CreateFrame('CheckButton', nil, f, 'EasyScrapCheckButtonTemplate')
f.checkButtons[2]:SetPoint('TOPLEFT', 8, -28)
f.checkButtons[2].text:SetText('Hide all Benthic Armor items.')

f.checkButtons[1]:HookScript('OnClick', function(self) filters['benthicArmor'].frame.checkButtons[2]:SetChecked(not self:GetChecked()) end)
f.checkButtons[2]:HookScript('OnClick', function(self) filters['benthicArmor'].frame.checkButtons[1]:SetChecked(not self:GetChecked()) end)

function f:populateData(data)
    self.checkButtons[1]:SetChecked(data[1])
    self.checkButtons[2]:SetChecked(data[2])
end

function f:saveData(customFilterIndex)
    EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[1] = self.checkButtons[1]:GetChecked()
    EasyScrap.saveData.customFilters[customFilterIndex].rules[self.ruleIndex].data[2] = self.checkButtons[2]:GetChecked()
end

filters['benthicArmor'].frame = f

filters['benthicArmor'].filterFunction = function(itemIndex, filterIndex)
    local item = EasyScrap.scrappableItems[itemIndex]
    local filterData = EasyScrap.saveData.customFilters[EasyScrap.activeFilterID].rules[filterIndex].data

    local tempString, unknown1, unknown2, unknown3 = strmatch(item.itemLink, "item:[-%d]-:[-%d]-:[-%d]-:[-%d]-:[-%d]-:[-%d]-:[-%d]-:[-%d]-:[-%d]-:[-%d]-:[-%d]-:[-%d]-:[-%d]-:([-:%d]+):([-%d]-):([-%d]-):([-%d]-)|")
    local bonusIDs = {}
    local upgradeValue
    local isBenthic = false
    
    if tempString then
        if upgradeTypeID and upgradeTypeID ~= "" then
            upgradeValue = tempString:match("[-:%d]+:([-%d]+)")
            bonusIDs = {strsplit(":", tempString:match("([-:%d]+):"))}
        else
            bonusIDs = {strsplit(":", tempString)}
        end
        --4775 bonus ID = azerite power ID 13 active
        for k,v in pairs(bonusIDs) do if v == '6300' then isBenthic = true end end
    end
    
    if filterData[1] then       
        local isMatch = isBenthic
        if not isMatch then filters['benthicArmor'].filterMessage = 'item is not Benthic Armor.' end
        return isMatch
    else
        local isMatch = not isBenthic
        if not isMatch then filters['benthicArmor'].filterMessage = 'item is Benthic Armor.' end
        return isMatch
    end
end


------------------------------------------------------------------------------------------------------------------------------


filters['azeriteArmor'].order = 1
filters['armorType'].order = 2
filters['bags'].order = 3
filters['benthicArmor'].order = 4
filters['bindType'].order = 5
filters['bonusStats'].order = 6
filters['duplicates'].order = 7
filters['equipmentSet'].order = 8
filters['itemLevel'].order = 9
filters['itemName'].order = 10
filters['itemQuality'].order = 11
filters['itemSlot'].order = 12
filters['itemType'].order = 13
filters['sellPrice'].order = 14
filters['transmogKnown'].order = 15
filters['weaponType'].order = 16





EasyScrap.filterTypes = filters
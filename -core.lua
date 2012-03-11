local cfg = {

	mainbar =   {
		name = "Action",
		pos = "BOTTOM",
		x = 0,
		y = 4,
		size = 28,
		orientation = "H",
		spacing = 2
	},
	multibarbottomleft = {
		name = "MultiBarBottomLeft",
		pos = "BOTTOM",
		x = 0,
		y = 34,
		size = 28,
		orientation = "H",
		spacing = 2
	},
	multibarbottomright = {
		name = "MultiBarBottomRight",
		pos = "BOTTOM",
		x = 0,
		y = 64,
		size = 28,
		orientation = "H",
		spacing = 2
	},
	multibarleft = {
		name = "MultiBarLeft",
		pos = "RIGHT",
		x = -34,
		y = 0,
		size = 28,
		orientation = "V",
		spacing = 2
	},
	multibarright = {
		name = "MultiBarRight",
		pos = "RIGHT",
		x = -4,
		y = 0,
		size = 28,
		orientation = "V",
		spacing = 2
	},
	shapeshift = {
		name = "Shapeshift",
		pos = "TOP",
		x = 0,
		y = 0,
		size = 28,
		orientation = "V",
		spacing = 2
	}

}

local ButtonColors = {
	normal = { 0.6, 0.6, 0.6, 1 },
	highlight = { 0.4, 0.4, 0.4, 1 },
	--checked = { 0.3, 0.3, 0.3, 1 },
	checked = { 0, 0, 1 },
	pushed = { 0.3, 0.3, 0.3, 1 }
}

local ButtonFont = "Interface\\Addons\\MagiActionBars\\font.ttf"
local NormalTexture = "Interface\\Addons\\MagiActionBars\\teste"

local function FixGrid(button)
	local normal = button:GetNormalTexture()
	local highlight = button:GetHighlightTexture()
	local checked = button:GetCheckedTexture()
	local pushed = button:GetPushedTexture()

	normal:SetVertexColor(unpack(ButtonColors.normal))
	highlight:SetVertexColor(unpack(ButtonColors.highlight))
	checked:SetVertexColor(unpack(ButtonColors.checked))
	pushed:SetVertexColor(unpack(ButtonColors.pushed))
end

local function StyleButton(b)
	b:SetNormalTexture(NormalTexture)
	b:SetCheckedTexture(NormalTexture)
	b:SetHighlightTexture(NormalTexture)
	b:SetPushedTexture(NormalTexture)

	local normal = b:GetNormalTexture()
	local highlight = b:GetHighlightTexture()
	local checked = b:GetCheckedTexture()
	local pushed = b:GetPushedTexture()
	local name = b:GetName()

	normal:SetAllPoints()
	normal:SetVertexColor(unpack(ButtonColors.normal))
	highlight:SetVertexColor(unpack(ButtonColors.highlight))
	checked:SetVertexColor(unpack(ButtonColors.checked))
	pushed:SetVertexColor(unpack(ButtonColors.pushed))

	local name = b:GetName()
	_G[name.."Icon"]:SetTexCoord(0.078, 0.92, 0.078, 0.92) --< originalmente: 0.078125, 0.921875, 0.078125, 0.921875
	_G[name.."Icon"]:SetPoint("TOPLEFT", 2, -2)
	_G[name.."Icon"]:SetPoint("BOTTOMRIGHT", -2, 2)
	_G[name.."HotKey"]:SetFont(ButtonFont, 8, "THINOUTLINE")
	_G[name.."HotKey"]:SetPoint("TOPRIGHT", 0, 0)
	-- _G[name.."HotKey"]:SetTextColor(1, 0, 1, 1) --< não funciona devido ao rangecheck

	_G[name.."Count"]:SetFont(ButtonFont, 8, "THINOUTLINE")
	_G[name.."Name"]:SetFont(ButtonFont, 8, "THINOUTLINE")
	_G[name.."Name"]:SetShadowColor(0, 0, 0, 0)

end

local function UpdateButtons(bar)
	local conf = cfg[bar]
	if (conf.orientation == 'H') then
		for i = 1, 12, 1 do
			local b = _G[conf.name.."Button"..i]
			b:ClearAllPoints()
			b:SetSize(conf.size, conf.size)
			b:SetPoint("TOPLEFT", (conf.size * i - conf.size) + (i * conf.spacing - conf.spacing), 0)
		end
	else
		for i = 1, 12, 1 do
			local b = _G[conf.name.."Button"..i]
			b:ClearAllPoints()
			b:SetSize(conf.size, conf.size)
			b:SetPoint("TOPLEFT", 0, -((conf.size * i - conf.size) + (i * conf.spacing - conf.spacing)))
		end
	end

end

local function CreateBars()

	-- cria uns frames cinza escuro só para não ficar muito feio
	--[[local scale = UIParent:GetScale()
	local bg = CreateFrame("Frame")
	bg:SetSize(388 * scale, 100 * scale)
	bg:SetPoint("BOTTOM", 0, 0)
	bg.tex = bg:CreateTexture()
	bg.tex:SetAllPoints()
	bg.tex:SetTexture(0.1, 0.1, 0.1)

	local bg2 = CreateFrame("Frame")
	bg2:SetSize(68 * scale, 388 * scale)
	bg2:SetPoint("RIGHT", 0, 0)
	bg2.tex = bg2:CreateTexture()
	bg2.tex:SetAllPoints()
	bg2.tex:SetTexture(0.1, 0.1, 0.1)]]

	-- cria container específico para a main action bar pois ela é mítica
	local MainBarContainer = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
	local conf = cfg.mainbar
	if (conf.orientation == 'H') then
		MainBarContainer:SetSize(conf.size * 12 + 11 *  conf.spacing, conf.size)
	else
		MainBarContainer:SetSize(conf.size, conf.size * 12 + 11 *  conf.spacing)
	end

	MainBarContainer:SetPoint(conf.pos, conf.x, conf.y)
	for i = 1, 12, 1 do
		local b = _G["ActionButton"..i]
		b:SetParent(MainBarContainer)
	end
	UpdateButtons("mainbar")


	--local bars = {}
	--if (_G["ShapeshiftBarFrame"] ~= nil) then
	--	bars = { "multibarbottomleft", "multibarbottomright", "multibarleft", "multibarright", "shapeshift" }
	--else
		bars = { "multibarbottomleft", "multibarbottomright", "multibarleft", "multibarright" }
	--end

	-- cria containers para as outras action bars
	for key, barname in pairs(bars) do
		local conf = cfg[barname]
		local container = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
		if (conf.orientation == "H") then
			container:SetSize(12 * conf.size + 11 *  conf.spacing, conf.size)
		else
			container:SetSize(conf.size, 12 * conf.size + 11 *  conf.spacing)
		end
		container:SetPoint(conf.pos, conf.x, conf.y)
		--print(conf.name)
		_G[conf.name]:SetParent(container)
		_G[conf.name]:ClearAllPoints()
		_G[conf.name]:SetPoint("TOPLEFT", 0, 0)
		UpdateButtons(barname)
	end

	MainMenuBar:Hide() --< esconde a barra padrão

end

-- listener para disparar o ajuste das action bars
local listener = CreateFrame("Frame")
listener:RegisterEvent("PLAYER_ENTERING_WORLD")
listener:SetScript("OnEvent", CreateBars)

-- listener para disparar o ajuste de cada button
hooksecurefunc("ActionButton_Update", StyleButton)
hooksecurefunc("ActionButton_ShowGrid", FixGrid)
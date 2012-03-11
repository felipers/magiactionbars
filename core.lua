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
		name = "ShapeshiftBarFrame",
		pos = "BOTTOM",
		x = -240,
		y = 4,
		size = 28,
		orientation = "H",
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
local NormalTexture = "Interface\\Addons\\MagiActionBars\\borda"

--
-- StyleButton
-- Estiliza cada button de cada ActionBar
-- baseado na configuração
--
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
	if (_G[name.."Name"]) then
		_G[name.."Name"]:SetFont(ButtonFont, 8, "THINOUTLINE")
		_G[name.."Name"]:SetShadowColor(0, 0, 0, 0)
	end
	

end

local function StyleShapeShiftButtons()
	for i = 1, 4, 1 do
		local b = _G["ShapeshiftButton"..i]
		StyleButton(b)
	end
end

--
-- UpdateButtons
-- Organiza, posiciona e redimensiona os botões
-- de cada ActionBar, dependendo da orientação
--
local function UpdateButtons(bar)
	local conf = cfg[bar]
	if (conf.name == "ShapeshiftBarFrame") then
		-- alteração de nome pois essa ActionBar sai do padrão :(
		conf.name = "Shapeshift"
	end
	if (conf.orientation == 'H') then
		for i = 1, 12, 1 do
			local b = _G[conf.name.."Button"..i]
			if (b == nil) then break end -- Shapeshift não tem 12 =P
			b:ClearAllPoints()
			b:SetSize(conf.size, conf.size)
			b:SetPoint("TOPLEFT", (conf.size * i - conf.size) + (i * conf.spacing - conf.spacing), 0)
		end
	else
		for i = 1, 12, 1 do
			local b = _G[conf.name.."Button"..i]
			if (b == nil) then break end -- Shapeshift não tem 12 =P
			b:ClearAllPoints()
			b:SetSize(conf.size, conf.size)
			b:SetPoint("TOPLEFT", 0, -((conf.size * i - conf.size) + (i * conf.spacing - conf.spacing)))
		end
	end

end

--
-- CreateBars
-- Organiza e posiciona as ActionBars através
-- de novos containers
--
local function CreateBars()
	local bars = { "mainbar", "multibarbottomleft", "multibarbottomright", "multibarleft", "multibarright" }
	-- caso exista a shapeshiftbar
	if (_G["ShapeshiftBarFrame"] ~= nil) then
		bars = { "mainbar", "multibarbottomleft", "multibarbottomright", "multibarleft", "multibarright", "shapeshift" }
	end

	-- percorre as bars
	for key, barName in pairs(bars) do
		local buttons = 12
		if (barName == "shapeshift") then buttons = 4 end

		-- puxa configuração
		local conf = cfg[barName]

		-- cria o container para os botões
		local container = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")

		-- seta o tamanho do container baseado na orientação
		if (conf.orientation == "H") then
			container:SetSize(buttons * conf.size + (buttons - 1) *  conf.spacing, conf.size)
		else
			container:SetSize(conf.size, buttons * conf.size + (buttons - 1) *  conf.spacing)
		end

		-- posiciona o container
		container:SetPoint(conf.pos, conf.x, conf.y)

		if (barName == "mainbar") then
			-- realoca os botões caso seja a ActionBar
			-- pois ela não tem parent próprio
			for i = 1, 12, 1 do
				local b = _G[conf.name.."Button"..i]
				b:SetParent(container)
			end
		else
			-- realoca as bars caso não seja a ActionBar :)
			-- print(conf.name)
			if (_G[conf.name]) then
				_G[conf.name]:SetParent(container)
				_G[conf.name]:ClearAllPoints()
				_G[conf.name]:SetPoint("TOPLEFT", 0, 0)
			end
		end

		-- atualiza os botoes da barra
		UpdateButtons(barName)

	end
	MainMenuBar:Hide()
	StyleShapeShiftButtons()
end

local ADDON_ENABLED = true
if (ADDON_ENABLED) then
	-- listener para disparar o ajuste geral das action bars
	local listener = CreateFrame("Frame")
	listener:RegisterEvent("PLAYER_ENTERING_WORLD")
	listener:SetScript("OnEvent", CreateBars)

	-- listener para disparar o ajuste de cada button
	hooksecurefunc("ActionButton_Update", StyleButton)
end

-- não é mais necessário corrigir o bug do ShowGrid :)
-- pois aparentemente foi ajustado em algum hotfix do 4.2



-- local function FixGrid(button)
-- 	local normal = button:GetNormalTexture()
-- 	local highlight = button:GetHighlightTexture()
-- 	local checked = button:GetCheckedTexture()
-- 	local pushed = button:GetPushedTexture()

-- 	normal:SetVertexColor(unpack(ButtonColors.normal))
-- 	highlight:SetVertexColor(unpack(ButtonColors.highlight))
-- 	checked:SetVertexColor(unpack(ButtonColors.checked))
-- 	pushed:SetVertexColor(unpack(ButtonColors.pushed))
-- end

--hooksecurefunc("ActionButton_ShowGrid", FixGrid)
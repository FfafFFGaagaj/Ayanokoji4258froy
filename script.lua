local Players, TweenService, UIS, RunService = game:GetService("Players"), game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("RunService")
local Lighting, player = game:GetService("Lighting"), Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
if playerGui:FindFirstChild("CustomMobileHub") then playerGui.CustomMobileHub:Destroy() end

local function rgb(r,g,b) return Color3.fromRGB(r,g,b) end
local Colors = {
	MainBg=rgb(22,24,30), SidebarBg=rgb(18,20,25), TopbarBg=rgb(16,18,22), CardBg=rgb(30,33,41),
	InputBg=rgb(20,22,28), TextPrimary=rgb(240,242,248), TextSecondary=rgb(155,160,175),
	Accent=rgb(130,85,255), ToggleOn=rgb(65,175,245), ToggleOff=rgb(55,60,72)
}
local function corner(o,r) local c=Instance.new("UICorner",o); c.CornerRadius=UDim.new(0,r or 7); return c end
local function stroke(o,col,th,tr) local s=Instance.new("UIStroke",o); s.Color=col or rgb(48,52,65); s.Thickness=th or 1; s.Transparency=tr or 0; return s end
local function dragify(target, moveTarget, tapFn)
	local dragging, moved, inpActive, startP, startPos = false, false, nil, nil, nil
	target.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
			dragging, moved, startP, startPos = true, false, i.Position, moveTarget.Position
			i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false; if not moved and tapFn then tapFn() end end end)
		end
	end)
	target.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement then inpActive=i end end)
	UIS.InputChanged:Connect(function(i)
		if i==inpActive and dragging then
			local d=i.Position-startP; if d.Magnitude>6 then moved=true end
			moveTarget.Position=UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
		end
	end)
end

local Library = {}
function Library:CreateWindow(cfg)
	local sg = Instance.new("ScreenGui"); sg.Name, sg.ResetOnSpawn, sg.IgnoreGuiInset, sg.DisplayOrder, sg.ZIndexBehavior, sg.Parent = "CustomMobileHub", false, true, 999999, Enum.ZIndexBehavior.Global, playerGui
	local fb = Instance.new("TextButton", sg); fb.Name, fb.Size, fb.Position, fb.BackgroundColor3, fb.Text, fb.TextColor3, fb.Font, fb.TextSize, fb.ZIndex = "FloatingToggle", UDim2.fromOffset(48,48), UDim2.new(0.04,0,0.2,0), Colors.TopbarBg, "UI", Colors.TextPrimary, Enum.Font.GothamBold, 15, 1000000
	corner(fb, 999); stroke(fb, Colors.Accent, 2)

	local mf = Instance.new("Frame", sg); mf.Name, mf.Size, mf.Position, mf.BackgroundColor3, mf.ClipsDescendants, mf.ZIndex = "MainFrame", UDim2.fromOffset(480,295), UDim2.new(0.5,-240,0.5,-147), Colors.MainBg, true, 999990
	corner(mf, 10); stroke(mf, Colors.Accent, 1.5)

	local tb = Instance.new("Frame", mf); tb.Name, tb.Size, tb.BackgroundColor3, tb.BorderSizePixel, tb.ZIndex = "TopBar", UDim2.new(1,0,0,34), Colors.TopbarBg, 0, 999992
	local tt = Instance.new("TextLabel", tb); tt.Size, tt.Position, tt.BackgroundTransparency, tt.Text, tt.TextColor3, tt.Font, tt.TextSize, tt.TextXAlignment, tt.ZIndex = UDim2.new(1,-110,1,0), UDim2.fromOffset(14,0), 1, (cfg and cfg.Title) or "ZENOX HUB 1.0", Colors.TextPrimary, Enum.Font.GothamSemibold, 13, Enum.TextXAlignment.Left, 999993

	local function topBtn(sym, ox, fn)
		local b=Instance.new("TextButton", tb); b.Size, b.Position, b.BackgroundTransparency, b.Text, b.TextColor3, b.Font, b.TextSize, b.ZIndex = UDim2.fromOffset(28,28), UDim2.new(1,ox,0.5,-14), 1, sym, Colors.TextSecondary, Enum.Font.GothamBold, 14, 999993
		b.MouseButton1Click:Connect(fn)
	end
	topBtn("✕", -32, function() sg:Destroy() end)
	local exp = false
	topBtn("□", -62, function()
		exp = not exp
		TweenService:Create(mf, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
			Size = exp and UDim2.fromOffset(550,330) or UDim2.fromOffset(480,295),
			Position = exp and UDim2.new(0.5,-275,0.5,-165) or UDim2.new(0.5,-240,0.5,-147)
		}):Play()
	end)
	topBtn("—", -92, function() mf.Visible, fb.Visible = false, true end)
	dragify(tb, mf); dragify(fb, fb, function() mf.Visible, fb.Visible = not mf.Visible, true end)

	local sb = Instance.new("ScrollingFrame", mf); sb.Name, sb.Size, sb.Position, sb.BackgroundColor3, sb.BorderSizePixel, sb.ScrollBarThickness, sb.CanvasSize, sb.AutomaticCanvasSize, sb.ZIndex = "Sidebar", UDim2.new(0,130,1,-86), UDim2.fromOffset(0,34), Colors.SidebarBg, 0, 2, UDim2.new(0,0,0,0), Enum.AutomaticSize.Y, 999991
	local sp = Instance.new("UIPadding", sb); sp.PaddingTop, sp.PaddingLeft, sp.PaddingRight = UDim.new(0,8), UDim.new(0,8), UDim.new(0,8)
	local sl = Instance.new("UIListLayout", sb); sl.Padding, sl.SortOrder = UDim.new(0,6), Enum.SortOrder.LayoutOrder

	local pf = Instance.new("Frame", mf); pf.Name, pf.Size, pf.Position, pf.BackgroundColor3, pf.BackgroundTransparency, pf.ZIndex = "ZenoxAvatarProfile", UDim2.fromOffset(118,40), UDim2.new(0,6,1,-46), Colors.TopbarBg, 0.05, 999995
	corner(pf, 8); stroke(pf, Colors.Accent, 1.2)
	local av = Instance.new("ImageLabel", pf); av.Name, av.Size, av.Position, av.BackgroundColor3, av.ZIndex = "AvatarIcon", UDim2.fromOffset(28,28), UDim2.new(0,5,0.5,-14), Colors.CardBg, 999996
	corner(av, 999); local as = stroke(av, rgb(255,255,255), 1.2)
	task.spawn(function() pcall(function() local c, r = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150); if r and av and av.Parent then av.Image = c end end) end)

	local nl = Instance.new("TextLabel", pf); nl.Name, nl.Size, nl.Position, nl.BackgroundTransparency, nl.Text, nl.TextColor3, nl.Font, nl.TextSize, nl.TextXAlignment, nl.TextTruncate, nl.ZIndex = "RainbowUsername", UDim2.new(1,-38,1,0), UDim2.fromOffset(36,0), 1, player.Name, rgb(255,255,255), Enum.Font.GothamBold, 10, Enum.TextXAlignment.Left, Enum.TextTruncate.AtEnd, 999996
	local seq = ColorSequence.new({
		ColorSequenceKeypoint.new(0,rgb(255,65,85)), ColorSequenceKeypoint.new(0.2,rgb(255,185,45)), ColorSequenceKeypoint.new(0.4,rgb(95,255,120)),
		ColorSequenceKeypoint.new(0.6,rgb(65,195,255)), ColorSequenceKeypoint.new(0.8,rgb(165,95,255)), ColorSequenceKeypoint.new(1,rgb(255,75,195))
	})
	local rg, ag = Instance.new("UIGradient", nl), Instance.new("UIGradient", as); rg.Color, ag.Color = seq, seq
	task.spawn(function() local o=0; while pf and pf.Parent do o=(o+RunService.RenderStepped:Wait()*0.35)%1; rg.Offset, ag.Rotation = Vector2.new(o,0), (o*360)%360 end end)

	local pagesFolder = Instance.new("Folder", mf); pagesFolder.Name = "Pages"
	local tabs, firstTab, Win = {}, true, {}

	function Win:AddTab(name, ico, minH)
		local bMin = minH or 800
		local btn = Instance.new("TextButton", sb); btn.Name, btn.Size, btn.BackgroundColor3, btn.BackgroundTransparency, btn.Text, btn.AutoButtonColor, btn.ZIndex = name.."_Tab", UDim2.new(1,0,0,32), Colors.CardBg, 1, "", false, 999992
		corner(btn, 6); local tst = stroke(btn, Colors.Accent, 1.2, 1)
		local ind = Instance.new("Frame", btn); ind.Size, ind.Position, ind.BackgroundColor3, ind.BorderSizePixel, ind.Visible, ind.ZIndex = UDim2.new(0,3,0.6,0), UDim2.new(0,3,0.2,0), Colors.ToggleOn, 0, false, 999993; corner(ind, 999)
		local tlbl = Instance.new("TextLabel", btn); tlbl.Size, tlbl.Position, tlbl.BackgroundTransparency, tlbl.Text, tlbl.TextColor3, tlbl.Font, tlbl.TextSize, tlbl.TextXAlignment, tlbl.ZIndex = UDim2.new(1,-16,1,0), UDim2.fromOffset(12,0), 1, (ico and ico.."  " or "")..name, Colors.TextSecondary, Enum.Font.GothamSemibold, 12, Enum.TextXAlignment.Left, 999993

		local pg = Instance.new("ScrollingFrame", pagesFolder); pg.Name, pg.Size, pg.Position, pg.BackgroundTransparency, pg.BorderSizePixel, pg.ScrollBarThickness, pg.ScrollBarImageColor3, pg.ElasticBehavior, pg.ScrollingDirection, pg.CanvasSize, pg.AutomaticCanvasSize, pg.Visible, pg.ZIndex = name.."_Page", UDim2.new(1,-130,1,-34), UDim2.fromOffset(130,34), 1, 0, 4, Colors.Accent, Enum.ElasticBehavior.Always, Enum.ScrollingDirection.Y, UDim2.new(0,0,0,bMin), Enum.AutomaticSize.Y, false, 999991
		local pp = Instance.new("UIPadding", pg); pp.PaddingTop, pp.PaddingLeft, pp.PaddingRight, pp.PaddingBottom = UDim.new(0,10), UDim.new(0,14), UDim.new(0,14), UDim.new(0,70)
		local pl = Instance.new("UIListLayout", pg); pl.Padding, pl.SortOrder = UDim.new(0,8), Enum.SortOrder.LayoutOrder
		local function sync() pg.CanvasSize = UDim2.new(0,0,0,math.max(pl.AbsoluteContentSize.Y+90, bMin)) end
		pl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(sync); task.defer(sync)

		local hd = Instance.new("TextLabel", pg); hd.Size, hd.BackgroundTransparency, hd.Text, hd.TextColor3, hd.Font, hd.TextSize, hd.TextXAlignment, hd.ZIndex = UDim2.new(1,0,0,26), 1, name, Colors.TextPrimary, Enum.Font.GothamBold, 18, Enum.TextXAlignment.Left, 999992
		local function sel()
			for _, t in ipairs(tabs) do t.Pg.Visible=false; t.Btn.BackgroundTransparency=1; t.St.Transparency=1; t.Ind.Visible=false; t.Lbl.TextColor3=Colors.TextSecondary end
			pg.Visible=true; sync(); btn.BackgroundTransparency=0; tst.Transparency=0; ind.Visible=true; tlbl.TextColor3=Colors.TextPrimary
		end
		btn.MouseButton1Click:Connect(sel); table.insert(tabs, {Btn=btn, St=tst, Ind=ind, Lbl=tlbl, Pg=pg}); if firstTab then firstTab=false; sel() end
		return {Page=pg, ScreenGui=sg, Sync=sync}
	end
	return Win, sg
end
local function addSec(tab, txt)
	local l=Instance.new("TextLabel", tab.Page); l.Size, l.BackgroundTransparency, l.Text, l.TextColor3, l.Font, l.TextSize, l.TextXAlignment, l.ZIndex = UDim2.new(1,0,0,20), 1, txt, Colors.TextPrimary, Enum.Font.GothamBold, 14, Enum.TextXAlignment.Left, 999992; tab.Sync()
end
local function addTog(tab, title, desc, def, cb)
	local st = def or false
	local c = Instance.new("TextButton", tab.Page); c.Size, c.BackgroundColor3, c.Text, c.AutoButtonColor, c.ZIndex = UDim2.new(1,0,0, desc and 48 or 38), Colors.CardBg, "", false, 999992; corner(c); stroke(c)
	local tl = Instance.new("TextLabel", c); tl.Size, tl.Position, tl.BackgroundTransparency, tl.Text, tl.TextColor3, tl.Font, tl.TextSize, tl.TextXAlignment, tl.ZIndex = UDim2.new(1,-66,0,18), UDim2.fromOffset(12, desc and 7 or 10), 1, title, Colors.TextPrimary, Enum.Font.GothamBold, 12, Enum.TextXAlignment.Left, 999993
	if desc then local dl=Instance.new("TextLabel", c); dl.Size, dl.Position, dl.BackgroundTransparency, dl.Text, dl.TextColor3, dl.Font, dl.TextSize, dl.TextXAlignment, dl.ZIndex = UDim2.new(1,-66,0,16), UDim2.fromOffset(12,25), 1, desc, Colors.TextSecondary, Enum.Font.Gotham, 11, Enum.TextXAlignment.Left, 999993 end
	local sw = Instance.new("Frame", c); sw.Size, sw.Position, sw.BackgroundColor3, sw.ZIndex = UDim2.fromOffset(40,20), UDim2.new(1,-52,0.5,-10), st and Colors.ToggleOn or Colors.ToggleOff, 999993; corner(sw, 999)
	local kb = Instance.new("Frame", sw); kb.Size, kb.Position, kb.BackgroundColor3, kb.ZIndex = UDim2.fromOffset(14,14), st and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7), rgb(245,248,255), 999994; corner(kb, 999)
	c.MouseButton1Click:Connect(function()
		st = not st
		TweenService:Create(sw, TweenInfo.new(0.18), {BackgroundColor3 = st and Colors.ToggleOn or Colors.ToggleOff}):Play()
		TweenService:Create(kb, TweenInfo.new(0.18), {Position = st and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)}):Play()
		if cb then cb(st) end
	end); tab.Sync()
end
local function addSld(tab, title, desc, mn, mx, def, cb)
	local cur = math.clamp(def or mn, mn, mx)
	local c = Instance.new("Frame", tab.Page); c.Size, c.BackgroundColor3, c.ZIndex = UDim2.new(1,0,0,68), Colors.CardBg, 999992; corner(c); stroke(c)
	local tl = Instance.new("TextLabel", c); tl.Size, tl.Position, tl.BackgroundTransparency, tl.Text, tl.TextColor3, tl.Font, tl.TextSize, tl.TextXAlignment, tl.ZIndex = UDim2.new(1,-86,0,18), UDim2.fromOffset(12,7), 1, title, Colors.TextPrimary, Enum.Font.GothamBold, 12, Enum.TextXAlignment.Left, 999993
	if desc then local dl=Instance.new("TextLabel", c); dl.Size, dl.Position, dl.BackgroundTransparency, dl.Text, dl.TextColor3, dl.Font, dl.TextSize, dl.TextXAlignment, dl.ZIndex = UDim2.new(1,-86,0,14), UDim2.fromOffset(12,23), 1, desc, Colors.TextSecondary, Enum.Font.Gotham, 10, Enum.TextXAlignment.Left, 999993 end
	local bx = Instance.new("TextBox", c); bx.Size, bx.Position, bx.BackgroundColor3, bx.Text, bx.TextColor3, bx.Font, bx.TextSize, bx.ClearTextOnFocus, bx.ZIndex = UDim2.fromOffset(58,24), UDim2.new(1,-70,0,8), Colors.InputBg, tostring(cur), Colors.ToggleOn, Enum.Font.GothamBold, 12, false, 999994; corner(bx, 5); stroke(bx, Colors.Accent)
	local tr = Instance.new("Frame", c); tr.Size, tr.Position, tr.BackgroundColor3, tr.ZIndex = UDim2.new(1,-24,0,8), UDim2.fromOffset(12,42), Colors.ToggleOff, 999993; corner(tr, 999)
	local r0 = (cur-mn)/(mx-mn)
	local fl = Instance.new("Frame", tr); fl.Size, fl.BackgroundColor3, fl.ZIndex = UDim2.new(r0,0,1,0), Colors.ToggleOn, 999994; corner(fl, 999)
	local th = Instance.new("TextButton", tr); th.Size, th.Position, th.BackgroundColor3, th.Text, th.AutoButtonColor, th.ZIndex = UDim2.fromOffset(16,16), UDim2.new(r0,-8,0.5,-8), rgb(245,248,255), "", false, 999995; corner(th, 999)
	local function setV(v)
		local n=tonumber(v); if not n then bx.Text=tostring(cur); return end
		cur=math.clamp(math.floor(n+0.5), mn, mx); local r=(cur-mn)/(mx-mn)
		fl.Size, th.Position, bx.Text = UDim2.new(r,0,1,0), UDim2.new(r,-8,0.5,-8), tostring(cur)
		if cb then cb(cur) end
	end
	local slg = false
	local function upd(x) if tr.AbsoluteSize.X>0 then setV(mn + math.clamp((x-tr.AbsolutePosition.X)/tr.AbsoluteSize.X, 0, 1)*(mx-mn)) end end
	local function beg(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then slg=true; upd(i.Position.X); i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then slg=false end end) end end
	tr.InputBegan:Connect(beg); th.InputBegan:Connect(beg)
	UIS.InputChanged:Connect(function(i) if slg and (i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement) then upd(i.Position.X) end end)
	bx.FocusLost:Connect(function() setV(bx.Text) end); tab.Sync()
end
local function addPick(tab, sg, title, desc, list, defN, cb)
	local selN = defN or (list[1] and list[1].Name) or "ม่วง"
	local c = Instance.new("TextButton", tab.Page); c.Size, c.BackgroundColor3, c.Text, c.AutoButtonColor, c.ZIndex = UDim2.new(1,0,0, desc and 48 or 38), Colors.CardBg, "", false, 999992; corner(c); stroke(c)
	local tl = Instance.new("TextLabel", c); tl.Size, tl.Position, tl.BackgroundTransparency, tl.Text, tl.TextColor3, tl.Font, tl.TextSize, tl.TextXAlignment, tl.ZIndex = UDim2.new(1,-110,0,18), UDim2.fromOffset(12, desc and 7 or 10), 1, title, Colors.TextPrimary, Enum.Font.GothamBold, 12, Enum.TextXAlignment.Left, 999993
	if desc then local dl=Instance.new("TextLabel", c); dl.Size, dl.Position, dl.BackgroundTransparency, dl.Text, dl.TextColor3, dl.Font, dl.TextSize, dl.TextXAlignment, dl.ZIndex = UDim2.new(1,-110,0,16), UDim2.fromOffset(12,25), 1, desc, Colors.TextSecondary, Enum.Font.Gotham, 11, Enum.TextXAlignment.Left, 999993 end
	local bg = Instance.new("TextLabel", c); bg.Size, bg.Position, bg.BackgroundColor3, bg.Text, bg.TextColor3, bg.Font, bg.TextSize, bg.ZIndex = UDim2.fromOffset(86,24), UDim2.new(1,-96,0.5,-12), Colors.InputBg, "สี: "..selN.." >", Colors.ToggleOn, Enum.Font.GothamBold, 11, 999993; corner(bg, 5); stroke(bg, Colors.Accent)
	local pop = Instance.new("Frame", sg); pop.Name, pop.Size, pop.Position, pop.BackgroundColor3, pop.ZIndex, pop.Visible = "ColorPickerPopup", UDim2.fromOffset(250,215), UDim2.new(0.5,-125,0.5,-107), Colors.MainBg, 999998, false; corner(pop, 10); stroke(pop, Colors.Accent, 2)
	local pt = Instance.new("TextLabel", pop); pt.Size, pt.Position, pt.BackgroundTransparency, pt.Text, pt.TextColor3, pt.Font, pt.TextSize, pt.TextXAlignment, pt.ZIndex = UDim2.new(1,-40,0,30), UDim2.fromOffset(12,4), 1, "เลือกสีมองผู้เล่น", Colors.TextPrimary, Enum.Font.GothamBold, 13, Enum.TextXAlignment.Left, 999999
	local cl = Instance.new("TextButton", pop); cl.Size, cl.Position, cl.BackgroundTransparency, cl.Text, cl.TextColor3, cl.Font, cl.TextSize, cl.ZIndex = UDim2.fromOffset(26,26), UDim2.new(1,-32,0,6), 1, "✕", Colors.TextSecondary, Enum.Font.GothamBold, 13, 999999; cl.MouseButton1Click:Connect(function() pop.Visible=false end)
	local hd = Instance.new("Frame", pop); hd.Size, hd.Position, hd.BackgroundTransparency, hd.ZIndex = UDim2.new(1,-20,1,-42), UDim2.fromOffset(10,36), 1, 999999
	local ll = Instance.new("UIListLayout", hd); ll.Padding, ll.SortOrder = UDim.new(0,5), Enum.SortOrder.LayoutOrder
	for _, it in ipairs(list) do
		local op = Instance.new("TextButton", hd); op.Size, op.BackgroundColor3, op.Text, op.AutoButtonColor, op.ZIndex = UDim2.new(1,0,0,27), Colors.CardBg, "", false, 999999; corner(op, 6)
		local sw = Instance.new("Frame", op); sw.Size, sw.Position, sw.BackgroundColor3, sw.BorderSizePixel, sw.ZIndex = UDim2.fromOffset(16,16), UDim2.new(0,10,0.5,-8), it.Color or rgb(255,255,255), 0, 999999; corner(sw, 999)
		if it.IsRainbow then local g=Instance.new("UIGradient", sw); g.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,rgb(255,65,65)),ColorSequenceKeypoint.new(0.25,rgb(255,200,50)),ColorSequenceKeypoint.new(0.5,rgb(65,255,130)),ColorSequenceKeypoint.new(0.75,rgb(65,175,255)),ColorSequenceKeypoint.new(1,rgb(185,75,255))}) end
		local lb = Instance.new("TextLabel", op); lb.Size, lb.Position, lb.BackgroundTransparency, lb.Text, lb.TextColor3, lb.Font, lb.TextSize, lb.TextXAlignment, lb.ZIndex = UDim2.new(1,-36,1,0), UDim2.fromOffset(34,0), 1, it.Name, Colors.TextPrimary, Enum.Font.GothamSemibold, 12, Enum.TextXAlignment.Left, 999999
		op.MouseButton1Click:Connect(function() selN=it.Name; bg.Text="สี: "..selN.." >"; pop.Visible=false; if cb then cb(it.Name, it.Color, it.IsRainbow) end end)
	end
	c.MouseButton1Click:Connect(function() pop.Visible = not pop.Visible end); tab.Sync()
end

local Window, MainSG = Library:CreateWindow({ Title = "ZENOX HUB 1.0" })
local GeneralTab = Window:AddTab("General", "🏠", 750)
local CharTab = Window:AddTab("Character", "👤", 1050)
local VisualsTab = Window:AddTab("Visuals", "👁️", 980)
local SettingsTab = Window:AddTab("Settings", "⚙️", 750)

local faceNearestEnabled = false
local function getNearestTarget(maxR)
	local myR = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not myR then return nil end
	local cl, dMin = nil, maxR or math.huge
	for _, m in ipairs(workspace:GetDescendants()) do
		if m:IsA("Model") and m~=player.Character then
			local h, r = m:FindFirstChildOfClass("Humanoid"), m:FindFirstChild("HumanoidRootPart")
			if h and r and h.Health>0 then local d=(r.Position-myR.Position).Magnitude; if d<dMin then dMin, cl = d, r end end
		end
	end
	return cl
end
addSec(GeneralTab, "Combat / Target")
addTog(GeneralTab, "Face Nearest Target (No Cam)", "หันหน้าตัวละครหาผู้เล่น/บอท/Dummy ใกล้สุด โดยไม่หันกล้อง", false, function(s) faceNearestEnabled=s end)

addSec(GeneralTab, "Teleport")
do
	local chosen, tLbl = nil, nil
	local pop = Instance.new("Frame", MainSG); pop.Name, pop.Size, pop.Position, pop.BackgroundColor3, pop.ZIndex, pop.Visible = "ZenoxTpPopup", UDim2.fromOffset(250,210), UDim2.new(0.5,-125,0.5,-105), Colors.MainBg, 999998, false; corner(pop, 10); stroke(pop, Colors.Accent, 2)
	local cx = Instance.new("TextButton", pop); cx.Size, cx.Position, cx.BackgroundTransparency, cx.Text, cx.TextColor3, cx.Font, cx.TextSize, cx.ZIndex = UDim2.fromOffset(24,24), UDim2.new(1,-28,0,4), 1, "✕", Colors.TextSecondary, Enum.Font.GothamBold, 12, 999999; cx.MouseButton1Click:Connect(function() pop.Visible=false end)
	local lh = Instance.new("ScrollingFrame", pop); lh.Size, lh.Position, lh.BackgroundTransparency, lh.BorderSizePixel, lh.ScrollBarThickness, lh.CanvasSize, lh.AutomaticCanvasSize, lh.ZIndex = UDim2.new(1,-14,1,-36), UDim2.fromOffset(7,30), 1, 0, 2, UDim2.new(0,0,0,0), Enum.AutomaticSize.Y, 999999
	local ll = Instance.new("UIListLayout", lh); ll.Padding, ll.SortOrder = UDim.new(0,5), Enum.SortOrder.LayoutOrder
	local function rebuild()
		for _, i in ipairs(lh:GetChildren()) do if i:IsA("TextButton") or i:IsA("TextLabel") then i:Destroy() end end
		local tot=0
		for _, p in ipairs(Players:GetPlayers()) do
			if p~=player then
				tot+=1; local rb=Instance.new("TextButton", lh); rb.Size, rb.BackgroundColor3, rb.Text, rb.TextColor3, rb.Font, rb.TextSize, rb.TextXAlignment, rb.TextTruncate, rb.ZIndex = UDim2.new(1,-4,0,26), Colors.MainBg, (p.DisplayName~=p.Name) and (p.DisplayName.." (@"..p.Name..")") or p.Name, Colors.TextPrimary, Enum.Font.GothamSemibold, 11, Enum.TextXAlignment.Left, Enum.TextTruncate.AtEnd, 999999
				corner(rb, 5); local pad=Instance.new("UIPadding", rb); pad.PaddingLeft=UDim.new(0,8)
				rb.MouseButton1Click:Connect(function() chosen=p; if tLbl then tLbl.Text, tLbl.TextColor3 = "เป้าหมาย: "..rb.Text, Colors.ToggleOn end; pop.Visible=false end)
			end
		end
		if tot==0 then local nl2=Instance.new("TextLabel", lh); nl2.Size, nl2.BackgroundTransparency, nl2.Text, nl2.TextColor3, nl2.Font, nl2.TextSize, nl2.ZIndex = UDim2.new(1,0,0,24), 1, "ไม่มีผู้เล่นอื่นในห้อง", Colors.TextSecondary, Enum.Font.Gotham, 11, 999999 end
	end
	local bx = Instance.new("Frame", GeneralTab.Page); bx.Size, bx.BackgroundColor3, bx.ZIndex = UDim2.new(1,0,0,74), Colors.CardBg, 999992; corner(bx)
	local ob = Instance.new("TextButton", bx); ob.Size, ob.Position, ob.BackgroundColor3, ob.Text, ob.TextColor3, ob.Font, ob.TextSize, ob.ZIndex = UDim2.new(1,-16,0,28), UDim2.fromOffset(8,8), Colors.InputBg, "เลือกชื่อผู้เล่นที่จะวาป  ▼", Colors.TextPrimary, Enum.Font.GothamBold, 11, 999993; corner(ob, 6)
	tLbl = Instance.new("TextLabel", bx); tLbl.Size, tLbl.Position, tLbl.BackgroundTransparency, tLbl.Text, tLbl.TextColor3, tLbl.Font, tLbl.TextSize, tLbl.TextXAlignment, tLbl.TextTruncate, tLbl.ZIndex = UDim2.new(1,-104,0,26), UDim2.fromOffset(10,41), 1, "เป้าหมาย: ยังไม่ได้เลือก", Colors.TextSecondary, Enum.Font.GothamSemibold, 11, Enum.TextXAlignment.Left, Enum.TextTruncate.AtEnd, 999993
	local tb2 = Instance.new("TextButton", bx); tb2.Size, tb2.Position, tb2.BackgroundColor3, tb2.Text, tb2.TextColor3, tb2.Font, tb2.TextSize, tb2.ZIndex = UDim2.fromOffset(84,26), UDim2.new(1,-92,0,41), Colors.ToggleOn, "วาปไปหา", Colors.TopbarBg, Enum.Font.GothamBold, 11, 999993; corner(tb2, 6)
	ob.MouseButton1Click:Connect(function() rebuild(); pop.Visible = not pop.Visible end)
	tb2.MouseButton1Click:Connect(function()
		if not chosen or not chosen.Parent then tLbl.Text, tLbl.TextColor3 = "เป้าหมาย: ยังไม่ได้เลือก", rgb(255,95,110); return end
		local mr, tr2 = player.Character and player.Character:FindFirstChild("HumanoidRootPart"), chosen.Character and chosen.Character:FindFirstChild("HumanoidRootPart")
		if mr and tr2 then mr.CFrame = tr2.CFrame * CFrame.new(0,0,3) end
	end)
end

addSec(GeneralTab, "Discord")
do
	local dc = Instance.new("Frame", GeneralTab.Page); dc.Name, dc.Size, dc.BackgroundColor3, dc.ZIndex = "ZenoxDiscordCard", UDim2.new(1,0,0,44), Colors.CardBg, 999992; corner(dc); stroke(dc)
	local dl = Instance.new("TextLabel", dc); dl.Size, dl.Position, dl.BackgroundTransparency, dl.Text, dl.TextColor3, dl.Font, dl.TextSize, dl.TextXAlignment, dl.ZIndex = UDim2.new(1,-118,1,0), UDim2.fromOffset(12,0), 1, "Discord Server", Colors.TextPrimary, Enum.Font.GothamSemibold, 12, Enum.TextXAlignment.Left, 999993
	local cb = Instance.new("TextButton", dc); cb.Size, cb.Position, cb.BackgroundColor3, cb.Text, cb.TextColor3, cb.Font, cb.TextSize, cb.ZIndex = UDim2.fromOffset(96,26), UDim2.new(1,-106,0.5,-13), Colors.Accent, "คัดลอกลิงก์ดิส", rgb(255,255,255), Enum.Font.GothamBold, 11, 999993; corner(cb, 6)
	cb.MouseButton1Click:Connect(function()
		local fn = (type(setclipboard)=="function" and setclipboard) or (type(toclipboard)=="function" and toclipboard) or (type(set_clipboard)=="function" and set_clipboard)
		if fn then pcall(fn, "https://discord.gg/J9EWMtk5CS") end
		cb.Text = "คัดลอกแล้ว ✓"; task.delay(1.5, function() if cb and cb.Parent then cb.Text="คัดลอกลิงก์ดิส" end end)
	end)
end
local speedEnabled, targetSpeed, jumpEnabled, targetJumpPower = false, 16, false, 50
local noclipEnabled, savedCollision, infJumpEnabled, airJumpPower, jumpCooldown = false, {}, false, 50, false
local posLockEnabled, lockedCFrame, fallLockEnabled, fallConn = false, nil, false, nil
local flyEnabled, flySpeed, flyBodyVel, flyBodyGyro = false, 80, nil, nil

local function applyJumpPower(hum, pwr)
	if not hum then return end
	if hum.UseJumpPower then hum.JumpPower=pwr else hum.JumpHeight=math.clamp((pwr*pwr)/(2*workspace.Gravity), 1, 500) end
end
local function setCharacterNoclip(char, en)
	if not char then return end
	if en then
		for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then if savedCollision[p]==nil then savedCollision[p]=p.CanCollide end; p.CanCollide=false end end
	else
		for p, old in pairs(savedCollision) do if p and p.Parent then p.CanCollide=old end end; table.clear(savedCollision)
	end
end
local function setCharacterFallLock(en)
	fallLockEnabled = en
	local char = player.Character; local hum, root = char and char:FindFirstChildOfClass("Humanoid"), char and char:FindFirstChild("HumanoidRootPart")
	if fallConn then fallConn:Disconnect(); fallConn=nil end
	if en and hum and hum.Health>0 then
		pcall(function() hum:ChangeState(Enum.HumanoidStateType.FallingDown); hum.PlatformStand=true end)
		if root then pcall(function() root.AssemblyAngularVelocity=Vector3.zero; root.CFrame=root.CFrame*CFrame.Angles(math.rad(75),0,0) end) end
		fallConn = RunService.Heartbeat:Connect(function()
			if not fallLockEnabled then return end
			local c=player.Character; local h, r = c and c:FindFirstChildOfClass("Humanoid"), c and c:FindFirstChild("HumanoidRootPart")
			if not h or h.Health<=0 then return end
			if h.MoveDirection.Magnitude>0.05 or UIS:IsKeyDown(Enum.KeyCode.Space) then
				fallLockEnabled=false; h.PlatformStand=false; pcall(function() h:ChangeState(Enum.HumanoidStateType.GettingUp) end)
				if fallConn then fallConn:Disconnect(); fallConn=nil end; return
			end
			h.PlatformStand=true; if r then r.AssemblyLinearVelocity=Vector3.new(0, r.AssemblyLinearVelocity.Y, 0) end
		end)
	elseif hum and hum.Health>0 then hum.PlatformStand=false; pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end) end
end
local function stopFly()
	flyEnabled=false
	if flyBodyVel then pcall(function() flyBodyVel:Destroy() end); flyBodyVel=nil end
	if flyBodyGyro then pcall(function() flyBodyGyro:Destroy() end); flyBodyGyro=nil end
	local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid"); if hum then hum.PlatformStand=false end
end
local function startFly()
	local char = player.Character; local root, hum = char and char:FindFirstChild("HumanoidRootPart"), char and char:FindFirstChildOfClass("Humanoid")
	if not root or not hum then return end
	if flyBodyVel then pcall(function() flyBodyVel:Destroy() end) end; if flyBodyGyro then pcall(function() flyBodyGyro:Destroy() end) end
	flyBodyVel = Instance.new("BodyVelocity"); flyBodyVel.Name, flyBodyVel.MaxForce, flyBodyVel.Velocity, flyBodyVel.Parent = "ZenoxFlyVelocity", Vector3.new(1e6,1e6,1e6), Vector3.zero, root
	flyBodyGyro = Instance.new("BodyGyro"); flyBodyGyro.Name, flyBodyGyro.MaxTorque, flyBodyGyro.P, flyBodyGyro.CFrame, flyBodyGyro.Parent = "ZenoxFlyGyro", Vector3.new(1e6,1e6,1e6), 3000, root.CFrame, root
end

addSec(CharTab, "Movement")
addTog(CharTab, "ล็อกตำแหน่งตัวละคร (Lock Position)", "ตรึงตำแหน่งตัวละครให้อยู่กับที่จนกว่าจะกดปิด", false, function(s) posLockEnabled=s; local r=player.Character and player.Character:FindFirstChild("HumanoidRootPart"); lockedCFrame=(s and r) and r.CFrame or nil end)
addTog(CharTab, "ล้มค้างไว้สไตล์ R6 (Fall Lock)", "ล้มตัวละครลงค้างไว้จนกว่าจะขยับเดิน/กระโดด หรือกดปิด", false, function(s) setCharacterFallLock(s) end)
addTog(CharTab, "Smooth WalkSpeed", "เปิดใช้งานความเร็ววิ่งแบบลื่นไหล กันบัคเมื่อ FPS ตก", false, function(s) speedEnabled=s; local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid"); if h and not s then h.WalkSpeed=16 end end)
addSld(CharTab, "WalkSpeed (1 - 500)", "ลากสไลด์หรือพิมพ์ตัวเลข 1 ถึง 500 ได้เลย", 1, 500, 16, function(v) targetSpeed=v end)
addTog(CharTab, "Custom JumpPower", "เปิดใช้งานแรงกระโดดตามค่าที่ตั้งไว้", false, function(s) jumpEnabled=s; local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid"); if h and not s then applyJumpPower(h,50) end end)
addSld(CharTab, "JumpPower (1 - 300)", "ลากสไลด์หรือพิมพ์ค่าแรงกระโดดได้เลย", 1, 300, 50, function(v) targetJumpPower=v end)
addTog(CharTab, "NoClip", "เดินทะลุกำแพงและสิ่งกีดขวาง พร้อมคืนค่าการชนเมื่อปิด", false, function(s) noclipEnabled=s; setCharacterNoclip(player.Character, s) end)

addSec(CharTab, "Fly")
addTog(CharTab, "Fly (Mobile)", "บินอิสระบนมือถือ บังคับตามจอยเดินและมุมกล้อง", false, function(s) flyEnabled=s; if s then startFly() else stopFly() end end)
addSld(CharTab, "Fly Speed (1 - 3000)", "เลื่อนสไลด์หรือพิมพ์ความเร็วบิน 1 ถึง 3000", 1, 3000, 80, function(v) flySpeed=v end)

addSec(CharTab, "Air & Reset")
addTog(CharTab, "Infinite Jump", "กระโดดกลางอากาศได้เรื่อยๆ ตามแรงที่ตั้งไว้", false, function(s) infJumpEnabled=s end)
addSld(CharTab, "Air Jump Power (1 - 500)", "ปรับแรงดีดตัวตอนกระโดดกลางอากาศ", 1, 500, 50, function(v) airJumpPower=v end)
do
	local rc = Instance.new("Frame", CharTab.Page); rc.Name, rc.Size, rc.BackgroundColor3, rc.ZIndex = "ZenoxInstantResetCard", UDim2.new(1,0,0,44), Colors.CardBg, 999992; corner(rc); stroke(rc)
	local rl = Instance.new("TextLabel", rc); rl.Size, rl.Position, rl.BackgroundTransparency, rl.Text, rl.TextColor3, rl.Font, rl.TextSize, rl.TextXAlignment, rl.ZIndex = UDim2.new(1,-96,1,0), UDim2.fromOffset(12,0), 1, "เกิดใหม่ไว (Instant Reset)", Colors.TextPrimary, Enum.Font.GothamSemibold, 12, Enum.TextXAlignment.Left, 999993
	local rb = Instance.new("TextButton", rc); rb.Size, rb.Position, rb.BackgroundColor3, rb.Text, rb.TextColor3, rb.Font, rb.TextSize, rb.ZIndex = UDim2.fromOffset(76,26), UDim2.new(1,-86,0.5,-13), rgb(220,75,95), "เกิดใหม่", rgb(255,255,255), Enum.Font.GothamBold, 11, 999993; corner(rb, 6)
	rb.MouseButton1Click:Connect(function() pcall(function() local c=player.Character; local h=c and c:FindFirstChildOfClass("Humanoid"); if h then h.Health=0 end; if c then c:BreakJoints() end end) end)
end
UIS.JumpRequest:Connect(function()
	if not infJumpEnabled or jumpCooldown then return end
	local c=player.Character; local h, r = c and c:FindFirstChildOfClass("Humanoid"), c and c:FindFirstChild("HumanoidRootPart")
	if h and r and h.Health>0 then
		local st=h:GetState(); if st==Enum.HumanoidStateType.Freefall or st==Enum.HumanoidStateType.Jumping then
			jumpCooldown=true; h:ChangeState(Enum.HumanoidStateType.Jumping); r.AssemblyLinearVelocity=Vector3.new(r.AssemblyLinearVelocity.X, airJumpPower, r.AssemblyLinearVelocity.Z); task.delay(0.14, function() jumpCooldown=false end)
		end
	end
end)

local espEnabled, espStaticCol, espRainbow, highlights = false, rgb(165,65,255), false, {}
local espColors = {
	{Name="ส้ม",Color=rgb(255,135,35),IsRainbow=false}, {Name="ขาว",Color=rgb(245,248,255),IsRainbow=false},
	{Name="แดง",Color=rgb(255,60,80),IsRainbow=false}, {Name="ม่วง",Color=rgb(165,65,255),IsRainbow=false},
	{Name="เรนโบว์",Color=rgb(255,255,255),IsRainbow=true}
}
local function getEspCol() return espRainbow and Color3.fromHSV((os.clock()*0.35)%1, 0.9, 1) or espStaticCol end
local function clearHighlights() for p,h in pairs(highlights) do if h then h:Destroy() end; highlights[p]=nil end end
local function applyHighlight(plr)
	if plr==player or not espEnabled or not plr.Character then return end
	local h = highlights[plr]
	if not h or not h.Parent then h=Instance.new("Highlight"); h.Name, h.DepthMode, h.FillTransparency, h.OutlineTransparency, h.Adornee, h.Parent = "ZenoxESP_Highlight", Enum.HighlightDepthMode.AlwaysOnTop, 0.55, 0, plr.Character, plr.Character; highlights[plr]=h end
	local col=getEspCol(); h.FillColor, h.OutlineColor = col, col
end
local function refreshHighlights() if not espEnabled then clearHighlights(); return end; for _, p in ipairs(Players:GetPlayers()) do if p~=player then applyHighlight(p) end end end

addSec(VisualsTab, "Player ESP")
addPick(VisualsTab, MainSG, "เลือกสีมองผู้เล่น", "กดเพื่อเปิดหน้าต่างเลือกสี (ส้ม / ขาว / แดง / ม่วง / เรนโบว์)", espColors, "ม่วง", function(_,col,rb) espStaticCol, espRainbow = col, rb; refreshHighlights() end)
addTog(VisualsTab, "เปิดมองผู้เล่น", "ไฮไลต์ผู้เล่นอื่นทะลุกำแพงตามสีที่เลือก", false, function(s) espEnabled=s; if s then refreshHighlights() else clearHighlights() end end)

local entityEspEnabled, redDistEnabled, pinkTracerEnabled = false, false, false
local entityHighlights, distGuis, tracerLines, tracerUiLines = {}, {}, {}, {}
local lastEntScan, lastDistUpd, cachedEnts = 0, 0, {}
local GREEN_C, RED_C, PINK_C = rgb(45,255,115), rgb(255,45,65), rgb(255,75,185)
local tracerGui = Instance.new("ScreenGui"); tracerGui.Name, tracerGui.ResetOnSpawn, tracerGui.IgnoreGuiInset, tracerGui.DisplayOrder, tracerGui.ZIndexBehavior, tracerGui.Parent = "ZenoxPinkTracerGui", false, true, 50, Enum.ZIndexBehavior.Sibling, playerGui

local function isPlrModel(m) for _, p in ipairs(Players:GetPlayers()) do if p.Character==m then return true end end; return false end
local function scanEnts()
	local res, mc = {}, player.Character
	for _, o in ipairs(workspace:GetDescendants()) do
		if o:IsA("Model") and o~=mc and not isPlrModel(o) then
			local h, r, n = o:FindFirstChildOfClass("Humanoid"), o:FindFirstChild("HumanoidRootPart") or o:FindFirstChild("Head") or o:FindFirstChildWhichIsA("BasePart"), o.Name:lower()
			if ((h and h.Health>0) or n:find("bot") or n:find("ghost") or n:find("dummy") or n:find("entity") or n:find("monster") or n:find("monochrome") or n:find("npc")) and r and r:IsA("BasePart") then table.insert(res, {Model=o, Root=r}) end
		end
	end
	cachedEnts=res; return res
end
local function getTargets()
	local t={}
	if espEnabled then for _, p in ipairs(Players:GetPlayers()) do if p~=player and p.Character then local r=p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Head") or p.Character:FindFirstChildWhichIsA("BasePart"); if r then table.insert(t, {Key="Plr_"..p.UserId, Label=p.Name, Root=r}) end end end end
	if entityEspEnabled then for i, e in ipairs(cachedEnts) do if e.Model and e.Model.Parent and e.Root and e.Root.Parent then table.insert(t, {Key="Ent_"..i.."_"..e.Model.Name, Label=e.Model.Name, Root=e.Root}) end end end
	return t
end
local function clearEnts() for m,h in pairs(entityHighlights) do pcall(function() if h then h:Destroy() end end); entityHighlights[m]=nil end; table.clear(cachedEnts) end
local function clearDists() for k,g in pairs(distGuis) do pcall(function() if g then g:Destroy() end end); distGuis[k]=nil end end
local function clearTracers()
	for k,l in pairs(tracerLines) do pcall(function() l.Visible=false; l:Remove() end); tracerLines[k]=nil end
	for k,f in pairs(tracerUiLines) do pcall(function() if f then f:Destroy() end end); tracerUiLines[k]=nil end
end
local function refreshEnts(force)
	if not entityEspEnabled then clearEnts(); return end
	local now=os.clock(); if force or (now-lastEntScan)>=0.75 then lastEntScan=now; scanEnts() end
	local act={}
	for _, e in ipairs(cachedEnts) do
		local m=e.Model; if m and m.Parent then act[m]=true; local h=entityHighlights[m]
			if not h or not h.Parent then h=Instance.new("Highlight"); h.Name, h.DepthMode, h.FillTransparency, h.OutlineTransparency, h.FillColor, h.OutlineColor, h.Adornee, h.Parent = "ZenoxEntityESP_Green", Enum.HighlightDepthMode.AlwaysOnTop, 0.52, 0, GREEN_C, GREEN_C, m, m; entityHighlights[m]=h end
		end
	end
	for m,h in pairs(entityHighlights) do if not act[m] then pcall(function() if h then h:Destroy() end end); entityHighlights[m]=nil end end
end
local function updDists(t)
	if not redDistEnabled then clearDists(); return end
	local mr=player.Character and (player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChildWhichIsA("BasePart")); local alive={}
	for _, it in ipairs(t) do
		if it.Root and it.Root.Parent then
			alive[it.Key]=true; local bb=distGuis[it.Key]
			if not bb or not bb.Parent then
				bb=Instance.new("BillboardGui"); bb.Name, bb.AlwaysOnTop, bb.MaxDistance, bb.Size, bb.StudsOffset, bb.Adornee, bb.Parent = "ZenoxRedDistGui", true, 1500, UDim2.fromOffset(140,28), Vector3.new(0,3.2,0), it.Root, playerGui
				local tx=Instance.new("TextLabel", bb); tx.Name, tx.Size, tx.BackgroundTransparency, tx.Font, tx.TextSize, tx.TextColor3, tx.TextStrokeColor3, tx.TextStrokeTransparency = "DistLabel", UDim2.fromScale(1,1), 1, Enum.Font.GothamBlack, 13, RED_C, rgb(0,0,0), 0; distGuis[it.Key]=bb
			else bb.Adornee=it.Root end
			local lb=bb:FindFirstChild("DistLabel"); if lb and lb:IsA("TextLabel") then lb.Text, lb.TextColor3 = it.Label.." ["..(mr and math.floor((it.Root.Position-mr.Position).Magnitude+0.5).."m" or "?").."]", RED_C end
		end
	end
	for k,bb in pairs(distGuis) do if not alive[k] then pcall(function() if bb then bb:Destroy() end end); distGuis[k]=nil end end
end
local function posLine(f, p1, p2)
	local dx, dy = p2.X-p1.X, p2.Y-p1.Y; local d=math.sqrt(dx*dx+dy*dy); if d<=1 then f.Visible=false; return end
	f.Visible, f.Size, f.Position, f.Rotation = true, UDim2.fromOffset(d,2.5), UDim2.fromOffset((p1.X+p2.X)*0.5, (p1.Y+p2.Y)*0.5), math.deg(math.atan2(dy,dx))
end
local function updTracers(t)
	if not pinkTracerEnabled then clearTracers(); return end
	local cam=workspace.CurrentCamera; if not cam then return end
	local vp=cam.ViewportSize; local sPos=Vector2.new(vp.X*0.5, vp.Y*0.88); local canDrw=(type(Drawing)=="table" and type(Drawing.new)=="function"); local alive={}
	for _, it in ipairs(t) do
		if it.Root and it.Root.Parent then
			alive[it.Key]=true; local sp, onS = cam:WorldToViewportPoint(it.Root.Position); local ePos, vis = Vector2.new(sp.X,sp.Y), onS and (sp.Z>0)
			if canDrw then local l=tracerLines[it.Key]; if not l then local ok,cr=pcall(function() local x=Drawing.new("Line"); x.Thickness,x.Transparency,x.Color=2,1,PINK_C; return x end); if ok and cr then l=cr; tracerLines[it.Key]=l end end; if l then l.Color,l.From,l.To,l.Visible=PINK_C,sPos,ePos,vis end end
			local ul=tracerUiLines[it.Key]; if not ul or not ul.Parent then ul=Instance.new("Frame"); ul.Name,ul.AnchorPoint,ul.BackgroundColor3,ul.BorderSizePixel,ul.Parent="ZenoxPinkTracerUiLine",Vector2.new(0.5,0.5),PINK_C,0,tracerGui; tracerUiLines[it.Key]=ul end
			if vis then posLine(ul, sPos, ePos) else ul.Visible=false end
		end
	end
	for k,l in pairs(tracerLines) do if not alive[k] then pcall(function() l.Visible=false; l:Remove() end); tracerLines[k]=nil end end
	for k,u in pairs(tracerUiLines) do if not alive[k] then pcall(function() if u then u:Destroy() end end); tracerUiLines[k]=nil end end
end

addSec(VisualsTab, "Entities & Tracers")
addTog(VisualsTab, "ESP บอท/ผี/ดัมมี่/เอนทิตี้ (เขียวเท่านั้น)", "ไฮไลต์บอท ผี ดัมมี่ เอนทิตี้ และโมโนโครมเป็นสีเขียวล็อกตายตัว", false, function(s) entityEspEnabled=s; refreshEnts(true) end)
addTog(VisualsTab, "ระยะห่างสีแดงคมชัด (Red Distance)", "โชว์ชื่อและระยะห่างของเป้าหมายที่มองอยู่ด้วยสีแดงคมชัด", false, function(s) redDistEnabled=s; if not s then clearDists() end end)
addTog(VisualsTab, "เส้นสีชมพูตาม ESP (Pink Tracer)", "ลากเส้นสีชมพูขยับตามเป้าหมายที่ระบบ ESP กำลังมองเห็น", false, function(s) pinkTracerEnabled=s; if not s then clearTracers() end end)
local fovEnabled, targetFov = false, 70
local defaultFov = (workspace.CurrentCamera and workspace.CurrentCamera.FieldOfView) or 70
local function applyFov() local c=workspace.CurrentCamera; if c then c.FieldOfView = fovEnabled and math.clamp(targetFov or 70, 70, 360) or defaultFov end end
addSec(VisualsTab, "Camera")
addTog(VisualsTab, "เปิดปรับมุมมองกล้อง (FOV)", "เปิดใช้งานมุมมองกล้องตามค่าที่ตั้งไว้", false, function(s) fovEnabled=s; applyFov() end)
addSld(VisualsTab, "FOV Camera (70 - 360)", "เลื่อนสไลด์หรือพิมพ์มุมมองกล้อง 70 ถึง 360", 70, 360, 70, function(v) targetFov=v; if fovEnabled then applyFov() end end)

local noFogEnabled, brightnessBoostVal = false, 2
local savedLighting = {Captured=false, Atm={}}
local function capLight()
	if savedLighting.Captured then return end
	savedLighting.Captured, savedLighting.FogEnd, savedLighting.FogStart, savedLighting.FogColor = true, Lighting.FogEnd, Lighting.FogStart, Lighting.FogColor
	savedLighting.Brightness, savedLighting.GlobalShadows, savedLighting.Ambient, savedLighting.OutdoorAmbient = Lighting.Brightness, Lighting.GlobalShadows, Lighting.Ambient, Lighting.OutdoorAmbient
	for _, o in ipairs(Lighting:GetDescendants()) do if o:IsA("Atmosphere") then savedLighting.Atm[o]=o.Density end end
end
local function applyLight()
	capLight()
	if noFogEnabled then Lighting.FogStart, Lighting.FogEnd = 1e6, 1e6; for a in pairs(savedLighting.Atm) do if a and a.Parent then a.Density=0 end end
	else Lighting.FogStart, Lighting.FogEnd, Lighting.FogColor = savedLighting.FogStart, savedLighting.FogEnd, savedLighting.FogColor; for a,d in pairs(savedLighting.Atm) do if a and a.Parent then a.Density=d end end end
	local sc = math.clamp(brightnessBoostVal or 2, 1, 300); Lighting.Brightness = (savedLighting.Brightness or 2)*(sc/2)
	if sc>10 then Lighting.GlobalShadows, Lighting.Ambient, Lighting.OutdoorAmbient = false, rgb(220,220,220), rgb(235,235,235)
	elseif not noFogEnabled then Lighting.GlobalShadows, Lighting.Ambient, Lighting.OutdoorAmbient = savedLighting.GlobalShadows, savedLighting.Ambient, savedLighting.OutdoorAmbient end
end
addSec(VisualsTab, "Environment & Lighting")
addTog(VisualsTab, "ลบหมอก (No Fog)", "ลบหมอกในแมพและหมอกบรรยากาศ เพื่อให้มองเห็นชัดขึ้น", false, function(s) noFogEnabled=s; applyLight() end)
addSld(VisualsTab, "เพิ่มแสง (1 - 300)", "พิมพ์ตัวเลขหรือเลื่อนสไลด์เพิ่มความสว่าง 1 ถึง 300", 1, 300, 2, function(v) brightnessBoostVal=v; applyLight() end)

RunService.RenderStepped:Connect(function()
	if entityEspEnabled then refreshEnts(false) end
	if redDistEnabled or pinkTracerEnabled then
		local t=getTargets(); if pinkTracerEnabled then updTracers(t) end
		if redDistEnabled and (os.clock()-lastDistUpd)>=0.12 then lastDistUpd=os.clock(); updDists(t) end
	end
	if fovEnabled then applyFov() end
end)

addSec(SettingsTab, "Hub Info")
addTog(SettingsTab, "Show Floating Button Now", "ซ่อนหน้าต่างหลักและเปิดปุ่มลอย UI ทันที", false, function(s)
	if s then local mf, fb = MainSG:FindFirstChild("MainFrame"), MainSG:FindFirstChild("FloatingToggle"); if mf and fb then mf.Visible, fb.Visible = false, true end end
end)

do
	local ThemeList = {
		{Name="Slate Gray + Off-White", MainBg=rgb(45,50,58), SidebarBg=rgb(36,40,47), TopbarBg=rgb(31,35,41), CardBg=rgb(58,64,74), TextPrimary=rgb(244,245,247), Accent=rgb(238,240,244)},
		{Name="Midnight Indigo + Cyber Orange", MainBg=rgb(16,20,42), SidebarBg=rgb(12,15,32), TopbarBg=rgb(10,12,27), CardBg=rgb(24,30,58), TextPrimary=rgb(246,248,255), Accent=rgb(255,118,28)},
		{Name="Neon Purple + Mint Teal", MainBg=rgb(22,15,36), SidebarBg=rgb(17,11,28), TopbarBg=rgb(14,9,23), CardBg=rgb(32,23,50), TextPrimary=rgb(236,255,250), Accent=rgb(45,235,195)},
		{Name="Zenox Neon Purple", MainBg=rgb(22,24,30), SidebarBg=rgb(18,20,25), TopbarBg=rgb(16,18,22), CardBg=rgb(30,33,41), TextPrimary=rgb(240,242,248), Accent=rgb(130,85,255)},
		{Name="Jet Black & Crimson Red", MainBg=rgb(12,12,14), SidebarBg=rgb(9,9,11), TopbarBg=rgb(8,8,10), CardBg=rgb(24,24,28), TextPrimary=rgb(248,242,244), Accent=rgb(225,29,72)},
		{Name="Charcoal & Neon Lime", MainBg=rgb(20,22,20), SidebarBg=rgb(15,17,15), TopbarBg=rgb(13,15,13), CardBg=rgb(28,32,28), TextPrimary=rgb(238,250,236), Accent=rgb(132,255,45)},
		{Name="Amber", MainBg=rgb(24,21,16), SidebarBg=rgb(19,17,13), TopbarBg=rgb(16,14,11), CardBg=rgb(34,30,23), TextPrimary=rgb(250,244,232), Accent=rgb(245,158,11)},
		{Name="Warm Cream & Mocha Brown", MainBg=rgb(244,237,226), SidebarBg=rgb(233,223,208), TopbarBg=rgb(220,207,188), CardBg=rgb(252,248,242), TextPrimary=rgb(58,38,26), Accent=rgb(120,72,42)}
	}
	local function applyTheme(th)
		local mf, fb = MainSG:FindFirstChild("MainFrame"), MainSG:FindFirstChild("FloatingToggle")
		if mf then
			mf.BackgroundColor3=th.MainBg; local ms=mf:FindFirstChildOfClass("UIStroke"); if ms then ms.Color=th.Accent end
			local tb, sb, pf, pgs = mf:FindFirstChild("TopBar"), mf:FindFirstChild("Sidebar"), mf:FindFirstChild("ZenoxAvatarProfile"), mf:FindFirstChild("Pages")
			if tb then tb.BackgroundColor3=th.TopbarBg; for _,c in ipairs(tb:GetChildren()) do if c:IsA("TextLabel") then c.TextColor3=th.TextPrimary end end end
			if sb then sb.BackgroundColor3=th.SidebarBg; for _,b in ipairs(sb:GetChildren()) do if b:IsA("TextButton") then b.BackgroundColor3=th.CardBg; local st=b:FindFirstChildOfClass("UIStroke"); if st then st.Color=th.Accent end; for _,l in ipairs(b:GetChildren()) do if l:IsA("TextLabel") and b.BackgroundTransparency==0 then l.TextColor3=th.TextPrimary end end end end end
			if pf then pf.BackgroundColor3=th.TopbarBg; local ps=pf:FindFirstChildOfClass("UIStroke"); if ps then ps.Color=th.Accent end end
			if pgs then for _,pg in ipairs(pgs:GetChildren()) do if pg:IsA("ScrollingFrame") then pg.ScrollBarImageColor3=th.Accent; for _,it in ipairs(pg:GetChildren()) do if it:IsA("Frame") or it:IsA("TextButton") then if it.Name~="ZenoxInstantResetCard" and it.Name~="ZenoxResetAllCard" then it.BackgroundColor3=th.CardBg end; for _,s in ipairs(it:GetChildren()) do if s:IsA("TextLabel") then s.TextColor3=th.TextPrimary end end elseif it:IsA("TextLabel") then it.TextColor3=th.TextPrimary end end end end end
		end
		if fb then fb.BackgroundColor3, fb.TextColor3 = th.TopbarBg, th.TextPrimary; local fs=fb:FindFirstChildOfClass("UIStroke"); if fs then fs.Color=th.Accent end end
	end
	local function applyFade(p)
		local mf=MainSG:FindFirstChild("MainFrame"); if mf then mf.BackgroundTransparency=((math.clamp(tonumber(p) or 1, 1, 120)-1)/119)*0.85 end
	end
	addSec(SettingsTab, "Themes & Fade")
	local idx=1; local tc=Instance.new("Frame", SettingsTab.Page); tc.Name, tc.Size, tc.BackgroundColor3, tc.ZIndex = "ZenoxThemeCard", UDim2.new(1,0,0,44), Colors.CardBg, 999992; corner(tc)
	local tl=Instance.new("TextLabel", tc); tl.Size, tl.Position, tl.BackgroundTransparency, tl.Text, tl.TextColor3, tl.Font, tl.TextSize, tl.TextXAlignment, tl.TextTruncate, tl.ZIndex = UDim2.new(1,-150,1,0), UDim2.fromOffset(12,0), 1, "ธีม: "..ThemeList[idx].Name, Colors.TextPrimary, Enum.Font.GothamSemibold, 11, Enum.TextXAlignment.Left, Enum.TextTruncate.AtEnd, 999993
	local cb=Instance.new("TextButton", tc); cb.Size, cb.Position, cb.BackgroundColor3, cb.Text, cb.TextColor3, cb.Font, cb.TextSize, cb.ZIndex = UDim2.fromOffset(128,26), UDim2.new(1,-138,0.5,-13), Colors.Accent, "เปลี่ยนธีมถัดไป", rgb(255,255,255), Enum.Font.GothamBold, 11, 999993; corner(cb, 6)
	cb.MouseButton1Click:Connect(function() idx=(idx%#ThemeList)+1; local ch=ThemeList[idx]; tl.Text, cb.BackgroundColor3 = "ธีม: "..ch.Name, ch.Accent; applyTheme(ch) end)
	addSld(SettingsTab, "Window Fade (1 - 120)", "ปรับความจางหน้าต่างเพื่อดูสีธีมและฉากหลังได้ชัดขึ้น", 1, 120, 1, function(v) applyFade(v) end)

	addSec(SettingsTab, "Reset")
	local rc=Instance.new("Frame", SettingsTab.Page); rc.Name, rc.Size, rc.BackgroundColor3, rc.ZIndex = "ZenoxResetAllCard", UDim2.new(1,0,0,44), Colors.CardBg, 999992; corner(rc)
	local rl=Instance.new("TextLabel", rc); rl.Size, rl.Position, rl.BackgroundTransparency, rl.Text, rl.TextColor3, rl.Font, rl.TextSize, rl.TextXAlignment, rl.ZIndex = UDim2.new(1,-110,1,0), UDim2.fromOffset(12,0), 1, "รีเซ็ตค่าฟีเจอร์ทั้งหมด", Colors.TextPrimary, Enum.Font.GothamSemibold, 12, Enum.TextXAlignment.Left, 999993
	local rb=Instance.new("TextButton", rc); rb.Size, rb.Position, rb.BackgroundColor3, rb.Text, rb.TextColor3, rb.Font, rb.TextSize, rb.ZIndex = UDim2.fromOffset(88,26), UDim2.new(1,-98,0.5,-13), rgb(220,75,95), "Reset All", rgb(255,255,255), Enum.Font.GothamBold, 11, 999993; corner(rb, 6)
	rb.MouseButton1Click:Connect(function()
		speedEnabled, jumpEnabled, noclipEnabled, infJumpEnabled, faceNearestEnabled = false, false, false, false, false
		posLockEnabled, fallLockEnabled, lockedCFrame = false, false, nil; setCharacterFallLock(false); stopFly()
		fovEnabled, targetFov = false, defaultFov; applyFov()
		espEnabled, entityEspEnabled, redDistEnabled, pinkTracerEnabled, noFogEnabled = false, false, false, false, false
		brightnessBoostVal, targetSpeed, targetJumpPower, airJumpPower = 2, 16, 50, 50
		clearHighlights(); clearEnts(); clearDists(); clearTracers(); setCharacterNoclip(player.Character, false); applyLight(); applyFade(1)
		local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed=16; applyJumpPower(h,50) end
	end)
end

RunService.Heartbeat:Connect(function(dt)
	local cdt=math.min(dt,0.1); local char=player.Character; local hum, root = char and char:FindFirstChildOfClass("Humanoid"), char and char:FindFirstChild("HumanoidRootPart")
	if speedEnabled and hum and hum.Health>0 then hum.WalkSpeed=hum.WalkSpeed+(targetSpeed-hum.WalkSpeed)*math.clamp(cdt*20,0,1); if math.abs(hum.WalkSpeed-targetSpeed)<0.25 then hum.WalkSpeed=targetSpeed end end
	if jumpEnabled and hum and hum.Health>0 then applyJumpPower(hum, targetJumpPower) end
	if noclipEnabled and char then setCharacterNoclip(char, true) end
	if posLockEnabled and lockedCFrame and root and hum and hum.Health>0 then root.AssemblyLinearVelocity, root.AssemblyAngularVelocity, root.CFrame = Vector3.zero, Vector3.zero, lockedCFrame end
	if flyEnabled and root and hum and hum.Health>0 then
		if not flyBodyVel or not flyBodyVel.Parent or not flyBodyGyro or not flyBodyGyro.Parent then startFly() end
		local cam=workspace.CurrentCamera; hum.PlatformStand=true; local mv=Vector3.zero
		if cam and hum.MoveDirection.Magnitude>0.01 then
			local fl, fr = Vector3.new(cam.CFrame.LookVector.X,0,cam.CFrame.LookVector.Z), Vector3.new(cam.CFrame.RightVector.X,0,cam.CFrame.RightVector.Z)
			local dir=(cam.CFrame.LookVector*((fl.Magnitude>0.001) and hum.MoveDirection:Dot(fl.Unit) or 0))+(cam.CFrame.RightVector*((fr.Magnitude>0.001) and hum.MoveDirection:Dot(fr.Unit) or 0))
			if dir.Magnitude>0.001 then mv=dir.Unit*flySpeed end
		end
		if flyBodyVel then flyBodyVel.Velocity=mv end; if flyBodyGyro and cam then flyBodyGyro.CFrame=CFrame.lookAt(root.Position, root.Position+cam.CFrame.LookVector) end
	elseif flyBodyVel or flyBodyGyro then stopFly() end
	if faceNearestEnabled and root and hum and hum.Health>0 then
		local tr=getNearestTarget(300); if tr then local p, l = root.Position, Vector3.new(tr.Position.X, root.Position.Y, tr.Position.Z); if (l-p).Magnitude>0.05 then root.CFrame=root.CFrame:Lerp(CFrame.lookAt(p,l), math.clamp(cdt*18,0,1)) end end
	end
	if espEnabled and espRainbow then
		local col=getEspCol(); for p,h in pairs(highlights) do if p and p.Parent and p.Character and h and h.Parent then h.FillColor, h.OutlineColor = col, col else applyHighlight(p) end end
	end
end)

player.CharacterAdded:Connect(function(nc)
	table.clear(savedCollision); lockedCFrame=nil; stopFly()
	local h=nc:WaitForChild("Humanoid",5); if h then if not speedEnabled then h.WalkSpeed=16 end; if not jumpEnabled then applyJumpPower(h,50) end end
	if noclipEnabled then setCharacterNoclip(nc,true) end; if fallLockEnabled then setCharacterFallLock(true) end
	task.defer(function() if flyEnabled then startFly() end; if fovEnabled then applyFov() end end)
end)
Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() if espEnabled then task.wait(0.2); applyHighlight(p) end end) end)
Players.PlayerRemoving:Connect(function(p) if highlights[p] then highlights[p]:Destroy(); highlights[p]=nil end end)

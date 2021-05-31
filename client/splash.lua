class 'Splash'

function Splash:__init()

	self.debug = false						-- draw velocity and position for testing

	self.threshold_velocity = -15		-- vertical speed threshold to trigger the splash
	self.threshold_altitude = 199.5	-- y position for splash effect (200 is the water surface level)
	self.interval = 2							-- interval in seconds to cooldown (per localplayer)
	
	self.timer = Timer()
	
	if self.debug then Events:Subscribe( "Render", self, self.Debug ) end
	
	Events:Subscribe( "PreTick", self, self.PreTick )
	Network:Subscribe("SplishSplash", self, self.PlaySplash)
end

function Splash:Debug()
	local font_scale	= math.round(Render.Size.y/1080,1)
	local text1 = "velocity.y "..tonumber(math.round(LocalPlayer:GetLinearVelocity().y,2))
	local text2 = "position.y "..tonumber(math.round(LocalPlayer:GetPosition().y,2))
	local pos1 = Vector2( Render.Width/2, Render.Height * 0.85 )
	local pos2 = Vector2( Render.Width/2, Render.Height * 0.88 )
	local font1 = 20*font_scale
	local font2 = 20*font_scale	
	pos1.y = pos1.y - Render:GetTextHeight("velocity.y 0.00", font1)
	pos1.x = pos1.x - Render:GetTextWidth("velocity.y 0.00", font1) / 2		
	pos2.y = pos2.y - Render:GetTextHeight("position.y 0.00", font2)
	pos2.x = pos2.x - Render:GetTextWidth("position.y 0.00", font2) / 2
	Render:DrawText( pos1 + Vector2(1,1)*font_scale, text1, Color.Black, font1)
	Render:DrawText( pos1, text1, Color.Yellow, font1)
	Render:DrawText( pos2 + Vector2(1,1)*font_scale, text2, Color.Black, font2)	
	Render:DrawText( pos2, text2, Color.White, font2)
end

function Splash:PlaySplash(args)
		ClientEffect.Play(AssetLocation.Game, {
			position = Vector3(args.position.x,199.5,args.position.z) ,
			angle = Angle(0,0,0) ,
			effect_id = 112 ,
		})
end

function Splash:PreTick()
	if LocalPlayer:GetLinearVelocity().y < self.threshold_velocity then 
		if LocalPlayer:GetPosition().y < self.threshold_altitude then
			if self.timer:GetSeconds() > self.interval then
				self.timer:Restart()
				ClientEffect.Play(AssetLocation.Game, {
					position = Vector3(LocalPlayer:GetPosition().x, 199.5, LocalPlayer:GetPosition().z) ,
					angle = Angle(0,0,0) ,
					effect_id = 112 ,
				})	
				Network:Send("SplishSplash", { player = LocalPlayer, position = LocalPlayer:GetPosition() })
			end
		end
	end
end

math.round = function(x, n) -- rounding function
    n = math.pow(10, n or 0)
    x = x * n
    if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
    return x / n
end

Splash = Splash()
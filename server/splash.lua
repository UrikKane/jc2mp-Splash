class 'Splash'

function Splash:__init()
	Network:Subscribe("SplishSplash", self, self.SendSplash)
end

function Splash:SendSplash(args)
	Network:SendNearby(args.player, "SplishSplash", args)
end

Splash = Splash()
hl.config({
	animations = {
		enabled = true,
	},
})

hl.curve("myBezier", { type = "bezier", points = { { 0.4, 0.0 }, { 0.2, 1.0 } } })
hl.curve("mySpring", { type = "spring", mass = 1, stiffness = 70, dampening = 13 })

hl.animation({ leaf = "windows", enabled = true, speed = 2.5, bezier = "myBezier", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 2.5, bezier = "myBezier" })
hl.animation({ leaf = "fade", enabled = true, speed = 2.5, bezier = "myBezier" })
hl.animation({
	leaf = "workspaces",
	enabled = true,
	speed = 2.5,
	bezier = "myBezier",
	style = "slidefadevert 20%",
})

hl.animation({ leaf = "layers", enabled = true, speed = 1, spring = "mySpring", style = "slide bottom" })

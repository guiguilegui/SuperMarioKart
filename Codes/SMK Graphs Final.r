library(ggplot2)
library(dplyr)
library(grid)
library(png)
library(mgcv)
library(RColorBrewer)

options(dplyr.print_max = 1e9)

d = read.table("C:\\Users\\Guillaume\\Documents\\Snes\\SuperMarioKart\\Codes\\VehPosition.txt", sep="\t",header = TRUE)
RaceInfo = read.table("C:\\Users\\Guillaume\\Documents\\Snes\\SuperMarioKart\\Codes\\RaceInfo.txt", sep="\t",header = TRUE)

####Preparing the first graph -- example plot####
d.Sample.Lap = 
	d %>%
	filter(Lap<=128, Player=="Player7", Iteration==0) #lap 127 is the first lap

#Use the map as background#
Grob = rasterGrob(readPNG("C:\\Users\\Guillaume\\Documents\\snes\\SuperMarioKart\\mariocircuit-1.png", TRUE), width=1, height=1, interpolate=TRUE)#

#plot#
ggplot(d.Sample.Lap)+ 
	annotation_custom(Grob, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf)+
	geom_path(aes(x = HPos, y = -VPos, color = Speed), size = 2, alpha = 0.75)+
	scale_x_continuous(limits = c(0, 256*1024), expand = c(0, 0)) + 
	scale_y_continuous(expand = c(0, 0), limits = c(-256*1024,0))+
	scale_color_continuous(guide = FALSE, low = "red", high = "green")+
	coord_fixed(ratio = 1)+
	labs(x = NULL, y = NULL)+
	theme(
		rect             	= element_blank(),
		line             	= element_blank(),
		text             	= element_blank(),
		panel.grid			= element_blank(), 
		panel.background	= element_rect(fill = "transparent", colour = NA),
		panel.border		= element_blank()
	)
	
####Preparing the second graph -- speed of first AI at 50CC####

#get AI rank#
d.Course = 
	d %>%
	filter(Lap == 132) %>%
	group_by(Iteration, Player) %>%
		summarise(Time.Spent = max(Time)/100)%>%
	group_by(Iteration) %>%
		mutate(Rank = dense_rank(Time.Spent))

#join with raceinfo#
d.times.rank = 
	d %>%
	filter(!(Lap %in% c(127,133))) %>%
	inner_join(d.Course) %>%
	inner_join(RaceInfo) %>%
	filter(Rank ==1&Class=="50CC") #first AI

#join with raceinfo#
d.times.rank.2 = 
	d.times.rank %>%
	arrange(Iteration, Player, Lap) %>%
	group_by(Iteration, Player, Lap) %>%
		mutate(
			dist    = ((lag(HPos) - HPos)^2 + (lag(VPos) - VPos)^2)^0.5,
			cumdist = cumsum(ifelse(is.na(dist), 0, dist)),
			cumprop = percent_rank(cumdist),
			Lap2 = (Lap > 128)
		)

#plot
ggplot(d.times.rank.2)+
	geom_smooth(aes(x = cumprop, y = Speed, col = interaction(Type,Lap2,lex.order = TRUE)),method="gam",formula = y ~ s(x,k= 100),se=FALSE)+
	scale_colour_brewer(palette= "Set1", name="Experiment + Lap",  labels = c('First Place +\nLap 1\n', 'First Place +\nLap 2 to 5\n','Last Place +\nLap 1\n','Last Place +\nLap 2 to 5'))+
	ggtitle("Kart speed by % of lap done for the best AI\nin Super Mario Kart's Mario Circuit 1, 50CC")+
	scale_x_continuous(labels = scales::percent, name = "Percentage of lap done")+
	theme(
		legend.background = element_blank(),
		legend.text = element_text(colour = "grey40"),
		legend.title = element_text(colour = "white"),
		legend.key = element_blank(),
		plot.title = element_text(lineheight=.7, face="bold",colour="white"),
		panel.grid.minor.y = element_line(size = 0.2, colour = "grey2", linetype = "longdash"),	
		panel.grid.major.y = element_line(size = 0.5, colour = "grey12", linetype = "longdash"),
		panel.grid.major.x = element_blank(), 
		panel.grid.minor.x = element_blank(), 
		panel.background = element_blank(),
		plot.background = element_rect(fill = "black"),
		strip.background =element_blank(),
		strip.text.x =element_blank(),
		axis.ticks.x=element_blank(),
		panel.border = element_blank(),
		axis.title = element_text(colour = "white")
	)

####Preparing the third graph -- approximation of the position by % of race done####	
d.times.rank.50 = d.times.rank.2 %>%
	#filter(Type=="first", Lap>128)
	filter(Lap>128)
	
gam.HPos.50  = gam(HPos ~ s(cumprop,k=80) + s(cumprop, by = Type, k=80) + Type, data	= d.times.rank.50)
gam.VPos.50  = gam(VPos ~ s(cumprop,k=80) + s(cumprop, by = Type, k=80) + Type, data	= d.times.rank.50)
gam.Speed.50 = gam(Speed ~ s(cumprop,k=80) + s(cumprop, by = Type, k=80) + Type, data= d.times.rank.50)

df.gam.predict = data.frame(cumprop = rep(seq(0, 1, by = 0.001),2), Type = rep(c("first","idle"),each=1001))

df.gam.predict$predict.HPos.50  = predict(gam.HPos.50,df.gam.predict)
df.gam.predict$predict.VPos.50  = predict(gam.VPos.50,df.gam.predict)
df.gam.predict$predict.Speed.50 = predict(gam.Speed.50,df.gam.predict)

ggplot(df.gam.predict)+
	annotation_custom(Grob, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
	geom_path(aes(x = predict.HPos.50, y = -predict.VPos.50, col = predict.Speed.50, group = Type), size=0.75, alpha = 0.75) +
	scale_x_continuous(limits = c(0, 256*1024), expand = c(0, 0)) + 
	scale_y_continuous(expand = c(0, 0), limits = c(-256*1024,0)) +
	scale_color_continuous(guide = FALSE, low = "red", high = "green") +
	coord_fixed(ratio = 1) +
	labs(x = NULL, y = NULL) +
	theme(
		rect             	= element_blank(),
		line             	= element_blank(),
		text             	= element_blank(),
		panel.grid			= element_blank(), 
		panel.background	= element_rect(fill = "transparent", colour = NA),
		panel.border		= element_blank()
	)
	
####Preparing the fourth graph -- aggregate of all AIs####
#average time by Class/Type/rank combination
d.Course.2 = 
	inner_join(d.Course,RaceInfo)%>%
	mutate(
		Class = factor(Class, levels=c("50CC", "100CC", "150CC")),
		Type = factor(Type, levels=c("idle", "first"))
	) %>%
	group_by(Rank,Class,Type) %>%
	summarise(
		Avg.Time = mean(Time.Spent), 
		min.Time = min(Time.Spent),
		max.Time = max(Time.Spent)
	)

#get the difference between first and last
d.Course.gain = 
	d.Course.2 %>%
	group_by(Rank,Class) %>%
	summarise(Time.Less = max(Avg.Time) - min(Avg.Time) ) %>%
	mutate(y = ifelse(Class=="50CC",-1,ifelse(Class=="100CC",-3,-5))) #vertical positioning of time difference

#plot
g = ggplot(d.Course.2)+
geom_path(aes(x = Rank, y = Avg.Time, color = as.factor(Rank), group = interaction(Class, Rank)),position = position_dodge(width = 0.6), size = 1)+
geom_point(aes(x = Rank, y = Avg.Time, color = as.factor(Rank), group = Class,shape = Type),position = position_dodge(width = 0.6), size = 2, fill = "black")+
scale_shape_manual(values=c(25,24), name="Experiment Type", labels = c("Last Place", "First Place"))+
scale_x_continuous(breaks = 1:7, name = "AI Rank")+
scale_y_continuous(breaks = seq(0,140,by=20), minor_breaks = seq(0,125,by=5), limit=c(-5,130), name = "Race Time (in seconds)")+
geom_text(data=subset(d.Course.2, Type == "idle"), aes(x = Rank, label = Class, group = Class, y = Avg.Time + 4),color="grey70", position = position_dodge(width = 0.6), size = 3)+
geom_text(data=d.Course.gain, aes(x = Rank, label = paste0(-round(Time.Less,1), "s"),color = as.factor(Rank), group = Class, y=y), position = position_dodge(width = 0.8), size = 3)+
ggtitle("Time difference between staying always first and always last\nin Super Mario Kart's Mario Circuit 1")+
guides(colour = FALSE, shape = guide_legend(override.aes = list(color="white")))+
	theme(
		legend.background = element_blank(),
		legend.text = element_text(colour = "grey40"),
		legend.title = element_text(colour = "white"),
		legend.key = element_blank(),
		plot.title = element_text(lineheight=.7, face="bold",colour="white"),
		panel.grid.minor.y = element_line(size = 0.2, colour = "grey2", linetype = "longdash"),	
		panel.grid.major.y = element_line(size = 0.5, colour = "grey12", linetype = "longdash"),
		panel.grid.major.x = element_blank(), 
		panel.grid.minor.x = element_blank(), 
		panel.background = element_blank(),
		plot.background = element_rect(fill = "black"),
		strip.background =element_blank(),
		strip.text.x =element_blank(),
		axis.ticks.x=element_blank(),
		panel.border = element_blank(),
		axis.title = element_text(colour = "white")
	)
	
png(filename = "plot4.png", width = 900, height = 1000, res = 90)
g
dev.off()

####Preparing the fifth graph -- comparison of slow mode####
d2 = read.table("C:\\Users\\Guillaume\\Documents\\Snes\\SuperMarioKart\\Codes\\VehPosition2.txt", sep="\t",header = TRUE)

d.times.P8 = 
	d2 %>%
	filter(Player=="Player8", Lap ==128) %>%
	mutate(
		dist    = ((lag(HPos) - HPos)^2 + (lag(VPos) - VPos)^2)^0.5,
		cumdist = cumsum(ifelse(is.na(dist), 0, dist)),
		cumprop = percent_rank(cumdist),
		Experiment = "Second Place +\nLap 1\n"
	) %>%
	union(
		d.times.rank.2 %>%
		filter(Type == "idle") %>%
		mutate(Experiment = ifelse(Lap > 128, "Last Place +\nLap 2 to 5\n", "Last Place +\nLap 1\n")) %>%
		ungroup() %>%
		select(-Type, -Rank, -P1Character, -Time.Spent, -Class, -Iteration, - Lap2)
	)
		
colors.chosen = brewer.pal(6, "Set1")

ggplot(d.times.P8)+
	geom_smooth(aes(x = cumprop, y = Speed, col = Experiment), method="gam", formula = y ~ s(x, k = 100), se = FALSE)+
	scale_colour_manual(name="Experiment + Lap", values = colors.chosen[c(3,4,6)])+
	ggtitle("Kart speed by % of lap done for the best AI\nin Super Mario Kart's Mario Circuit 1, 50CC")+
	scale_x_continuous(labels = scales::percent, name = "Percentage of lap done")+
	theme(
		legend.background = element_blank(),
		legend.text = element_text(colour = "grey40"),
		legend.title = element_text(colour = "white"),
		legend.key = element_blank(),
		plot.title = element_text(lineheight=.7, face="bold",colour="white"),
		panel.grid.minor.y = element_line(size = 0.2, colour = "grey2", linetype = "longdash"),	
		panel.grid.major.y = element_line(size = 0.5, colour = "grey12", linetype = "longdash"),
		panel.grid.major.x = element_blank(), 
		panel.grid.minor.x = element_blank(), 
		panel.background = element_blank(),
		plot.background = element_rect(fill = "black"),
		strip.background =element_blank(),
		strip.text.x =element_blank(),
		axis.ticks.x=element_blank(),
		panel.border = element_blank(),
		axis.title = element_text(colour = "white")
	)
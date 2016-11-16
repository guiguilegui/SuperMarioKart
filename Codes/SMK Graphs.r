library(ggplot2)
library(png)
library(gtable)
library(grid)
library(dplyr)
d = read.table("C:\\Users\\Guillaume\\Documents\\Snes\\SuperMarioKart\\Codes\\Results.txt", sep="\t",header = TRUE)

d2 = d %>%
filter(Lap>127 & Lap<133)


#Time Taken for each course#
d.Course = d %>%
filter(Lap<133) %>%
group_by(Iteration, Player) %>%
summarise(Time.Spent = (max(Time) - min(Time))/100)%>%
group_by(Iteration) %>%
mutate(Rank = dense_rank(Time.Spent))

d.Course.stats = d.Course %>%
group_by(Rank) %>%
summarise(
	Min.Time.Spent = min(Time.Spent),
	Max.Time.Spent = max(Time.Spent),
	Mean.Time.Spent = mean(Time.Spent)
)

ggplot(d.Course)+
geom_point(aes(x = Rank, y = Time.Spent, color = as.factor(Rank)),alpha=0.2)+
#geom_text(data=)+
scale_x_continuous(breaks = 1:7, name = "AI Rank")+
scale_y_continuous(minor_breaks = 95:125, name = "Race Time (in seconds)")+
theme(
	legend.position = "none",
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
	axis.title = element_text(colour = "white"),
	legend.position = "none"
)

d.Speed = d %>%
filter(Iteration == 1)

ggplot(d.Speed )+
geom_point(aes(y = Speed, x = Player, color = as.factor(Player)))

ggplot(d.Speed)+
geom_jitter(aes(y = Speed, x = Player, color = as.factor(Player)),alpha=0.2,position = position_jitter(width = .8,height = 0))+ 
geom_boxplot(aes(y = Speed, x = Player),fill = NA,color="white",outlier.shape = NA)+
scale_y_continuous(breaks = (0:10)*100,name = "Speed")+
theme(
	legend.position = "none",
	plot.title = element_text(lineheight=.7, face="bold",colour="white"),
	panel.grid.minor.y = element_line(size = 0.2, colour = "grey4", linetype = "longdash"),
	panel.grid.major.y = element_line(size = 0.5, colour = "grey12", linetype = "longdash"),
	panel.grid.major.x = element_blank(), 
	panel.background = element_blank(),
	plot.background = element_rect(fill = "black"),
	strip.background =element_blank(),
	strip.text.x =element_blank(),
	axis.ticks.x=element_blank(),
	panel.border = element_blank(),
	axis.title.y = element_text(colour = "white"),
	axis.title.x = element_blank(),
	legend.position = "none"
)

+
theme(
plot.title = element_text(lineheight=.7, face="bold",colour="white"),
panel.grid.minor = element_blank(), 
panel.grid.major.y = element_line(size = 1, colour = "grey12", linetype = "longdash"),
panel.grid.major.x = element_line(size = 0.5, colour = "grey20", linetype = "longdash"), 
panel.background = element_blank(),
plot.background = element_rect(fill = "black"),
strip.background =element_blank(),
strip.text.x =element_blank(),
axis.title = element_blank(),
axis.ticks.x=element_blank(),
panel.border = element_blank(),
axis.title = element_text(colour = "white"),
legend.position = "none"
 )+ ggtitle("Distribution du nombre de points")
 


Grob = rasterGrob(readPNG("C:\\Users\\Guillaume\\Documents\\snes\\mariocircuit-1.png", TRUE), width=1, height=1, interpolate=TRUE)#http://www.mariouniverse.com/images/maps/snes/smk/mariocircuit-1.png

Point1 = c(588,-240)*256
Point2 = c(78,-420)*256
Point3 = c(330,-650)*256
Point4 = c(630,-750)*256


d.Curve = d %>%
group_by(Lap,Player) %>%
mutate(
	Point1.Time = Time[which.min((Point1[1] - HPos)^2 + (Point1[2] - - VPos)^2)],
	Point2.Time = Time[which.min((Point2[1] - HPos)^2 + (Point2[2] - - VPos)^2)],
	Point3.Time = Time[which.min((Point3[1] - HPos)^2 + (Point3[2] - - VPos)^2)],
	Point4.Time = Time[which.min((Point4[1] - HPos)^2 + (Point4[2] - - VPos)^2)]	
) %>%
rowwise() %>%
mutate(Curve = rank(c(Time,Point1.Time,Point2.Time,Point3.Time,Point4.Time),ties.method	="min")[1])%>%
group_by(Lap,Player,Curve) %>%
mutate(Time.Spent = max(Time) - min(Time))%>%
group_by(Lap,Curve) %>%
mutate(Rank.Curve = dense_rank(Time.Spent))



ggplot(data=d.Curve3) + 
annotation_custom(Grob, xmin=-Inf, xmax=Inf, ymin=-Inf, ymax=Inf)+
geom_point(aes(x=HPos, y=-VPos, color = as.factor(Character)))+
scale_x_continuous(limits= c(0,256*1024), expand = c(0, 0)) + 
scale_y_continuous(expand = c(0, 0), limits= c(-256*1024,0))+
scale_color_discrete(guide = FALSE)+z
coord_fixed(ratio = 1)+
labs(x = NULL, y = NULL)+
theme(
	rect             = element_blank(),
	line             = element_blank(),
	text             = element_blank(),
	panel.grid=element_blank(), 
	panel.background=element_rect(fill = "transparent",colour = NA),
	panel.border=element_blank()
)

ggplot(data=sample_frac(d.Curve,1)) + 
#ggplot(data=subset(d.Curve,Rank.Curve==1||Rank.Curve==7)) + 
annotation_custom(Grob, xmin=-Inf, xmax=Inf, ymin=-Inf, ymax=Inf)+
geom_point(aes(x=HPos, y=-VPos, color = Rank.Curve),alpha=0.05,size=0.5)+
scale_x_continuous(limits= c(0,256*1024), expand = c(0, 0)) + 
scale_y_continuous(expand = c(0, 0), limits= c(-256*1024,0))+
scale_color_continuous(guide = FALSE,low="red",high="green")+
coord_fixed(ratio = 1)+
labs(x = NULL, y = NULL)+
theme(
	rect             = element_blank(),
	line             = element_blank(),
	text             = element_blank(),
	panel.grid=element_blank(), 
	panel.background=element_rect(fill = "transparent",colour = NA),
	panel.border=element_blank()
)


print(d2[,c("Time","Curve1.Start","Curve2.Start","Lap2")],n=50)

print(d2[,c("Time","Lap2")],n=50)
d[1:1248,c("Time","Lap2")]

#######################################################################
#######################################################################
options(dplyr.print_max = 1e9)

d = read.table("C:\\Users\\Guillaume\\Documents\\Snes\\SuperMarioKart\\Codes\\VehPosition.txt", sep="\t",header = TRUE)
RaceInfo = read.table("C:\\Users\\Guillaume\\Documents\\Snes\\SuperMarioKart\\Codes\\RaceInfo.txt", sep="\t",header = TRUE)

d.Course = d %>%
filter(Lap==132) %>%
group_by(Iteration, Player) %>%
summarise(Time.Spent = max(Time)/100)%>%
group_by(Iteration) %>%
mutate(Rank = dense_rank(Time.Spent))

d.Course.2 = inner_join(d.Course,RaceInfo)%>%
group_by(Rank,Class,Type) %>%
summarise(Avg.Time = mean(Time.Spent), min.Time = min(Time.Spent), max.Time = max(Time.Spent),lolwat = min.Time -max.Time)

d.Course.2$Class = factor(d.Course.2$Class, levels=c("50CC", "100CC", "150CC"))

d.Course.gain = d.Course.2 %>%
group_by(Rank,Class) %>%
summarise(Time.Less = max(Avg.Time) - min(Avg.Time) )


#df.text = data.frame(Class="50CC",Rank=1,y=0)

ggplot(d.Course.2)+
geom_path(aes(x = Rank, y = Avg.Time, color = as.factor(Rank),group=interaction(Class, Rank)),position = position_dodge(width = 0.6),size=1)+
geom_point(aes(x = Rank, y = Avg.Time, color = as.factor(Rank),group=Class,shape = Type),position = position_dodge(width = 0.6),size=2,fill="black")+
scale_shape_manual(values=c(24,25))+
scale_x_continuous(breaks = 1:7, name = "AI Rank")+
scale_y_continuous(breaks = seq(0,140,by=20), minor_breaks = seq(0,125,by=5),limit=c(-5,130), name = "Race Time (in seconds)")+
geom_text(data=subset(d.Course.2, Type == "idle"), aes(x = Rank, label = Class, group = Class, y=Avg.Time + 4),color="grey70",position = position_dodge(width = 0.6), size = 2)+
geom_text(data=d.Course.gain, aes(x = Rank, label = paste0(-round(Time.Less,1),"s"),color=as.factor(Rank), group = Class, y=-4),position = position_dodge(width = 0.8), size = 2.4)+
theme(
	legend.position = "none",
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
	axis.title = element_text(colour = "white"),
	legend.position = "none"
)
######################################################################
library(mgcv)
d.times.rank = 
d %>%
filter(!(Lap %in% c(127,133))) %>%
inner_join(d.Course) %>%
inner_join(RaceInfo) %>%
filter(Rank ==1&Class=="50CC")
#filter(Rank == 2&Class=="100CC"&Type=="idle")
#filter(Class=="50CC"&Rank == 2)

d.times.rank.2 = d.times.rank %>%
arrange(Iteration,Player, Lap) %>%
group_by(Iteration,Player, Lap) %>%
mutate(
	dist    = ((lag(HPos) - HPos)^2 + (lag(VPos)-VPos)^2)^0.5,
	cumdist = cumsum(ifelse(is.na(dist),0,dist)),
	cumprop = percent_rank(cumdist),
	Lap2 = (Lap>128)
) 


ggplot(d.times.rank.2[sample(nrow(d.times.rank.2)),])+
#geom_point(aes(x = cumprop, y = Speed, col = interaction(Type,Lap2,lex.order = TRUE)), alpha = 1)+
geom_smooth(aes(x = cumprop, y = Speed, col = interaction(Type,Lap2,lex.order = TRUE)),method="gam",formula = y ~ s(x,k=100),se=FALSE)+
scale_colour_brewer(palette= "Set1", name="Experiment + Lap",  labels = c('First Place\nLap 1\n', 'First Place\nLap 2 & More\n','Last Place\nLap 1\n','Last Place\nLap 2 & More'))+
scale_x_continuous(labels = scales::percent, name = "Percentage of lap done")+
theme(
	legend.background = element_blank(),
	legend.text = element_text(colour = "grey24"),
	legend.title = element_text(colour = "white"),
	legend.key = element_blank(),
	#legend.position = "none",
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


d.times.rank.150 = d.times.rank.2 %>%
	filter(Class == "150CC", Type=="first", Lap>128)
	
gam.HPos.150 = gam(HPos ~ s(cumprop,k=80), data	= d.times.rank.150)
gam.VPos.150 = gam(VPos ~ s(cumprop,k=80), data	= d.times.rank.150)
gam.Speed.150 = gam(Speed ~ s(cumprop,k=80), data= d.times.rank.150)


d.times.rank.50 = d.times.rank.2 %>%
	filter(Class == "50CC", Type=="first", Lap>128)
	
gam.HPos.50 = gam(HPos ~ s(cumprop,k=80), data	= d.times.rank.50)
gam.VPos.50 = gam(VPos ~ s(cumprop,k=80), data	= d.times.rank.50)
gam.Speed.50 = gam(Speed ~ s(cumprop,k=80), data= d.times.rank.50)

df.gam.predict = data.frame(cumprop = seq(0, 1, by = 0.0001))

df.gam.predict$predict.HPos.50=predict(gam.HPos.50,df.gam.predict)
df.gam.predict$predict.VPos.50=predict(gam.VPos.50,df.gam.predict)
df.gam.predict$predict.Speed.50=predict(gam.Speed.50,df.gam.predict)

df.gam.predict$predict.HPos.100=predict(gam.HPos.100,df.gam.predict)
df.gam.predict$predict.VPos.100=predict(gam.VPos.100,df.gam.predict)
df.gam.predict$predict.Speed.100=predict(gam.Speed.100,df.gam.predict)

df.gam.predict$predict.HPos.150=predict(gam.HPos.150,df.gam.predict)
df.gam.predict$predict.VPos.150=predict(gam.VPos.150,df.gam.predict)
df.gam.predict$predict.Speed.150=predict(gam.Speed.150,df.gam.predict)


ggplot(df.gam.predict)+
geom_path(aes(x = predict.HPos.50, y = -predict.VPos.50, col=predict.Speed.50),size=2)
+
geom_path(aes(x = predict.HPos.100, y = -predict.VPos.100, col=predict.Speed.100),size=2)+
geom_path(aes(x = predict.HPos.150, y = -predict.VPos.150, col=predict.Speed.150),size=2)

ggplot(df.gam.predict)+
geom_path(aes(x = predict.HPos.50, y = -predict.VPos.50), col="red",size=1)+
geom_path(aes(x = predict.HPos.100, y = -predict.VPos.100), col = "yellow", size=1)+
geom_path(aes(x = predict.HPos.150, y = -predict.VPos.150), col = "green", size=1)


ggplot(df.gam.predict)+
geom_path(aes(x = cumprop, y = predict.Speed, col=predict.Speed),size=2)


 head(d.times.rank.2 ,30)
+
scale_shape_manual(values=c(24,25))+
scale_x_continuous(breaks = 1:7, name = "AI Rank")+
scale_y_continuous(breaks = seq(0,140,by=20), minor_breaks = seq(0,125,by=5),limit=c(-5,130), name = "Race Time (in seconds)")+
geom_text(data=subset(d.Course.2, Type == "idle"), aes(x = Rank, label = Class, group = Class, y=Avg.Time + 4),color="grey70",position = position_dodge(width = 0.6), size = 2)+
geom_text(data=d.Course.gain, aes(x = Rank, label = paste0(-round(Time.Less,1),"s"),color=as.factor(Rank), group = Class, y=-4),position = position_dodge(width = 0.8), size = 2.4)+
theme(
	legend.position = "none",
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
	axis.title = element_text(colour = "white"),
	legend.position = "none"
)

model.loess = loess(MAD ~ a.WOW*b.WOW*d.WOW, data=d.times.rank, degree = 2)


#######################################################################
#######################################################################

options(dplyr.print_max = 1e9)

d = read.table("C:\\Users\\Guillaume\\Documents\\Snes\\SuperMarioKart\\Codes\\VehPosition.txt", sep="\t",header = TRUE)
RaceInfo = read.table("C:\\Users\\Guillaume\\Documents\\Snes\\SuperMarioKart\\Codes\\RaceInfo.txt", sep="\t",header = TRUE)


d.Course = d %>%
filter(Lap==127) %>%
group_by(Iteration, Player) %>%
summarise(Time.Spent = max(Time)/100)%>%
group_by(Iteration) %>%
mutate(Rank = dense_rank(Time.Spent))

library(ggplot2)
library(png)
library(gtable)
library(grid)

d = read.table("C:\\Users\\Guillaume\\Documents\\GBA\\BizHawk-1.11.6\\Lua\\Results.txt", sep="\t",header = TRUE)

d = subset(d,Time>0)

Grob = rasterGrob(readPNG("C:\\Users\\Guillaume\\Documents\\snes\\mariocircuit-1.png", TRUE), width=1, height=1, interpolate=TRUE)#http://www.mariouniverse.com/images/maps/snes/smk/mariocircuit-1.png

g = ggplot(data=d) + 
annotation_custom(Grob, xmin=-Inf, xmax=Inf, ymin=-Inf, ymax=Inf)+
geom_path(aes(x=HPos2, y=-VPos2, color = Speed2))+
geom_path(aes(x=HPos3, y=-VPos3, color = Speed3))+
geom_path(aes(x=HPos4, y=-VPos4, color = Speed4))+
geom_path(aes(x=HPos5, y=-VPos5, color = Speed5))+
geom_path(aes(x=HPos6, y=-VPos6, color = Speed6))+
geom_path(aes(x=HPos7, y=-VPos7, color = Speed7))+
geom_path(aes(x=HPos8, y=-VPos8, color = Speed8))+
scale_x_continuous(limits= c(0,256*1024), expand = c(0, 0)) + 
scale_y_continuous(expand = c(0, 0), limits= c(-256*1024,0))+
scale_color_continuous(guide = FALSE)+
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

ggsave(g, file="C:\\Users\\Guillaume\\Documents\\Snes\\Graphs\\mario_circuit.png", width=4, height=4)
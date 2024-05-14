install.packages("ggplot2")
install.packages("dplyr")

library(ggplot2)
library(dplyr)



#Port data 
library(readxl)
worldport_rank <- read_excel("~/Downloads/worldport_rank.xlsx")
View(worldport_rank)

## Trade volume raniking port top 20 in 2020
Rank_2020 = subset(worldport_rank, Year==2020 & Rank <=20)
View(Rank_2020)
str(Rank_2020)
Rank_2020$Volume <-as.numeric(Rank_2020$Volume)
is.numeric(Rank_2020$Volume)

p<-ggplot(data=Rank_2020,aes(x=reorder(Port,Rank_2020$Volume),y=Volume))+geom_bar(stat='identity',fill='#006699')+coord_flip()+labs(x='Port',y='Volume (1000 TEUs)',title = 'Top 20 Ports in 2020') +theme(plot.title=element_text(size=18,hjust=0.5))+geom_text(aes(label=Volume),size=3,hjust=1.25,color='#FFFFFF')
p


p
p <- p+labs(x='Port',y='Volume (1000 TEUs)',title = 'Top 20 Ports in 2020') +theme(plot.title = element_text(size=18, hjust=0.5))+geom_text(aes(label=Volume),size=3,hjust=1.25,color='#FFFFFF')
p

##2020 Top trade volume countries
df<-subset(worldport_rank, Year==2020)
df$Volume<-as.numeric(df$Volume)
is.numeric(df$Volume)
country<-aggregate(df$Volume, by=list(df$Country),FUN=sum)
country
df$Volume[is.na(df$Volume)]<-0
df
country<-aggregate(df$Volume, by=list(df$Country),FUN=sum)
country
con<-country[!(country$x == "0"),]
con
l<-ggplot(data=con, aes(x=reorder(Group.1,con$x),y=x))+geom_bar(stat='identity',fill='#FF0033')+coord_flip()+geom_text(aes(label=x),size=3,hjust=1.25,color='#FFFFFF')+labs(x='Countries',y='Volume (1000TEUs)',title='Top Countries in trade volume in 2020')+theme(plot.title=element_text(size = 16, hjust = 0.5))
l

##Interactive map of Ports
##ggmap : to get longtitude and latitude from google maps data

install.packages("ggmap")
library(ggmap)
register_google(key='AIzaSyAjcOMKjNEkyXb20k5Gqt_UY7PwpjzSCug')
library(dplyr)
distinct(worldport_rank,Port)
port<-distinct(worldport_rank,Port)
port
print(port, n=49) 
names<-c("Shanghai","Singapore","Zhoushan","Shenzhen","Guangzhou","Qingdao","Busan","Hong Kong","Tianjin","Rotterdam","Jebel Ali","Port Klang","Xiamen","Antwerp","Kaohsiung","Dalian","Los Angeles", "Hamburg","Tanjung Pelepas","Laem Chabang","Yokohama","Long Beach","Tanjung Priok","New York","Colombo","Saigon","Tanger-Med","Suzhou","Piraeus","Yingkou","Valencia","Manila","Taicang","Hai Phong","Algeciras","Nhava Sheva","Bremerhaven","Lianyungang","Mundra","Savannah","Tokyo","Rizhao","Foshan","Jeddah","Colon Panama","Santos","Salalah","Dongguan","Beibu Gulf")
gc<-geocode(names)
portmap<-data.frame(name=names,lon=gc$lon,lat=gc$lat)
cen<-c(mean(portmap$lon),mean(portmap$lat))
map<-get_googlemap(center = cen, maptype = "terrain", zoom = 1, markers = gc)
gmap<-ggmap(map)
gmap


##make port map 2020-trial 1 
worldport_rank$Port<-as.character(worldport_rank$Port)
worldport_rank$Volume<-as.numeric(worldport_rank$Volume)
worldport_rank<-mutate_all(worldport_rank,~replace(.,is.na(.),0))
df<-subset(worldport_rank, Year==2020)
df
first<-cbind(df, portmap)
names(first)<-c("Rank", "Year", "Volume", "name","Country","Region","Port","lon","lat")
trade<-first %>% select(Volume, Port, lon, lat)
trade$lon<-as.numeric(trade$lon)
trade$lat<-as.numeric(trade$lat)
cen<-c(mean(trade$lon), mean(trade$lat))
trademap<-data.frame(lon=trade$lon,lat=trade$lat)
trademap$lon<-ifelse(trademap$lon>180,-(360-trademap$lon),trademap$lon)
trademap
map<-get_googlemap(center = cen, maptype = "terrain", zoom=1)
gmap<-ggmap(map)
gmap
fmap<-gmap+geom_point(data=trade,aes(x=lon,y=lat,size=Volume),alpha=0.5,color='red')+scale_size_continuous(range = c(1,14))
fmap

## not good to see so use ggplot geom_polygon data=map.world_polygon - trial 2
#now we use better illustration map 
require(ggplot2)
require(dplyr)
require(tidyverse)
map.world_polygon <- map_data("world")
df<-subset(worldport_rank, Year==2020)
first<-cbind(df,portmap)
names(first)<-c("Rank", "Year", "Volume", "name","Country","Region","Port","lon","lat")
one<- first %>% ggplot(aes(x=lon, y=lat))+ geom_polygon(data=map.world_polygon, aes(x=long, y=lat, group=group), fill='#FFCC66', colour='#000000', size=.15)+ geom_point(aes(size=first$Volume), color='#FF3300',alpha=.15)+geom_point(aes(size=first$Volume), color='#FF3300', alpha=.7, shape=1)+scale_size_continuous(range = c(.2,10),breaks=c(5000,10000,30000),name="Volume/n(1000 TEU")+ggtitle("2020 Port Map") + theme(plot.title = element_text(family = "serif", face = "bold", hjust = 0.5, size = 15, color = "darkblue"))


cf<-subset(worldport_rank, Year==2019)
second<-cbind(cf,portmap)
two<- second %>% ggplot(aes(x=lon, y=lat))+ geom_polygon(data=map.world_polygon, aes(x=long, y=lat, group=group), fill='#FFCC66', colour='#000000', size=.15)+ geom_point(aes(size=second$Volume), color='#FF3300',alpha=.15)+geom_point(aes(size=second$Volume), color='#FF3300', alpha=.7, shape=1)+scale_size_continuous(range = c(.2,10),breaks=c(5000,10000,30000),name="Volume/n(1000 TEU")+ggtitle("2019 Port Map") + theme(plot.title = element_text(family = "serif", face = "bold", hjust = 0.5, size = 15, color = "darkblue")) 

bf<-subset(worldport_rank, Year==2018)
third<-cbind(bf,portmap)
three<-third %>% ggplot(aes(x=lon, y=lat))+ geom_polygon(data=map.world_polygon, aes(x=long, y=lat, group=group), fill='#FFCC66', colour='#000000', size=.15)+ geom_point(aes(size=third$Volume), color='#FF3300',alpha=.15)+geom_point(aes(size=third$Volume), color='#FF3300', alpha=.7, shape=1)+scale_size_continuous(range = c(.2,10),breaks=c(5000,10000,30000),name="Volume/n(1000 TEU")+ggtitle("2018 Port Map") + theme(plot.title = element_text(family = "serif", face = "bold", hjust = 0.5, size = 15, color = "darkblue"))

af<-subset(worldport_rank, Year==2017)
fourth<-cbind(af,portmap)
four<-fourth %>% ggplot(aes(x=lon, y=lat))+ geom_polygon(data=map.world_polygon, aes(x=long, y=lat, group=group), fill='#FFCC66', colour='#000000', size=.15)+ geom_point(aes(size=fourth$Volume), color='#FF3300',alpha=.15)+geom_point(aes(size=fourth$Volume), color='#FF3300', alpha=.7, shape=1)+scale_size_continuous(range = c(.2,10),breaks=c(5000,10000,30000),name="Volume/n(1000 TEU")+ggtitle("2017 Port Map") + theme(plot.title = element_text(family = "serif", face = "bold", hjust = 0.5, size = 15, color = "darkblue"))

ef<-subset(worldport_rank, Year==2016)
fifth<-cbind(ef, portmap)
names(fifth)<-c("Rank", "Year", "Volume", "name","Country","Region","Port","lon","lat")
five<-fifth %>% ggplot(aes(x=lon, y=lat))+ geom_polygon(data=map.world_polygon, aes(x=long, y=lat, group=group), fill='#FFCC66', colour='#000000', size=.15)+ geom_point(aes(size=fifth$Volume), color='#FF3300',alpha=.15)+geom_point(aes(size=fifth$Volume), color='#FF3300', alpha=.7, shape=1)+scale_size_continuous(range = c(.2,10),breaks=c(5000,10000,30000),name="Volume/n(1000 TEU")+ggtitle("2016 Port Map") + theme(plot.title = element_text(family = "serif", face = "bold", hjust = 0.5, size = 15, color = "darkblue"))

ff<-subset(worldport_rank, Year==2015)
sixth<-cbind(ff, portmap)
names(sixth)<-c("Rank", "Year", "Volume", "name","Country","Region","Port","lon","lat")
six<-sixth %>% ggplot(aes(x=lon, y=lat))+ geom_polygon(data=map.world_polygon, aes(x=long, y=lat, group=group), fill='#FFCC66', colour='#000000', size=.15)+ geom_point(aes(size=sixth$Volume), color='#FF3300',alpha=.15)+geom_point(aes(size=sixth$Volume), color='#FF3300', alpha=.7, shape=1)+scale_size_continuous(range = c(.2,10),breaks=c(5000,10000,30000),name="Volume/n(1000 TEU")+ggtitle("2015 Port Map") + theme(plot.title = element_text(family = "serif", face = "bold", hjust = 0.5, size = 15, color = "darkblue"))

gf<-subset(worldport_rank, Year==2014)
seventh<-cbind(gf, portmap)
names(seventh)<-c("Rank", "Year", "Volume", "name","Country","Region","Port","lon","lat")
seven<-seventh %>% ggplot(aes(x=lon, y=lat))+ geom_polygon(data=map.world_polygon, aes(x=long, y=lat, group=group), fill='#FFCC66', colour='#000000', size=.15)+ geom_point(aes(size=seventh$Volume), color='#FF3300',alpha=.15)+geom_point(aes(size=seventh$Volume), color='#FF3300', alpha=.7, shape=1)+scale_size_continuous(range = c(.2,10),breaks=c(5000,10000,30000),name="Volume/n(1000 TEU")+ggtitle("2014 Port Map") + theme(plot.title = element_text(family = "serif", face = "bold", hjust = 0.5, size = 15, color = "darkblue")) 

hf<-subset(worldport_rank, Year==2013)
eighth<-cbind(hf, portmap)
names(eighth)<-c("Rank", "Year", "Volume", "name","Country","Region","Port","lon","lat")
eight<-eighth %>% ggplot(aes(x=lon, y=lat))+ geom_polygon(data=map.world_polygon, aes(x=long, y=lat, group=group), fill='#FFCC66', colour='#000000', size=.15)+ geom_point(aes(size=eighth$Volume), color='#FF3300',alpha=.15)+geom_point(aes(size=eighth$Volume), color='#FF3300', alpha=.7, shape=1)+scale_size_continuous(range = c(.2,10),breaks=c(5000,10000,30000),name="Volume/n(1000 TEU")+ggtitle("2013 Port Map") + theme(plot.title = element_text(family = "serif", face = "bold", hjust = 0.5, size = 15, color = "darkblue")) 

vf<-subset(worldport_rank, Year==2012)
ninth<-cbind(vf,portmap)
names(ninth)<-c("Rank", "Year", "Volume", "name","Country","Region","Port","lon","lat")
nine<-ninth %>% ggplot(aes(x=lon, y=lat))+ geom_polygon(data=map.world_polygon, aes(x=long, y=lat, group=group), fill='#FFCC66', colour='#000000', size=.15)+ geom_point(aes(size=ninth$Volume), color='#FF3300',alpha=.15)+geom_point(aes(size=ninth$Volume), color='#FF3300', alpha=.7, shape=1)+scale_size_continuous(range = c(.2,10),breaks=c(5000,10000,30000),name="Volume/n(1000 TEU")+ggtitle("2012 Port Map") + theme(plot.title = element_text(family = "serif", face = "bold", hjust = 0.5, size = 15, color = "darkblue"))

nf<-subset(worldport_rank, Year==2011)
tenth<-cbind(nf,portmap)
names(tenth)<-c("Rank", "Year", "Volume", "name","Country","Region","Port","lon","lat")
ten<-tenth %>% ggplot(aes(x=lon, y=lat))+ geom_polygon(data=map.world_polygon, aes(x=long, y=lat, group=group), fill='#FFCC66', colour='#000000', size=.15)+ geom_point(aes(size=tenth$Volume), color='#FF3300',alpha=.15)+geom_point(aes(size=tenth$Volume), color='#FF3300', alpha=.7, shape=1)+scale_size_continuous(range = c(.2,10),breaks=c(5000,10000,30000),name="Volume/n(1000 TEU")+ggtitle("2011 Port Map") + theme(plot.title = element_text(family = "serif", face = "bold", hjust = 0.5, size = 15, color = "darkblue"))

#We need to save the maps png files for animation
one
two
three
four
five
six
seven
eight
nine
ten

## animating the port maps 2011-2020 : 10 years trade volume changes in world port
install.packages("magick")
install.packages("magrittr")
library(magick)
library(magrittr)
q<- image_read("/Users/benutzer/Downloads/Maps/10.png")
w <- image_read("/Users/benutzer/Downloads/Maps/9.png")
e <- image_read("/Users/benutzer/Downloads/Maps/8.png")
r <- image_read("/Users/benutzer/Downloads/Maps/7.png")
t <- image_read("/Users/benutzer/Downloads/Maps/6.png")
y <- image_read("/Users/benutzer/Downloads/Maps/5.png")
u <- image_read("/Users/benutzer/Downloads/Maps/4.png")
i <- image_read("/Users/benutzer/Downloads/Maps/3.png")
o <- image_read("/Users/benutzer/Downloads/Maps/2.png")
p <- image_read("/Users/benutzer/Downloads/Maps/1.png")
image_scale(p, "800")
image_scale(p, "x800")
image_info(p)
img<-c(q, w, e, r,t, y, u, i, o ,p)
animation<-image_animate(image_scale(img, "1200X800"), fps=1, dispose="previous")
animation
image_write(animation, "port.gif")



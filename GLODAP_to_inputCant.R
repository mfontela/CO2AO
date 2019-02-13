#Script para preparar los datos de GLODAPv2 al input que corre el Cant
library(tidyverse)
library(readxl)
library(readr)
library(R.matlab)
library(rlist)
library(Imap)
library(lubridate)


setwd('XXXXXXXXXXX') #ACTUALIZA ESTO CON LA CARPETA DONDE GUARDASTE EL ARCHIVO *.mat (GLODAPv2 Atlantic Ocean.mat)

A<-readMat("GLODAPv2 Atlantic Ocean.mat")
A<-list.remove(A, c("expocode", "expocodeno")) #Para que al pasar la lista a data.frame no me den problemas
A<-as.data.frame(A) #Pasa la lista a data.frame
#Empiezas con 372040 observaciones
#Queremos quedarnos con los parámetros que necesita el phi_Cant y con datos de buena calidad
# neededParameters={'longitude','latitude','pressure','theta','salinity','oxygen','silicate','nitrate','phosphate', 'ct','at','year'};
A<-A %>% 
  mutate_all(.funs = funs(ifelse(. == "NaN", NA, .)))%>% #pasas los NaN a NA
  mutate(year=decimal_date(ymd(sprintf('%04d%02d%02d',G2year,G2month,G2day)))) %>% #Conviertes la fecha a año
  mutate(G2nitrate=ifelse(G2nitritef==2, G2nitrate+G2nitrite, G2nitrate))%>% #Si hay nitrite, y es bueno, se lo sumo al nitrate
  filter(!is.na(G2pressure) & !is.na(G2theta) & !is.na(G2salinity) &
           !is.na(G2oxygen) & !is.na(G2silicate) & !is.na(G2nitrate) &
           !is.na(G2phosphate) & !is.na(G2tco2) & !is.na(G2talk))%>% #eliminas las muestras con NA en todos los neededParameters. Bajamos a 65mil observaciones
  filter(G2salinityf==2 & G2oxygenf==2  & G2silicatef==2 & G2nitratef==2 & G2phosphatef==2 & G2tco2f==2 & G2talkf==2) %>% #El flag de buena calidad
  select(G2station,G2bottle,G2year,G2longitude, G2latitude, G2depth,G2pressure,
         G2theta, G2salinity, G2oxygen, G2silicate, G2nitrate, G2phosphate, G2tco2, G2talk, year) %>% #Me quedo sólo con las columnas del input_data
  rename(St=G2station, Bottle=G2bottle, date=G2year, longitude=G2longitude, latitude=G2latitude, Depth=G2depth,
         pressure=G2pressure, theta=G2theta, salinity=G2salinity, oxygen=G2oxygen, silicate=G2silicate, nitrate=G2nitrate, phosphate=G2phosphate, ct=G2tco2, at=G2talk) %>% #Ya solo faltan el Loc y orden del input_data.csv (que en realidad no sirven para nada...)
  mutate(Loc=date*10^9+St*10^3+Bottle, Orden=1:nrow(.))

#reordeno para que Loc y Orden estén en primeras posiciones del csv
A<-A[,c(17,18,1:16)]

#Exporto a csv sin row.names
write.csv(A, file="input_data_GLODAP2.csv", row.names = F, sep=";") 
#El sep es para que separe por ; que es cómo están en el input_data.csv que queremos reproducir
#Siguiente paso: Ir a Matlab, run_phi.m y cambiar línea 7 por:
# INPUT_FILE='input_data_GLODAP2.csv'; Run!
#NOTA: si te da problemas al correr el run_phi.m (pasa a veces según configuración comas/puntos comas de tu equipo) prueba a cambiar comas por puntoscomas en el csv de entrada o 
# añade 'Delimiter',';' a la función readtable: InputData=readtable(INPUT_FILE,'Delimiter',';');

#Interpreta el "out_phi_201902diaThora.csv" que te generó el programa

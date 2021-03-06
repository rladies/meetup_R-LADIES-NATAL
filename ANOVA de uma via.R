
# ANOVA de uma via # MEETUP 

# Passo 1: Carregar os pacotes

if(!require(dplyr)) install.packages("dplyr")
library(dplyr)                                
if(!require(RVAideMemoire)) install.packages("RVAideMemoire") 
library(RVAideMemoire)                                        
if(!require(car)) install.packages("car")   
library(car)                                
if(!require(psych)) install.packages("psych") 
library(psych)                                
if(!require(rstatix)) install.packages("rstatix") 
library(rstatix)                                
if(!require(DescTools)) install.packages("DescTools") 
library(DescTools)

# Passo 2: Carregar o banco de dados

# Importante: selecionar o diret�rio de trabalho (working directory)
# Isso pode ser feito manualmente: Session > Set Working Directory > Choose Directory

dados <- read.csv2('Dados ANOVA.csv', stringsAsFactors = T) # Carregamento do arquivo csv
View(dados)                                # Visualiza��o dos dados em janela separada
glimpse(dados)                             # Visualiza��o de um resumo dos dados


# Passo 3: Verifica��o da normalidade dos dados
## Shapiro por grupo (pacote RVAideMemoire)

#H0: distribui��o dos dados � normal se p > 0,05
#H1: distribui��o n�o segue padr�es de normalidade se p < 0,05

byf.shapiro(ALT ~ TRAT, dados)


# Passo 4: Verifica��o da homogeneidade de vari�ncias
## Teste de Levene (pacote car)

#H0: dados apresentam homog�nidade de variancias se p > 0,05
#H1: dados n�o apresentam homog�nidade de variancias se p < 0,05

leveneTest(ALT ~ TRAT, dados, center=mean)


# Passo 5: Verifica��o da presen�a de outliers (por grupo) - Pacotes dplyr e rstatix

# Para ALT: (rstatix)
dados %>%   #identificar por grupo
  group_by(TRAT) %>% 
  identify_outliers(ALT)

## Pelo boxplot:
boxplot(ALT ~ TRAT, data = dados, ylab="Altura das Plantas (cm)", xlab="Tratamento")


# Passo 6: Realiza��o da ANOVA

#H0: todos os grupos possuem m�dias iguais se p > 0,05
#H1: h� pelo menos uma diferen�a entre as m�dias se p < 0,05

## Cria��o do modelo para ALT
anova_ALT <- aov(ALT ~ TRAT, dados)
summary(anova_ALT)

# Passo 7: An�lise post-hoc - Pacote DescTools

# Uso do TukeyHSD
PostHocTest(anova_ALT, method = "hsd", conf.level=0.95)

# Passo 8 (opcional): An�lise descritiva dos dados
describeBy(dados$ALT, group = dados$TRAT)

# Os dados foram analisados a partir de uma ANOVA de uma via 
#  que verificou o efeito da salinidade em plantas de manjeric�o e
# foi poss�vel concluir que h� um efeito 
# significativo da salinidade na altura das plantas (p>0,05).

#install.packages("EloRating")
#install.packages("tidyverse")

library(tidyverse)
library(EloRating)

all_games_2223 <- read_csv("all_games_23_through_March_13.csv")


seqcheck(winner = all_games_2223$winner, 
         loser = all_games_2223$loser, 
         Date = all_games_2223$game_date) #makes sure dataframe is usable for ELO package

ELOrankings_2223 <- elo.seq(winner = all_games_2223$winner, 
                            loser = all_games_2223$loser, 
                            Date = all_games_2223$game_date, 
                            runcheck = F,
                            k = 50) #generates ELO rankings, using specified k value

wk122 <- as.data.frame(extract_elo(ELOrankings_2223, extractdate = "2022-02-01")) #extracts ELO for certain date
#need to convert row names to a vector, then could left join to show change by week

elo2223<- as.data.frame(extract_elo(ELOrankings_2223)) #final rankings

eloplot(ELOrankings_2223) #plot of all rankings for all teams -- how to filter this?

eloplot(eloobject = ELOrankings_2223, ids = c("Hawaii", "Grand Canyon", "Daemen"), from = "2022-01-05", to = "2023-03-13")


elo2223 <- ELOrankings_2223[["logtable"]] #makes a dataframe of rankings before and after each game

elo2223 %>% ggplot(aes(x = Date, y = Apost, group = winner)) + geom_line()

#if you want to create a separate DF for a team
Hawaii <- elo2223 %>% filter(winner == "Hawaii" | loser  == "Hawaii")
Hawaii <- Hawaii %>% mutate(ELO = if_else(winner == "Hawaii", Apost, Bpost))
Hawaii <- Hawaii %>% mutate(game_no = seq(from = 1, to = 50)) 
Hawaii %>% ggplot(aes(x = Date, y = ELO)) + geom_line()

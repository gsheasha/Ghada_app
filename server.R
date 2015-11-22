server <- function(input, output) {
  #compute the incidence
  incidence<-reactive({round(rbeta(input$simNo,input$num,input$den),2)})    
  #Calculate the number of SSI-patients
  ssiNo<-reactive({round(input$noPat*incidence())})
  #####################################################
  
  totalCostIc<-reactive({input$costIcPerPatient*input$noPat})
  costPerSsi<-reactive({apply(as.matrix(ssiNo()),1,function(y)rtrunc(y,spec="burr",b=60000, shape1=0.21385, shape2=4.1144,scale=60.365))})
  totalCostSsi<-reactive({sapply(costPerSsi(),sum)})
  #compute the number of cases prevented due to ICP
  preventedSsiNo<-reactive({ssiNo()*input$icEfficacy}) 
  #calculate the number of SSI case after ICP
  newSsiNo<-reactive({ssiNo()-preventedSsiNo()})
  #Estimate the cost per SSI for cases developed after ICP
 costPerSsiIc<-reactive({apply(as.matrix(newSsiNo()),1,function(y)rtrunc(y,spec="burr",b=60000, shape1=0.21385, shape2=4.1144,scale=60.365))})
 #Calculate the total cost of SSI and total cost of SSI and ICP after ICP
  newTotalCostwitoutIC<- reactive({sapply(costPerSsiIc(),sum)})
 newTotalCost<-reactive({newTotalCostwitoutIC()+totalCostIc()})
 #Calculate the savings
 saving<-reactive({totalCostSsi()-newTotalCost()})
 #calculate the percentage of postive savings
 positiveSaving<-reactive({saving()[saving()>=0]})
 negativeSaving<-reactive({saving()[saving()<0]})
 savingPercentage<-reactive({length(positiveSaving())*100/length(saving())})
  # draw a pie chart
 data<-reactive({c(length( positiveSaving()),length(negativeSaving()))})
 lbls <- reactive({c("The hospital will save money", "The hospital will lose money")})
 
  
  
  
  
  
  
  
  
  
  ########################################################
 
 output$incidence <- renderPrint({
   summary(incidence())
 })
 output$ssiNo <- renderPrint({
   summary(ssiNo())
 })
 output$totalCostSsi <- renderPrint({
   summary(totalCostSsi())
 })
 
 
 output$hist <- renderPlot({
    pie3D(data(),labels=lbls(),explode=0.1,
          main="Pie Chart showing whether the hospital will save or loose money due to implementaion of ICP ")
  })
  
  output$text1 <- renderText({ 
    paste("Based on the data you fed to the model, the estimated incidence rate is",median(incidence()),". At this rate,the hospital bears a median total cost of", format(round(median(totalCostSsi()),0),big.mark=","),"EGP to treat",median(ssiNo()),"among",input$noPat,"surgical patients admitted to the hospital")
  })
  
  output$text2 <- renderText({ 
    paste("If we implement an infection control program with an efficacy of", input$icEfficacy,"at", totalCostIc(), "EGP,the number of SSI patient that may be avoided is",round(median(preventedSsiNo()),0),"patients. The median total cost (cost of treating",round(median(newSsiNo()),0)," SSI patients and the cost of ICP) is",format(round(median(newTotalCost()),0),big.mark=","),"EGP.","Thus, the median savings may be",format(round(median(saving()),0),big.mark=","),"EGP. In",round(savingPercentage(),0),"% of the runs, the hospital saves from",round(min(positiveSaving()),0),"to",format(round(max(positiveSaving()),0),big.mark=","), "EGP due to the implementation of the ICP") 
  })
  output$text3<- renderText({ 
    paste("On the other hand, in",100-round(savingPercentage(),0), "% of the runs, the hosptial may loose from",-1*round(max(negativeSaving()),0) ,"to",format(round(-1*min(negativeSaving()),0),big.mark=","),"EGP.") 
  })
 output$table<-renderDataTable({cbind(Serial=c(1:1000),Incidence=incidence(),SSINO=ssiNo(),Total_cost_of_SSI=format(round(totalCostSsi()),0,big.mark=","),No_of_prevented_cases=preventedSsiNo(),NewSSIIC=newSsiNo(),Total_cost_SSI_IC=format(round(newTotalCost(),0),big.mark=","),Saving=format(round(saving(),0),big.mark=","))})
}
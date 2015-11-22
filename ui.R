
library(shiny)
library(actuar)
library(plotrix)
library(xtable)
library(truncdist)

ui <- fluidPage(includeCSS("bootswatch-cerulean.css"),
                title = "Simulation",
 tabsetPanel( tabPanel(title="Description of the calculator", 
h1("Background"),

p("Surgical site infection (SSI) carries an enormous clinical and economic burden. The good news is that up to 35% of surgical wound infections could be prevented by an effective infection control programs.However, infection control programs (ICPs) are costly themselves."),
                       
p("Decisions, such as **Is it worthy to implement infection control measures?** and **How much resources can be utilized for this purpose?** are critical and should be informed."), 
                       
h1("Aim of the work"),
p("The aim of this calculator is helping policymakers to figure out how much they can allocate to implement an infection control program with a known efficacy in their hospitals; and to predict, in advance, the expected consequences of its implementation."),
                    
h1("How to use the calculator"),
p("This calculator is formed of two tabs."), 
                       
p( "The  **first tab**  calculated the expected number of patients with surgical site infection(SSI) and the expected total cost paid by the hospital to treat them."),
                       
p("You have to feed four cells in the first tab"),
                       
p("The first two cells are used to calculate *the incidence of SSI* using data from the hospital surveillance system. The *number of surgical patients* followed by the surveillance is entered in the first cell and *the number of patients developed surgical site infection* is entered in the second cell."),
                       
p("In the third cell, enter *the expected number of surgical patients admitted to the hospital*; e.g., 1,000 surgical patients."),
                       
p("In the forth cell, enter *the number of simulations*;  recommended 10,000."),
                     
p("The data filled in the **second tab** is related to the infection control program (ICP)."),
p("Enter *the cost of ICP per patient* in the first cell on the right. If the cost of ICP is not known per patient, then divide the total cost of the ICP by the number of the surgical patients you entered in the third cell on the first tab."),
                       
p("Select *the expected efficacy* of the ICP using the slide bar on the right. It ranges from zero (no efficacy at all) to 1 (the ICP can prevent the occurrence of all the cases of surgical site infection). If you select 0.20, this means the ICP can reduced the number of surgical site infection by 20%."),
h1("Output of the calculator"),
             
p("In **the first tab**, the following data are presented:
                       1. The incidence rate of SSI
                       2. The expected number of SSI patients.
                       3. The expected total cost the hospital will pay to treat the patients with SSI"),
                       
p("In **the second tab**, The *expected savings resulting form implementing the ICP*. ")),             
    tabPanel(title = "Costing of Surgical Site Infection",
 column(4, 
  numericInput("den", label = "Enter the total number of surgical patients included in the surveillence", value = 228),
 numericInput("num",label = "Enter the number of SSI patients detected by the surveillence", value = 32),
 br(),
 hr(),
 h4("Incidence of SSI"),
 verbatimTextOutput("incidence")
  ),
  
  column(4,
  numericInput("simNo", label = "Enter the number of runs(10,000 runs is recommended)", 
             value = 10000),
  numericInput("noPat", label = "Enter the number of surgical patients at risk", value = 1000),
  br(),
  hr(),
  h4("Number of SSI Patients"),
  verbatimTextOutput("ssiNo")
  ),
 column(4,br(),
        br(),
  h4(textOutput("text1")),
  br(),
  br(),
  br(),
  hr(),
  h4("Totla Cost of SSI"),
  verbatimTextOutput("totalCostSsi")
  )
 ),
    tabPanel(title = "Infection Control Program",
   numericInput("costIcPerPatient",label = "Enter the cost of infection control program per patient", value = 1),
   sliderInput(inputId = "icEfficacy", label = "Enter the expected efficacy of the infection cotnrol program", value = 0.2, min = 0, max = 1),
   h4(textOutput("text2")),
   h4(textOutput("text3")),
   plotOutput("hist")
   ),
 tabPanel(title = "Resutls of simulation",
          dataTableOutput("table")
 )
 )
)

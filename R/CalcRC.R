#' Calculates the Replacement Cost(RC) and the sum of the MtMs for all the trades
#' @title Calculates the RC
#' @param trades The full list of the Trade Objects 
#' @param csa (Optional) The CSA objects
#' @param collaterals (Optional) The collaterals Objects
#' @return The replacement Cost and the sum of the MtMs
#' @export
#' @author Tasos Grivas <tasos@@openriskcalculator.com>
#' @references Basel Committee: The standardised approach for measuring counterparty credit risk exposures
#' http://www.bis.org/publ/bcbs279.htm

CalcRC <- function(trades, csa, collaterals)  {
  
  V <- sum(sapply(trades, function(x) x$MtM))
  
  if (missing(csa))
  {
    V_C <- V
    RC <- max(V_C,0)
  } else
  {
    if(length(collaterals)!=0)
    {
        collaterals = collaterals[sapply(collaterals, function(x) x$csa_id == csa$ID)]
    } else
    {collaterals = NULL }
    if(csa$Values_type == "Actual")
    {
      IM_cpty = csa$IM_cpty
      MTA_cpty = csa$MTA_cpty
      thres_cpty = csa$thres_cpty
    }
    
    MTA_cpty = csa$MTA_cpty
    current_collateral = 0
    
    if(length(collaterals)!=0)
    {
    for(i in 1:length(collaterals))
    {
      if(collaterals[[i]]$type =="ICA")
      {
        current_collateral = current_collateral + collaterals[[i]]$Amount
        IM_cpty = collaterals[[i]]$Amount
      } else if(collaterals[[i]]$type =="VariationMargin")
      {        current_collateral = current_collateral + collaterals[[i]]$Amount      }
    }
    
    V_C <- V - current_collateral
    RC  <- max(V_C, thres_cpty + MTA_cpty- IM_cpty,0)
    }else
    {
      V_C <- V
      RC  <- max(V_C, 0)
    }
  }
  
return(list("V_C"=V_C,"RC"=RC))
}
GroupEquityTrades = function(group_trades, trade_classes_tree,hedging_set_name)
{
  # for the Credit case the Hedging sets will be created based on the reference entity
  refEntities   <- unique(lapply(group_trades, function(x) (if(length(x$Issuer)!= 0) x$Issuer)))
  refEntities = c(refEntities, unique(lapply(group_trades, function(x) (if(length(x$Underlying_Index)!= 0) x$Underlying_Index))))
  if(!missing(hedging_set_name))
  {
    if(substr(hedging_set_name,1,4)=="Vol_"||substr(hedging_set_name,1,6)=="Basis_")
      temp_refEntities = paste0(hedging_set_name,"_",refEntities)
    
  }else
  { temp_refEntities = refEntities
  temp_refEntities = temp_refEntities[sapply(temp_refEntities, function(x) !is.null(x))]
  }

refEntities_tree = list()
refEntities = refEntities[sapply(refEntities, function(x) !is.null(x))]

for (j  in 1:length(refEntities))
{
  refEntities_trades  <- group_trades[sapply(group_trades, function(x) ((ifelse(length(x$Issuer== refEntities[[j]])!=0,x$Issuer == refEntities[[j]],FALSE) ) | (ifelse(length(x$Underlying_Index== refEntities[[j]])!=0, x$Underlying_Index == refEntities[[j]],FALSE))))]
  refEntities_tree[[j]] = trade_classes_tree$AddChild(temp_refEntities[[j]])
  for (k in 1:length(refEntities_trades))
  {
    tree_trade = refEntities_tree[[j]]$AddChild(refEntities_trades[[k]]$external_id)
    tree_trade$trade_details = Trading::GetTradeDetails(refEntities_trades[[k]])
    tree_trade$trade = refEntities_trades[[k]]
  }
}
return(trade_classes_tree)
}
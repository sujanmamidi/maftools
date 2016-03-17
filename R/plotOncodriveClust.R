#' Plots results from \code{oncodrive}
#'
#' @description Takes results from \code{oncodrive} and plots them as a scatter plot. Size of the gene shows number of clusters (hotspots), x-axis can either be an absolute number of variants
#' accumulated in these clusters or a fraction of total variants found in these clusters. y-axis is fdr values transformed into -log10 for better representation. Lables indicate Gene name with number clusters
#' observed.
#' @param  res results from \code{oncodrive}
#' @param fdrCutOff fdr cutoff to call a gene as a driver.
#' @param useFraction if TRUE uses a fraction of total variants as X-axis scale instead of absolute counts.
#' @return a ggplot object which can be further modified.
#' @export


plotOncodrive = function(res = NULL, fdrCutOff = 0.05, useFraction = F){

  if(is.null(res)){
    stop('Please provide results from oncodrive.')
  }


  res$label = paste(res$Hugo_Symbol, '[',res$clusters,']', sep='')
  res$significant = ifelse(test = res$fdr < fdrCutOff, yes = 'sig', no = 'nonsig')

  if(useFraction){
    p = ggplot(data = res, aes(x = fract_muts_in_clusters, y = -log10(fdr), size = clusters, color = significant, alpha = 0.7))+
      geom_point()+theme_bw()+theme(legend.position = 'NONE')+scale_color_manual(values = c('sig' = 'maroon', 'nonsig' = 'blue'))+
      geom_text_repel(data = filter(res, fdr < fdrCutOff), aes(x = fract_muts_in_clusters, y = -log10(fdr), label = label, size = 2))+
      xlab('Fraction of mutations in clusters')
  }else{
    p = ggplot(data = res, aes(x = muts_in_clusters, y = -log10(fdr), size = clusters, color = significant, alpha = 0.7))+
      geom_point()+theme_bw()+theme(legend.position = 'NONE')+scale_color_manual(values = c('sig' = 'maroon', 'nonsig' = 'blue'))+
      geom_text_repel(data = filter(res, fdr < fdrCutOff), aes(x = muts_in_clusters, y = -log10(fdr), label = label, size = 2))+
      xlab('Number of mutations in clusters')
  }

  print(p)
  return(p)
}
# sisend: sõne tüüpi muutuja, mis sisaldab mudeli tunnuseid (eraldatud tühikutega)
# väljund: mudeli tüüpi objekt
variable.string.to.glmm.formula <- function (variable.string) {
  predictor <- "cbind(NEG_RESULTS, POS_RESULTS)"
  variables <- unlist(strsplit(variable.string, "\\s+"))
  squares <- which (grepl("\\*", variables))
  if (length(squares) != 0) {
    sq.factors <- strsplit(variables[squares], "\\*")
    sq.factors <- sapply(sq.factors, function(x) x[1])
    variables[squares] <- lapply(sq.factors, function(x) paste0(c(x, "_2"), collapse = ""))
  }
  variables <- c(variables, "(1|ID)")
  terms <- paste0(variables, collapse = " + ")
  return (as.formula(paste0(c(predictor, terms), collapse = " ~ ")))
}

# sisend: mudeli tunnus ja tüüp
# väljund: antud tunnusega sarnased tunnused
generate.associated.terms <- function(original.term, type) {
  spl <- unlist(strsplit(original.term, "_"))
  if (length(spl) == 1) {
    spl <- unlist(strsplit(original.term, "\\*"))
  }
  k <- substr(spl[1], 4, nchar(spl[1]))
  if (type == 1) { 
    t1 <- paste0("MAX", k)
    t2 <- paste0("MAX", k, "_1MM")
    t3 <- paste0("MAX", k, "_2MM")
    terms <- c(t1, t2, t3)
    roots <- paste0(terms, "*", terms)
    terms <- c(terms, roots)
    return (terms)
  } else if (type == 2) { 
    t1 <- paste0("MAX", k)
    t2 <- paste0("MAX", k, "_1MM")
    terms <- c(t1, t2)
    roots <- paste0(terms, "*", terms)
    terms <- c(terms, roots)
    return (terms)
  } else if (type == 3) {
    t1 <- paste0("MAX", k)
    terms <- c(t1)
    roots <- paste0(terms, "*", terms)
    terms <- c(terms, roots)
    return(terms)
  } else {
    return (NULL)
  }
}

# rekursiivne algoritm AIC järgi mudelisse tunnuste valimiseks
forward.selection.all.models.AIC <- function (data, cores = 2, features = NULL, check.list = NULL, model = NULL, type = 1,
                                              current.level = 0, max.level = 2, min.aic = 1000000, do.check = FALSE) {
  require(glmmADMB)
  require(parallel)
  
  # milliseid tunnuseid mudelisse lubatakse
  if (is.null(features)) {
    features <- names(data)[4:162]
    if (type == 1) {
      rm <- c(grep("FULL", features), grep("MIN", features), grep("ABS", features), grep("18", features), grep("17", features))
      features <- c(features[-rm], paste(features[-rm], "*", features[-rm], sep = ""))
    } else if (type == 2) {
      rm <- c(grep("FULL", features), grep("MIN", features), grep("ABS", features), grep("2MM", features),
              grep("18", features), grep("17", features))
      features <- c(features[-rm], paste(features[-rm], "*", features[-rm], sep = ""))
    } else if (type == 3) {
      rm <- c(grep("FULL", features), grep("MIN", features), grep("ABS", features), grep("MM", features),
              grep("18", features), grep("17", features))
      features <- c(features[-rm], paste(features[-rm], "*", features[-rm], sep = ""))
    } else {
      rm <- c(grep("FULL", features), grep("MIN", features), grep("ABS", features), grep("MM", features),
              grep("18", features), grep("17", features))
      features <- features[-rm]
    }
  }
  
  n <- length(features)
  m <- length(model)
  l <- length(check.list)
  if (type == 4) {
    l <- 0
  }
  
  if (do.check & l > 0) { # kui saab lisada tunnuseid, ilma et peaks kasutusele võtma uue k-meeride tabeli
    
    aic <- mclapply(1:l, function(i, model, check.list) {
      fml <- variable.string.to.glmm.formula(paste0(c(model, check.list[i]), collapse = " "))
      fit <- glmmadmb(fml, data, family = "binomial")
      aic <- extractAIC(fit)[2]
      return (data.frame(added=check.list[i], i=i, AIC=aic, lfml=(m + 1), terms=as.character(fml)[3]))
    }, model, check.list, mc.cores = cores)
    aic <- as.data.frame(do.call ("rbind", aic))
    current.min.aic <- min(aic$AIC)
    
    if (current.min.aic < min.aic) {
      all.min.aic <- which(aic$AIC <= current.min.aic + 2 & aic$AIC < min.aic)
      
      for (j in all.min.aic) {
        forward.selection.all.models.AIC (data, cores, 
                                          features, 
                                          setdiff(check.list, c(as.character(aic$added[j]))), 
                                          c(model, as.character(aic$added[j])), type, 
                                          current.level, max.level, min.aic = aic$AIC[j], do.check = TRUE)
      }
      return (model)
      
    } else { 
      forward.selection.all.models.AIC (data, cores, features, check.list, model, type, 
                                        current.level, max.level, min.aic, do.check = FALSE)
      return (model)
    }
  }
  
  if (current.level >= max.level) {
    a <- paste(paste(model, collapse=" "), min.aic)
    write(a, file=paste0("models.out.file.", type), append=TRUE)
    return (model)
  }
  
  # uue k-meeride tabeli kasutusele võtmine
  aic <- mclapply(1:n, function(i, model, features) {
    fml <- variable.string.to.glmm.formula(paste0(c(model, features[i]), collapse = " "))
    fit <- glmmadmb(fml, data, family = "binomial")
    aic <- extractAIC(fit)[2]
    return (data.frame(added=features[i], i=i, AIC=aic, lfml=(m + 1), terms=as.character(fml)[3]))
  }, model, features, mc.cores = cores)
  aic <- as.data.frame(do.call ("rbind", aic))
  current.min.aic <- min(aic$AIC)
  
  if (current.min.aic < min.aic) {
    all.min.aic <- which(aic$AIC <= current.min.aic + 2 & aic$AIC < min.aic)
    
    for (j in all.min.aic) {
      forward.selection.all.models.AIC (data, cores, 
                                        setdiff(features, check.list), 
                                        setdiff(c(check.list, generate.associated.terms(as.character(aic$added[j]), type)), c(as.character(aic$added[j]))), 
                                        c(model, as.character(aic$added[j])), type, 
                                        current.level + 1, max.level, min.aic = aic$AIC[j], do.check = TRUE)
    }
    
  } else { 
    return (model)
  }
}
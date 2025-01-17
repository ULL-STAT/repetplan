% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/repGBprior.plan.R
\name{repGBprior.plan}
\alias{repGBprior.plan}
\title{Determine the design of a censored repetitive sampling plan using a GB prior to model the knowledge about \eqn{p}.}
\usage{
repGBprior.plan(risks, p, asvar, beta.pars, pg_bar = TRUE)
}
\arguments{
\item{risks}{Vector of producer and consumer maximum sampling risks}

\item{p}{Vector of acceptance and rejection quality levels}

\item{asvar}{List with the asymptotical variance-covariance matrix of MLE estimators of location and scale lifetime distribution parameters. See \code{asympt.var()} for more details.}

\item{beta.pars}{Data frame with the GB parameters according to the available knowledge about \eqn{p}. See \code{beta.params()} for more details.}
}
\value{
A data.frame with the following variables of the censored repetitive design of the sampling plans.
\itemize{
\item{"q": }{Censoring degree}
\item{"n": }{Sample size}
\item{"n_low": }{Lower bound of sample size}
\item{"n_up": }{Upper bound of sample size}
\item{"ka": }{Acceptance constant}
\item{"kr": }{Rejection constant}
\item{"termcd": }{Termination code of Newton-Raphson optimization}
\item{"message": }{Final message of Newton-Raphson optimization}
\item{"p_alpha": }{Acceptable quality level (AQL)}
\item{"p_beta": }{Rejectable quality level (RQL)}
\item{"a": }{Parameter a}
\item{"b": }{Parameter b}
\item{"l": }{Lower limit of \eqn{p}}
\item{"u": }{Upper limit of \eqn{p}}
\item{"mean_p": }{Mean of \eqn{p}}
\item{"var_p": }{Variance of \eqn{p}}
\item{"dist": }{Distribution name}
\item{"alpha": }{Maximum producer's risk}
\item{"beta": }{Maximum consumer's risk}
\item{"asn_alpha": }{ASN at AQL}
\item{"asn_beta": }{ASN at RQL }
\item{"asn_avg": }{Average of ASN at AQL and ASN at RQL}
\item{"easn": }{Expected ASN}
\item{"p_asn_max": }{Quality level in which ASN maximizes}
\item{"asn_max": }{Maximum ASN over the quality level}
}
}
\description{
This function computes the design of the censored repetitive sampling plan using a model prior of \eqn{p} and expected sampling risks
given the requirements of the producer and consumer about maximum allowable risks and quality levels
}
\examples{
risks<-c(0.05,0.10)
p<-c(0.00654, 0.0426)
q<- 0.1
asvar<-asympt.var(q,"normal")
l<- p[1]/5
u<- p[2]+(p[1]-l)

# GB parameters for a knowledge of mean and variance of p distribution
know_p<-list(mean_p=p[1],var_p=((p[2]-p[1])/4)^2)
beta.parms<-beta.params(p,l,u, know_p)

designs<-repGBprior.plan(risks,p,asvar, beta.parms)

optimal.design<-designs \%>\% group_by(q,dist,p_alpha,p_beta) \%>\%
                filter( (abs(alpha-risks[1])<1e-05) & (abs(risks[2]-beta)<1e-05) & (termcd==1)) \%>\%
                group_by(q,p_alpha,p_beta,a,b,l,u,dist) \%>\%
                mutate(easn_min=min(easn)) \%>\%
                slice(which.min(easn)) \%>\% as.data.frame()

}

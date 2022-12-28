#gauss(x,t) = exp(-(x/t)**2)
nd(x, mu, sd) = (1/(sd*sqrt(2*pi)))*exp(-(x-mu)**2/(2*sd**2))

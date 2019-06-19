module Gaussian
  def getProbability(z)
    return 0 if z < -6.5
    return 1 if z > 6.5
  
    factk = 1
    sum = 0
    term = 1
    k = 0
  
    loopStop = Math.exp(-23)
    while term.abs > loopStop do
        term = 0.3989422804 * ((-1) ** k) * (z ** k) / (2 * k + 1) / (2 ** k) * (z ** (k + 1)) / factk
        sum += term
        k += 1
        factk *= k
    end
  
    sum += 0.5
    1-sum
  end
end
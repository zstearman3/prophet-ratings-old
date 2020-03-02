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
  
  def getZscore(p)
    a1 =  -39.6968302866538
    a2 =  220.946098424521
    a3 = -275.928510446969
    a4 =  138.357751867269
    a5 =  -30.6647980661472
    a6 =    2.50662827745924
    b1 =  -54.4760987982241
    b2 =   161.585836858041
    b3 = -155.698979859887
    b4 =   66.8013118877197 
    b5 =  -13.2806815528857 
    c1 =   -7.78489400243029E-03
    c2 =   -0.322396458041136 
    c3 =   -2.40075827716184 
    c4 =   -2.54973253934373
    c5 =    4.37466414146497 
    c6 =    2.93816398269878 
    d1 =    7.78469570904146E-03
    d2 =    0.32246712907004 
    d3 =    2.445134137143 
    d4 =    3.75440866190742
    p_low = 0.02425 
    p_high = 1 - p_low
    
    raise ArgumentError if p < 0 || p > 1
    if p < p_low
      q = (-2 * Math::log(p))**0.5
      (((((c1 * q + c2) * q + c3) * q + c4) * q + c5) * q + c6) / 
      ((((d1 * q + d2) * q + d3) * q + d4) * q + 1)
    elsif p <= p_high
      q = p - 0.5
      r = q * q
      (((((a1 * r + a2) * r + a3) * r + a4) * r + a5) * r + a6) * q / 
      (((((b1 * r + b2) * r + b3) * r + b4) * r + b5) * r + 1)
    else
      q = (-2 * Math::log(1 - p))**0.5
      (((((c1 * q + c2) * q + c3) * q + c4) * q + c5) * q + c6) / 
      ((((d1 * q + d2) * q + d3) * q + d4) * q + 1)
    end
  end
end
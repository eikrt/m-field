local utils = {}

function utils.lerp(a, b, t)
  return a + (b - a) * t
end
function utils.inverse_lerp(value, start, stop)
  if start == stop then
    error("Start and stop values cannot be the same.")
  end
  return (value - start) / (stop - start)
end
function utils.distance(x1, y1, x2, y2)
  local dx = x2 - x1
  local dy = y2 - y1
  return math.sqrt(dx * dx + dy * dy)
end
function utils.has_value (tab, val)
  for index, value in ipairs(tab) do
    if value == val then
      return true
    end
  end

  return false
end

return utils

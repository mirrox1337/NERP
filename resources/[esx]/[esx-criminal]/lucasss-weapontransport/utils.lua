function table.contains(table, object)
	for index, value in ipairs(table) do
        if value == object then
            return true
        end
    end

    return false
end

function table.dump(tabl)
	if type(tabl) == 'table' then
      local s = '{ '
      for k,v in pairs(tabl) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. table.dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(tabl)
   end
end

function table.copy(table)
  	local empty = {}
  	
  	for k,v in pairs(table) do empty[k] = v end
 	 return setmetatable(empty, getmetatable(table))
end

function string.startsWith(string, value)
   return string.sub(string, 1, string.len(value)) == value
end
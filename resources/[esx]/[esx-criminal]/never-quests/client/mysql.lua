MySQL = {
	Sync = {}
}

function MySQL.execute(query, params, func)
	if func == nil then
		func = function()
		end
	end

	ESX.TriggerServerCallback('mysql-async:execute', func, query, params)
end

function MySQL.fetchAll(query, params, func)
	if func == nil then
		func = function()
		end
	end

	ESX.TriggerServerCallback('mysql-async:fetchAll', func, query, params)
end

function MySQL.fetchScalar(query, params, func)
	if func == nil then
		func = function()
		end
	end

	ESX.TriggerServerCallback('mysql-async:fetchScalar', func, query, params)
end

function MySQL.insert(query, params, func)
	if func == nil then
		func = function()
		end
	end

	ESX.TriggerServerCallback('mysql-async:insert', func, query, params)
end

function MySQL.Sync.execute(query, params, func)
	if func == nil then
		func = function()
		end
	end

	ESX.TriggerServerCallback('mysql-async:sync:execute', func, query, params)
end

function MySQL.Sync.fetchAll(query, params, func)
	if func == nil then
		func = function()
		end
	end

	ESX.TriggerServerCallback('mysql-async:sync:fetchAll', func, query, params)
end

function MySQL.Sync.fetchScalar(query, params, func)
	if func == nil then
		func = function()
		end
	end

	ESX.TriggerServerCallback('mysql-async:sync:fetchScalar', func, query, params)
end

function MySQL.Sync.insert(query, params, func)
	if func == nil then
		func = function()
		end
	end

	ESX.TriggerServerCallback('mysql-async:sync:insert', func, query, params)
end
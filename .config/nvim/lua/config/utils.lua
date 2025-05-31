-------------------------------------------------------------------------------
---                         General functions                               ---
-------------------------------------------------------------------------------

function MergeTables(t1, t2)
    if t2 == nil then return t1 end

    if type(t1) ~= "table" then
        t1 = { t1 }
    end

    for k, v in pairs(t2) do
        t1[k] = v
    end

    return t1
end

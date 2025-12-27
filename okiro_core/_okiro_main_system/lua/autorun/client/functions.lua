function W( x ) return x*ScrW()/1920 end
function H( y ) return y*ScrH()/1080 end

function formatXP(amount)
    local suffix = ""
    local absAmount = math.abs(amount)
    local formattedAmount = absAmount

    if absAmount >= 1e9 then
        formattedAmount = absAmount / 1e9
        suffix = "B"
    elseif absAmount >= 1e6 then
        formattedAmount = absAmount / 1e6
        suffix = "M"
    elseif absAmount >= 1e3 then
        formattedAmount = absAmount / 1e3
        suffix = "k"
    else
        suffix = ""
    end

    if formattedAmount % 1 ~= 0 then
        formattedAmount = string.format("%.2f", formattedAmount)
    end

    if amount < 0 then
        return "-" .. formattedAmount .. suffix
    else
        return formattedAmount .. suffix
    end
end
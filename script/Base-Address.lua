gg.clearResults()
local m,d=os.date("%m")+0,os.date("%d")+0
local searchStr="32400;"..os.date("%Y")..";"..m..";"..d.."::"
gg.searchNumber(searchStr,4)
gg.refineNumber("32400",4)
local results=gg.getResults(1000)

for i,v in ipairs(results) do
    v.name="Base-address"
end

if #results>0 then
    gg.addListItems(results)
end

gg.toast(#results.."件を保存")
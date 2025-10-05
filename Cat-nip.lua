-- 終了処理
function Exit()
    gg.clearResults()
    gg.setVisible(true)
    print(" \n作成者：Mujaki")
    os.exit()
end

gg.clearResults()
gg.removeListItems(gg.getListItems())

-- チェックボックス
local choice = gg.multiChoice({"マタタビ", "獣石", "閉じる"}, nil, "処理を選択")
if choice == nil or choice[3] then
    Exit()
end

local do_first = choice[2] == true
local do_second = choice[1] == true

local last_step_address = nil

-- 獣石処理
if do_first or do_second then
    gg.searchNumber("27;28;0::17", gg.TYPE_DWORD)
    gg.refineNumber("28", gg.TYPE_DWORD)

    local results = gg.getResults(10000)
    local saved_list = {}

    for _, r in ipairs(results) do
        local current = r.address
        local temp_list = {}
        local ok = true

        for step = 1, 10 do
            local prev = current - 8
            local val = gg.getValues({{address = prev, flags = gg.TYPE_DWORD}})[1].value
            local expected = 28 - step

            if val == expected then
                table.insert(temp_list, {address = prev + 4, flags = gg.TYPE_DWORD})
                current = prev
            else
                temp_list = {}
                ok = false
                break
            end
        end

        if ok and #temp_list > 0 then
            for _, item in ipairs(temp_list) do
                table.insert(saved_list, item)
            end
            table.insert(saved_list, {address = r.address + 4, flags = gg.TYPE_DWORD}) -- 28 の4バイト先
            last_step_address = current
        end
    end

    if do_first then
        local input1 = gg.prompt({"獣石の個数"}, {[1] = 99}, {[1] = "number"})
        if not input1 then Exit() end
        local VALUE1 = tonumber(input1[1])

        if #saved_list > 0 then
            gg.setValues((function()
                local t = {}
                for _, item in ipairs(saved_list) do
                    table.insert(t, {address = item.address, flags = item.flags, value = VALUE1})
                end
                return t
            end)())
        end
    end
end

gg.removeListItems(gg.getListItems())

-- マタタビ処理
if do_second then
    local input2 = gg.prompt({"マタタビの個数"}, {[1] = 99}, {[1] = "number"})
    if not input2 then Exit() end
    local VALUE2 = tonumber(input2[1])

    if last_step_address then
        local current = last_step_address
        local saved_list2 = {}
        local ok = true

        for step = 1, 18 do
            local prev = current - 8
            local val = gg.getValues({{address = prev, flags = gg.TYPE_DWORD}})[1].value
            local expected = 18 - step

            if val == expected then
                table.insert(saved_list2, {address = prev + 4, flags = gg.TYPE_DWORD})
                current = prev
            else
                saved_list2 = {}
                ok = false
                break
            end
        end

        if ok and #saved_list2 > 0 then
            gg.setValues((function()
                local t = {}
                for _, item in ipairs(saved_list2) do
                    table.insert(t, {address = item.address, flags = item.flags, value = VALUE2})
                end
                return t
            end)())
        end
    end
end

gg.toast("処理が完了しました。")
Exit()
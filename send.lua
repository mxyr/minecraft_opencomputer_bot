print("初始化通信模块")
local function panduan(msg)
  if msg == "true" then
      print("机器人执行指令成功！")
    elseif msg == "false" then
      print("机器人执行指令失败！")
    elseif msg == nil then
      print("机器人执行指令成功！返回值为空")
    else
      print("机器人执行指令成功！返回值如下：\n" .. tostring(msg))
    end
end
local component = require("component")
local term = require("term")
local m = component.modem
local event = require("event")
print("初始化成功！")
print("请输入通讯端口")
local port = tonumber(term.read())
if port == nil then
  port=18169
  print("未指定端口，使用默认18169")
end
m.open(port)
if m.isOpen(port) then
  print(tostring(port) .. "端口开启成功！")
else
  print(tostring(port) .. "端口开启失败！")
end
print("请指定机器人地址")
local botid = term.read()
if botid == "\n" then
  print("未指定机器人地址，将采取广播通讯。")
end
if botid == "\n" then
  m.broadcast(port, "test\n")
  local _, _, from, _, _, message = event.pull("modem_message")
  if message == "true" then
    print("通讯链接建立成功！")
  else
    print("返回消息未知！")
  end
  repeat
    print("请输入命令！")
    local command = term.read()
    m.broadcast(port, command)
    local _, _, from, _, _, message = event.pull("modem_message")
    panduan(message)
  until command == "stop\n"
else
  m.send(botid, port, "test\n")
  local _, _, from, _, _, message = event.pull("modem_message")
  if message == "true" then
    print("通讯链接建立成功！")
  else
    print("返回消息未知！")
  end
  repeat
    print("请输入命令！")
    local command = term.read()
    m.send(botid, port, command)
    local _, _, from, _, _, message = event.pull("modem_message")
    panduan(message)
  until command == "stop\n"
end
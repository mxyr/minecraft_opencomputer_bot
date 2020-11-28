local function zhixing(n)
  command = "out = robot." .. n
  load(command)()
  return out
end
print("初始化接收程序")
local component = require("component")
local event = require("event")
local term = require("term")
robot = require("robot")
local m = component.modem
print("初始化成功！")
print("请输入通讯端口")
local port = tonumber(term.read())
if port == nil then
  port = 18169
  print("未指定端口，使用默认18169")
end
m.open(port)
if m.isOpen(port) then
  print(tostring(port) .. "端口开启成功！开始监听！")
else
  print(tostring(port) .. "端口开启失败！")
end
repeat
  local _, _, from, port, _, message = event.pull("modem_message")
  print("从" .. from .. "收到向" .. port .. "端口的消息：" .. tostring(message))
  if message == "test\n" then
    m.send(from, port, "true")
  elseif message == "break\n" then
    m.send(from, port, "机器人接收程序关闭")
  else
    local ok, output=pcall(zhixing, message)
    if ok then
      m.send(from, port, output)
    else
      m.send(from, port, "false")
    end
  end
until message == "break\n"
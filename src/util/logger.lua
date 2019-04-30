local logger = {DEBUG = "DEBUG", ERROR = "ERROR", MISC = "MISC"}

function logger:log(msg, category)
    category = category or "DEBUG"
    msg = msg or "Caller - please set this message variable otherwise I am not very useful."

    --print("[LD44][" .. category .. "] " .. msg)
end

return logger

# If I run the entire box, allow autoload
#set auto-load safe-path /

# Pretty print by default
set print pretty on

# Print hex by default
set output-radix 16

define offsetof
    set $rc = (char*)&((struct $arg0 *)0)->$arg1 - (char*)0
end

define btsave
        set pagination off
        set logging overwrite on
        set logging file gdb.bt
        set logging on
        thread apply all backtrace
        set logging off
        set pagination on
end

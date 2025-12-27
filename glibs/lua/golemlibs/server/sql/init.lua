GOLEM.SQL = GOLEM.SQL or {}

require("mysqloo")

GOLEM.SQL.COLORS = {
	SUCCESS = Color(46,204,113),
	ERROR = Color(231,76,60),
	WARNING = Color(241,196,15),
	INFO = Color(52,152,219)
}

GOLEM.SQL.db = nil
GOLEM.SQL.usingSQLite = false

gInitializeMySQL()
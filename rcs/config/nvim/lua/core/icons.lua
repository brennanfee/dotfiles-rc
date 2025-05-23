local M = {}

M.kind = {
  Array = " ",
  Boolean = " ",
  Calendar = " ",
  Class = " ",
  Color = "󰏘 ",
  Constant = "󰏿 ",
  Constructor = " ",
  Copilot = " ",
  Enum = " ",
  EnumMember = " ",
  Event = " ",
  Field = "󰜢 ",
  File = "󰈙 ",
  Folder = "󰉋 ",
  Function = "󰆧 ",
  Interface = " ",
  Key = "󰌋 ",
  Keyword = " ",
  Method = " ",
  -- Module = " ",
  Module = " ",
  Namespace = "󰌗 ",
  Null = "󰟢 ",
  Number = " ",
  Object = "󰅩 ",
  Operator = " ",
  Package = " ",
  Property = "󰜢 ",
  Reference = "󰈇 ",
  Snippet = " ",
  String = " ",
  Struct = " ",
  Table = " ",
  Tag = " ",
  Text = "󰉿 ",
  TypeParameter = " ",
  Unit = "󰑭 ",
  Value = "󰎠 ",
  Variable = " ",
  Watch = " ",
}

M.devicons = {
  default_icon = {
    icon = "󰈙",
    name = "Default",
  },
  c = {
    icon = "",
    name = "c",
  },
  css = {
    icon = "",
    name = "css",
  },
  deb = {
    icon = "",
    name = "deb",
  },
  Dockerfile = {
    icon = "",
    name = "Dockerfile",
  },
  html = {
    icon = "",
    name = "html",
  },
  jpeg = {
    icon = "󰉏",
    name = "jpeg",
  },
  jpg = {
    icon = "󰉏",
    name = "jpg",
  },
  js = {
    icon = "󰌞",
    name = "js",
  },
  kt = {
    icon = "󱈙",
    name = "kt",
  },
  lock = {
    icon = "󰌾",
    name = "lock",
  },
  lua = {
    icon = "",
    name = "lua",
  },
  mp3 = {
    icon = "󰎆",
    name = "mp3",
  },
  mp4 = {
    icon = "",
    name = "mp4",
  },
  out = {
    icon = "",
    name = "out",
  },
  png = {
    icon = "󰉏",
    name = "png",
  },
  py = {
    icon = "",
    name = "py",
  },
  ["robots.txt"] = {
    icon = "󰚩",
    name = "robots",
  },
  toml = {
    icon = "",
    name = "toml",
  },
  ts = {
    icon = "󰛦",
    name = "ts",
  },
  ttf = {
    icon = "",
    name = "TrueTypeFont",
  },
  rb = {
    icon = "",
    name = "rb",
  },
  rpm = {
    icon = "",
    name = "rpm",
  },
  vue = {
    icon = "󰡄",
    name = "vue",
  },
  woff = {
    icon = "",
    name = "WebOpenFontFormat",
  },
  woff2 = {
    icon = "",
    name = "WebOpenFontFormat2",
  },
  xz = {
    icon = "",
    name = "xz",
  },
  zip = {
    icon = "",
    name = "zip",
  },
}

M.git = {
  Branch = "",
  Copilot = " ",
  Diff = " ",
  FileDeleted = " ",
  FileIgnored = "◌",
  FileRenamed = " ",
  FileStaged = "S",
  FileUnmerged = "",
  FileUnstaged = "",
  FileUntracked = "U",
  LineAdded = " ",
  LineModified = " ",
  LineRemoved = " ",
  Octoface = " ",
  Repo = " ",
  SignsAdd = "┃",
  SignsChange = "┃",
  SignsDelete = "_",
  SignsTopDelete = "‾",
  SignsChangeDelete = "~",
  SignsUntracked = "┆",
}

M.ui = {
  ArrowCircleDown = "",
  ArrowCircleLeft = "",
  ArrowCircleRight = "",
  ArrowCircleUp = "",
  BoldArrowDown = "",
  BoldArrowLeft = "",
  BoldArrowRight = "",
  BoldArrowUp = "",
  BoldClose = "",
  BoldDividerLeft = "",
  BoldDividerRight = "",
  BoldLineDashedMiddle = "┋",
  BoldLineLeft = "▎",
  BoldLineMiddle = "┃",
  BookMark = "",
  BoxChecked = " ",
  Bug = " ",
  Calendar = " ",
  Check = "",
  ChevronRight = "",
  ChevronShortDown = "",
  ChevronShortLeft = "",
  ChevronShortRight = "",
  ChevronShortUp = "",
  Circle = " ",
  Close = "󰅖",
  CloudDownload = " ",
  Code = "",
  Comment = "",
  Dashboard = "",
  DebugConsole = " ",
  DividerLeft = "",
  DividerRight = "",
  DoubleChevronRight = "»",
  Ellipsis = "",
  EmptyFolder = " ",
  EmptyFolderOpen = " ",
  File = " ",
  FileSymlink = "",
  Files = " ",
  FindFile = "󰈞",
  FindText = "󰊄",
  Fire = "",
  Folder = "󰉋 ",
  FolderOpen = " ",
  FolderSymlink = " ",
  Forward = " ",
  Gear = " ",
  History = " ",
  Lightbulb = " ",
  LineDashedMiddle = "┆",
  LineLeft = "▏",
  LineMiddle = "│",
  List = " ",
  Lock = " ",
  NewFile = " ",
  Note = " ",
  Package = " ",
  Pencil = "󰏫 ",
  Plus = " ",
  Project = " ",
  Scopes = "",
  Search = " ",
  SignIn = " ",
  SignOut = " ",
  Stacks = "",
  Tab = "󰌒 ",
  Table = " ",
  Target = "󰀘 ",
  Telescope = " ",
  Text = " ",
  Tree = "",
  Triangle = "󰐊",
  TriangleShortArrowDown = "",
  TriangleShortArrowLeft = "",
  TriangleShortArrowRight = "",
  TriangleShortArrowUp = "",
  Watches = "󰂥",
}

M.diagnostics = {
  BoldError = "",
  BoldHint = "",
  BoldInformation = "",
  BoldQuestion = "",
  BoldWarning = "",
  Debug = "",
  Error = "",
  Hint = "󰌶",
  Information = "",
  Question = "",
  Trace = "✎",
  Warning = "",
}

M.misc = {
  CircuitBoard = " ",
  Package = " ",
  Robot = "󰚩 ",
  Smiley = " ",
  Squirrel = " ",
  Tag = "",
  Watch = "",
}

return M

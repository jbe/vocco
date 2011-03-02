Vocco::Generator::CSS = <<-'__YOU_ARE_SPECIAL__'
body {
  font-family: "Palatino Linotype", "Book Antiqua", Palatino, FreeSerif, serif;
  font-size: 15px; }

html, body {
  height: 100%; }

body {
  padding: 1em; }

.code {
  font-family: Menlo, Monaco, "DejaVu Sans Mono", Consolas, "Lucida Console", monospace;
  font-size: 16px;
  padding: 1em;
  width: 50%; }

.nav {
  width: 40%;
  position: fixed;
  top: 0;
  left: 55%;
  height: 100%;
  font-size: 15px;
  line-height: 22px;
  color: #252519; }
  .nav .wrapper {
    color: black;
    height: 100%; }
    .nav .wrapper .area {
      background-color: #cccccc;
      padding: 1em 1em 1em 1em;
      border-bottom: 1px dashed #bbbbbb;
      border-top: 1px dashed #666666; }
      .nav .wrapper .area .autohide {
        opacity: 0;
        height: 0px;
        -webkit-transition: all 0.2s linear;
        overflow: auto; }
      .nav .wrapper .area:hover .autohide {
        height: 150px;
        opacity: 1; }
    .nav .wrapper .notes {
      max-height: 40%;
      overflow: auto; }

table th {
  text-align: right; }

__YOU_ARE_SPECIAL__

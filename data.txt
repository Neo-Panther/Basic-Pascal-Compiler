program Example9;
var
  i: Integer;
begin
  i := 10;
  if i > 10 then
  begin
    i := 10;
    i := i - 1;
    write(i);
  end
  else
  begin
    i := 20;
    write(i);
  end;
end.
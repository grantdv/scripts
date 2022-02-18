<%
Dim varInitial_Time
varInitial_Time = Timer
Response.Write "Initial_Time =[" & varInitial_Time & "]<br>"
%>
 
 
<% 'Start ASP Script Tag
For I = 1 to 10
Response.write "Hello World Take " & I & "<br>"
Next
'End ASP Script Tag %>
<!-- Start: HTML--><br>You looped <%=(I - 1) %> times.<br><!-- End: HTML-->
 
<%
Dim varFinal_Time
varFinal_Time = Timer
Response.Write "Final_Time =[" & varFinal_Time & "]<br>"
Dim varDelta_Time
varDelta_Time = FormatNumber(varFinal_Time - varInitial_Time, 2)
Response.Write "It took [" & varDelta_Time & "] seconds to load this page."
%>
(END)         

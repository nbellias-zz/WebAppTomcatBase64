<%-- 
    Document   : index
    Created on : 19 Ιαν 2020, 9:02:53 π.μ.
    Author     : nikolaos
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Persons</h1>
        <form action="index.jsp" method="POST">
            <p><input type="text" id="id" name="id" placeholder="Enter your id" required="true"/></p>
            <p><input type="text" id="name" name="name" placeholder="Enter your name" required="true"/></p>
            <p><input type="file" name="photo" id="photo" onchange="previewPhoto()"/></p>
            <p><img src="" alt="Person photo" id="photopreview" width="100px"></p>
            <p><input type="hidden" name="phototosave" id="phototosave"/></p>
            <p><input type="submit" title="Save" /></p>
            <p><input type="reset" title="Clear" /></p>
        </form>
        <hr/>
        <%
            Connection con = null;
            Statement st0 = null;
            Statement st1 = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                

                if (request.getParameter("id") != null && request.getParameter("name") != null) {
                    String id = request.getParameter("id");
                    String name = request.getParameter("name");
                    String photo = request.getParameter("phototosave");
                    con = (Connection) DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/nikolaosdb", "nikolaos", "1234567890");
                    st0 = con.createStatement();
                    int i = st0.executeUpdate("insert into person(id,name,photo)values('" + id + "','" + name + "','" + photo + "')");
                    out.println("Person data is successfully inserted! (" + i + " record)");
                    st0.close();
                    con.close();
                }

                con = (Connection) DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/nikolaosdb", "nikolaos", "1234567890");
                st1 = con.createStatement();
                ResultSet rs = st1.executeQuery("select * from person");

        %>
        <table>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Photo</th>
                <th></th>
            </tr>
            <tbody>
                <%                    while (rs.next()) {
                %>
                <tr>
                    <td><%=rs.getString("id")%></td>
                    <td><%=rs.getString("name")%></td>
                    <td><img src="<%=rs.getString("photo")%>" alt="photo" width="100px"/></td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
        <br>
        <%
        } catch (Exception e) {
            out.print(e.getMessage());
        %>
        <br>
        <%
            } finally {
                st1.close();
                con.close();
            }
        %>
        <hr/>
        <script>

            function previewPhoto() {
                var preview = document.getElementById("photopreview");
                var phototosave = document.getElementById("phototosave");
                var file = document.getElementById("photo").files[0];
                var reader = new FileReader();
                if (file.size > 500000) {
                    alert("Cannot save this file. Its size exceeds 1MB");
                    file = null;
                } else {
                    reader.onloadend = function () {
                        preview.src = reader.result;
                        phototosave.value = reader.result;
                    }
                }

                if (file) {
                    reader.readAsDataURL(file);
                } else {
                    preview.src = "";
                }
                //}
            }

        </script>
    </body>
</html>

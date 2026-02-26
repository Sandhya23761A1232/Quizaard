<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    // ✅ Check if the user is already logged in
    if (session.getAttribute("username") != null) {
        response.sendRedirect("home.jsp");
        return;
    }
%>

<html>
<head>
    <title>Login | Quizzard</title>
    <style>
        body {
            background: url('images/rbg.webp') no-repeat center center fixed;
            background-size: cover;
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
        }

        .overlay {
            background-color: rgba(0,0,0,0.6);
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
        }

        .container {
            position: relative;
            width: 400px;
            margin: 100px auto;
            background: rgba(255,255,255,0.95);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0px 0px 20px rgba(0,0,0,0.3);
            z-index: 2;
        }

        h2 {
            text-align: center;
            color: #ff1493;
            margin-bottom: 25px;
        }

        input {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 15px;
        }

        button {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, hotpink, deeppink);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: 0.3s ease;
        }

        button:hover {
            background: linear-gradient(135deg, deeppink, hotpink);
            transform: scale(1.03);
        }

        p {
            text-align: center;
            margin-top: 15px;
        }

        a {
            color: hotpink;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="overlay"></div>
    <div class="container">
        <h2>Login to Quizzard</h2>
        <form method="post">
            <input type="text" name="username" placeholder="Enter your Username" required>
            <input type="password" name="password" placeholder="Enter your Password" required>
            <button type="submit" name="login">Login</button>
        </form>
        <p>New user? <a href="register.jsp">Create an Account</a></p>
    </div>

    <%
        if (request.getParameter("login") != null) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/quizzarddb", "root", "");

                String sql = "SELECT * FROM users WHERE username=? AND password=?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, username);
                ps.setString(2, password);
                rs = ps.executeQuery();

                if (rs.next()) {
                    // ✅ Create session and store user data
                    session.setAttribute("username", rs.getString("username"));
                    session.setAttribute("fullname", rs.getString("fullname"));
                    session.setMaxInactiveInterval(30 * 60); // session timeout 30 min

                    out.println("<script>alert('Welcome back, " + rs.getString("fullname") + "!'); window.location='home.jsp';</script>");
                } else {
                    out.println("<script>alert('Invalid username or password. Please try again.');</script>");
                }
            } catch (Exception e) {
                out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
                e.printStackTrace();
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception ex) {}
                try { if (ps != null) ps.close(); } catch (Exception ex) {}
                try { if (conn != null) conn.close(); } catch (Exception ex) {}
            }
        }
    %>
</body>
</html>

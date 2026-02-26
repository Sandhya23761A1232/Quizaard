<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Register | Quizzard</title>
    <style>
        body {
            background: url('images/qbg.webp') no-repeat center center fixed;
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
            margin-bottom: 20px;
        }
        input, select {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        button {
            width: 100%;
            padding: 10px;
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
        <h2>Create Your Account</h2>

        <form method="post">
            <input type="text" name="fullname" placeholder="Full Name" required>
            <input type="text" name="username" placeholder="Username" required>
            <input type="email" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <select name="gender" required>
                <option value="">Select Gender</option>
                <option>Male</option>
                <option>Female</option>
                <option>Other</option>
            </select>
            <input type="text" name="phone" placeholder="Phone Number" required pattern="[0-9]{10}" title="Enter valid 10-digit number">
            <button type="submit" name="register">Sign Up</button>
        </form>

        <p>Already have an account? <a href="login.jsp">Login</a></p>
    </div>

    <%
        if (request.getParameter("register") != null) {
            String fullname = request.getParameter("fullname");
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String gender = request.getParameter("gender");
            String phone = request.getParameter("phone");

            Connection conn = null;
            PreparedStatement ps = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/quizzarddb", "root", "");

                String sql = "INSERT INTO users(fullname, username, email, password, gender, phone) VALUES(?,?,?,?,?,?)";
                ps = conn.prepareStatement(sql);
                ps.setString(1, fullname);
                ps.setString(2, username);
                ps.setString(3, email);
                ps.setString(4, password);
                ps.setString(5, gender);
                ps.setString(6, phone);

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    out.println("<script>alert('Registration successful! You can now login.'); window.location='login.jsp';</script>");
                } else {
                    out.println("<script>alert('Registration failed! Please try again.');</script>");
                }

            } catch (Exception e) {
                out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
                e.printStackTrace();
            } finally {
                try { ps.close(); conn.close(); } catch (Exception ex) {}
            }
        }
    %>
</body>
</html>

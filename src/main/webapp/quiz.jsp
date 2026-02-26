<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="true" %>
<html>
<head>
    <title>Select Quiz Category | Quizzard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            margin: 0;
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #fff0f5, #ffe4f0);
            color: #333;
        }

        /* Navbar */
        .navbar {
            background: linear-gradient(135deg, hotpink, deeppink);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 50px;
            box-shadow: 0px 3px 10px rgba(0,0,0,0.2);
        }

        .navbar h1 {
            color: white;
            font-size: 24px;
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            margin-left: 25px;
        }

        .nav-links a:hover {
            text-decoration: underline;
        }

        h2 {
            text-align: center;
            margin: 40px 0 10px;
            color: deeppink;
        }

        p {
            text-align: center;
            color: #666;
            margin-bottom: 40px;
        }

        /* Category Cards */
        .categories {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 30px;
            padding: 0 80px 60px;
        }

        .category {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0px 4px 15px rgba(0,0,0,0.15);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
            text-align: center;
        }

        .category:hover {
            transform: translateY(-10px);
            box-shadow: 0px 10px 25px rgba(0,0,0,0.25);
        }

        .category img {
            width: 100%;
            height: 160px;
            object-fit: cover;
        }

        .category h3 {
            color: deeppink;
            margin-top: 15px;
        }

        .category p {
            color: #666;
            padding: 0 15px 20px;
            font-size: 14px;
        }

        /* Footer */
        footer {
            background: #2c2c2c;
            color: white;
            text-align: center;
            padding: 15px;
            font-size: 14px;
        }

        footer span {
            color: hotpink;
        }
    </style>
</head>
<body>

    <%
        String username = (String) session.getAttribute("username");
        if (username == null) {
            response.sendRedirect("login.jsp");
        }
    %>

    <!-- Navbar -->
    <div class="navbar">
        <h1>🎯 Quizzard</h1>
        <div class="nav-links">
            <a href="home.jsp">🏠 Home</a>
            <a href="profile.jsp">👤 Profile</a>
            <a href="logout.jsp">🚪 Logout</a>
        </div>
    </div>

    <h2>Choose Your Quiz Category 🧠</h2>
    <p>Select a category below to begin your quiz journey!</p>

    <div class="categories">
        <%
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/quizzarddb", "root", "");

                String sql = "SELECT * FROM quiz_categories";
                ps = conn.prepareStatement(sql);
                rs = ps.executeQuery();

                while (rs.next()) {
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
                    String desc = rs.getString("description");
                    String image = rs.getString("image");
        %>

        <div class="category" onclick="window.location.href='startQuiz.jsp?category_Id=<%=id%>'">
            <img src="<%= image %>" alt="<%= name %>">
            <h3><%= name %></h3>
            <p><%= desc %></p>
        </div>

        <%
                }
            } catch (Exception e) {
                out.println("<p style='color:red;text-align:center;'>Error loading categories: " + e.getMessage() + "</p>");
                e.printStackTrace();
            } finally {
                try { rs.close(); ps.close(); conn.close(); } catch (Exception ex) {}
            }
        %>
    </div>

    <footer>
        © 2025 <span>Quizzard</span> | Learn Smarter, Play Harder 💡
    </footer>
</body>
</html>
